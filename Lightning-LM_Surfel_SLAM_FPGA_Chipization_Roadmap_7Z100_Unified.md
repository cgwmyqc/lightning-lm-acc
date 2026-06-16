# Lightning-LM Surfel 版本 SLAM 算法芯片化实施路线（7Z100 统一复用架构版）

> 状态：本文档已合并到 `Lightning-LM_Surfel_Unified_Orin_FPGA_Roadmap_7Z100.md`。后续实施以统一文档为准，本文保留为总路线历史参考。

> 目标：形成“机器人三维建模及定位软件硬件协同加速算法 1 套”，满足合同指标：机器人定位精度 ±1.5 cm，建图精度 ≤5 cm。  
> 硬件目标：以实验室 7Z100 开发板作为主实施平台；7Z015 仅作为降级/早期验证平台参考。  
> 架构原则：**资源变多后可以把 BatchUpdate、DirtyRefit、可选 6×6 solve 纳入 FPGA，但不能把建图和定位拆成两套重复硬件。最终应形成一套统一的 `SLAM/Localization Surfel Accelerator`，建图和定位复用同一个 observation pipeline。**  
> 数据通道原则：**PCIe 2.0 ×8 应用于大块连续 H2C/C2H、active map window 上传、dirty block 同步、双缓冲流水线和调试 replay；不用于 FPGA 随机访问 Orin 内存，也不改变 Orin 管全局地图的系统边界。**

---

## 0. 版本更新说明

本版相对于原文档做了以下调整：

```text
1. 硬件目标从 Zynq-7015 保守路线调整为 7Z100 主路线。
2. 将建图和定位统一抽象为 scan-to-surfel-map observation。
3. 不再建议独立实现 map_observation_core 与 loc_observation_core。
4. 新增 unified_surfel_observation_core(mode)。
5. BatchUpdate、DirtyRefit、solve6x6 在 7Z100 上进入正式规划。
6. 地图格式拆分为 UpdateCell 与 ObsCell，减少定位和 observation 带宽。
7. 增加 7Z100 资源预估和 lane 扩展策略。
8. 新增 PCIe 2.0 ×8 数据通道规划，包括链路验证、DDR buffer、双缓冲、建图 dirty block 同步和定位大窗口重试。
```

---

## 1. 核心判断

### 1.1

即使用 7Z100，也不建议把完整 SLAM/Localization 系统搬进 FPGA。正确边界仍然是：

```text
Orin:
  - ROS2 / 数据同步 / rosbag
  - IMU predict / 去畸变调度
  - ESKF/定位迭代主状态
  - 全局地图管理
  - active map window 选择
  - PGO / 回环 / fallback
  - 日志、配置、验收指标统计

FPGA:
  - 局部 active surfel map 上的规则批处理
  - scan-to-surfel observation
  - BatchUpdate
  - DirtyRefit
  - HTH/HTr reduction
  - 可选 solve6x6
```

### 1.2

建图前端和定位后端都可以写成：

```text
scan points + pose guess + active surfel map
  -> transform
  -> surfel lookup
  -> residual / Jacobian
  -> HTH / HTr / score
  -> pose increment / ESKF update
```

两者差异只在：

| 项目 | 建图模式 | 定位模式 |
|---|---|---|
| active map 来源 | 在线维护的 BlockSurfelMap | 全局 SurfelTileMap 的局部窗口 |
| 是否写地图 | 是 | 默认否 |
| 是否 DirtyRefit | 是 | 默认否 |
| 是否保存全局地图 | 是，由 Orin | 否，读取已有地图 |
| fallback | iVox/CPU Surfel | NDT_OMP/CPU Surfel |
| 输出 | 位姿 + 新地图 | 位姿 + 定位质量 |

因此 FPGA 应只做一套：

```text
unified_surfel_observation_core(mode = MAPPING | LOCALIZATION)
```

而不是：

