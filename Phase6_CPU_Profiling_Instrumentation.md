# 第六阶段 CPU 耗时统计与 FPGA 适配埋点说明

本文档说明第六阶段新增的性能统计代码放在哪里、每个统计点包住了哪段算法、这些算法在 SLAM 中的作用，以及后续如何用同一套指标对比纯 CPU 与 CPU+FPGA 状态。

## 1. 文档目的

第六阶段没有接入真 FPGA，也没有改变 LIO/SLAM 的数值计算流程；本阶段只做性能观测基础设施。

主要目的：

- 在线 SLAM 运行时，可以在 Pangolin UI 中观察待加速代码的耗时。
- 离线或在线运行后，可以通过 CSV 对比纯 CPU 与未来 CPU+FPGA 的耗时差异。
- 统计整体 SLAM 帧率，包括输入 LiDAR FPS 与实际 SLAM 处理 FPS。
- 给后续 FPGA 接入保留统一口径，特别是 `Plane ICP HTH/HTr <backend>` 这一点面 ICP 正规方程统计项。

当前 profiling 相关代码主要分布在：

| 文件 | 作用 |
| --- | --- |
| `src/utils/perf_monitor.h` / `src/utils/perf_monitor.cc` | 性能统计框架，记录帧级指标、阶段耗时、FPS、CSV |
| `src/core/system/slam.cc` | 每帧入口，统计 frame total、输入帧、处理帧、跳帧、FPS |
| `src/core/lio/laser_mapping.cc` | LIO 核心耗时点，包括预处理、去畸变、降采样、ESKF、ObsModel、ICP |
| `src/ui/pangolin_window.*` | UI 性能曲线与菜单状态显示 |
| `config/default*.yaml` | `profile` 与 `fpga` 配置开关 |

## 2. 性能统计框架

性能统计框架定义在 `src/utils/perf_monitor.h`。

核心数据结构是 `PerfSnapshot`，它保存一帧的统计结果：

```cpp
struct PerfSnapshot {
    int64_t frame_id = 0;
    double timestamp = 0.0;
    std::string backend = "CPU";

    uint64_t input_frames = 0;
    uint64_t processed_frames = 0;
    uint64_t skipped_frames = 0;
    double input_fps = 0.0;
    double slam_fps = 0.0;

    int input_points = 0;
    int downsampled_points = 0;
    int effective_surface_points = 0;
    int effective_icp_points = 0;

    double frame_total_ms = 0.0;
    double preprocess_ms = 0.0;
    double sync_ms = 0.0;
    double imu_undistort_ms = 0.0;
    double downsample_ms = 0.0;
    double eskf_update_ms = 0.0;
    double obs_total_ms = 0.0;
    double lidar_match_ms = 0.0;
    double plane_icp_ms = 0.0;
    double point_icp_ms = 0.0;
    double mapping_ms = 0.0;
};
```

阶段耗时通过 RAII 方式统计。进入代码块时构造 `ScopedPerfStage`，离开作用域时析构并记录耗时：

```cpp
{
    ScopedPerfStage perf("Downsample");
    voxel_scan_.setInputCloud(scan_undistort_);
    voxel_scan_.filter(*scan_down_body_);
}
```

这种写法的好处是统计代码很轻，不改变原有算法路径；后续把某个阶段替换成 FPGA backend 时，也可以继续沿用相同的指标名和 CSV 字段。

`PerfMonitor` 还维护每个阶段的滑动窗口统计：

```cpp
struct PerfStageSummary {
    double latest_ms = 0.0;
    double mean_ms = 0.0;
    double p50_ms = 0.0;
    double p95_ms = 0.0;
    uint64_t count = 0;
};
```

这些统计用于观察短期耗时波动、均值和尾延迟。

## 3. 帧级统计入口

帧级统计在 `src/core/system/slam.cc` 的 `SlamSystem::ProcessLidar()` 中完成。标准点云和 Livox 点云两个入口都做了同样处理。

代码片段：

```cpp
PerfMonitor::BeginFrame(ToSec(cloud->header.stamp));
lio_->ProcessPointCloud2(cloud);
const bool processed = lio_->Run();

// 关键帧处理、回环、栅格地图、UI 更新 ...

PerfMonitor::EndFrame(processed);
if (ui_ && PerfMonitor::UiEnabled()) {
    ui_->UpdatePerfStats(PerfMonitor::GetLatestSnapshot());
}
```

