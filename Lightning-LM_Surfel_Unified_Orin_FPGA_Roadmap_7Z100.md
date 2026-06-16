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
- FPGA 配置命名已统一为嵌套结构：global `fpga.enable/mode` + `fpga.mapping.*` + `fpga.localization.*`
- 建图侧已有 backend 管理：`CPU`、`CPU_SIM`、`FPGA_OBS`、`FPGA_OBS_UPDATE`、`FPGA_FULL`
- 定位侧已有 backend 管理：`NDT_OMP`、`SURFEL_CPU_SIM`、`SURFEL_FPGA_OBS`、`SURFEL_FPGA_OBS_SOLVE`、`SURFEL_FPGA_WITH_NDT_FALLBACK`
- 旧版 `fpga.localization_enable/localization_mode/localization_fallback` 兼容读取，推荐配置已迁移到嵌套字段
- 默认配置仍走 CPU/NDT，不影响原定位流程
- 硬件 mode 当前为 guarded fallback：建图 FPGA mode warning 后 fallback CPU；定位 FPGA mode warning 后 fallback `SURFEL_CPU_SIM` 或 NDT
- 新增共享 ABI：`fpga/abi/slam_accel_abi.h`
- Orin golden 生成/回放工具：`build_surfel_loc_golden`、`run_surfel_loc_golden_replay`
- Orin 定位 golden source 导出工具：`export_loc_golden_frame`
- Windows/Vivado-HLS CSim 源码：`fpga/hls/unified_surfel_observation_core/`
- 已从真实定位流程导出 `fpga/golden_src/localization/frame_000001`
- 已生成 `fpga/golden/localization/frame_000001` localization ABI golden
- 已完成 Orin 侧 `run_surfel_loc_golden_replay` 验证并 PASS
- 已完成 Windows 侧 `frame_000001` g++ CSim 与 Vivado HLS 2018.3 CSim 验证并 PASS
- 已新增 Windows 侧 CSim/C Synthesis 脚本：`run_gpp_csim.ps1`、`run_vivado_hls_csim.ps1`、`run_vivado_hls_csynth.ps1`、`create_vivado_hls_project.tcl`
- 已完成 `unified_surfel_observation_core` Vivado HLS 2018.3 C Synthesis：`xc7z100ffg900-2`，10.00 ns target，9.307 ns estimated，BRAM_18K 36，DSP48E 256，FF 32045，LUT 45244
- 已完成 HLS 单控制口接口收敛：`unified_surfel_observation_core` 不再生成 `s_axi_control`，只保留 `ap_ctrl_hs`、`m_axi` 和 direct scalar offset ports
- 已更新 P2 `slam_accel_ctrl`：single AXI-Lite register bank + dispatch FSM + HLS `ap_ctrl_hs` 直连契约 + 32-bit buffer address registers
- 已完成 `slam_accel_ctrl` interface convergence OOC synthesis check：0 errors，0 critical warnings，LUT 542，FF 619
- 已完成短 bag NDT vs CPU_SIM baseline：
  - bag：`mid360_20260313_outdoor_30deg_up_quan_03_0.db3`
  - map：`data/new_map/`
  - NDT PGO frames：168，failures：0
  - CPU_SIM PGO frames：168，failures：0，fallback：0
  - matched frames：168
  - CPU_SIM mean_abs_residual mean：`0.052104`
  - CPU_SIM vs NDT translation error mean：`0.078699 m`
  - CPU_SIM vs NDT translation error max：`0.184180 m`

未完成：

- SurfelTileMap `.smap` 离线转换工具
- mapping observation golden
- HLS Cosim、IP export、implementation 报告
- `slam_accel_ctrl` 与 HLS IP/BD/XDMA 集成、XDMA host runtime、在线 guarded enable
- `BatchUpdate`、`DirtyRefit`、`solve6x6_core`

---

## 3. Baseline Reports

`reports/` 用于保存算法轨迹 baseline，和 `fpga/golden/` 分开管理。

当前已归档：