```text
mapping_observation_core + loc_observation_core
```

---

## 2. 7Z100 统一硬件架构

### 2.1

```text
                           ┌────────────────────────────────────┐
                           │              Orin CPU              │
                           │ ROS2 / IMU / ESKF / PGO / fallback │
                           │ 全局地图管理 / active window / XDMA │
                           └─────────────────┬──────────────────┘
                                             │ PCIe / XDMA
┌────────────────────────────────────────────┼────────────────────────────────────────────┐
│                                       7Z100 FPGA PL                                      │
│                                                                                        │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│  │ slam_accel_ctrl                                                                  │  │
│  │  - single AXI-Lite slave exposed to XDMA                                          │  │
│  │  - register bank / command decoder / dispatch FSM                                │  │
│  │  - mode / kernel_sel / status / error / perf counters                            │  │
│  └──────────────┬──────────────────┬──────────────────┬────────────────────────────┘  │
│                 │                  │                  │                               │
│                 ▼                  ▼                  ▼                               │
│  ┌────────────────────────┐ ┌─────────────────┐ ┌──────────────────┐                 │
│  │ unified_surfel_         │ │ map_update_      │ │ solve6x6_core     │                 │
│  │ observation_core        │ │ pipeline         │ │ optional          │                 │
│  │ - transform             │ │ - BatchUpdate    │ │ - LDLT/Cholesky   │                 │
│  │ - lookup                │ │ - DirtyRefit     │ │ - condition check │                 │
│  │ - residual/Jacobian     │ │ - dirty list     │ └──────────────────┘                 │
│  │ - HTH/HTr reduce        │ │ - obs view sync  │                                      │
│  └────────────────────────┘ └─────────────────┘                                      │
│                 │                  │                                                  │
│                 └──────────────┬───┴──────────────────────────────────────────────────┘
│                                ▼
│                       AXI master / DDR buffer
│      scan buffer / active obs map / update map / dirty list / HTH-HTr / dx
└────────────────────────────────────────────────────────────────────────────────────────┘
```

### 2.2

继续坚持：

```text
XDMA M_AXI_LITE -> slam_accel_ctrl_0/S_AXI
```

禁止回到：

```text
XDMA M_AXI_LITE -> axi_smc -> 多个 HLS s_axi_control
```

`KERNEL_SEL` 建议：

```text
0  NORMAL_EQ_LEGACY          # 兼容历史 replay
1  LOOKUP_LEGACY             # 兼容历史 replay
2  BATCH_UPDATE
3  DIRTY_REFIT
4  UNIFIED_OBSERVATION
5  SOLVE6X6
6  MAP_UPDATE_PIPELINE       # BatchUpdate + DirtyRefit + ObsViewSync
7  HEALTH_CHECK
```

`MODE` 建议：

```text
0  MAPPING_OBSERVATION
1  LOCALIZATION_OBSERVATION
2  MAPPING_UPDATE
3  LOCALIZATION_READ_ONLY
```

### 2.3

大数据只走 DDR buffer：

```text
Orin host
  -> XDMA H2C
  -> FPGA DDR input/map/update buffers
  -> FPGA kernel m_axi read/write
  -> FPGA DDR output buffers
  -> XDMA C2H
  -> Orin host
```

AXI-Lite 只用于：

```text
- start/done/busy/error
- kernel_sel / mode
- buffer address
- num_points / num_blocks / num_dirty_cells
- flags
- perf counters
```

---


## 3. PCIe 2.0 ×8 数据通道与系统级利用策略

### 3.1 作用边界

实验室 7Z100 开发板具备 PCIe 2.0 ×8 条件时，系统可以显著提高 Orin 与 FPGA 之间的 H2C/C2H 数据搬运能力。需要明确：PCIe 2.0 ×8 解决的是 **数据通道带宽**，不是直接提高 `unified_surfel_observation_core`、`map_update_pipeline` 或 `solve6x6_core` 的计算吞吐。

