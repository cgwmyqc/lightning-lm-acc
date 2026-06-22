# Orin + FPGA + Lightning-LM 性能瓶颈调查与整改决策方案

> 适用项目：`Lightning-LM_Surfel_Unified_Orin_FPGA_Roadmap_7Z100.md` 当前 Stage 55/56 之后的在线 Mapping FPGA_OBS 接入阶段。  
> 目标读者：Codex / 开发执行者。  
> 核心原则：**先做证据闭环，再决定是否改架构；禁止在没有分段耗时证据前直接大改。**

---

## 0. 背景与当前结论边界

当前系统已经完成：

1. Orin 与 FPGA 物理链路、XDMA 基础通信已打通。
2. `mapping_backend=FPGA_OBS` 已经接入在线 SLAM 流程。
3. FPGA 调用日志显示 `success=1`，说明不是“FPGA 完全没跑”。
4. 切换回 CPU-only 后系统正常，说明 bag 数据、IMU 原始数据本身大概率不是根因。

但在线运行 FPGA_OBS 后出现：

- `Proc Lidar` 从 CPU 正常水平恶化到约 `0.6s ~ 1.5s`；
- `processing_fps` 降到约 `0.6 ~ 1.6 FPS`；
- `ESKF update / obs_total / obs_model_misc` 占据几乎全部帧时间；
- 日志出现大量 `get abnormal dt` 和 `检测到雷达断流`；
- 每帧通常有 `obs_model_calls=5`，每次 ObsModel 都会调用一次 FPGA_OBS。

### 0.1 当前必须避免的误判

不要直接把问题归因成以下任意一种：

- “FPGA 慢”；
- “ROS2 IMU 数据卡顿”；
- “架构必须推倒重来”；
- “只要换 MultiThreadedExecutor 就能解决”；
- “PCIe 2.0 x8 带宽不够”。

当前更合理的判断是：

> 在线 FPGA_OBS 已经工作，但其在 ESKF 迭代中的调用方式、XDMA 分段耗时、active map 传输/访问方式、ROS2 单线程调度与 LIO 主流程耦合方式，至少有一个环节导致主线程长时间阻塞。需要通过分段 profiling 归因。

---

## 1. 已知现象整理

### 1.1 日志关键现象

根据当前真实日志，整理出以下现象：

| 项目 | 观测值 | 初步含义 |
|---|---:|---|
| `mapping_backend` | `FPGA_OBS` | 已进入 FPGA mapping observation 路径 |
| FPGA 调用结果 | `success=1` | FPGA transaction 表面成功 |
| `xdma_elapsed_sec` | 约 `0.10 ~ 0.30 s` | 当前记录主要是 HLS start 到 done 的等待时间，不等价于完整 Host transaction 时间 |
| `obs_model_calls` | 通常为 `5` | 每帧 ESKF 迭代会多次调用 ObsModel |
| `obs_model_avg_ms` | 约 `125 ~ 310 ms` | 与单次 FPGA_OBS 量级接近 |
| `obs_total_ms` | 约 `625 ~ 1550 ms` | 约等于 `obs_model_calls * obs_model_avg_ms` |
| `Proc Lidar` | 约 `600 ~ 1500 ms` | Lidar callback / 主处理流程严重阻塞 |
| `processing_fps` | 约 `0.6 ~ 1.6 FPS` | 在线处理远低于 10Hz lidar 实时要求 |
| `get abnormal dt` | 约 `0.1 ~ 0.95s` | 更像主线程处理慢导致的输入消费延迟/队列积压，而非离线数据源本身异常 |
| `雷达断流` | 约 `0.5 ~ 1.6s` | 处理线程跟不上 bag 消息节奏，导致逻辑层看到 lidar 时间间隔异常 |

### 1.2 源码关键事实

当前源码中存在以下需要重点验证的路径：

#### 1.2.1 ROS2 在线主流程疑似单线程

文件：`src/core/system/slam.cc`

当前 `SlamSystem::Spin()` 内部使用：

```cpp
spin(node_);
```

这通常等价于 `rclcpp::spin(node_)`，即默认 SingleThreadedExecutor 风格。若 lidar callback 内部执行 `lio_->Run()` 并阻塞数百毫秒到数秒，IMU callback 消费也会被延迟。

#### 1.2.2 Lidar callback 内部直接执行完整 LIO

文件：`src/core/system/slam.cc`

`ProcessLidar(...)` 中执行：

```cpp
PerfMonitor::BeginFrame(...);
lio_->ProcessPointCloud2(cloud);
const bool processed = lio_->Run();
...
PerfMonitor::EndFrame(processed);
```

这意味着一次 lidar callback 内包含：

- 点云预处理；
- SyncPackages；
- IMU 去畸变；
- 下采样；
- ESKF update；
- ObsModel；
- Mapping / keyframe / UI 更新。

若 FPGA_OBS 同步阻塞，整个 ROS callback 会阻塞。

#### 1.2.3 每次 ObsModelFpgaObservation 都重新导出 active map 并调用 XDMA

文件：`src/core/lio/laser_mapping.cc`

当前 `ObsModelFpgaObservation(...)` 内部包含：

```cpp
loc::ActiveMapBuffer active_map;
surfel_map_->ExportActiveMap(active_map);

const auto scan_points = fpga::ToAbiScanPoints(scan_down_body_);
...
fpga::XdmaRuntime runtime(options_.mapping_xdma_options_);
runtime.RunMappingObservation(scan_points, pose, active_map, params, true, ...);
```

需要重点确认：

1. `ExportActiveMap(active_map)` 是否在每个 ESKF 迭代重复执行；
2. `ToAbiScanPoints(scan_down_body_)` 是否在每个 ESKF 迭代重复执行；
3. `XdmaRuntime runtime(...)` 是否每次创建并重新 open `/dev/xdma*`；
4. `RunMappingObservation(..., write_full_image=true, ...)` 是否每次都重写 scan、pose、map header、params、active blocks、obs cells；
5. active map 和 scan 在同一帧不同 ESKF iteration 内是否实际不变，只有 pose 变化。

#### 1.2.4 XDMA runtime 当前只统计 HLS wait，不统计完整 transaction

文件：`src/core/fpga/xdma_runtime.cc`

当前 `result.elapsed_sec` 的计时起点在：

```cpp
const auto start = std::chrono::steady_clock::now();
Write32(... CONTROL, 0x1u, ...);
while (...) { poll status; }
const auto end = std::chrono::steady_clock::now();
result.elapsed_sec = duration(end - start);
```