```text
reports/localization/ndt_vs_cpu_sim/mid360_20260313_outdoor_30deg_up_quan_03_short/
  report.md
  summary.json
  commands.md
reports/fpga/hls/unified_surfel_observation_core/localization/frame_000001/
  commands.md
  gpp_csim_stdout.txt
  vivado_hls_csim_stdout.txt
  compare_summary.json
reports/fpga/hls/unified_surfel_observation_core/csynth/
  commands.md
  summary.json
  vivado_hls_csynth_summary.txt
reports/fpga/hls/unified_surfel_observation_core/interface_convergence/
  commands.md
  summary.json
  vivado_hls_interface_summary.txt
reports/fpga/rtl/slam_accel_ctrl/ooc_synth/
  commands.md
  summary.json
  vivado_synth_summary.txt
reports/fpga/rtl/slam_accel_ctrl/interface_convergence/
  commands.md
  summary.json
  vivado_ooc_synth_summary.txt
```

建议纳入 git：

- `report.md`
- `summary.json`
- `commands.md`

不建议纳入 git：

- `ndt.log`
- `cpu_sim.log`

如果需要保留原始日志，放在本地：

```text
reports/localization/ndt_vs_cpu_sim/mid360_20260313_outdoor_30deg_up_quan_03_short/logs/
```

`logs/` 只作为本机排查材料，不作为必需提交内容。

### 3.1 进度更新规则

从 2026-06-16 起，本路线文档作为唯一进度入口；不要更新 `Lightning-LM_Surfel_Unified_Orin_FPGA_Roadmap_7Z100 copy.md`，后续只认 `Lightning-LM_Surfel_Unified_Orin_FPGA_Roadmap_7Z100.md`。

本规则覆盖 Orin 侧和 Windows FPGA 侧全链路。每次完成 Orin 侧代码、ROS app、golden 工具、CPU_SIM、配置、ABI、Windows HLS、RTL、Vivado/Vitis 工程 TCL、host runtime、XDMA 工具或接口定义变更后，必须同步更新本文档。

每次更新至少记录：

- 当前阶段状态
- 变更摘要
- 验证命令
- 验证结果
- 误差、资源或时序摘要
- 下一步或阻塞项

如果验证失败，也必须记录失败现象和下一步定位方向。`fpga/golden/`、HLS/Vivado 生成目录等不纳入 git 的内容，只在本文档或 `reports/` 中记录路径和用途。

---

## 4. 统一 ABI

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

## 5. Orin 侧任务

第一批已落地：

- `surfel_loc` 使用共享 ABI 的 `ObsCellFloat64` 和 `ActiveBlockRecord`
- `SurfelMapWindow` 从 active map cloud 打包只读 observation buffer
- `SurfelLocBackend::ComputeObservation` 只读 ABI buffer 输出 H/b/stats
- `build_surfel_loc_golden` 从 map PCD、scan PCD、pose 生成 localization golden
- `run_surfel_loc_golden_replay` 读回 golden 并用 CPU_SIM 复算
- `export_loc_golden_frame` 从真实定位流程截取 body-frame undistorted scan、active map、pose guess
- `frame_000001` localization golden 已生成并通过 Orin replay
- `run_loc_offline` 已验证默认 NDT 和 `SURFEL_CPU_SIM` 两条定位路径可通过同一段短 bag

下一批 Orin 任务：

- mapping observation golden dumper
- `.smap` SurfelTileMap 离线转换工具
- Orin host replay 对接 Windows HLS CSim 输出
- 后续 XDMA runtime 与在线 guarded enable

---

## 6. Windows FPGA/HLS 侧任务

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

当前 Windows 侧以 Vivado HLS 2018.3 为第一目标，后续兼容 Vitis HLS。已新增脚本化 CSim 入口：

```text
fpga/hls/unified_surfel_observation_core/run_gpp_csim.ps1
fpga/hls/unified_surfel_observation_core/run_vivado_hls_csim.ps1
fpga/hls/unified_surfel_observation_core/run_vivado_hls_csynth.ps1
fpga/hls/unified_surfel_observation_core/create_vivado_hls_project.tcl
```

已完成定位 `frame_000001` 验证：

```text
g++ CSim: PASS
Vivado HLS 2018.3 CSim: PASS
counts_ok=1
values_ok=1
max_abs=0.0078906
max_rel=4.41926e-05
worst_idx=104
actual_counts=6050/911/2
expected_counts=6050/911/2
```

当前 HLS 修正点：

- Windows g++ 初测曾发现 counts 一致但 H/b 不一致
- 根因定位为 HLS Jacobian 旋转项符号与 Orin CPU_SIM 不一致
- 已改为与 Orin 一致的 `-normal^T * Skew(point_world)`，修正后 CSim PASS