理论带宽估算：

```text
PCIe 2.0 单 lane：5 GT/s，8b/10b 后约 500 MB/s
PCIe 2.0 ×8：约 4 GB/s 单向理论峰值
H2C 与 C2H 全双工，可同时传输
```

工程目标建议：

```text
H2C/C2H 大块连续传输有效带宽：1.5 GB/s ~ 3.2 GB/s
低于 1 GB/s 时，需要检查 XDMA、AXI、DDR、host buffer、传输块大小和对齐方式。
```

### 3.2 链路宽度与速度验证

上板 bring-up 阶段必须检查实际链路，而不是只看开发板标称能力：

```bash
sudo lspci -vv -s <Xilinx设备BDF>
```

通过标准：

```text
LnkCap: Speed 5GT/s, Width x8
LnkSta: Speed 5GT/s, Width x8
```

其中 `LnkSta` 是实际协商结果。如果实际为 `Width x1` 或 `Speed 2.5GT/s`，应先排查：

```text
- 是否使用 ×1 转接线/延长线
- 主机/Orin 插槽是否支持 ×8
- Vivado PCIe/XDMA 配置是否为 Gen2 ×8
- PCIe reset/refclk/lane polarity 是否正确
- 供电、时钟、散热是否导致链路降宽/降速
```

### 3.3 对统一架构的直接帮助

PCIe 2.0 ×8 允许系统采用更实用的“FPGA DDR active map 常驻 + 增量同步”模式：

```text
建图模式：
  每帧上传 scan / update tuples
  FPGA DDR 常驻 active map
  FPGA 执行 observation + BatchUpdate + DirtyRefit
  周期性 C2H 回传 dirty blocks 给 Orin mirror/save

定位模式：
  Orin 管全局 SurfelTileMap
  active window 改变时上传 active ObsCell map
  每帧只上传 scan / pose_guess
  FPGA 执行只读 scan-to-surfel-map observation
```

这使系统不必每帧上传完整地图，但在地图窗口切换、定位失败扩大窗口、建图同步 dirty blocks 时，有足够带宽支撑。

### 3.4 仍然不能让 FPGA 管理全局地图

即使是 PCIe 2.0 ×8，也不建议 FPGA 保存或管理全局地图。原因包括：

```text
- 全局地图可能达到 GB 级，超过 FPGA DDR 热路径需求
- FPGA 不适合解析 PCD/YAML/index 或访问文件系统
- 全局重定位、tile 缓存、PGO、fallback 是策略逻辑，应由 Orin 负责
- FPGA 的强项是 active local map 上的固定格式批处理计算
```

正确边界仍然是：

```text
Orin：全局地图、active window、策略、状态、fallback、验收统计
FPGA：active map buffer 内的 lookup、residual/Jacobian、HTH/HTr、BatchUpdate、DirtyRefit、可选 solve6x6
```

### 3.5 DDR buffer 与双缓冲规划

7Z100 方案建议显式规划 FPGA DDR：

```text
FPGA DDR Layout:

0x0000_0000 - 0x00FF_FFFF  control / small buffers / descriptors
0x0100_0000 - 0x03FF_FFFF  scan input ring buffer A/B
0x0400_0000 - 0x07FF_FFFF  observation output / residual debug buffer A/B
0x0800_0000 - 0x1FFF_FFFF  active ObsCell map buffer A/B
0x2000_0000 - 0x2FFF_FFFF  UpdateCell map buffer / mapping active map
0x3000_0000 - 0x37FF_FFFF  dirty block/cell lists / map sync buffers
0x3800_0000 - 0x3FFF_FFFF  golden replay / debug / correspondence buffer
```

双缓冲目标：

```text
FPGA 计算 frame N
Orin 上传 frame N+1 scan / update tuples
Orin 下载 frame N-1 output / dirty list
active map window 切换时使用备用 map buffer
```