因此 `xdma_elapsed_sec` 更接近：

```text
HLS start -> HLS done
```

它不包含或不完整包含：

- file lock 时间；
- open `/dev/xdma*` 时间；
- H2C 写 scan / pose / map / cells 时间；
- readback verify 时间；
- register configure 时间；
- C2H 读取 output 时间；
- `ExportActiveMap` 时间；
- ABI pack 时间。

所以必须新增完整分段耗时。

#### 1.2.5 HLS 内核当前单次调用可能计算量偏大

文件：`fpga/hls/unified_surfel_observation_core/unified_surfel_observation_core.cpp`

当前内核核心循环为：

```cpp
for (uint32_t i = 0; i < num_points; ++i) {
    p = RotatePoint(...);
    LookupNearest(...);
    AccumulateUpper(...);
}
```

其中 `LookupNearest` 包含：

- 中心 cell 查找；
- 6/18/26 邻域查找；
- 每次 `LookupCell` 内对 `active_blocks` 做二分查找；
- 从 `obs_cells` 做随机访问；
- double 计算 residual/Jacobian/HTH/HTr。

需要重点确认 HLS 是否达到合理 II，以及瓶颈是否来自：

- 未 pipeline；
- double 运算；
- AXI DDR 随机读；
- 每点最多 27 次 block 二分查找；
- `active_blocks`/`obs_cells` 位于 PL DDR 但访问不连续；
- active cells 增长导致 cache/locality 变差。

---

## 2. 本次调查的核心问题

本次调查必须回答以下 8 个问题。

### Q1：单帧时间到底被谁吃掉？

拆成：

```text
T_frame = T_ros_callback_wait/dispatch
        + T_ProcessPointCloud2
        + T_SyncPackages
        + T_imu_undistort
        + T_downsample
        + T_ESKF_update
        + T_ObsModel_total
        + T_mapping_update
        + T_UI/loop/gridmap
```

### Q2：单次 FPGA_OBS transaction 的完整耗时是多少？

必须拆成：

```text
T_fpga_obs_total = T_export_active_map
                 + T_pack_scan
                 + T_runtime_construct
                 + T_file_lock
                 + T_open_fd
                 + T_h2c_scan_pose_header_params
                 + T_h2c_blocks_cells
                 + T_verify_readback
                 + T_reg_config
                 + T_hls_wait_done
                 + T_c2h_output
                 + T_decode_output
```

### Q3：一帧内是否重复向 FPGA 写入同一份 scan/map？

判断：

- 同一帧的 ESKF iteration 中，`scan_down_body_` 是否不变；
- `active_map.window_id/version` 是否不变；
- 只有 pose 是否变化；
- 如果 scan/map 不变，则当前 `write_full_image=true` 每次全量写入是可优化项。

### Q4：`obs_model_calls=5` 是否是性能下降的线性放大器？

需要验证：

```text
obs_total_ms ≈ obs_model_calls * fpga_obs_total_ms
```

如果成立，则说明当前瓶颈不是单次调用偶发卡顿，而是 ESKF 迭代模型下重复调用 FPGA_OBS 带来的结构性耗时。

### Q5：`xdma_elapsed_sec` 与 active_cells / scan_points 是否强相关？

需要绘图/统计：

```text
xdma_elapsed_sec vs scan_points
xdma_elapsed_sec vs active_blocks
xdma_elapsed_sec vs active_cells
xdma_elapsed_sec vs valid_count/miss_count
```

如果和 active_cells / active_blocks 强相关，则说明 HLS map lookup 或 DDR random access 可能是主瓶颈。

### Q6：IMU abnormal dt 是数据问题还是主线程消费延迟？

由于当前是离线数据集，如果 CPU-only 正常，则更可能是处理线程落后导致的“逻辑断流”。需要验证：

- rosbag 消息 header stamp 间隔是否正常；
- callback wall interval 是否被拉大；
- `imu_buffer_` 是否积压或被突发消费；
- `lidar_buffer_` 是否积压；
- `SyncPackages()` 看到的 lidar 时间是否跳变。

### Q7：ROS2 单线程 executor 是否扩大了问题？

需要做对照实验：

- 当前 `rclcpp::spin(node_)`；
- `MultiThreadedExecutor`；
- IMU/LiDAR 分 callback group；
- Lidar callback 仍然同步执行 LIO；
- Lidar callback 只入队，LIO worker 独立线程处理。

注意：该实验只用于确认调度影响，不代表最终必须大改架构。

### Q8：最终是否需要架构重构？

只有在完成 profiling 之后，根据数据决定：

- 仅做小修：缓存 map / 减少重复 H2C / 复用 fd / 减少 iteration；
- 中等改造：FPGA transaction 分 prepare/run 两阶段；
- 大改架构：ROS callback 与 LIO/FPGA worker 解耦，异步 pipeline。

---

## 3. 调查阶段总览

| 阶段 | 名称 | 是否改功能 | 目的 |
|---|---|---:|---|
| P0 | 日志与 profiling 基础埋点 | 否 | 建立证据闭环 |
| P1 | Orin 侧 XDMA transaction 分段耗时 | 否 | 判断 Host / DMA / HLS 各段耗时 |
| P2 | LIO / ESKF / ObsModel 调用链统计 | 否 | 判断每帧重复调用与迭代放大 |
| P3 | ROS2 调度与 buffer backlog 统计 | 否 | 判断 IMU/Lidar 异常是否由主线程阻塞造成 |
| P4 | HLS 性能与规模相关性分析 | 否 | 判断 FPGA 内核是否需要优化 |
| P5 | 对照实验矩阵 | 尽量只改配置 | 建立 CPU/FPGA/iteration/map size 的对比 |
| P6 | 整改方案决策 | 是/否待定 | 根据数据选择小修、中修或架构调整 |

---

## 4. P0：新增统一 Trace 机制

### 4.1 新增 trace 开关

建议在配置文件中增加：

```yaml
profile:
  fpga_trace_enable: true
  fpga_trace_csv_enable: true
  fpga_trace_csv_path: ./data/profile/fpga_obs_trace.csv
  ros_callback_trace_enable: true
  trace_log_every_n: 1
```

如果不想改 YAML parser，也可以先用环境变量：

```bash
export LIGHTNING_FPGA_TRACE=1
export LIGHTNING_ROS_TRACE=1
```