这里统计的是一帧 LiDAR 从进入 SLAM 系统到 `ProcessLidar()` 返回的总耗时。对应 CSV/UI 字段：

| 字段 | 含义 |
| --- | --- |
| `frame_total_ms` | 整帧 SLAM 处理耗时 |
| `input_frames` | 输入 LiDAR 帧数 |
| `processed_frames` | `lio_->Run()` 成功处理的帧数 |
| `skipped_frames` | 同步失败、跳帧或处理失败的帧数 |
| `input_fps` | LiDAR 输入帧率 |
| `slam_fps` | SLAM 实际处理帧率 |

该层统计的作用是建立最外层对比口径：纯 CPU 状态下每帧要多久，未来 CPU+FPGA 状态下每帧是否真正变快。

## 4. `LaserMapping::Run()` 耗时统计点

`LaserMapping::Run()` 是 LIO 前端主流程，一帧点云进入后，大部分 CPU 热点都在这里串起来。

### 4.1 `SyncPackages`

代码位置：`src/core/lio/laser_mapping.cc`

```cpp
bool sync_ok = false;
{
    ScopedPerfStage perf("SyncPackages");
    sync_ok = SyncPackages();
}
```

统计范围：LiDAR 与 IMU 数据同步。

代码作用：从缓存队列中取出一帧 LiDAR，并截取该 LiDAR 时间范围内对应的 IMU 数据，构造 `MeasureGroup`。

为什么耗时：通常不是最大热点，但它决定当前帧是否可以进入后续 LIO 计算。如果 IMU/LiDAR 时间戳不匹配，这里会导致帧被跳过。

FPGA 目标：否。同步逻辑属于控制流和数据组织，不适合放到 FPGA。

### 4.2 `IMU Undistort`

代码片段：

```cpp
{
    ScopedPerfStage perf("IMU Undistort");
    p_imu_->Process(measures_, kf_, scan_undistort_);
}
```

统计范围：IMU 预测、点云运动去畸变、生成 `scan_undistort_`。

算法作用：LiDAR 一帧扫描有时间跨度，车辆运动会让点云产生运动畸变。该阶段用 IMU 积分估计扫描期间的位姿变化，把点云补偿到统一时刻。

简化表达：

```text
p_l_corrected = T_ref^{-1} * T(t_i) * p_l_raw
```

其中 `T(t_i)` 是点在采样时刻的 IMU/LiDAR 位姿，`T_ref` 是参考时刻位姿。

为什么耗时：需要遍历点云，并结合 IMU 队列做时间插值和坐标变换。

FPGA 目标：否。第六阶段路线中明确不优先搬 IMU 去畸变。

### 4.3 `Downsample`

代码片段：

```cpp
{
    ScopedPerfStage perf("Downsample");
    voxel_scan_.setInputCloud(scan_undistort_);
    voxel_scan_.filter(*scan_down_body_);

    if (cur_pts < (scan_undistort_->size() * 0.1) || cur_pts < options_.min_pts) {
        auto v = voxel_scan_;
        v.setLeafSize(0.1, 0.1, 0.1);
        v.setInputCloud(scan_undistort_);
        v.filter(*scan_down_body_);
    }
}
```

统计范围：PCL voxel grid 降采样，包括点数过少时的备用降采样。

算法作用：把点云按体素网格聚合，减少后续最近邻搜索和 ICP 构建的点数。

简化表达：

```text
voxel_index = floor(p / voxel_size)
```

同一 voxel 内的点被合并或采样，输出 `scan_down_body_`。

为什么耗时：需要遍历原始点云并构造 voxel map。点云越密，耗时越高。

FPGA 目标：否。它影响整体帧率，但不是第一批 FPGA 加速目标。

### 4.4 点数统计

代码片段：

```cpp
int cur_pts = scan_down_body_->size();
PerfMonitor::SetFramePointStats(static_cast<int>(scan_undistort_->size()), cur_pts);
```

统计内容：

| 字段 | 含义 |
| --- | --- |
| `input_points` | 去畸变后的输入点数 |
| `downsampled_points` | 降采样后的点数 |

这些点数用于解释耗时变化。例如某帧 `Plane ICP HTH/HTr CPU` 变慢，通常要同时看 `effective_surface_points` 是否增大。

### 4.5 `ESKF Update total`

代码片段：

```cpp
{
    ScopedPerfStage perf("ESKF Update total");
    kf_.Update(ESKF::ObsType::LIDAR, 1.0);
}
```

统计范围：完整 LiDAR ESKF 迭代更新。

