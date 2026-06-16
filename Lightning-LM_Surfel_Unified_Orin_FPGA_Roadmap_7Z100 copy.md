# Lightning-LM Surfel 统一 Orin/FPGA 实施路线（7Z100）

> 本文档合并 `Lightning-LM_Surfel_SLAM_FPGA_Chipization_Roadmap_7Z100_Unified.md` 与 `Lightning-LM_Surfel_Localization_FPGA_Roadmap_7Z100_Unified.md`，作为后续唯一推进入口。  
> 第一批目标：统一 Orin/Windows-HLS 的 ABI、golden replay、CPU_SIM/CSim 对齐。不做 XDMA 上板联调。

---

## 1. 架构边界

Orin 负责：

- 全局地图、SurfelTileMap/active window 管理
- scan 去畸变、pose guess、迭代控制、fallback、PGO
- golden replay 生成与 CPU_SIM 对比
- XDMA host runtime 和在线 guarded enable 的后续接入

FPGA 负责：

- active map buffer 内的规则批处理
- `unified_surfel_observation_core(mode=MAPPING_OBSERVATION|LOCALIZATION_OBSERVATION)`
- 后续可选 `map_update_pipeline` 和 `solve6x6_core`

禁止事项：

- 不把 `NDT_OMP` 原样 HLS 化
- 不让 FPGA 读取 PCD/YAML/index 或管理全局地图
- 不新增两套 mapping/localization observation kernel
- 不绕过 CPU_SIM/golden 直接进入在线 FPGA 模式

---

## 2. 当前实现状态

已完成：

- 定位 CPU_SIM 第一版：`TiledMap active cloud -> ActiveMapBuffer -> SurfelLocBackend`
- `fpga.localization_enable` / `localization_mode` / `localization_fallback` 配置开关
- 默认配置仍走 CPU/NDT，不影响原定位流程
- 新增共享 ABI：`fpga/abi/slam_accel_abi.h`
- Orin golden 生成/回放工具：`build_surfel_loc_golden`、`run_surfel_loc_golden_replay`
- Windows/Vivado-HLS CSim 源码：`fpga/hls/unified_surfel_observation_core/`

未完成：

- SurfelTileMap `.smap` 离线转换工具
- mapping observation golden
- HLS synthesis/implementation 报告
- `slam_accel_ctrl`、XDMA host runtime、在线 guarded enable
- `BatchUpdate`、`DirtyRefit`、`solve6x6_core`

---

## 3. 统一 ABI

唯一跨 Orin/HLS 数据契约：

```text
fpga/abi/slam_accel_abi.h
```

核心类型：

- `SlamAccelMode`
- `SlamAccelScanPoint`
- `SlamAccelPose`
- `ActiveMapHeader`
- `ActiveBlockRecord`
- `ObsCellFloat64`
- `SlamNormalEquation`
- `GoldenFileHeader`

约束：

- ABI 头只使用 C/C++ 基础类型
- 不依赖 Eigen、PCL、ROS
- 结构体固定对齐并使用 `static_assert`
- `H_upper[21]` 按 6x6 上三角 row-major 顺序存储

---

## 4. Orin 侧任务

第一批已落地：

- `surfel_loc` 使用共享 ABI 的 `ObsCellFloat64` 和 `ActiveBlockRecord`
- `SurfelMapWindow` 从 active map cloud 打包只读 observation buffer
- `SurfelLocBackend::ComputeObservation` 只读 ABI buffer 输出 H/b/stats
- `build_surfel_loc_golden` 从 map PCD、scan PCD、pose 生成 localization golden
- `run_surfel_loc_golden_replay` 读回 golden 并用 CPU_SIM 复算

下一批 Orin 任务：

- mapping observation golden dumper
- `.smap` SurfelTileMap 离线转换工具
- Orin host replay 对接 HLS CSim 输出
- 后续 XDMA runtime 与在线 guarded enable

---

## 5. Windows FPGA/HLS 侧任务

第一批已落地：

```text
fpga/hls/unified_surfel_observation_core/
  unified_surfel_observation_core.h
  unified_surfel_observation_core.cpp
  obs_tb.cpp
  README.md
```

HLS V1 做：

- 读 scan、pose、active ObsCell map
- exact/nearby surfel lookup
- residual/Jacobian
- `H_upper[21]`、`b[6]`、valid/reject/miss/residual stats
- CSim 读取 Orin golden 并比较

HLS V1 不做：

- BatchUpdate
- DirtyRefit
- solve6x6
- AXI-Lite controller
- XDMA runtime

---

## 6. Golden Replay

定位 golden 目录：

```text
fpga/golden/localization/frame_xxxxxx/
  loc_scan.bin
  loc_pose.bin
  loc_active_map.bin
  loc_expected_obs.bin
  loc_meta.yaml
```

生成：

```bash
./bin/build_surfel_loc_golden \
  --map_pcd ./data/example_active_map.pcd \
  --scan_pcd ./data/example_scan_body.pcd \
  --output_dir ./fpga/golden/localization/frame_000001 \
  --tx 0 --ty 0 --tz 0 --qx 0 --qy 0 --qz 0 --qw 1
```

Orin 回放：

```bash
./bin/run_surfel_loc_golden_replay \
  --golden_dir ./fpga/golden/localization/frame_000001
```

Windows HLS CSim：

```text
obs_tb.exe <repo>/fpga/golden/localization/frame_000001
```

验收：

- `H/b` 误差：`abs <= 1e-4` 或 `rel <= 1e-3`
- `valid_count/reject_count/miss_count` 精确一致

---

## 7. 分阶段路线

P0 当前基线：

- CPU/NDT 默认路径不变
- 定位 CPU_SIM guarded enable
- 统一文档、ABI、localization golden、HLS CSim 源码

P1 统一 observation：

- mapping observation 改为同一 ABI buffer
- mapping/localization golden 都可生成
- HLS CSim 同时通过 mapping/localization golden

P2 控制与上板准备：

- `slam_accel_ctrl`
- HLS synthesis/implementation
- XDMA host replay
- PCIe Gen2 x8 链路检查

P3 在线接入：

- mapping FPGA observation guarded enable
- localization FPGA observation guarded enable
- CPU/FPGA compare mode
- timeout/error fallback

P4 扩展能力：

- map update pipeline：BatchUpdate + DirtyRefit
- optional solve6x6_core
- 2-lane/4-lane observation 性能优化

---

## 8. 合同指标闭环

目标：

- 定位精度：±1.5 cm
- 建图精度：≤5 cm

验收顺序：

1. CPU/NDT 与 CPU Surfel baseline 可复现
2. CPU_SIM golden 可复算
3. HLS CSim 与 golden 对齐
4. Orin host replay 与 HLS 输出对齐
5. 在线 guarded enable，失败可 fallback
6. 性能、精度、资源报告闭环

一句话总结：

```text
Orin 管全局地图和策略，FPGA 只加速 active map buffer 上的统一 scan-to-surfel observation；
建图和定位共用同一 observation core，所有硬件路径先通过 ABI/golden/CPU_SIM/CSim 对齐。
```