### 4.2 新增 CSV 输出文件

建议输出 3 个 CSV：

```text
./data/profile/fpga_obs_trace.csv
./data/profile/lio_frame_trace.csv
./data/profile/ros_callback_trace.csv
```

### 4.3 CSV 必须包含 frame_id / obs_call_id

所有 trace 必须带：

```text
frame_id
lidar_stamp_begin
lidar_stamp_end
obs_call_id_global
obs_call_id_in_frame
eskf_iter_index
```

否则无法判断“每帧多次 FPGA 调用”与“每次调用耗时”的关系。

---

## 5. P1：XDMA Runtime 分段耗时埋点

### 5.1 修改文件

```text
src/core/fpga/xdma_runtime.h
src/core/fpga/xdma_runtime.cc
```

### 5.2 扩展 `XdmaRuntime::RunResult`

建议新增：

```cpp
struct StageTiming {
    double total_sec = 0.0;
    double file_lock_sec = 0.0;
    double open_fd_sec = 0.0;
    double make_header_sec = 0.0;
    double h2c_scan_sec = 0.0;
    double h2c_pose_sec = 0.0;
    double h2c_map_header_sec = 0.0;
    double h2c_params_sec = 0.0;
    double h2c_active_blocks_sec = 0.0;
    double h2c_obs_cells_sec = 0.0;
    double verify_readback_sec = 0.0;
    double output_zero_sec = 0.0;
    double reg_config_sec = 0.0;
    double hls_wait_sec = 0.0;
    double c2h_output_sec = 0.0;

    uint64_t h2c_scan_bytes = 0;
    uint64_t h2c_pose_bytes = 0;
    uint64_t h2c_map_header_bytes = 0;
    uint64_t h2c_params_bytes = 0;
    uint64_t h2c_active_blocks_bytes = 0;
    uint64_t h2c_obs_cells_bytes = 0;
    uint64_t c2h_output_bytes = 0;
};

struct RunResult {
    ...
    StageTiming timing;
};
```

### 5.3 计时范围要求

当前 `elapsed_sec` 只保留为兼容字段，并明确重命名含义：

```cpp
result.elapsed_sec = result.timing.hls_wait_sec;
```

新增：

```cpp
result.timing.total_sec
```

它必须覆盖完整 `RunObservationImpl(...)`，从进入函数到读取 output 完成。

### 5.4 统计写入字节数

在 `RunObservationImpl` 中统计：

```cpp
h2c_scan_bytes          = scan_points.size() * sizeof(SlamAccelScanPoint);
h2c_pose_bytes          = sizeof(SlamAccelPose);
h2c_map_header_bytes    = sizeof(ActiveMapHeader);
h2c_params_bytes        = sizeof(SlamAccelObservationParams);
h2c_active_blocks_bytes = active_map.blocks.size() * sizeof(ActiveBlockRecord);
h2c_obs_cells_bytes     = active_map.cells.size() * sizeof(ObsCellFloat64);
c2h_output_bytes        = sizeof(SlamNormalEquation);
```

### 5.5 输出日志格式

每次 FPGA_OBS 成功后输出：

```text
[FPGA_OBS_TRACE]
frame=...
obs_call_in_frame=...
eskf_iter=...
scan_points=...
active_blocks=...
active_cells=...
h2c_total_bytes=...
c2h_total_bytes=...
total_ms=...
lock_ms=...
open_fd_ms=...
h2c_scan_ms=...
h2c_blocks_ms=...
h2c_cells_ms=...
verify_ms=...
reg_ms=...
hls_wait_ms=...
c2h_output_ms=...
status=0x...
error=0x...
run_count=a->b
```

### 5.6 验收标准

完成后必须能回答：

1. 单次 FPGA_OBS 完整耗时是多少？
2. `hls_wait_ms` 占比多少？
3. H2C 写入 active cells 是否显著？
4. open fd / lock 是否可忽略？
5. verify_readback 是否被误打开并拖慢？

---

## 6. P2：LIO / ESKF / ObsModel 调用链埋点

### 6.1 修改文件

```text
src/core/lio/eskf.cc
src/core/lio/laser_mapping.cc
src/core/lio/laser_mapping.h
src/utils/perf_monitor.cc
src/utils/perf_monitor.h
```

如果不想改 `PerfMonitor`，也可以先使用独立 CSV writer。

### 6.2 在 `ESKF::Update` 中记录迭代信息

文件：`src/core/lio/eskf.cc`

当前循环：

```cpp
for (int i = -1; i < maximum_iter_; i++) {
    ...
    lidar_obs_func_(x_, custom_obs_model_);
}
```

需要记录：

```text
frame_id
eskf_iter_raw_i
eskf_iter_index
maximum_iter
obs_model_call_start_wall
obs_model_call_end_wall
obs_model_call_ms
custom_obs_valid
valid_count/effect_count
lidar_residual_mean
lidar_residual_max
```

注意 `i=-1` 也是一次 observation call，不能漏掉。

### 6.3 在 `LaserMapping::ObsModelFpgaObservation` 中记录前后耗时

文件：`src/core/lio/laser_mapping.cc`

新增分段：

```text
T_obs_total
T_export_active_map
T_pack_extrinsic
T_pack_scan_points
T_make_pose
T_make_params
T_runtime_construct
T_run_mapping_observation_total
T_decode_output
T_set_obs
```

### 6.4 检查同帧重复数据

在 `ObsModelFpgaObservation` 中记录：

```text
scan_down_body_ptr
scan_down_body_size
active_map.window_id
active_map.version
active_map.blocks.size
active_map.cells.size
pose tx ty tz qx qy qz qw
```

并输出：

```text
same_frame_scan_same = true/false
same_frame_map_same = true/false
pose_changed = true/false
```

判断逻辑：

- 如果同一 `frame_id` 内 `active_map.version` 不变、scan size 不变，只有 pose 变化，则后续可考虑 **prepare/run 两阶段** 优化。

### 6.5 验收标准

必须输出一张表：

| frame | obs_calls | sum_obs_ms | avg_obs_ms | sum_fpga_total_ms | sum_hls_wait_ms | frame_total_ms |
|---:|---:|---:|---:|---:|---:|---:|
| 10 | 5 | ... | ... | ... | ... | ... |

并判断：

```text
frame_total_ms 是否约等于 obs_calls * fpga_obs_total_ms
obs_total_ms 是否约等于 sum_fpga_total_ms
```