已完成 Vivado HLS 2018.3 C Synthesis：

```text
command: powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
project: %TEMP%\lightning_hls_unified_obs
part: xc7z100ffg900-2
status: PASS
target_clock: 10.00 ns
estimated_clock: 9.307 ns
BRAM_18K: 36 / 1510 (2%)
DSP48E: 256 / 2020 (12%)
FF: 27475 / 554800 (4%)
LUT: 41633 / 277400 (15%)
```

说明：

- C Synthesis 工程默认放在 `%TEMP%\lightning_hls_unified_obs`，用于规避 Vivado HLS 2018.3 在 Windows 深路径下生成 RTL 文件名过长的问题。
- 当前 C Synthesis 证明 observation compute core 可综合，并已完成单控制口接口收敛。
- HLS IP 不再生成 `s_axi_control` 或其他 AXI-Lite slave；控制只使用 `ap_ctrl_hs`。
- input structs 已通过 `DATA_PACK` 收敛为 direct scalar base-address ports：`scan_points`、`pose`、`map_header`、`active_blocks`、`obs_cells`。
- `SlamNormalEquation` output 因 Vivado HLS 2018.3 不接受 2176-bit 非 2 次幂 packed AXI master，仍保留 output field direct offset ports；`slam_accel_ctrl` 从单一 `OUT_ADDR` 派生这些 field address。
- 暂不做 XDMA、block design、在线上板。

CSim 对齐记录已归档：

```text
reports/fpga/hls/unified_surfel_observation_core/localization/frame_000001/
  commands.md
  gpp_csim_stdout.txt
  vivado_hls_csim_stdout.txt
  compare_summary.json
```

C Synthesis 资源/时序记录已归档：

```text
reports/fpga/hls/unified_surfel_observation_core/csynth/
  commands.md
  summary.json
  vivado_hls_csynth_summary.txt
```

接口收敛记录已归档：

```text
reports/fpga/hls/unified_surfel_observation_core/interface_convergence/
  commands.md
  summary.json
  vivado_hls_interface_summary.txt
reports/fpga/rtl/slam_accel_ctrl/interface_convergence/
  commands.md
  summary.json
  vivado_ooc_synth_summary.txt
```

下一步 Windows 侧建议：

- 先做 HLS Cosim / IP export 前的 generated RTL port mapping 复核
- 再做 HLS IP export
- 之后进入 fresh Vivado 7Z100 block design 计划
- 暂不做 XDMA、block design、在线上板

P2 `slam_accel_ctrl` RTL 已完成接口收敛：

```text
fpga/rtl/slam_accel_ctrl/
  slam_accel_ctrl.v
  README.md
```

RTL OOC synthesis check 已归档：

```text
reports/fpga/rtl/slam_accel_ctrl/ooc_synth/
  commands.md
  summary.json
  vivado_synth_summary.txt
```

当前 `slam_accel_ctrl` 做 single AXI-Lite register bank、command decoder、dispatch FSM、status/error/perf counters，并提供 `KERNEL_SEL=4` unified observation 的 `ap_start/ap_done/ap_idle/ap_ready` 直连契约、32-bit buffer base address 输出和 output field address 派生；尚未实例化 HLS IP、XDMA、block design 或 DDR interconnect。

---

## 7. Golden Replay

注意区分两类数据：

- `reports/`：算法轨迹 baseline，用于比较 NDT、CPU_SIM、未来 FPGA 输出
- `fpga/golden/`：固定 ABI 输入输出样本，用于 HLS CSim / Cosim / Windows 侧验证

定位 golden 目录：

```text
fpga/golden/localization/frame_xxxxxx/
  loc_scan.bin
  loc_pose.bin
  loc_active_map.bin
  loc_expected_obs.bin
  loc_meta.yaml
```

第一版 localization golden 来源：

```text
bag -> Orin 定位前端 -> body-frame undistorted scan PCD
map active cloud -> ActiveMapBuffer
pose guess -> loc_pose.bin
CPU_SIM ComputeObservation -> loc_expected_obs.bin
```

### Scan PCD 生成方式

`build_surfel_loc_golden` 需要：

```text
map_pcd + scan_pcd + pose_guess
```

其中 `scan_pcd` 不能使用 `/livox/lidar` 原始消息直接转出来的裸点云，而应使用定位后端实际消费的 body-frame scan。

当前定位主流程：

