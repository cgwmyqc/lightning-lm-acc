# Lightning-LM 定位算法 FPGA 友好化与 Orin/FPGA 地图管理实施路线（7Z100 统一复用版）

> 适用对象：Codex / Orin 侧开发 / Windows Vivado-HLS/RTL 侧开发。  
> 更新目的：在实验室具备 7Z100 开发板的前提下，把定位链路从 `TiledMap + NDT_OMP + PCL` 主链路，改造成与建图链路共用的 `SurfelTileMap + active local map window + unified_surfel_observation_core`。  
> 合同指标：机器人定位精度 ±1.5 cm，建图精度 ≤5 cm。  
> 核心原则：**7Z100 允许更完整地硬件化 BatchUpdate、DirtyRefit 和可选 6×6 solve，但建图与定位仍必须复用同一套 observation pipeline，不能做两套重复 FPGA kernel。**  
> PCIe 原则：**PCIe 2.0 ×8 用于提高 active map window、scan batch、dirty blocks 和 debug/replay 数据的搬运能力；它不能替代 Orin 的全局地图管理，也不能让 FPGA 每帧加载全部地图。**

---

## 0. 总体结论

当前定位模块不能继续只依赖 `NDT_OMP` 作为最终芯片化主链路。定位需要改造成和建图一致的 scan-to-surfel-map 形式：

```text
全局地图 / 建图输出地图
  -> Orin 离线转换为 SurfelTileMap
  -> Orin 按当前 pose / LO / DR 选择 active local map window
  -> Orin 将 active surfel blocks 上传到 FPGA DDR
  -> FPGA 使用统一 observation core 做 lookup + residual/Jacobian + HTH/HTr
  -> Orin 或 FPGA solve6x6 得到 pose increment
  -> Orin 做迭代控制、质量判断、PGO/fallback
```

定位 FPGA 化的关键不是把 `NDT_OMP` 搬进 FPGA，而是新增一条 FPGA-friendly 定位后端：

```text
SurfelLocBackend:
  CPU_SIM
  FPGA_OBS_ONLY
  FPGA_OBS_SOLVE6X6
  FPGA_WITH_NDT_FALLBACK
```

---

## 1. 建图和定位必须复用的统一算法核心

### 1.1

为了避免资源浪费，定位不要单独实现一套 `loc_observation_core`。应统一为：

```text
unified_surfel_observation_core
```

该 core 同时服务建图和定位：

```text
mode = MAPPING_OBSERVATION
mode = LOCALIZATION_OBSERVATION
```

两种模式的区别只在于地图来源和是否允许地图更新。

| 项目 | 建图模式 | 定位模式 |
|---|---|---|
| 输入 scan | 当前帧去畸变/下采样点云 | 当前帧去畸变/下采样点云 |
| 输入 pose | ESKF 当前预测位姿 | LO/DR/上一帧定位位姿 |
| 输入地图 | 在线 active BlockSurfelMap | 全局 SurfelTileMap 的 active window |
| lookup | 共用 | 共用 |
| residual/Jacobian | 共用 | 共用 |
| HTH/HTr | 共用 | 共用 |
| score/statistics | 共用 | 共用 |
| BatchUpdate | 启用 | 默认禁用 |
| DirtyRefit | 启用或低频启用 | 默认禁用，除非维护临时局部动态地图 |
| 6×6 solve | 可选 | 可选 |
| 全局地图管理 | Orin | Orin |

核心单点流程完全一致：

```text
p_body
  -> p_world = R * p_body + t
  -> block/cell encode
  -> active block table lookup
  -> exact / 6 / 18 / 26 neighbor surfel lookup
  -> residual = nᵀ(p_world - centroid)
  -> valid check
  -> Jacobian
  -> HTH/HTr accumulation
```

---

## 2. 定位模式 Orin/FPGA 分工

### 2.1

定位时，Orin 必须负责：