---

## 7. P3：ROS2 调度与 Buffer Backlog 调查

### 7.1 修改文件

```text
src/core/system/slam.cc
src/core/lio/laser_mapping.cc
src/core/lio/laser_mapping.h
```

### 7.2 注意：不要简单用 wall_now - msg.header.stamp

离线 rosbag 的 `msg.header.stamp` 是数据采集时间，不一定等于系统 wall clock。不要直接用：

```cpp
rclcpp::Clock().now() - msg->header.stamp
```

作为 callback latency，除非明确启用了 `/clock` 和 `use_sim_time`。

### 7.3 应记录两类间隔

#### 7.3.1 消息时间戳间隔

```text
imu_stamp_delta = imu_stamp_current - imu_stamp_last
lidar_stamp_delta = lidar_stamp_current - lidar_stamp_last
```

用于判断原始数据时间戳是否连续。

#### 7.3.2 callback wall 间隔

使用 `std::chrono::steady_clock`：

```text
imu_callback_wall_delta = steady_now - last_imu_callback_wall
lidar_callback_wall_delta = steady_now - last_lidar_callback_wall
```

用于判断 ROS callback 是否被主线程阻塞。

### 7.4 在 IMU callback 中记录

文件：`src/core/system/slam.cc`

在：

```cpp
imu_sub_ = node_->create_subscription<sensor_msgs::msg::Imu>(...)
```

中记录：

```text
[ROS_IMU_TRACE]
imu_seq
imu_stamp
imu_stamp_delta
imu_callback_wall_delta
```

### 7.5 在 LiDAR callback 中记录

在 `cloud_sub_` 和 `livox_sub_` callback 中记录：

```text
[ROS_LIDAR_TRACE]
lidar_seq
lidar_stamp
lidar_stamp_delta
lidar_callback_wall_delta
proc_lidar_ms
```

### 7.6 在 `LaserMapping` buffer 中记录

文件：`src/core/lio/laser_mapping.cc`

在以下函数中记录 buffer size：

```cpp
ProcessIMU(...)
ProcessPointCloud2(...)
SyncPackages()
```

输出：

```text
imu_buffer_size_before
imu_buffer_size_after
lidar_buffer_size_before
lidar_buffer_size_after
measures_imu_count
lidar_begin_time
lidar_end_time
last_lidar_time
detected_lidar_gap
```

### 7.7 验收标准

必须判断：

| 现象 | 解释 |
|---|---|
| `imu_stamp_delta` 正常，但 `imu_callback_wall_delta` 很大 | ROS executor / callback 被阻塞 |
| `lidar_stamp_delta` 正常，但 `lidar_callback_wall_delta` 很大 | 处理线程跟不上 bag 播放 |
| `imu_buffer_` 突增或突降 | 消息堆积/突发消费 |
| `Proc Lidar` 大于 lidar 周期 | 必然造成在线输入消费落后 |

---

## 8. P4：HLS 内核性能调查

### 8.1 修改/检查文件

```text
fpga/hls/unified_surfel_observation_core/unified_surfel_observation_core.cpp
fpga/hls/unified_surfel_observation_core/README.md
fpga/hls/unified_surfel_observation_core/build/.../solution1.log
```

### 8.2 必须整理 HLS csynth 信息

从 Vivado HLS 报告中提取：

```text
Estimated clock period
Latency min / max
Interval / II
Loop pipeline 情况
BRAM/DSP/LUT/FF 使用率
m_axi bundle 配置
```

### 8.3 重点查看循环

核心循环：

```cpp
for (uint32_t i = 0; i < num_points; ++i) {
    LookupNearest(...);
    AccumulateUpper(...);
}
```

需要确认：

1. 该循环是否 pipeline；
2. II 是多少；
3. double 运算是否导致长 latency；
4. `LookupNearest` 内嵌 26 邻域搜索是否被完整展开或串行执行；
5. 每次 `LookupCell` 的 binary search 是否访问 PL DDR；
6. active block 查找是否可以缓存到 BRAM；
7. obs cell 访问是否随机导致 DDR 效率很低。

### 8.4 上板实测相关性

根据 `fpga_obs_trace.csv` 绘制：

```text
hls_wait_ms vs scan_points
hls_wait_ms vs active_blocks
hls_wait_ms vs active_cells
hls_wait_ms vs miss_count
hls_wait_ms vs valid_count
```

建议新增脚本：

```text
tools/analyze_fpga_slam_trace.py
```

输出：

```text
correlation matrix
scatter plot csv summary
p50/p90/p95 latency
```

如果暂时不画图，也必须输出 Pearson/Spearman 相关系数。

---

## 9. P5：对照实验矩阵

所有实验必须固定同一个 bag、同一个 config 起点、同一个运行时长或固定 frame 数。

### 9.1 实验 A：CPU-only baseline

配置：

```yaml
mapping_backend: CPU
fpga_global_enable: false
```

记录：

```text
frame_total_ms
eskf_update_ms
obs_total_ms
obs_model_calls
processing_fps
imu abnormal dt count
lidar gap count
```

### 9.2 实验 B：当前 FPGA_OBS 原始版本

配置保持当前：

```yaml
mapping_backend: FPGA_OBS
fpga_global_enable: true
fpga_mapping_enable: true
```

记录完整 trace。

### 9.3 实验 C：FPGA_OBS + max_iteration=1

目的：确认 ESKF iteration 放大效应。

配置：

```yaml
fasterlio:
  max_iteration: 1
```

判断：

- 如果 FPS 约提升到原来的 3~5 倍，则说明重复 ObsModel 调用是主因之一；
- 如果仍然很慢，则单次 FPGA_OBS/HLS 已经不可接受。

### 9.4 实验 D：FPGA_OBS + UI/loop/gridmap 关闭

目的：排除 UI / loop closing / grid map 干扰。

配置建议：

```yaml
ui:
  enable: false
loop_closing:
  enable: false
gridmap:
  enable: false
```

按实际配置字段修改。

### 9.5 实验 E：verify_readback 开/关对比

配置：

```yaml
mapping_xdma_verify_readback: false
```

若当前已经是 false，也需要在 trace 中确认 `verify_readback_sec=0`。

### 9.6 实验 F：限制 active map 尺寸

目的：确认 HLS wait 是否随 active cells 增长。

临时配置或代码限制：

```text
active_blocks cap: 64 / 128 / 256
active_cells cap: 16384 / 32768 / 65536
```