```text
bag /livox/lidar + /livox/imu
-> Localization::ProcessLivoxLidarMsg
-> LaserMapping 前端同步 IMU / 去畸变 / 输出 scan
-> LidarLoc::Run / Localize
-> NDT_OMP 或 SURFEL_CPU_SIM
```

推荐新增导出工具：

```text
src/app/export_loc_golden_frame.cc
```

命令接口：

```bash
ros2 run lightning export_loc_golden_frame \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config ./config/default_livox.yaml \
  --map_path ./data/new_map/ \
  --frame_index 20 \
  --output_dir ./fpga/golden_src/localization/frame_000001
```

输出：

```text
fpga/golden_src/localization/frame_000001/
  scan_body_undistorted.pcd
  active_map.pcd
  pose_guess.txt
  frame_meta.yaml
```

`pose_guess.txt` 内容：

```text
tx ty tz qx qy qz qw
```

`frame_meta.yaml` 内容：

```yaml
bag: /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3
config: ./config/default_livox.yaml
map_path: ./data/new_map/
frame_index: 20
timestamp: 177338xxxx.xxxxxx
scan_points: N
pose_guess:
  tx: ...
  ty: ...
  tz: ...
  qx: ...
  qy: ...
  qz: ...
  qw: ...
```

导出逻辑：

1. 读 bag。
2. 正常喂 `/livox/imu` 和 `/livox/lidar`。
3. 等定位前端完成 IMU 初始化。
4. 在第 `frame_index` 个有效定位 scan 到达时：
   - 保存 body-frame undistorted scan 为 `scan_body_undistorted.pcd`
   - 调用 `map_->LoadOnPose(pose_guess)`
   - 从 active map 导出 `active_map.pcd`
   - 保存 `pose_guess.txt`
   - 保存 `frame_meta.yaml`
   - 退出，不继续跑完整 bag

生成：

```bash
ros2 run lightning build_surfel_loc_golden \
  --map_pcd ./fpga/golden_src/localization/frame_000001/active_map.pcd \
  --scan_pcd ./fpga/golden_src/localization/frame_000001/scan_body_undistorted.pcd \
  --output_dir ./fpga/golden/localization/frame_000001 \
  --tx <tx> --ty <ty> --tz <tz> \
  --qx <qx> --qy <qy> --qz <qz> --qw <qw>
```

Orin 回放：

```bash
ros2 run lightning run_surfel_loc_golden_replay \
  --golden_dir ./fpga/golden/localization/frame_000001
```

当前 `frame_000001` 实测结果：

```text
source:
  frame_index: 20
  timestamp: 1773380993.78701472
  scan_points: 6963
  active_map_points: 1427508

golden:
  num_scan_points: 6963
  num_active_blocks: 3719
  num_active_cells: 952064
  valid_count: 6050
  reject_count: 911
  miss_count: 2
  residual_abs_sum: 387.50723040867683
  residual_max_abs: 0.29974964033236406

orin_replay:
  status: PASS
  counts_ok: 1
  values_ok: 1
  max_abs: 0.00791019
  max_rel: 4.40468e-05
```

Windows HLS CSim：

```text
obs_tb.exe <repo>/fpga/golden/localization/frame_000001
```

验收：

- `H/b` 误差：`abs <= 1e-4` 或 `rel <= 1e-3`
- `valid_count/reject_count/miss_count` 精确一致

---

## 8. 分阶段路线

P0 当前基线（已完成）：

- CPU/NDT 默认路径不变
- 定位 CPU_SIM guarded enable
- 建图/定位 FPGA 配置命名统一
- 短 bag NDT vs CPU_SIM baseline 可复现
- 统一文档、ABI、localization golden 工具、HLS CSim 源码
- localization `frame_000001` golden 已生成，Orin replay PASS

P1 统一 observation（当前焦点）：

- Windows HLS CSim 通过 localization golden（`frame_000001` 已 PASS）
- 保存 CSim 输出、误差记录（已归档）
- `unified_surfel_observation_core` Vivado HLS 2018.3 C Synthesis 已 PASS，资源/时序报告已归档
- HLS 单控制口接口收敛已 PASS：无 HLS AXI-Lite slave，控制交给 `slam_accel_ctrl`
- mapping observation 改为同一 ABI buffer
- mapping/localization golden 都可生成
- HLS CSim 同时通过 mapping/localization golden

P2 控制与上板准备：