```text
- 读取全局地图索引 surfel_index.yaml
- 加载/卸载 SurfelTileMap tile 文件
- 根据 pose 选择 active local map window
- 打包 active_map_buffer
- 通过 XDMA H2C 上传 active map / scan / pose
- 调用 unified_surfel_observation_core
- 根据 HTH/HTr 执行位姿迭代，或调用 FPGA solve6x6
- 判断 valid_count、residual、score、pose increment 是否可信
- 必要时扩大地图窗口或回退 NDT_OMP
- 输出 LocalizationResult 并进入 PGO
```

### 2.2

FPGA 只看到当前局部地图窗口：

```text
active_map_header
active_block_table
active_obs_cell_records
scan_points
pose_guess
output_normal_equation
```

FPGA 不负责：

```text
- 读取 PCD / yaml / index 文件
- 保存全局地图
- 动态创建或删除全局 map chunk
- 全局重定位策略
- PGO
- ROS2 节点调度
```

---


## 3. PCIe 2.0 ×8 对定位架构的利用方式

### 3.1 作用边界

7Z100 开发板具备 PCIe 2.0 ×8 条件时，定位模式可以更充分利用 Orin 与 FPGA 之间的数据搬运能力。需要明确：PCIe 2.0 ×8 提升的是 **Orin ↔ FPGA 的数据吞吐**，不是直接提升 FPGA 内部算术核速度。

理论带宽估算：

```text
PCIe 2.0 单 lane：5 GT/s，8b/10b 编码后约 500 MB/s
PCIe 2.0 ×8：约 4 GB/s 单向理论峰值
全双工：H2C 与 C2H 可同时传输
```

工程上应按有效带宽设计和测试：

```text
期望有效 H2C/C2H：1.5 GB/s ~ 3.2 GB/s
若长期只有几百 MB/s，应优先检查 XDMA、AXI、DDR、host 工具和传输块大小，而不是怀疑 PCIe 标准本身。
```

### 3.2 必须验证实际链路宽度

开发板支持 ×8 不代表系统实际训练到 ×8。Orin 或 x86 主机上必须检查 `LnkSta`：

```bash
sudo lspci -vv -s <Xilinx设备BDF>
```

必须重点确认：

```text
LnkCap: Speed 5GT/s, Width x8
LnkSta: Speed 5GT/s, Width x8
```

其中 `LnkSta` 才是实际运行状态。如果看到：

```text
LnkSta: Width x1
```

则说明链路实际退化到 ×1，无法利用 ×8 带宽。常见原因包括：

```text
- 使用了 ×1 转接线或 ×1 延长线
- Orin/主机插槽不支持 ×8
- Vivado PCIe/XDMA 配置不是 ×8
- PCIe reset / refclk / lane polarity / equalization 问题
- 开发板供电或时钟不稳定导致降速/降宽
```

### 3.3 对定位 active local map window 的帮助

定位模式下，FPGA 不加载全局地图，只使用 Orin 选择出来的 active local map window。PCIe 2.0 ×8 允许 active window 做得更大、切换更快：

```text
正常定位：
  active_radius_xy_m = 35 ~ 50 m
  max_active_blocks = 4096 ~ 8192
  map_window_changed 时上传 active_map_buffer

定位置信度低：
  扩大 active_radius_xy_m 到 60 m 或更大
  上传更大的 active_map_buffer
  尝试多个 pose_guess
  根据 FPGA 返回的 score / valid_count / residual 选择最优解
```

但仍然禁止每帧上传全部地图。正确策略是：

```text
map upload frequency << scan frequency
scan 每帧上传
active map 仅在窗口切换或版本变化时上传
```

### 3.4 compact ObsCell 与带宽预算

定位只读匹配不需要 `sum/scatter/dirty`，应使用 compact ObsCell，而不是完整建图 UpdateCell。

推荐定位用：

```text
ObsCellCompact32/64:
  centroid[3]
  normal[3]
  plane_d
  quality
  count
  flags
```

带宽估算：

```text
1 block = 8 × 8 × 4 = 256 cells
ObsCellCompact32: 256 × 32B = 8KB/block
4096 blocks: 4096 × 8KB = 32MB
8192 blocks: 8192 × 8KB = 64MB
```