### 3.6 HLS/AXI 侧带宽利用约束

要真正利用 ×8，FPGA 内部数据面也必须配合：

```text
- 所有大 buffer 64B 对齐
- H2C/C2H 使用大块连续传输，不做小包频繁读写
- HLS m_axi 使用 burst 访问
- active map 采用连续 block pool
- block table / cell records 尽量顺序或局部访问
- 避免 FPGA 计算时通过 PCIe 随机访问 Orin 内存
- PCIe 只负责批量搬运，kernel 只访问 FPGA 本地 DDR
```

推荐 host 工具增加带宽基准测试：

```bash
sudo ./fpga/host_tools/xdma_bandwidth_test \
  --h2c /dev/xdma0_h2c_0 \
  --c2h /dev/xdma0_c2h_0 \
  --size-mb 16,32,64,128,256 \
  --repeat 20 \
  --align 4096
```

验收记录：

```text
- H2C mean/min/max MB/s
- C2H mean/min/max MB/s
- full-duplex H2C+C2H MB/s
- 对不同 size 的带宽曲线
```

### 3.7 对建图模式的利用

建图模式建议利用 PCIe 2.0 ×8 做三件事：

```text
1. scan/update tuples 每帧 H2C 上传。
2. active map 常驻 FPGA DDR，避免每帧全量上传地图。
3. dirty blocks / dirty cells 周期性 C2H 回传 Orin，用于 CPU mirror、地图保存和异常恢复。
```

推荐策略：

```text
FPGA active map 是热路径副本或主副本
Orin 保留 authoritative/global mirror
每 N 帧或 dirty block 数量超过阈值时同步
FPGA error/reset 后，Orin 可重新下发 active map snapshot
```

### 3.8 对定位模式的利用

定位模式建议利用 PCIe 2.0 ×8 做四件事：

```text
1. 支持更大的 active local map window。
2. active window 改变时快速上传 compact ObsCell map。
3. 低置信度时扩大窗口重试。
4. 多 pose_guess / 多假设定位时复用同一 active_map_buffer，只上传不同 pose buffer。
```

正式在线模式不应每帧回传大 correspondence buffer；只在 debug 模式启用：

```text
正式模式 C2H：H_upper[21] + b[6] + stats
调试模式 C2H：per-point residual / hit cell / miss reason / correspondence list
```

### 3.9 对资源路线的影响

由于 PCIe 2.0 ×8 降低了地图窗口上传和 dirty block 同步压力，7Z100 方案可以更积极地规划：

```text
第一阶段：unified_surfel_observation_core + active ObsCell map buffer
第二阶段：定位大窗口与多假设重试
第三阶段：建图 active map 常驻 FPGA DDR
第四阶段：BatchUpdate + DirtyRefit + dirty block sync
第五阶段：可选 solve6x6_core 与 2/4-lane observation
```

但它不改变最重要的架构原则：

```text
统一 observation core
单 AXI-Lite 控制面
Orin 管全局地图和策略
FPGA 管局部 active map 的批处理计算
```


## 4. 统一数据格式：UpdateCell 与 ObsCell 分离

### 4.1

当前完整 `VoxelCell` 包含：

```text
count
flags
sum[3]
scatter[6]
normal[3]
d
quality
last_update_frame
padding
```

这对建图更新有用，但定位/observation 查找时只需要：

```text
normal
d
centroid
quality
count
flags
```

因此文档必须明确：

```text
UpdateCell: 面向 BatchUpdate / DirtyRefit
ObsCell:    面向建图和定位共用的 observation lookup
```

### 4.2