不要作为最终算法修改，只用于性能归因。

### 9.7 实验 G：只跑 FPGA golden replay，不跑 ROS2

已有入口：

```text
src/app/run_surfel_mapping_xdma_golden.cc
```

目的：得到纯 XDMA + HLS transaction baseline，排除 ROS2 调度影响。

记录：

```text
single transaction total_ms
hls_wait_ms
h2c bytes/ms
c2h bytes/ms
repeat stability p50/p95
```

### 9.8 实验 H：ROS2 MultiThreadedExecutor 对照

只作为实验分支，不作为最终默认修改。

修改：

```cpp
rclcpp::executors::MultiThreadedExecutor executor;
executor.add_node(node_);
executor.spin();
```

进一步实验：

- IMU callback group；
- LiDAR callback group；
- service callback group。

判断：

- 如果 abnormal dt 显著下降，但 FPS 仍低，则说明 ROS 调度问题是副作用，根本瓶颈仍在 FPGA_OBS/ESKF；
- 如果 FPS 也显著提升，则说明 SingleThreadedExecutor 放大了阻塞。

---

## 10. 数据分析脚本要求

新增脚本：

```text
tools/analyze_fpga_slam_trace.py
```

### 10.1 输入

```bash
python3 tools/analyze_fpga_slam_trace.py \
  --fpga ./data/profile/fpga_obs_trace.csv \
  --frame ./data/profile/lio_frame_trace.csv \
  --ros ./data/profile/ros_callback_trace.csv \
  --out ./data/profile/fpga_slam_trace_report.md
```

### 10.2 输出报告必须包含

```text
1. 总帧数
2. FPGA_OBS 总调用次数
3. 平均每帧 FPGA_OBS 调用次数
4. frame_total_ms p50/p90/p95/max
5. fpga_obs_total_ms p50/p90/p95/max
6. hls_wait_ms p50/p90/p95/max
7. h2c_cells_ms p50/p90/p95/max
8. active_cells p50/p90/p95/max
9. processing_fps p50/min/max
10. imu_stamp_delta 异常次数
11. imu_callback_wall_delta 异常次数
12. lidar_stamp_delta 异常次数
13. lidar_callback_wall_delta 异常次数
14. hls_wait 与 active_cells 相关系数
15. hls_wait 与 scan_points 相关系数
16. 结论分类
```

### 10.3 结论分类规则

脚本应自动给出初步分类：

```text
CASE_A_REPEATED_FPGA_CALLS
CASE_B_HLS_COMPUTE_SLOW
CASE_C_H2C_TRANSFER_SLOW
CASE_D_ROS_EXECUTOR_BACKLOG
CASE_E_ACTIVE_MAP_GROWTH
CASE_F_MIXED
```

分类逻辑示例：

```text
if obs_calls_per_frame >= 4 and obs_total_ms / frame_total_ms > 0.7:
    repeated_fpga_calls = true

if hls_wait_ms / fpga_obs_total_ms > 0.7:
    hls_compute_slow = true

if h2c_total_ms / fpga_obs_total_ms > 0.3:
    h2c_slow = true

if callback_wall_delta_p95 >> stamp_delta_p95:
    ros_backlog = true

if corr(hls_wait_ms, active_cells) > 0.7:
    active_map_growth = true
```

---

## 11. 可能整改方向

整改方向必须由 P0~P5 的结果触发，不允许提前拍脑袋决定。

---

### 11.1 方向 R1：小改，不改总体架构

适用条件：

```text
单次 FPGA_OBS 可接受，但每帧重复调用/重复数据准备造成放大。
```

可改项：

1. `XdmaRuntime` 作为 `LaserMapping` 成员持久化，避免每次构造；
2. `/dev/xdma*` fd 持久化，避免每次 open/close；
3. file lock 可选关闭或进程内单例锁；
4. 同一帧内缓存：
   - `ActiveMapBuffer`；
   - `scan_points`；
   - `extrinsic_R/T`；
   - `params`。
5. 同一帧 ESKF 多次迭代时，第一次写 full image，后续只写 pose + output_zero + start；
6. 关闭不必要的 verify readback；
7. 降低在线 smoke 阶段 `max_iteration`，作为临时验证手段。

建议 API：

```cpp
bool PrepareMappingObservationFrame(
    const std::vector<SlamAccelScanPoint>& scan_points,
    const loc::ActiveMapBuffer& active_map,
    const SlamAccelObservationParams& params,
    PreparedFrameHandle* handle,
    RunResult* result,
    std::string* error);

bool RunPreparedMappingObservation(
    const PreparedFrameHandle& handle,
    const SlamAccelPose& pose,
    RunResult* result,
    std::string* error);
```

---

### 11.2 方向 R2：中改，FPGA transaction 分两阶段

适用条件：

```text
H2C active cells / scan 写入耗时明显，且同一帧多次重复写 full image。
```

改法：

```text
Frame Prepare 阶段：
  写 scan_points
  写 active_map_header
  写 active_blocks
  写 obs_cells
  写 params

Each ESKF Iteration 阶段：
  只写 pose
  清 output
  start HLS
  read output
```

优点：

- 不改变 SLAM 算法；
- 不改变 HLS 主要计算；
- 显著减少重复 H2C 数据写入；
- 是当前架构的自然延伸，不算推翻。

---

### 11.3 方向 R3：HLS 内核优化

适用条件：

```text
hls_wait_ms 占 fpga_obs_total_ms 70% 以上，且与 active_cells/active_blocks/scan_points 强相关。
```

可能优化：

1. 给 point loop 加 pipeline，并检查 II；
2. 减少 double，评估 float/fixed-point；
3. 将 `active_blocks` 缓存到 BRAM；
4. 优化 block lookup：
   - 二分查找改 hash/direct index；
   - 或 Host 侧预编码候选 block/cell；
5. 减少每点 26 邻域 lookup 次数；
6. 将 mapping lookup 由“运行时搜索”改成“Host 预匹配 + FPGA 只算 residual/Jacobian/HTH/HTr”；
7. 多 CU / 多 bank 并行。

风险：

- 可能改变当前 unified surfel observation 的硬件结构；
- 需要重新 golden/cosim/bitstream；
- 不应作为第一步整改，除非 profiling 证明 HLS 是主因。

---

### 11.4 方向 R4：ROS2 调度优化

适用条件：