在 PCIe 2.0 ×8 下，几十 MB 级 active map window 上传是可以接受的，但不应每帧上传。定位窗口应采用版本号缓存：

```text
if map_window_version unchanged:
    reuse FPGA DDR active map
else:
    H2C upload active_map_buffer
```

### 3.5 定位多假设与大窗口重试

PCIe 2.0 ×8 支持定位后端增加鲁棒性策略：

```text
1. 正常用小窗口 + 单 pose_guess。
2. valid_count 低或 residual 大时，Orin 扩大 active window。
3. Orin 生成多个 pose_guess，例如 LO、DR、上一帧定位、人工初值附近扰动。
4. FPGA 复用同一个 active_map_buffer，分别计算多个 observation score。
5. Orin 选择 score 最优且满足阈值的定位结果。
```

第一版可以串行跑多假设；7Z100 资源允许时，可扩展为多 lane 或多 command queue。

### 3.6 双缓冲与流水线

定位模式建议至少使用双缓冲：

```text
scan_buffer[2]
output_buffer[2]
active_map_buffer[2]
```

目标流水线：

```text
FPGA 计算 frame N
Orin 上传 frame N+1 scan / pose
Orin 下载 frame N-1 output
active map window 变化时，切换到备用 map buffer
```

这样 PCIe 传输与 FPGA 计算可以重叠，降低端到端延迟。

### 3.7 定位侧推荐 DDR buffer 规划

建议在 7Z100 工程中预留足够 DDR 地址空间：

```text
FPGA DDR Layout for Localization:

0x0100_0000 - 0x03FF_FFFF  scan input ring buffer
0x0400_0000 - 0x07FF_FFFF  observation output / residual debug
0x0800_0000 - 0x1FFF_FFFF  active ObsCell map buffer A/B
0x3000_0000 - 0x37FF_FFFF  multi-hypothesis pose / score buffers
0x3800_0000 - 0x3FFF_FFFF  golden replay / debug buffer
```

正式模式只回传：

```text
H_upper[21]
b[6]
valid_count / reject_count / miss_count
mean/max residual
score / perf counter
```

调试模式可额外回传：

```text
per-point residual buffer
hit block/cell id
miss_reason list
correspondence debug list
```

调试模式不能作为性能验收模式。


## 4. 7Z100 目标下的定位硬件能力

7Z100 资源比 7Z015 宽裕很多，因此定位侧可以规划三档硬件能力：

### 4.1

```text
FPGA:
  unified_surfel_observation_core
    - transform
    - lookup
    - residual/Jacobian
    - HTH/HTr
    - score/statistics

Orin:
  6×6 solve
  迭代控制
  fallback
```

优点：

```text
- 复用建图 observation core
- 最容易与 CPU_SIM 对齐
- 风险最低
```

### 4.2

```text
FPGA:
  unified_surfel_observation_core
  optional_solve6x6_core

Orin:
  迭代控制
  map window 管理
  fallback
```

输出由：

```text
H_upper[21] + b[6]
```

变为：

```text
pose_delta[6] + quality statistics
```

但 Orin 仍应读取 HTH/HTr 用于 debug 和 CPU/FPGA 对比。

### 4.3

定位通常不更新权威全局地图，但可以维护一个临时动态局部缓存：

```text
- 用于短时动态场景适应
- 不写回全局地图
- 可在定位失败时清空
```

不建议作为第一版验收目标。

---

## 5. 定位地图格式：只读 Compact ObsCell

定位不需要保存建图更新所需的全部统计量，因此定位地图不能直接使用完整 `VoxelCell128` 作为热路径格式。

### 5.1

建图更新需要：

```text
count
sum[3]
scatter[6]
dirty flag
version
```

定位匹配只需要：

```text
centroid[3]
normal[3]
plane_d
quality
count
flags
```

因此建议定义两类 cell：

```text
UpdateCell64/128   用于建图 BatchUpdate 和 DirtyRefit
ObsCellCompact32/64 用于建图/定位 observation lookup
```

定位 active map 使用 `ObsCellCompact`：