```cpp
struct alignas(64) UpdateCell128 {
    uint32_t count;
    uint32_t flags;
    float sum_x, sum_y, sum_z;
    float scatter_xx, scatter_xy, scatter_xz;
    float scatter_yy, scatter_yz, scatter_zz;
    float nx, ny, nz, d;
    float quality;
    uint32_t last_update_frame;
    float pad[15];
};

struct alignas(64) ObsCellFloat64 {
    float centroid_x, centroid_y, centroid_z;
    float normal_x, normal_y, normal_z;
    float plane_d;
    float quality;
    uint32_t count;
    uint32_t flags;
    uint32_t reserved[6];
};

struct ActiveBlockEntry {
    int32_t bx, by, bz;
    uint32_t block_id;
    uint32_t valid;
};
```

后续优化可把 `ObsCellFloat64` 量化为 `ObsCellCompact32`。

### 4.3

```text
UpdateCell128:
  1 block = 256 × 128B = 32KB

ObsCellFloat64:
  1 block = 256 × 64B = 16KB

ObsCellCompact32:
  1 block = 256 × 32B = 8KB
```

建图更新使用 `UpdateCell`，observation 和定位使用 `ObsCell`。DirtyRefit 负责从 `UpdateCell` 生成/刷新 `ObsCell`。

---

## 5. 统一 observation pipeline

### 5.1

`unified_surfel_observation_core` 完成：

```text
scan point
  -> body/lidar to world transform
  -> grid/block/cell encode
  -> active block table lookup
  -> exact / 6 / 18 / 26 neighbor lookup
  -> candidate select
  -> residual
  -> valid check
  -> Jacobian
  -> HTH/HTr accumulation
  -> score/statistics/miss histogram
```

### 5.2

```text
scan_points_addr
pose_packet_addr
active_obs_map_addr
active_block_table_addr
output_addr
num_points
num_blocks
hash_table_size
mode
flags
```

### 5.3

```text
H_upper[21]
b[6]
valid_count
reject_count
miss_count
hit_exact
hit_neighbor
mean_residual
max_residual
residual_sum
miss_reason_histogram
perf_cycle_count
error_code
```

### 5.4

建图：

```text
KERNEL_SEL = UNIFIED_OBSERVATION
MODE       = MAPPING_OBSERVATION
map_addr   = current active obs map
scan_addr  = current frame points
```

定位：

```text
KERNEL_SEL = UNIFIED_OBSERVATION
MODE       = LOCALIZATION_OBSERVATION
map_addr   = active global/localization obs map window
scan_addr  = current frame points
```

### 5.5

建议分三版：

```text
V1: 1-lane，保证 ABI/golden 正确
V2: 2-lane，开始上板在线验证
V3: 4-lane，作为 7Z100 性能优化目标
```

不要第一版直接 8-lane，因为 lookup 包含 DDR 随机访问、candidate select 和 reduction，调试复杂度会大幅增加。

---

## 6. 地图更新 pipeline

### 6.1

BatchUpdate 用于建图模式，把当前帧新点写入 surfel 地图统计量：

```text
world point
  -> block key
  -> cell index
  -> update count/sum/scatter
  -> mark dirty
  -> update block version
```

通俗理解：

```text
BatchUpdate = 把新点云倒入地图格子，并更新每个格子的统计数据。
```

### 6.2

DirtyRefit 用于把被更新过的 cell 重新拟合成 surfel 平面：

```text
dirty cell
  -> centroid = sum / count
  -> covariance = scatter / count - centroid * centroidᵀ
  -> eigen smallest -> normal
  -> d = -normal dot centroid
  -> quality = lambda_min / trace
  -> update valid flag
  -> generate ObsCell
```

通俗理解：

```text
DirtyRefit = 把更新过的格子重新整理成可匹配的小平面。
```

### 6.3

7Z015 上建议 BatchUpdate 和 DirtyRefit 分开做；7Z100 上可以规划成一个 pipeline：

```text
map_update_pipeline:
  BatchUpdate
    -> dirty_cell_list
    -> DirtyRefit
    -> ObsViewSync
```

但为了调试仍保留独立 kernel：