```text
callback wall delta 明显大于 message stamp delta，且 SingleThreadedExecutor 导致 IMU callback 被 lidar processing 阻塞。
```

可改项：

1. `MultiThreadedExecutor`；
2. IMU/LiDAR 分 callback group；
3. LiDAR callback 只入队，LIO worker 独立线程处理；
4. IMU callback 只更新 buffer，不做重计算；
5. 对 rosbag 离线回放增加处理限速或 drop 策略；
6. 若 FPGA 每帧仍耗时 > lidar 周期，则必须允许输入堆积保护。

注意：

> ROS2 调度优化可以消除“IMU 假异常/输入消费延迟”，但如果 FPGA_OBS 单帧仍需要 600ms~1500ms，它不能单独把 FPS 拉回 10Hz。

---

### 11.5 方向 R5：算法层减少 FPGA_OBS 调用次数

适用条件：

```text
obs_model_calls=5 是主要放大器，单次 FPGA_OBS 已经接近 100~300ms，无法满足每帧多次调用。
```

可选策略：

1. 在线 FPGA_OBS 阶段临时 `max_iteration=1/2`；
2. 前几次 IEKF iteration 使用 CPU/近似/缓存 observation，最后一次用 FPGA；
3. 只在收敛前后变化较大时更新 FPGA observation；
4. 缓存上一 iteration 的 lookup 结果，只更新 residual/Jacobian；
5. 将 FPGA 加速目标退回到更小粒度：只算 HTH/HTr，不在 FPGA 做 lookup。

风险：

- 可能影响定位/建图精度；
- 必须做轨迹误差与地图质量对比。

---

## 12. 最终决策树

完成调查后按以下规则决策。

### 12.1 不需要大改架构

满足：

```text
fpga_obs_total_ms 单次可接受；
主要问题来自重复导出/重复 H2C/open/lock；
ROS backlog 是主线程长时间处理的副作用；
HLS wait 不是绝对瓶颈。
```

整改：

```text
R1 + R2
```

即持久化 runtime、缓存 frame 数据、prepare/run 分离。

---

### 12.2 需要中等改造

满足：

```text
单次 HLS wait 100~300ms；
obs_model_calls=5 导致总帧时间 600~1500ms；
降低 max_iteration 后 FPS 线性改善；
H2C 不是主要问题。
```

整改：

```text
R2 + R5
```

即分离 prepare/run，同时减少每帧 FPGA 调用次数或设计缓存 observation。

---

### 12.3 需要 HLS/硬件结构优化

满足：

```text
hls_wait_ms 占比最高；
hls_wait 与 active_cells/active_blocks 强相关；
即使 max_iteration=1 也不能达到实时。
```

整改：

```text
R3
```

重点优化 lookup、内存访问、double、pipeline。

---

### 12.4 需要 ROS2 pipeline 重构

满足：

```text
callback wall delta 远大于 stamp delta；
MultiThreadedExecutor 或 worker 化能明显降低 IMU abnormal dt；
但计算吞吐仍需另行优化。
```

整改：

```text
R4
```

将 ROS callback 与 LIO/FPGA 处理解耦。

---

### 12.5 需要重新定义 FPGA 加速边界

满足：

```text
FPGA 做 lookup + residual + HTH/HTr 的整体收益低于 CPU；
HLS lookup 随 active map 增长不可控；
PCIe/PL DDR random access 使当前 unified observation 不适合实时在线。
```

整改：

```text
重新评估加速边界：
  CPU 做 surfel lookup / data association；
  FPGA 只做 residual/Jacobian/HTH/HTr 规约；
或 Host 侧预生成每点候选 cell，FPGA 只做固定小规模选择和累加。
```

这是较大架构调整，必须有 profiling 证据支撑。

---

## 13. Codex 执行清单

### 13.1 第一批提交：只加 trace，不改行为

需要修改：

```text
src/core/fpga/xdma_runtime.h
src/core/fpga/xdma_runtime.cc
src/core/lio/laser_mapping.h
src/core/lio/laser_mapping.cc
src/core/lio/eskf.cc
src/core/system/slam.cc
```

新增：

```text
tools/analyze_fpga_slam_trace.py
```

输出：

```text
./data/profile/fpga_obs_trace.csv
./data/profile/lio_frame_trace.csv
./data/profile/ros_callback_trace.csv
./data/profile/fpga_slam_trace_report.md
```

验收：

```bash
colcon build --packages-select lightning --cmake-args -DCMAKE_BUILD_TYPE=Release
source install/setup.bash
ros2 run lightning run_slam_online --config ./config/default_livox.yaml
python3 tools/analyze_fpga_slam_trace.py \
  --fpga ./data/profile/fpga_obs_trace.csv \
  --frame ./data/profile/lio_frame_trace.csv \
  --ros ./data/profile/ros_callback_trace.csv \
  --out ./data/profile/fpga_slam_trace_report.md
```

---

### 13.2 第二批提交：实验配置，不改核心算法

新增/修改配置：

```text
config/default_livox_fpga_trace.yaml
config/default_livox_fpga_iter1.yaml
config/default_livox_fpga_no_ui.yaml
config/default_livox_cpu_baseline.yaml
```

每个配置必须记录：

```text
mapping_backend
fpga enable
max_iteration
ui enable
loop closing enable
gridmap enable
verify_readback
```

---

### 13.3 第三批提交：根据报告选择整改分支

Codex 不应自行决定大改架构。第三批必须先输出：

```text
Bottleneck classification:
- repeated_fpga_calls: true/false
- hls_compute_slow: true/false
- h2c_transfer_slow: true/false
- ros_executor_backlog: true/false
- active_map_growth: true/false

Recommended remediation:
- R1/R2/R3/R4/R5

Reason:
- 用 CSV 数据支撑
```

---

## 14. 本次调查完成后的期望报告模板

Codex 最终需要生成：

```text
data/profile/fpga_slam_trace_report.md
```

报告结构：