```cpp
struct alignas(32) ObsCellCompact32 {
    float centroid_x;
    float centroid_y;
    float centroid_z;
    float normal_x;
    float normal_y;
    float normal_z;
    float plane_d;
    uint16_t count;
    uint16_t quality_q;   // 可先保留 float32 版本，后续再量化
    uint16_t flags;
    uint16_t reserved;
};
```

第一版可以先用 64B float32 对齐版本，保证正确性：

```cpp
struct alignas(64) ObsCellFloat64 {
    float centroid_x, centroid_y, centroid_z;
    float normal_x, normal_y, normal_z;
    float plane_d;
    float quality;
    uint32_t count;
    uint32_t flags;
    uint32_t reserved[6];
};
```

### 5.2

如果继续用完整 128B cell：

```text
1 block = 256 × 128B = 32KB
```

如果改成 64B observation cell：

```text
1 block = 256 × 64B = 16KB
```

如果后续量化为 32B：

```text
1 block = 256 × 32B = 8KB
```

定位 active window 往往需要上千个 block。compact 格式可以显著降低 DDR 带宽、PCIe 上传时间和 cache 压力。

---

## 6. Active Local Map Window 设计

### 6.1

新增模块：

```text
src/core/localization/surfel_loc/
  surfel_tile.h/.cc
  surfel_tile_map.h/.cc
  surfel_map_window.h/.cc
  surfel_loc_backend.h/.cc
  surfel_loc_golden_dumper.h/.cc
```

Orin 侧地图窗口逻辑：

```text
current_pose
  -> 计算需要的 tile keys
  -> 加载缺失 tiles
  -> 卸载远处 tiles
  -> 转换为 active obs block set
  -> 构建 active_block_table
  -> 打包 active_map_buffer
  -> 上传到 FPGA DDR
```

### 6.2

建议配置：

```yaml
localization:
  backend: SURFEL_FPGA_WITH_NDT_FALLBACK
  surfel_backend:
    active_radius_xy_m: 35.0
    active_radius_z_m: 4.0
    reload_margin_m: 8.0
    max_active_tiles: 32
    max_active_blocks: 16384
    cell_format: ObsCellFloat64
    upload_when_window_changed: true
    force_upload_every_n_frames: 0
    min_valid_count: 500
    max_mean_residual: 0.08
    max_pose_update_norm: 0.5
    fallback_to_ndt: true
```

7Z100 方案中 `max_active_blocks` 可以比 7Z015 更大，但仍必须由 Orin 裁剪，不允许 FPGA 管理全局地图。

### 6.3

第一版推荐 open addressing hash table：

```cpp
struct ActiveBlockEntry {
    int32_t bx;
    int32_t by;
    int32_t bz;
    uint32_t block_id;
    uint32_t valid;
};
```

FPGA 查询：

```text
world point
  -> grid index
  -> block key + cell idx
  -> hash(block key)
  -> probe active block table
  -> get block_id
  -> read block[cell_idx]
```

后续优化可做 dense local block table：

```text
origin_block + window_dim_x/y/z + offset table
```

dense table 适合室内有限范围；hash table 适合稀疏大场景。

---

## 7. 定位后端新增代码任务

### LOC-P0：冻结当前 NDT_OMP baseline

目标：保留原定位作为 fallback 和验收对照。

任务：

```text
1. 增加 LocBackendType 枚举：
   - NDT_OMP
   - SURFEL_CPU_SIM
   - SURFEL_FPGA_OBS
   - SURFEL_FPGA_OBS_SOLVE
   - SURFEL_FPGA_WITH_NDT_FALLBACK

2. `LidarLoc` 中保留 NDT_OMP 代码。
3. 增加定位 profile：
   - loc_backend
   - loc_time_ms
   - ndt_score
   - surfel_valid_count
   - surfel_mean_residual
   - active_window_id
   - active_window_version
   - fpga_latency_ms
   - fallback_reason
```

验收：

```text
backend=NDT_OMP 时原定位行为不变。
```

---

### LOC-P1：构建 SurfelTileMap 离线转换工具

新增工具：