算法作用：ESKF 在当前状态附近多次线性化 LiDAR 观测，调用 `ObsModel()` 构造观测正规方程，然后更新状态。

简化形式：

```text
delta_x = solve(H + P^{-1}, b)
x <- x boxplus delta_x
```

这里的 `H` 和 `b` 来自点面/点到点 ICP 观测，`P` 是状态协方差。

为什么耗时：该阶段包含多次 `ObsModel()` 调用、矩阵求解和状态更新。`ObsModel()` 内部最近邻、平面拟合和 ICP 正规方程构建通常是大头。

FPGA 目标：部分相关。ESKF 本身不搬 FPGA，但其中点面 ICP 正规方程构建会作为后续 FPGA 加速目标。

### 4.6 `Incremental Mapping`

代码片段：

```cpp
Timer::Evaluate(
    [&, this]() {
        ScopedPerfStage perf("Incremental Mapping");
        MapIncremental();
    },
    "    Incremental Mapping");
```

统计范围：关键帧创建后，当前点云增量加入 iVox 地图。

算法作用：将当前点云从 body/lidar 坐标系转换到 world 坐标系，并决定哪些点加入局部地图。

点云世界系变换：

```text
p_w = R_wb (R_bl p_l + t_bl) + t_wb
```

代码中对应 `PointBodyToWorld()`。

为什么耗时：需要遍历降采样点云，并调用 iVox 地图插入。

FPGA 目标：否。它属于地图维护逻辑，不是第一个 FPGA kernel 的范围。

## 5. `LaserMapping::ObsModel()` 耗时统计点

`ObsModel()` 是第六阶段最重要的观测函数，也是未来 FPGA 加速切入点所在位置。

### 5.1 `ObsModel total`

代码片段：

```cpp
void LaserMapping::ObsModel(NavState &s, ESKF::CustomObservationModel &obs) {
    ScopedPerfStage obs_perf("ObsModel total");
    ...
}
```

统计范围：一次完整 LiDAR observation model 计算。

包括：

- 当前帧点变换到世界系
- iVox 最近邻搜索
- 平面拟合
- 有效点筛选
- 点面 ICP 正规方程构建与累加
- 可选点到点 ICP

该指标用于观察 ESKF 每次迭代中，观测模型本身占用了多少时间。

### 5.2 `ObsModel Lidar Match`

代码片段：

```cpp
Timer::Evaluate(
    [&, this]() {
        ScopedPerfStage perf("ObsModel Lidar Match");
        Mat3f R_wl = (s.rot_.matrix() * offset_R_lidar_fixed_).cast<float>();
        Vec3f t_wl = (s.rot_ * offset_t_lidar_fixed_ + s.pos_).cast<float>();

        std::for_each(std::execution::par_unseq, index.begin(), index.end(), ...);
    },
    "    ObsModel (Lidar Match)");
```

统计范围：点云配准前半段，包括坐标变换、iVox 最近邻、平面拟合和有效点筛选。

点云世界系变换：

```text
p_w = R_wl p_l + t_wl
```

其中：

```text
R_wl = R_wi R_il
t_wl = R_wi t_il + t_wi
```

iVox 最近邻查找：

```cpp
ivox_->GetClosestPoint(point_world, points_near, fasterlio::NUM_MATCH_POINTS);
```

平面模型：

```text
n^T p_w + d = 0
```

代码中 `plane_coef_[i]` 存储近似为：

```text
[n_x, n_y, n_z, d]
```

点面残差：

```text
r_i = n_i^T p_{w,i} + d_i
```

代码中：

```cpp
float pd2 = plane_coef_[i].dot(temp);
residuals_[i] = pd2;
```

为什么耗时：每个降采样点都要查最近邻并拟合局部平面，iVox 查询和平面估计是 CPU 热点。

FPGA 目标：否。阶段规划明确不搬 iVox 最近邻和平面拟合。

### 5.3 有效点统计

代码片段：

```cpp
corr_pts_.resize(effect_feat_surf_);
corr_norm_.resize(effect_feat_surf_);
PerfMonitor::SetEffectivePointStats(effect_feat_surf_, effect_feat_icp_);
```

统计内容：

| 字段 | 含义 |
| --- | --- |
| `effective_surface_points` | 点面 ICP 有效点数 |
| `effective_icp_points` | 点到点 ICP 有效点数 |

这些字段非常重要，因为点面正规方程构建耗时基本随 `effective_surface_points` 增长。

### 5.4 `Plane ICP HTH/HTr CPU`