```md
# FPGA-SLAM Trace Report

## 1. Test Setup
- commit id:
- config:
- bag:
- FPGA bitstream:
- XDMA driver:
- Orin platform:

## 2. Summary
| metric | value |

## 3. Frame Timing
| frame | total_ms | eskf_ms | obs_total_ms | obs_calls | fps |

## 4. FPGA Transaction Timing
| p50 | p90 | p95 | max |

## 5. H2C/C2H Breakdown
| stage | p50_ms | p95_ms | bytes_p50 |

## 6. ESKF Iteration Amplification
- obs_calls_per_frame:
- sum_fpga_ms_per_frame:
- ratio_to_frame_total:

## 7. ROS Callback / Buffer Analysis
- imu stamp delta:
- imu callback wall delta:
- lidar stamp delta:
- lidar callback wall delta:
- abnormal count:

## 8. Correlation Analysis
- hls_wait vs scan_points:
- hls_wait vs active_cells:
- hls_wait vs active_blocks:

## 9. Bottleneck Classification

## 10. Recommended Remediation

## 11. Whether Architecture Must Change
```

---

## 15. 当前最可能的调查结论预期

注意：以下只是预期，不是最终结论。

从当前日志和源码结构看，最可能的瓶颈组合是：

```text
1. 每帧 ESKF 约 5 次 ObsModel 调用；
2. 每次 ObsModel 都同步调用 FPGA_OBS；
3. 每次 FPGA_OBS 都可能重复准备/写入 scan + active map；
4. HLS 单次 wait 约 100~300ms；
5. 所以单帧 obs_total 约 5 * 100~300ms = 500~1500ms；
6. ROS2 默认 spin 单线程进一步导致 IMU/Lidar callback 消费延迟；
7. 因此在线日志出现 IMU abnormal dt 和 lidar 断流。
```

所以，当前更像：

```text
“FPGA_OBS 在线接入方式 + ESKF 迭代调用模型 + ROS2 单线程调度”共同导致实时性崩溃。
```

但最终必须以 trace 数据为准。

---

## 16. 禁止事项

在完成本调查前，禁止：

1. 直接推翻当前 surfel unified FPGA 架构；
2. 直接把所有逻辑改成异步 pipeline；
3. 直接修改 HLS 算法语义；
4. 直接降低精度参数并声称优化成功；
5. 只看 `xdma_elapsed_sec` 就判断 PCIe 或 FPGA 性能；
6. 用 wall clock 与 rosbag header stamp 直接相减判断 callback latency；
7. 忽略 `obs_model_calls` 对总耗时的线性放大。

---

## 17. 最小可接受结论

本调查完成后，至少要能回答：

1. 单次 FPGA_OBS 完整 transaction 平均耗时是多少？
2. `hls_wait`、H2C、C2H、fd/open/lock 各占多少？
3. 每帧调用 FPGA_OBS 几次？
4. 同一帧内是否重复写入相同 active map？
5. `active_cells` 增长是否导致 HLS wait 增长？
6. CPU-only 与 FPGA_OBS 的 `obs_model_calls` 是否一致？
7. IMU abnormal dt 是否由 callback wall delay 造成？
8. 最终应选择 R1/R2/R3/R4/R5 哪条整改路线？

---

## 18. 2026-06-21 正确 `--config` 后 Mapping + Localization FPGA_OBS 在线证据

### 18.1 本轮命令与状态确认

本轮定位在线测试使用了正确参数形式：

```bash
ros2 run lightning run_loc_online --config ./config/default_livox.yaml
```

日志确认 mapping 与 localization 都真实进入 FPGA_OBS：

```text
[LaserMapping] mapping_backend=FPGA_OBS
[LidarLoc] backend=SURFEL_FPGA_OBS
```

因此，本轮卡顿不是 `config` 参数未生效，也不是单纯 ROS2 命令写法问题。

本轮主要证据来自：

```text
data/profile/fpga_obs_trace.csv
data/profile/loc_fpga_obs_trace.csv
```

### 18.2 关键统计

Mapping FPGA_OBS：

```text
rows: 315
scan_points mean ~= 840
active_cells mean ~= 36,597
h2c_map mean ~= 6 ms
hls_wait mean ~= 178 ms
total mean ~= 344 ms
mutex_wait p95 ~= 1610 ms
```

Localization FPGA_OBS：

```text
rows: 36
scan_points mean ~= 5,756
active_blocks = 3,719
active_cells = 952,064
h2c_map mean ~= 147 ms
hls_wait mean ~= 1536 ms
total mean ~= 1852 ms
first rebuild_window ~= 213 ms
```

相关性：

```text
Mapping hls_wait vs scan_points corr ~= 0.775
Mapping hls_wait vs miss_count corr ~= 0.876
Localization hls_wait vs scan_points corr ~= 0.908
Localization hls_wait vs miss_count corr ~= 0.771
```

典型现象：

```text
localization 一次迭代 hls_wait 可达 0.7~2.2s
localization 一帧多次迭代后 xdma_total_sum 可达数秒
mapping 在 localization 持有 XDMA lock 时 mutex_wait 可达 1s+
随后出现 lidar/imu backlog、abnormal dt、雷达断流
```

### 18.3 当前结论

当前第一瓶颈是：

```text
HLS observation kernel 的 lookup / PL DDR 随机访问太慢。
```

PCIe Gen2 x1 是次级瓶颈：

```text
localization h2c_map mean ~= 147 ms
localization hls_wait mean ~= 1536 ms
```

即使 PCIe 从 x1 修到 x4，只降低 H2C 传输，也无法单独把定位 FPGA_OBS 从秒级降到 30Hz 所需的 33ms 以内。

ROS2 backlog、雷达断流、轨迹发散更像是慢处理导致的结果，不是本轮第一根因。

另外，`run_loc_online` 内部仍运行 LIO front-end；当配置里 mapping 与 localization 同时打开 FPGA_OBS 时，两者会竞争同一 XDMA/HLS runtime lock。此时 mapping 的秒级 `mutex_wait` 不是 mapping kernel 本身变慢，而是排队等待 localization 大任务完成。

### 18.4 整改路线选择

本轮调查优先选择：

```text
R3: HLS lookup / PL DDR 访问结构优化
R2/R5: Orin 侧减少重复传输、缩小 active map、减少在线调用次数
```

暂不把 PCIe x1 作为第一整改项。PCIe x4 后续仍要修，但它不是当前 1Hz/卡顿的主因。

---

## 19. Stage58：Windows/HLS 侧 Unified Observation Kernel 性能整改

Stage58 的目标不是改在线 ROS2 流程，而是先让 golden/replay 上的 HLS kernel 本身显著降耗。

### 19.1 必须新增的 HLS 性能报告

分别覆盖：

```text
mapping golden frame_000001
localization golden frame_000001
synthetic sweep:
  scan_points = 256/512/1024/2048/4096/6963
  active_cells = 16k/32k/64k/128k/256k/512k/952k
```