```text
src/app/build_surfel_loc_map.cc
```

输入：

```text
global.pcd
或 TiledMap chunks
或建图输出的 surfel map snapshot
```

输出：

```text
surfel_index.yaml
tiles/tile_x_y_z.smap
```

`.smap` 文件必须是固定二进制格式，不能保存 PCL 对象、C++ 指针或 `std::vector/unordered_map` 内部结构。

建议头：

```cpp
struct SurfelTileFileHeader {
    uint32_t magic;          // 'SMAP'
    uint16_t version;
    uint16_t header_bytes;
    float cell_resolution;
    int32_t block_dim_x;     // 8
    int32_t block_dim_y;     // 8
    int32_t block_dim_z;     // 4
    int32_t tile_key_x;
    int32_t tile_key_y;
    int32_t tile_key_z;
    uint32_t num_blocks;
    uint32_t num_valid_cells;
    uint32_t block_record_bytes;
    uint32_t cell_record_bytes;
    uint32_t flags;
};
```

验收：

```text
surfel_index.yaml 存在
tiles/*.smap 存在
num_valid_cells > 0
CPU 工具可读取并打印统计
```

---

### LOC-P2：实现 Orin active map window

新增：

```text
SurfelMapWindow
```

职责：

```text
- 输入当前定位预测 pose
- 输出 active tile keys
- 加载/卸载 tiles
- 生成 active block table
- 打包 ObsCellFloat64 / ObsCellCompact32
- 维护 map_window_id / map_window_version
```

验收：

```text
同一 pose 下 active window 可重复生成
未超过 reload_margin_m 不重复上传
超过 reload_margin_m 后 version 增加
CPU LookupSurfel 在 active buffer 上可运行
```

---

### LOC-P3：实现 SurfelLocBackend CPU_SIM

CPU_SIM 必须只读 FPGA ABI buffer，不能直接访问高级 C++ map。

接口：

```cpp
bool SurfelLocBackend::ComputeObservation(
    const CloudPtr& scan_body,
    const SE3& pose_guess,
    const ActiveMapBuffer& map,
    LocNormalEquation& out);

bool SurfelLocBackend::Align(
    const CloudPtr& scan_body,
    const SE3& init_pose,
    SE3& pose_out,
    LocQuality& quality_out);
```

验收：

```text
不调用 NDT_OMP 即可输出定位位姿。
SURFEL_CPU_SIM 与 NDT_OMP 轨迹差异可解释。
失败时能 fallback 到 NDT_OMP。
```

---

### LOC-P4：生成定位 golden replay

目录：

```text
fpga/golden/localization/frame_000001/
  loc_scan.bin
  loc_pose_guess.bin
  loc_active_map.bin
  loc_expected_obs.bin
  loc_expected_solve.bin   # 如果启用 FPGA solve6x6
  loc_meta.yaml
```

`loc_meta.yaml`：

```yaml
frame_id: 1
map_window_id: 3
map_window_version: 12
num_scan_points: 18432
num_active_blocks: 4096
hash_table_size: 16384
neighbor_type: 26
mode: LOCALIZATION_OBSERVATION
expected:
  valid_count: 10234
  reject_count: 431
  miss_count: 7767
  mean_residual: 0.012
```

验收：

```text
CPU_SIM 可重放 golden 并得到一致输出。
```

---

### LOC-P5：HLS CSim 复用 `unified_surfel_observation_core`

目录：

```text
fpga/hls/unified_surfel_observation_core/
  unified_surfel_observation_core.cpp
  unified_surfel_observation_core.h
  obs_buffer_layout.h
  obs_tb.cpp
  README.md
```

接口：

```cpp
void unified_surfel_observation_core(
    volatile ap_uint<32>* gmem,
    uint32_t scan_addr,
    uint32_t pose_addr,
    uint32_t map_addr,
    uint32_t output_addr,
    uint32_t num_points,
    uint32_t num_blocks,
    uint32_t hash_table_size,
    uint32_t mode,
    uint32_t flags);
```

模式：