这是第六阶段最重要的统计点，也是后续 FPGA 加速的 CPU baseline。

代码片段：

```cpp
{
    ScopedPerfStage perf("Plane ICP HTH/HTr CPU", effect_feat_surf_, effect_feat_surf_, "CPU");
    std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
        Vec3f point_this_be = corr_pts_[i].head<3>();
        Vec3f point_this = off_R * point_this_be + off_t;
        Mat3f point_crossmat = math::SKEW_SYM_MATRIX(point_this);

        Vec3f norm_vec = corr_norm_[i].head<3>();
        Vec3f C(Rt * norm_vec);
        Vec3f A(point_crossmat * C);

        Eigen::Matrix<double, 1, ESKF::pose_obs_dim_> J;
        J.setZero();
        J << norm_vec[0], norm_vec[1], norm_vec[2], A[0], A[1], A[2];

        float res = -corr_pts_[i][3];
        double w = 1.0;

        JTJ[i] = (J.transpose() * J).eval() * w;
        JTr[i] = J.transpose() * res * w;
    });

    for (int i = 0; i < index.size(); ++i) {
        obs.HTH_ += JTJ[i] * options_.plane_icp_weight_;
        obs.HTr_ += JTr[i] * options_.plane_icp_weight_;
    }
}
```

统计范围：只包含点面 ICP 的雅可比构建、每点 `J^T J / J^T r` 计算，以及最终累加到 `obs.HTH_ / obs.HTr_`。

该阶段输入数据：

```text
corr_pts_[i]  = 有效点 p_l 以及 residual
corr_norm_[i] = 对应局部平面 normal n_w
Rt            = R_wi^T
off_R/off_t   = LiDAR 到 IMU 外参
```

点面残差：

```text
r_i = n_i^T p_{w,i} + d_i
```

代码中使用：

```text
res = -corr_pts_[i][3]
```

点面 ICP 雅可比：

```text
point_this = R_il p_l + t_il
C = R_wi^T n_w
A = [point_this]_x C
J_i = [ n_x, n_y, n_z, A_x, A_y, A_z ]
```

其中 `[point_this]_x` 是反对称矩阵：

```text
[p]_x =
[  0  -p_z  p_y
   p_z   0  -p_x
  -p_y  p_x   0 ]
```

正规方程累加：

```text
H = sum_i w_i J_i^T J_i
b = sum_i w_i J_i^T r_i
```

代码中对应：

```cpp
JTJ[i] = (J.transpose() * J).eval() * w;
JTr[i] = J.transpose() * res * w;

obs.HTH_ += JTJ[i] * options_.plane_icp_weight_;
obs.HTr_ += JTr[i] * options_.plane_icp_weight_;
```

算法作用：把所有点面约束压缩成一个 6x6 Hessian 和 6x1 bias，供 ESKF 的 LiDAR 更新使用。

为什么耗时：每个有效点都要计算叉乘矩阵、雅可比、外积和累加。点数大时，这部分非常适合做成固定数据格式的 FPGA kernel。

FPGA 目标：是。后续 FPGA 只替换这一段，不搬最近邻、平面拟合、ESKF 和点到点 ICP。

### 5.5 `Point ICP CPU`

代码片段：

```cpp
if (options_.enable_icp_part_) {
    ScopedPerfStage perf("Point ICP CPU", cnt_pts, effect_feat_icp_, "CPU");
    ...
    JTJ[i] = J.transpose() * J;
    JTr[i] = -J.transpose() * e;
}
```

统计范围：可选点到点 ICP 的雅可比和正规方程构建。

点到点误差：

```text
e_i = q_{s,i} - q_{map,i}
```

其中 `q_s` 是当前点变换到世界系的位置，`q_map` 是最近邻地图点。

雅可比简化形式：

```text
J_i = [ I, -R_wi R_il [q_i]_x ]
```

代码中：

```cpp
J.block<3, 3>(0, 0) = Mat3d::Identity();
J.block<3, 3>(0, 3) = -(s.rot_.matrix() * offset_R_lidar_fixed_) * SO3::hat(q);
```

为什么耗时：遍历点云、计算 3D residual 和 3x6 Jacobian，但当前配置中 `enable_icp_part` 常为 false。

FPGA 目标：否。阶段规划中点到点 ICP 不作为第一批加速对象。

## 6. 可视化与 CSV 输出

### 6.1 Pangolin UI 曲线

UI 更新入口：

```cpp
ui_->UpdatePerfStats(PerfMonitor::GetLatestSnapshot());
```