```text
KERNEL_SEL = BATCH_UPDATE
KERNEL_SEL = DIRTY_REFIT
KERNEL_SEL = MAP_UPDATE_PIPELINE
```

### 6.4

即使有 7Z100，也不要第一版做复杂多写口冲突仲裁。推荐：

```text
Orin 预处理：
  world point -> block_id/cell_id
  sort/group by block_id/cell_id
  形成 BatchUpdateTuple

FPGA：
  对同一 cell 的 tuple 顺序累加
  一次读 cell，一次写回 cell
```

后续优化：

```text
- 多 lane 按 block bank 分发
- 同 cell merge buffer
- dirty bitmap bank 化
```

---

## 7. solve6x6_core

### 7.1

Observation core 输出：

```text
H δx = -b
```

其中：

```text
H = JᵀJ, 6×6
b = Jᵀr, 6×1
δx = [δroll, δpitch, δyaw, δx, δy, δz]
```

`solve6x6_core` 求解：

```text
δx = -H⁻¹b
```

通俗理解：

```text
6×6 solve = 根据所有点的残差证据，算出机器人位姿这一次该修正多少。
```

### 7.2

可以规划 FPGA solve，但不要让它阻塞主线：

```text
第一阶段：FPGA 输出 H/b，Orin solve
第二阶段：FPGA 同时输出 H/b 和 dx，用于 compare
第三阶段：dx 稳定后允许在线启用 fpga_solve_enable
```

算法建议：

```text
- LDLT 或 Cholesky
- 支持 damping
- 支持 singular/ill-conditioned error_code
- 禁止输出 NaN/Inf
```

---

## 8. 定位模式补充

### 8.1

定位模式使用已有全局地图：

```text
SurfelTileMap
  -> active local map window
  -> ObsCell map buffer
  -> unified observation
```

默认不执行：

```text
BatchUpdate
DirtyRefit
```

除非明确启用临时 local dynamic cache。

### 8.2

定位侧新增：

```text
src/core/localization/surfel_loc/
  surfel_tile_map.*
  surfel_map_window.*
  surfel_loc_backend.*
```

Orin 根据当前位姿管理窗口：

```text
if distance(current_pose, active_window_center) > reload_margin:
    load/unload tiles
    pack active obs map
    upload FPGA DDR
    map_window_version++
else:
    reuse current active map in FPGA DDR
```

### 8.3

定位必须保留：

```text
NDT_OMP fallback
SURFEL_CPU_SIM fallback
```

fallback 触发：

```text
- FPGA timeout
- valid_count 太低
- residual 太大
- pose increment 异常
- active window miss ratio 太高
- solve6x6 error
```

---

## 9. 总体分阶段路线

### P0：统一基线冻结

```text
- CPU Surfel Mapping baseline
- NDT_OMP Localization baseline
- SurfelLoc CPU_SIM baseline
- profile 和验收指标脚本
```

验收：

```text
建图和定位 CPU baseline 可复现。
```

---

### P1：统一 ABI 与地图格式

任务：

```text
- 新建 fpga/abi/slam_accel_abi.h
- 定义 UpdateCell128
- 定义 ObsCellFloat64 / ObsCellCompact32
- 定义 ActiveBlockEntry
- 定义 ScanPoint/PosePacket/ObsOutput
- 建图和定位共用 ABI
```

验收：

```text
CPU_SIM 只读 ABI buffer 可完成 observation。
```

---

### P2：Golden Replay 框架

golden 类型：

```text
mapping_observation
localization_observation
batch_update
dirty_refit
map_update_pipeline
solve6x6
```

要求：

```text
所有 FPGA kernel 必须先 CSim replay PASS，再上板。
```

---

### P3：slam_accel_ctrl 统一控制器

任务：

```text
- single AXI-Lite slave
- register bank
- dispatch FSM
- kernel_sel/mode
- perf/error counters
```