```text
mode = 0 MAPPING_OBSERVATION
mode = 1 LOCALIZATION_OBSERVATION
```

第一版要求：

```text
- 单 lane 或 2-lane，先保证正确性
- float32 实现
- 输出 H_upper[21]、b[6]、statistics
- 不做完整 residual sort
- 不新增独立 AXI-Lite control
```

7Z100 第二版优化：

```text
- 4-lane point pipeline
- active block table cache
- ObsCell burst prefetch
- HTH/HTr 多 lane 局部累加 + final reduce
```

验收：

```text
H_upper/b 误差 abs <= 1e-4 或 rel <= 1e-3
valid_count/reject_count/miss_reason 与 CPU_SIM 对齐
LOCALIZATION_OBSERVATION 和 MAPPING_OBSERVATION 共用同一个 core
```

---

### LOC-P6：可选 `solve6x6_core`

7Z100 可以规划，但不要阻塞 observation core。

目录：

```text
fpga/hls/solve6x6_core/
```

功能：

```text
H_upper[21] + b[6] -> dx[6]
```

算法建议：

```text
第一版：LDLT 或 Cholesky，float32/double mixed
第二版：退化检测、阻尼、condition number 估计
```

验收：

```text
dx 与 Eigen CPU solve 对齐。
如果 H 不可解，必须输出 error_code，不允许输出 NaN。
```

在线定位中：

```text
if fpga_solve_enable:
    FPGA 输出 dx
else:
    FPGA 输出 H/b，Orin solve
```

---

### LOC-P7：接入统一 `slam_accel_ctrl`

保持对 XDMA 只暴露一个 AXI-Lite slave：

```text
xdma_0/M_AXI_LITE -> slam_accel_ctrl_0/S_AXI
```

扩展 `KERNEL_SEL`：

```text
0 normal_eq_legacy
1 lookup_legacy
2 batch_update
3 dirty_refit
4 unified_observation
5 solve6x6
6 map_update_pipeline
```

定位时调用：

```text
KERNEL_SEL = 4
mode = LOCALIZATION_OBSERVATION
```

若启用硬件 solve：

```text
KERNEL_SEL = 5
```

验收：

```text
/dev/xdma* 稳定存在
dmesg 无 CmpltTO/MalfTLP/BAR 错误
host replay localization PASS
```

---

### LOC-P8：在线定位 guarded enable

配置：

```yaml
localization:
  backend: SURFEL_FPGA_WITH_NDT_FALLBACK
  surfel_backend:
    fpga_enable: true
    fpga_solve_enable: false
    fallback_to_ndt: true
    min_valid_count: 500
    max_mean_residual: 0.08
    max_pose_update_norm: 0.5
    max_fpga_timeout_ms: 50
```

fallback 条件：

```text
- FPGA timeout
- error bit
- valid_count 太低
- mean_residual 太大
- pose increment 异常
- 连续 miss_count 过高
- active window 未覆盖当前位姿
```

验收：

```text
在线定位可运行
失败时不发散，自动回退 NDT_OMP
定位精度满足 ±1.5 cm
```

---

## 8. 7Z100 资源规划与定位侧预估

以下为工程量级预估，最终以 Vivado synth/impl 报告为准。

### 8.1

| 模块 | LUT | FF | DSP | BRAM36 |
|---|---:|---:|---:|---:|
| slam_accel_ctrl + register/FSM | 3k–6k | 4k–8k | 0 | 1–2 |
| unified observation 2-lane | 35k–60k | 45k–80k | 80–160 | 30–60 |
| active map hash/cache | 8k–18k | 10k–25k | 0–8 | 20–50 |
| AXI/FIFO/buffer | 8k–15k | 10k–20k | 0 | 20–40 |
| solve6x6 optional | 8k–18k | 10k–25k | 30–80 | 4–10 |
| **定位合计** | **54k–117k** | **69k–158k** | **80–248** | **71–162** |

### 8.2

```text
LUT  < 70%  推荐
DSP  < 60%  推荐
BRAM < 70%  推荐
```

虽然 7Z100 资源较大，但后续还需要 ILA、debug counter、AXI interconnect、PCIe/XDMA、时序余量，不建议追满。