Pangolin 中新增两组曲线：

```cpp
log_perf_time_.SetLabels(std::vector<std::string>{
    "frame_total_ms",
    "obs_total_ms",
    "lidar_match_ms",
    "plane_icp_cpu_ms",
    "point_icp_ms",
    "mapping_ms"
});
log_perf_fps_.SetLabels(std::vector<std::string>{"input_fps", "slam_fps"});
```

UI 菜单新增只读状态：

| 菜单项 | 含义 |
| --- | --- |
| `Perf backend` | 当前 backend，例如 `CPU` |
| `Frame time` | 最近一帧总耗时 |
| `SLAM FPS` | 实际 SLAM 处理 FPS |
| `Surface pts` | 最近一帧点面有效点数 |

### 6.2 CSV 输出

CSV 默认路径：

```text
./data/profile/slam_perf.csv
```

关键字段：

```text
frame_id,timestamp,backend,input_frames,processed_frames,skipped_frames,
input_fps,slam_fps,input_points,downsampled_points,
effective_surface_points,effective_icp_points,frame_total_ms,
preprocess_ms,sync_ms,imu_undistort_ms,downsample_ms,
eskf_update_ms,obs_total_ms,lidar_match_ms,plane_icp_ms,
point_icp_ms,mapping_ms,h2c_ms,kernel_ms,c2h_ms,compare_ms,fallback_count
```

### 6.3 YAML 开关

所有默认配置文件都新增了：

```yaml
profile:
  enable: true
  ui_enable: true
  csv_enable: true
  csv_path: ./data/profile/slam_perf.csv
  log_every_n_frames: 10

fpga:
  enable: false
  mode: cpu
```

含义：

| 配置 | 作用 |
| --- | --- |
| `profile.enable` | 总开关 |
| `profile.ui_enable` | 是否推送 UI 性能曲线 |
| `profile.csv_enable` | 是否写 CSV |
| `profile.csv_path` | CSV 输出路径 |
| `profile.log_every_n_frames` | 每隔多少帧打印一次 profile 日志 |
| `fpga.enable` | 当前是否启用 FPGA 路径 |
| `fpga.mode` | backend 名称，当前默认 `cpu` |

## 7. 后续 FPGA 适配口径

后续接入 FPGA 时，最重要的是不要改变统计口径。

当前 CPU baseline 指标名：

```text
Plane ICP HTH/HTr CPU
```

未来建议沿用：

```text
Plane ICP HTH/HTr CPU_SIM
Plane ICP HTH/HTr FPGA
Plane ICP HTH/HTr FALLBACK_CPU
```

这样 UI 和 CSV 中的 `plane_icp_ms` 字段不用变，只需要通过 `backend` 区分当前结果来自 CPU、CPU_SIM、FPGA，还是 FPGA 失败后的 CPU fallback。

FPGA 预留字段：

| 字段 | 含义 |
| --- | --- |
| `h2c_ms` | Host to Card / host 到 FPGA DDR 输入传输耗时 |
| `kernel_ms` | FPGA kernel 计算耗时 |
| `c2h_ms` | Card to Host / FPGA DDR 到 host 输出传输耗时 |
| `compare_ms` | CPU golden 与 FPGA 结果对比耗时 |
| `fallback_count` | FPGA 失败后回退 CPU 的累计次数 |

第一个 FPGA kernel 的边界应保持为：

```text
输入：
  Rt = R_wi^T
  plane_weight
  frame_id / iter_id / num_points
  point_this = R_il p_l + t_il
  normal = n_w
  residual = corr_pts_[i][3]

输出：
  HTH = sum_i w J_i^T J_i
  HTr = sum_i w J_i^T r_i
```

也就是说，FPGA 只替换 `Plane ICP HTH/HTr CPU` 统计块里的计算。iVox 最近邻、平面拟合、有效点筛选、ESKF 更新仍保留在 CPU 侧。这样后续对比时可以直接观察：

```text
纯 CPU:
  plane_icp_ms = Plane ICP HTH/HTr CPU

CPU+FPGA:
  plane_icp_ms = h2c_ms + kernel_ms + c2h_ms + compare_ms
```

如果 `frame_total_ms` 和 `slam_fps` 同时改善，说明 FPGA 加速对端到端 SLAM 有实际收益；如果只有 `plane_icp_ms` 改善但 `frame_total_ms` 不变，则说明瓶颈转移到了最近邻、平面拟合、同步、UI 或其他 CPU 流程。