验收：

```text
/dev/xdma* 稳定
dmesg 无 BAR/CmpltTO/MalfTLP
VERSION 可读
```

---

### P4：unified_surfel_observation_core V1

任务：

```text
- 1-lane
- float32
- mapping/localization 共用
- 输出 H/b/statistics
```

验收：

```text
mapping_observation golden PASS
localization_observation golden PASS
```

---

### P5：在线接入 Observation

建图：

```text
LaserMapping::ObsModel -> unified observation
Orin ESKF update
```

定位：

```text
SurfelLocBackend -> unified observation
Orin solve / iteration
```

验收：

```text
可在线 guarded enable
可自动 fallback
轨迹不发散
```

---

### P6：map_update_pipeline

任务：

```text
- BatchUpdate
- DirtyRefit
- ObsViewSync
```

验收：

```text
count/flags bit exact
sum/scatter/normal/d/quality 误差达标
CPU mirror 与 FPGA active map 周期性一致
```

---

### P7：solve6x6_core

任务：

```text
- H/b -> dx
- error_code
- Orin compare mode
```

验收：

```text
dx 与 CPU Eigen/LDLT 对齐
在线启用后定位/建图结果不退化
```

---

### P8：2-lane / 4-lane 性能优化

任务：

```text
- observation 2-lane -> 4-lane
- local H/b partial reduce
- active map cache
- burst read optimization
- perf counter
```

验收：

```text
端到端耗时有明显下降
资源使用率和时序可接受
```

---

### P9：合同验收

交付：

```text
- 三维建模及定位软硬件协同加速算法 1 套
- 定位精度 ±1.5 cm 报告
- 建图精度 ≤5 cm 报告
- FPGA 加速性能报告
- 稳定性报告
```

---

## 10. 7Z100 资源预估

以下为工程估算，最终以 Vivado HLS/Vivado Implementation 报告为准。

### 10.1

| 模块 | LUT | FF | DSP | BRAM36 |
|---|---:|---:|---:|---:|
| XDMA/PCIe/AXI 基础系统 | 20k–45k | 25k–60k | 0–10 | 20–60 |
| slam_accel_ctrl + debug/perf | 3k–8k | 5k–12k | 0 | 2–4 |
| unified observation 1-lane | 25k–45k | 35k–65k | 50–100 | 25–50 |
| unified observation 2-lane | 45k–75k | 60k–110k | 100–200 | 40–80 |
| unified observation 4-lane | 80k–130k | 110k–190k | 200–400 | 70–130 |
| active map hash/cache | 10k–25k | 15k–35k | 0–8 | 20–60 |
| BatchUpdate 1-lane | 10k–22k | 15k–35k | 20–60 | 10–30 |
| DirtyRefit 1-lane float32 | 25k–50k | 35k–75k | 80–180 | 10–30 |
| ObsViewSync | 5k–12k | 8k–18k | 0–10 | 5–15 |
| solve6x6_core | 8k–20k | 12k–30k | 30–90 | 4–12 |
| ILA/debug 预留 | 10k–30k | 10k–30k | 0 | 10–40 |

### 10.2

第一版可落地组合：

```text
XDMA/PCIe
slam_accel_ctrl
unified observation 1-lane or 2-lane
active map hash/cache
Orin solve
Orin DirtyRefit/BatchUpdate fallback
```

第二版目标组合：

```text
XDMA/PCIe
slam_accel_ctrl
unified observation 2-lane
BatchUpdate 1-lane
DirtyRefit 1-lane
ObsViewSync
Orin solve
```

第三版性能组合：

```text
XDMA/PCIe
slam_accel_ctrl
unified observation 4-lane
map_update_pipeline
solve6x6_core
active map cache
debug counters
```

### 10.3

```text
LUT  < 70%：推荐
DSP  < 60%：推荐
BRAM < 70%：推荐
```

原因：