- `slam_accel_ctrl` RTL 已完成接口收敛并通过 Vivado OOC synthesis check
- 当前 `slam_accel_ctrl` 只是 register bank + command decoder + dispatch FSM + HLS direct-control contract，尚未实例化 HLS IP、BD、XDMA、DDR interconnect 或上板链路
- HLS generated RTL port mapping 复核、Cosim、IP export
- fresh Vivado 7Z100 block design / implementation
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

## 9. 下一步执行清单

Step 1：归档 baseline（已完成）

- 已创建 `reports/localization/ndt_vs_cpu_sim/mid360_20260313_outdoor_30deg_up_quan_03_short/`
- 已归档 `report.md`、`summary.json`、`commands.md`
- 原始日志暂存 `/tmp/lightning_compare_ndt.log`、`/tmp/lightning_compare_cpu_sim.log`，不默认纳入 git

Step 2：实现 scan PCD 导出工具（已完成）

- 已新增 `export_loc_golden_frame`
- 已输出 `scan_body_undistorted.pcd`、`active_map.pcd`、`pose_guess.txt`、`frame_meta.yaml`
- 已用同一段 bag 导出 `fpga/golden_src/localization/frame_000001`

Step 3：生成 localization golden（已完成）

- 已使用 `build_surfel_loc_golden`
- 已输出到 `fpga/golden/localization/frame_000001`
- 已使用 `run_surfel_loc_golden_replay` 在 Orin 侧验证通过

Step 4：Windows 侧 HLS（localization CSim、C Synthesis、接口收敛已完成）

- 已先做 g++ CSim 与 Vivado HLS 2018.3 CSim
- CSim 输入 `fpga/golden/localization/frame_000001`
- 当前结果：PASS，`max_abs=0.0078906`，`max_rel=4.41926e-05`
- 已完成 Vivado HLS 2018.3 C Synthesis：10.00 ns target，9.307 ns estimated，BRAM_18K 36，DSP48E 256，FF 27475，LUT 41633
- 已完成接口收敛：无 `s_axi_control`，input direct base ports 已收敛，output field direct ports 由 `slam_accel_ctrl` 派生地址支持
- 下一步做 HLS generated RTL port mapping 复核 / Cosim / IP export
- 暂不做 XDMA、block design、在线上板

Step 5：Orin/Windows 对齐记录

- 已保存 CSim 输出、误差统计和关键命令到 `reports/fpga/hls/unified_surfel_observation_core/localization/frame_000001/`
- 已对比 Orin replay 的 `valid/reject/miss` 与 `H/b`
- 已保存 C Synthesis 命令、资源和时序摘要到 `reports/fpga/hls/unified_surfel_observation_core/csynth/`
- 已保存接口收敛命令、HLS interface 摘要和 RTL OOC synthesis 摘要到 `reports/fpga/hls/unified_surfel_observation_core/interface_convergence/` 与 `reports/fpga/rtl/slam_accel_ctrl/interface_convergence/`
- CSim、C Synthesis 与接口收敛已完成，下一步可进入 HLS generated RTL port mapping 复核 / Cosim / IP export

Step 6：后续 Orin/FPGA 任务

- 复核 `slam_accel_ctrl` 与 HLS observation IP generated RTL 的端口连接表，尤其是 output field direct offset ports
- `slam_accel_ctrl` 与 HLS observation IP 集成
- Fresh Vivado 7Z100 block design / XDMA / DDR buffer integration
- mapping observation golden
- SurfelTileMap `.smap` 离线转换工具
- XDMA host runtime
- online guarded enable 与 CPU fallback

---

## 10. 合同指标闭环

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

---

## 11. 2026-06-16 HLS Generated RTL Port Mapping / Cosim / IP Export 更新

### 当前阶段状态

- `unified_surfel_observation_core` generated RTL port mapping：PASS。
- g++ CSim：PASS。
- Vivado HLS 2018.3 CSim：PASS。
- Vivado HLS 2018.3 C Synthesis：PASS。
- Vivado HLS 2018.3 Cosim：BLOCKED，阻塞在 HLS 自动生成 cosim wrapper 的 C++ 编译阶段，尚未进入 RTL 仿真。
- Vivado HLS 2018.3 IP export：PASS，已通过本地 `core_revision` 兼容修复生成 IP catalog 输出。

### 本次变更摘要