### 8.3

如果建图和定位各做一套 observation core：

```text
mapping_observation_core + loc_observation_core
```

资源会近似翻倍。统一成：

```text
unified_surfel_observation_core(mode)
```

可复用：

```text
- transform datapath
- block/cell encode
- active block table lookup
- candidate selector
- residual/Jacobian
- HTH/HTr reduction
- statistics counters
- AXI reader/writer
```

因此定位文档必须明确禁止重复实现两套 observation core。

---

## 9. 与建图模式的接口统一

定位 active map buffer 和建图 observation map buffer 应使用同一套 ABI：

```text
ObsMapHeader
ActiveBlockEntry
ObsCellFloat64 / ObsCellCompact32
ScanPointXYZI
PosePacket
ObsOutput
```

建图模式中，`BatchUpdate + DirtyRefit` 输出的 surfel 也要同步生成 observation view：

```text
UpdateCell -> DirtyRefit -> ObsCell
```

定位模式中，离线 SurfelTileMap 直接提供 observation view：

```text
.smap -> ObsCell
```

这样建图和定位的匹配内核完全一致。

---

## 10. Codex 执行顺序

请严格按以下顺序执行：

```text
LOC-7Z100-P0  冻结 NDT_OMP baseline 和现有 Surfel CPU baseline
LOC-7Z100-P1  定义统一 ObsMap ABI，不再区分 loc/map observation 格式
LOC-7Z100-P2  新增 SurfelTileMap 离线转换和 active window
LOC-7Z100-P3  实现 SurfelLocBackend CPU_SIM，只读 ABI buffer
LOC-7Z100-P4  生成 localization golden replay
LOC-7Z100-P5  复用 unified_surfel_observation_core HLS CSim
LOC-7Z100-P6  接入 slam_accel_ctrl，KERNEL_SEL=unified_observation
LOC-7Z100-P7  Orin host replay PASS
LOC-7Z100-P8  在线定位 guarded enable
LOC-7Z100-P9  可选 solve6x6_core
```

每个阶段提交：

```text
1. 修改文件列表
2. 是否影响 CPU baseline
3. 是否影响 ABI/golden 格式
4. 是否影响 FPGA register map
5. 是否保留 NDT fallback
6. 编译/运行命令
7. 验收日志
```

---

## 11. 禁止事项

```text
- 不要把 NDT_OMP 原样 HLS 化。
- 不要为定位单独写一套 loc_observation_core。
- 不要让 FPGA 读取 PCD/yaml/index 文件。
- 不要让 FPGA 保存全局地图。
- 不要新增多个 XDMA 可见 HLS AXI-Lite 外设。
- 不要删除 NDT_OMP fallback。
- 不要没有 CPU_SIM/golden 就直接进入在线定位。
- 不要把 PGO 或完整 ESKF 放入第一版 FPGA。
```

---

## 12. 最终交付定义

定位芯片化交付应包含：

```text
软件：
  - SurfelTileMap 离线转换工具
  - Orin active local map window 管理
  - SurfelLocBackend CPU_SIM / FPGA / fallback
  - 定位 golden replay 工具
  - 在线定位 guarded enable

硬件：
  - unified_surfel_observation_core，mode=LOCALIZATION_OBSERVATION
  - 可选 solve6x6_core
  - slam_accel_ctrl KERNEL_SEL 扩展
  - XDMA host replay

验收：
  - CPU_SIM vs FPGA replay 对齐
  - 在线定位运行日志
  - 定位精度 ±1.5 cm 测试报告
  - fallback 有效性测试
```

---

## 13. 一句话总结

在 7Z100 目标下，定位可以更充分地 FPGA 化，但不能变成另一套独立硬件。正确路线是：**Orin 管理全局 SurfelTileMap 和 active local map window，FPGA 复用建图同一个 `unified_surfel_observation_core` 做 scan-to-surfel-map 匹配；可选增加 `solve6x6_core`，但 PGO、fallback、全局地图和迭代策略仍由 Orin 负责。**