建议在 HLS output reserved words 或 debug build 中增加 counters：

```text
point_count
neighbor_probe_count
block_lookup_count
obs_cell_read_count
exact_hit / neighbor_hit / miss
max_probe_per_point
```

### 19.2 优先优化点

1. 将 `active_blocks` 缓存到 BRAM/URAM，避免每点 26-neighbor 都对 DDR 做 block lookup。
2. 减少每点 26 邻域的二分查找次数。
3. 对 block lookup 建立 hash/direct-index 辅助结构。
4. 将 obs cell 访问尽量改成顺序/局部 burst，减少随机 DDR 读。
5. 检查 point loop pipeline II、cycle、latency、resource。

如果这些仍不能把 full localization observation 降到目标量级，则进入 ABI v2：

```text
Host/Orin 预计算候选 cell/block 索引
FPGA 只做 residual / Jacobian / HTH / HTr accumulation
```

### 19.3 Stage58 验收

```text
mapping XDMA golden counts 仍为 611/0/171
localization XDMA golden counts 仍为 6050/911/2
H/b 仍满足 abs <= 1e-4 或 rel <= 1e-3
mapping sweep latency 显著下降
localization full-frame hls_wait 至少下降 5x，最好 20x+
```

---

## 20. Stage59：Orin 侧在线调用方式整改

Stage59 与 Stage58 并行推进，但不应掩盖 HLS 主瓶颈。

### 20.1 配置规则

测试 mapping 性能：

```yaml
fpga:
  enable: true
  mapping:
    enable: true
    mode: fpga_obs
  localization:
    enable: false
```

测试 localization 性能：

```yaml
fpga:
  enable: true
  mapping:
    enable: false
  localization:
    enable: true
    mode: fpga_obs
```

不再默认同时打开两者，除非专门测试 XDMA 竞争。

### 20.2 定位 active map 缩小

当前 localization `active_cells = 952064`，不适合在线每帧全量传给 FPGA。建议新增 FPGA_OBS 专用限制：

```yaml
lidar_loc:
  surfel_fpga_max_active_blocks: 256
  surfel_fpga_max_active_cells: 65536
  surfel_fpga_window_radius_m: 30.0
```

第一版只影响 FPGA_OBS，不改变 NDT/CPU_SIM 默认路径。

### 20.3 减少重复调用

1. mapping/localization 第一版在线 FPGA_OBS smoke 只允许 `max_iterations=1`。
2. 后续再做 correspondence reuse / one-shot observation。
3. 不在每次 ObsModel 中重新构造 runtime。
4. 将在线流程拆成：

```text
PrepareFrame(): 写 scan/map
RunPoseObservation(): 只更新 pose/output/control 并启动 HLS
```

### 20.4 Stage59 验收

```text
mapping-only FPGA_OBS 无 XDMA mutex_wait 长尾
localization-only FPGA_OBS 无 mapping 竞争
active_cells 明显下降
h2c_map 明显下降
hls_wait 随 active_cells/scan_points 下降
无持续 abnormal dt / 雷达断流
```

---

## 21. Stage60：重新进入联合建图定位联调

进入条件：

```text
Stage58 Windows/HLS golden replay 性能明显改善
Stage59 mapping-only 在线 smoke 稳定
Stage59 localization-only 在线 smoke 稳定
两者单独运行时都没有 XDMA timeout / CmpltTO / AER fatal
```

联合配置：

```yaml
fpga:
  enable: true
  mapping:
    enable: true
    mode: fpga_obs
    fallback: cpu
  localization:
    enable: true
    mode: fpga_obs
    fallback: ndt_omp
```

联合验收：

```text
mapping_backend=FPGA_OBS
localization backend=SURFEL_FPGA_OBS
XDMA mutex_wait 不再出现秒级等待
Proc Lidar 不超过 lidar 周期
无持续 abnormal dt / 雷达断流
CPU baseline vs FPGA_OBS 轨迹差异、失败帧、fallback 次数写入 report
```

在 Stage58/59 之前，不建议继续做 mapping + localization 同时 FPGA_OBS 的在线联调，因为现在测到的主要是 XDMA/HLS 串行竞争和队列积压。

---

# End

---

## 22. Stage58 Windows/HLS Result

Stage58 Windows/HLS optimization has been implemented.

Scope:

```text
No math semantic change.
No BAR shim / XDMA / MIG / register-map change.
No host-visible normal-equation ABI change in output_words[0..31].
```

Implemented optimization:

```text
active_blocks are copied once per kernel launch into local BRAM.
Block binary search now uses the local active-block cache.
Each point reuses block-index lookup results across the 27 center/neighbor probes.
obs_cells remain in PL DDR for this first optimization round.
output_words[32..39] now contain Stage58 performance/debug counters.
```

Windows validation:

```text
g++ CSim PASS
Vivado HLS CSim PASS
Vivado HLS C Synthesis PASS
Vivado HLS IP export PASS
Vivado BD validate PASS
Vivado project synthesis PASS with -Jobs 18
Vivado implementation/bitstream PASS with -Jobs 18
```

Correctness:

```text
localization frame_000001: 6050/911/2 PASS
mapping frame_000001: 611/0/171 PASS
synthetic sweep PASS
reject and mapping lookup probes PASS
```

HLS C Synthesis summary:

```text
target clock: 10.00 ns
estimated clock: 9.307 ns
BRAM_18K: 184 / 1510 = 12%
DSP48E: 348 / 2020 = 17%
FF: 64051 / 554800 = 11%
LUT: 102449 / 277400 = 36%
```

Implementation summary:

```text
bitstream: fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
post-route WNS: 0.090 ns
post-route WHS: 0.028 ns
DRC errors: 0
critical warnings: 0
```

Build-time note:

```text
Continue using -Jobs 18 for board-level synth/impl/bitstream.
Long 30-60 minute builds are still expected because Vivado 2018.3 route,
timing and bitgen steps internally use only a limited number of CPUs.
Do not run full implementation for every small HLS edit; use g++ CSim,
Vivado HLS CSim and C Synthesis first.
```

Next Orin gate:

```bash
./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120

./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120
```

Then compare `hls_wait` with Stage57/54 baseline. If localization full-frame
`hls_wait` does not improve by at least 5x, move to ABI v2: Orin precomputes
candidate block/cell indices, FPGA only performs residual selection, Jacobian
and H/b accumulation.