- `create_vivado_hls_project.tcl` 新增/固化 `cosim`、`csynth_cosim`、`export_ip`、`csynth_export_ip` flow，并配置 IP export format/version/description。
- 新增 Windows 入口脚本：
  - `fpga/hls/unified_surfel_observation_core/run_vivado_hls_cosim.ps1`
  - `fpga/hls/unified_surfel_observation_core/run_vivado_hls_export_ip.ps1`
- `run_vivado_hls_export_ip.ps1` 增加 Vivado HLS 2018.3 `core_revision` 溢出兼容处理：若 HLS 未生成 `component.xml`/zip，且生成的 `run_ippack.tcl` revision 超过 Vivado 2018.3 IP packager 可接受范围，则把本地生成物中的 revision 改为 `1` 并重跑 Vivado packager。
- 更新 `fpga/hls/unified_surfel_observation_core/README.md`，记录 cosim 状态、IP export 命令、generated RTL port mapping 和 `unified_obs_error=32'd0` 临时约定。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_cosim.ps1 `
  -GoldenDir .\fpga\golden\localization\frame_000001 `
  -ProjectDir "$env:TEMP\lightning_hls_unified_obs_cosim"

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
```

### 验证结果

- g++ CSim：`[obs_tb] PASS`。
- Vivado HLS CSim：`CSim done with 0 errors`，`[obs_tb] PASS`。
- C Synthesis：`xc7z100ffg900-2`，target `10.00 ns`，estimated `9.307 ns`，`BRAM_18K 36`，`DSP48E 256`，`FF 27475`，`LUT 41633`；generated report 未发现 `s_axi_control` 或其他 `s_axi` 控制入口。
- Generated RTL port mapping：`ap_ctrl_hs`，direct scalar address width 为 32-bit；`scan_points/pose/map_header/active_blocks/obs_cells` 为单一 direct scalar base-address ports；output field direct ports 全部存在。
- 当前 HLS core 无 error 输出；后续 wrapper/BD 中 `unified_obs_error` 固定接 `32'd0`，直到真实 error channel 加入。
- Cosim：BLOCKED。失败发生在进入 RTL 仿真前，关键错误为 `g++.exe: error: release: No such file or directory`、`ERROR: [COSIM 212-317] C++ compile error.`、`ERROR: [COSIM 212-331] Aborting co-simulation: C simulation failed, compilation errors.`；按 Vivado HLS 2018.3 工具链/接口限制归档，下一步改做 wrapper-level RTL simulation。
- IP export：PASS。已生成 `%TEMP%\lightning_hls_unified_obs\solution1\impl\ip\component.xml` 和 `%TEMP%\lightning_hls_unified_obs\solution1\impl\ip\xilinx_com_hls_unified_surfel_observation_core_1_0.zip`，`component.xml` 中 `coreRevision=1`；导出目录仍为本地生成物，不纳入 git。

### 归档报告

```text
reports/fpga/hls/unified_surfel_observation_core/port_mapping/
  commands.md
  port_mapping.md
  summary.json
reports/fpga/hls/unified_surfel_observation_core/cosim/
  commands.md
  summary.json
  vivado_hls_cosim.log
  vivado_hls_cosim_summary.txt
reports/fpga/hls/unified_surfel_observation_core/ip_export/
  commands.md
  summary.json
  vivado_ip_packager.log
  vivado_hls_ip_export_summary.txt
```

### 下一步

- 不做 XDMA、block design、DDR interconnect 或上板。
- 下一步进入 wrapper-level RTL integration/simulation 计划：将 `slam_accel_ctrl` 与 HLS IP generated RTL 通过一层顶层 wrapper 固化连接，`unified_obs_error` 暂接 `32'd0`，并以 RTL testbench 验证 `ap_start/ap_done`、direct address ports 和 output field address 派生逻辑。

补充：同日已加严 `run_vivado_hls_export_ip.ps1` 退出码保护。若 Vivado HLS 返回 0 但没有生成 `component.xml`/zip，且不存在可修复的 `run_ippack.tcl` 或 revision 未命中可修复条件，脚本会返回失败，避免 IP export 误报 PASS。

补充：同日检查发现 `fpga/golden/localization/frame_000001/*` 曾被 git 跟踪，已按规则执行 `git rm --cached` 仅取消索引跟踪并保留本地文件，同时在 `.gitignore` 增加 `fpga/golden/`。后续 golden 仍只作为本地验证输入，在路线文档和 reports 中记录路径和用途。