```text
- 需要保留 ILA/debug 空间
- 需要保留时序收敛余量
- HLS 后期优化会引入额外 FIFO/寄存器
- AXI interconnect/DDR/PCIe 会消耗额外资源
```

---

## 11. Codex 执行清单

### 第一批：统一软件与 ABI

```text
[ ] 新建 fpga/abi/slam_accel_abi.h
[ ] 定义 UpdateCell / ObsCell / ActiveBlockEntry / PosePacket / ObsOutput
[ ] 修改建图 CPU_SIM，使 observation 只读 ObsCell buffer
[ ] 修改定位 CPU_SIM，使其复用同一 observation 函数
[ ] 新增 SurfelTileMap 和 active window
[ ] 生成 mapping/localization observation golden
```

### 第二批：统一 observation core

```text
[ ] 新建 fpga/hls/unified_surfel_observation_core/
[ ] 支持 mode=MAPPING_OBSERVATION
[ ] 支持 mode=LOCALIZATION_OBSERVATION
[ ] CSim 对齐 mapping golden
[ ] CSim 对齐 localization golden
[ ] 接入 slam_accel_ctrl
[ ] Orin host replay PASS
```

### 第三批：建图 map update

```text
[ ] BatchUpdateTuple 格式
[ ] Orin 预排序/分组
[ ] batch_update_core CSim
[ ] dirty_refit_core CSim
[ ] map_update_pipeline CSim
[ ] ObsViewSync
[ ] 上板 replay PASS
```

### 第四批：在线接入

```text
[ ] Mapping FPGA observation guarded enable
[ ] Localization FPGA observation guarded enable
[ ] fallback_on_error
[ ] compare_cpu_fpga
[ ] 轨迹和地图精度对比
```

### 第五批：solve 与性能优化

```text
[ ] solve6x6_core
[ ] observation 2-lane
[ ] observation 4-lane
[ ] active map cache
[ ] perf counter
[ ] 资源/时序报告
```

---

## 12. 禁止事项

```text
- 不要为建图和定位分别写两套 observation core。
- 不要把 NDT_OMP 原样 HLS 化。
- 不要让 FPGA 读取 PCD/yaml/index 文件。
- 不要让 FPGA 管理全局地图。
- 不要新增多个 XDMA 可见 HLS AXI-Lite 外设。
- 不要没有 CPU_SIM/golden 就进入在线模式。
- 不要第一版直接 8-lane。
- 不要第一版迁移完整 ESKF/PGO。
```

---

## 13. 合同指标闭环

建图模式：

```text
Orin:
  sensor/IMU/ESKF/保存地图/fallback

FPGA:
  unified observation
  BatchUpdate
  DirtyRefit
  optional solve6x6

输出：
  三维 surfel/点云地图
  建图精度 ≤5 cm
```

定位模式：

```text
Orin:
  全局 SurfelTileMap
  active local map window
  PGO/fallback/质量判断

FPGA:
  unified observation
  optional solve6x6

输出：
  机器人位姿
  定位精度 ±1.5 cm
```

最终交付定义：

```text
机器人三维建模及定位软件硬件协同加速算法 1 套
  = 统一 Surfel Map 表达
  + 统一 observation FPGA core
  + 建图 map_update_pipeline
  + 定位 active window 管理
  + Orin/FPGA XDMA 协同
  + CPU fallback/golden/replay/验收报告
```

---

## 14. 一句话总结

7Z100 让项目可以从“单个 normal_eq 加速器”升级为更完整的 SLAM/Localization Surfel Accelerator，但架构上仍要克制：**建图和定位共用一个 `unified_surfel_observation_core`，建图额外启用 `map_update_pipeline = BatchUpdate + DirtyRefit + ObsViewSync`，定位只读 active SurfelTileMap，`solve6x6_core` 作为可选模块。Orin 始终负责全局地图、状态机、fallback 和验收指标。**
