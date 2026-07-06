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

从 2026-06-19 起，board-level Vivado synthesis、implementation 和 bitstream 脚本默认使用多核心运行，默认 `-jobs 18`；如本机资源不足，可显式传入 `-Jobs N` 降低并记录原因。

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

---

## 12. 2026-06-17 Vivado Wrapper-Level Simulation 更新

### 当前阶段状态

- 已新增最小 Vivado wrapper-level simulation/OOC 工程骨架：`fpga/vivado/slam_accel_wrapper_sim/`。
- 本阶段未创建完整 board-level Vivado project，未创建 block design，未接 XDMA，未接 DDR interconnect，未生成 bitstream，未上板。
- wrapper-level behavioral simulation：PASS。
- wrapper OOC synthesis：PASS，0 errors，0 critical warnings。

### 本次变更摘要

- 新增 `slam_accel_wrapper_sim_top`，实例化 `slam_accel_ctrl` 和 HLS control-plane mock。
- `slam_accel_ctrl` 到 HLS 侧契约已在 wrapper 中固化：
  - `unified_obs_ap_start -> ap_start`
  - `ap_done/ap_idle/ap_ready -> unified_obs_ap_done/ap_idle/ap_ready`
  - `num_points` 和 direct scalar address ports 直连
  - output field address 由单一 `OUT_ADDR` 派生后直连
  - 当前 HLS 无 error 输出，`unified_obs_error` 固定接 `32'd0`
- 新增 RTL testbench，覆盖 AXI-Lite 配置、正常 dispatch、unsupported kernel 和 address high word error 路径。
- 新增 Vivado TCL 与 PowerShell 入口：
  - `run_vivado_sim.ps1`
  - `run_vivado_ooc_synth.ps1`
  - `run_sim.tcl`
  - `run_ooc_synth.tcl`
- PowerShell 入口使用各自 `%TEMP%` 工程目录下的 `vivado.log/.jou`，避免多个 Vivado 进程抢仓库根目录日志文件。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_wrapper_sim\run_vivado_sim.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_wrapper_sim\run_vivado_ooc_synth.ps1
```

### 验证结果

- Behavioral simulation：
  - status：PASS
  - testbench 输出：`[tb_slam_accel_wrapper_sim] PASS`
  - 覆盖：AXI-Lite write/read、`KERNEL_SEL=4`、`ap_start/ap_done/ap_idle/ap_ready`、direct address ports、output field address 派生、`ERROR=0x1`、`ERROR=0x3`
- OOC synthesis：
  - status：PASS
  - errors：0
  - critical warnings：0
  - ordinary warnings：9
  - 资源：Slice LUTs 620，Slice Registers 1079，Block RAM Tile 0，DSPs 0
- 普通 warning 说明：
  - `s_axi_awaddr[1:0]` 和 `s_axi_araddr[1:0]` 未使用是因为 `slam_accel_ctrl` 按 32-bit word 对齐寄存器地址。
  - `HD.CLK_SRC` 未设置是 OOC timing estimation 常见 warning。
  - `s_axi_wready` 被综合合并到 `s_axi_awready`。

### 归档报告

```text
reports/fpga/vivado/slam_accel_wrapper_sim/
  commands.md
  summary.json
  vivado_wrapper_summary.txt
  vivado_sim.log
  vivado_sim_log.txt
  vivado_ooc_synth.log
  vivado_ooc_synth_log.txt
  utilization.rpt
  timing_summary.rpt
```

### 下一步

- 继续不做 XDMA、完整 block design、DDR interconnect、bitstream 或上板。
- 下一步进入真实 HLS IP wrapper/BD 集成计划：用已导出的 HLS IP 替换或增强当前 control-plane mock，定义真实 `m_axi_gmem0..4` 到后续 interconnect/DDR 的连接策略。

---

## 13. 2026-06-17 Real HLS IP BD Integration Skeleton 更新

### 当前阶段状态

- 新增真实 HLS IP / `slam_accel_ctrl` BD 集成骨架：`fpga/vivado/slam_accel_hls_ip_bd/`。
- 不需要手工创建 Vivado 工程；所有工程继续由 TCL/PowerShell 从空目录生成到 `%TEMP%`。
- 本阶段未创建 XDMA、DDR interconnect、PS、implementation、bitstream 或上板工程。
- BD validate：PASS。
- HDL wrapper generation：PASS。
- non-project OOC synthesis：BLOCKED，阻塞点为 Vivado HLS 2018.3 导出的 floating-point subcore XCI 将 `generate_synth_checkpoint` 锁为只读/off。
- project-managed `synth_1`：PASS，0 errors，0 critical warnings。

### 本次变更摘要

- 新增 `create_bd.tcl`，从 `%TEMP%\lightning_hls_unified_obs\solution1\impl\ip` 导入真实 HLS IP `unified_surfel_observation_core`。
- `slam_accel_ctrl` 作为 BD module reference 实例化，保持唯一外露控制入口。
- 固化连接：`ap_start/ap_done/ap_idle/ap_ready`、`num_points`、输入 direct scalar base address、output field direct address。
- `unified_obs_error` 由 `xlconstant` 固定为 `32'd0`。
- HLS `m_axi_gmem0..4` 暂时作为 external AXI master interface 暴露。
- 新增 `slam_accel_hls_ip_bd.xdc`，约束 `aclk` 为 10.000 ns / 100 MHz。
- 新增 `run_vivado_bd_validate.ps1`、`run_vivado_ooc_synth.ps1`、`run_vivado_project_synth.ps1`。
- 新增 `README.md` 和 `reports/fpga/vivado/slam_accel_hls_ip_bd/` 归档。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_ooc_synth.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_project_synth.ps1
```

### 验证结果

- BD validate：PASS，日志 marker 为 `BD_VALIDATE_PASS`。
- Wrapper generation：PASS，生成 `slam_accel_hls_ip_bd_wrapper.v`。
- Non-project OOC synthesis：BLOCKED，关键错误为 `Cannot change read-only property 'generate_synth_checkpoint'`；该路径用于记录 Vivado HLS 2018.3 subcore XCI 限制，不作为当前通过标准。
- Project-managed synthesis：PASS，日志 marker 为 `PROJECT_SYNTH_PASS`，`SYNTH_1_STATUS=synth_design Complete!`。
- Project-managed synthesis 日志结论：`Synthesis finished with 0 errors, 0 critical warnings and 0 warnings.`

### 资源与时序摘要

- Part：`xc7z100ffg900-2`
- Design：`slam_accel_hls_ip_bd_wrapper`
- Clock：`aclk = 10.000 ns / 100 MHz`
- Slice LUTs：21292 / 277400，7.68%
- Slice Registers：25884 / 554800，4.67%
- Block RAM Tile：24 / 755，3.18%
- DSPs：256 / 2020，12.67%
- Bonded IOB：4032 / 362，1113.81%
- Setup WNS：2.732 ns，TNS：0.000 ns，setup failing endpoints：0
- Hold WHS：-0.017 ns，THS：-2.925 ns，hold failing endpoints：170

说明：IOB 超额是因为本阶段把 AXI-Lite 与 `m_axi_gmem0..4` 全部暴露为外部端口；下一阶段必须通过 AXI VIP/BRAM/SmartConnect simulation harness 或后续 DDR/interconnect 内部化。Hold violation 是 synth/open-run 的早期估计，后续进入真实 fabric/implementation 后再收敛。

### 归档报告

```text
reports/fpga/vivado/slam_accel_hls_ip_bd/
  commands.md
  summary.md
  vivado_bd_validate_log.txt
  vivado_ooc_synth_log.txt
  vivado_project_synth_log.txt
  vivado_project_synth_runme_log.txt
  slam_accel_hls_ip_bd_project_synth_utilization.txt
  slam_accel_hls_ip_bd_project_synth_timing_summary.txt
```

### 下一步

- 不做上板、不做 bitstream、不做 XDMA。
- 下一步进入 AXI VIP/BRAM/SmartConnect simulation harness 计划：保留真实 HLS IP 和 `slam_accel_ctrl`，将当前外露 `m_axi_gmem0..4` 接入可仿真的内存/互连 harness，解决 IOB 超额和 wrapper-level data-plane 验证缺口。
---

## 14. 2026-06-17 AXI Memory Harness / Data-Plane Integration 更新

### 当前阶段状态
- 已新增真实 HLS IP memory harness：`fpga/vivado/slam_accel_hls_mem_harness/`。
- 本阶段仍未创建 XDMA、DDR、PS、implementation、bitstream 或上板工程。
- `slam_accel_ctrl` 继续保持唯一外露 AXI-Lite 控制入口。
- `unified_surfel_observation_core` 继续使用真实 HLS IP，`unified_obs_error` 仍由 `xlconstant` 固定接 `32'd0`。
- HLS `m_axi_gmem0..4` 已从顶层外露端口改为内部 BRAM-backed AXI memory targets。
- BD validate：PASS。
- Project-managed synthesis：PASS，0 errors，0 critical warnings。
- Wrapper behavioral simulation：PASS，`[tb_lmem_bd_smoke] PASS`。

### 本次变更摘要
- 新增 `create_bd.tcl`，创建短名 Vivado project/BD：`lmem` / `lmem_bd`，默认实际生成目录为 `fpga/vivado/.build/lmem_bd`；运行 Vivado 时临时映射短盘符以避免 Vivado 2018.3 在 Windows 下触发 260 字符路径限制。
- 新增 5 路独立内部 BRAM-backed AXI targets：
  - `m_axi_gmem0 -> axi_bram_ctrl_0 + blk_mem_0`，128-bit
  - `m_axi_gmem1 -> axi_bram_ctrl_1 + blk_mem_1`，512-bit
  - `m_axi_gmem2 -> axi_bram_ctrl_2 + blk_mem_2`，256-bit
  - `m_axi_gmem3 -> axi_bram_ctrl_3 + blk_mem_3`，512-bit
  - `m_axi_gmem4 -> axi_bram_ctrl_4 + blk_mem_4`，64-bit
- 每路 BRAM target 使用 4K address range，当前用于 data-plane smoke，不用于 golden 数值对齐。
- 新增 `run_vivado_bd_validate.ps1`、`run_vivado_project_synth.ps1`、`run_vivado_sim.ps1`。
- 新增 `tb_lmem_bd_smoke.v`，通过真实 BD wrapper 配置 AXI-Lite、触发 start、等待 controller DONE，并检查 `ERROR=0`、`RUN_COUNT=1`。
- 更新 `fpga/vivado/slam_accel_hls_mem_harness/README.md` 和 `reports/fpga/vivado/slam_accel_hls_mem_harness/`。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_project_synth.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_sim.ps1
```

### 验证结果
- BD validate：PASS，日志 marker 为 `BD_VALIDATE_PASS`。
- Synthesis：PASS，日志 marker 为 `PROJECT_SYNTH_PASS`，`SYNTH_1_STATUS=synth_design Complete!`。
- Synthesis 日志结论：`Synthesis finished with 0 errors, 0 critical warnings and 0 warnings.`；Vivado 汇总为 50 Infos、11 Warnings、0 Critical Warnings、0 Errors。
- Simulation：PASS，日志 marker 为 `[tb_lmem_bd_smoke] PASS`，仿真在 14235 ns 完成。
- 顶层 `m_axi_gmem0..4` 不再外露；XSim protocol instance 显示 5 路 HLS AXI master 均连接到内部 AXI BRAM Controller。
- Vivado XSim 中出现 BRAM behavioral model warning 和 DSP48 OPMODE warning，均为当前零初始化 smoke 场景下的普通 warning；testbench PASS。

### 资源与时序摘要
- Part：`xc7z100ffg900-2`
- Clock：`aclk = 10.000 ns / 100 MHz`
- Slice LUTs：23027 / 277400，8.30%
- Slice Registers：31014 / 554800，5.59%
- Block RAM Tile：47 / 755，6.23%
- DSPs：256 / 2020，12.67%
- Bonded IOB：204 / 362，56.35%
- Setup WNS：2.732 ns，TNS：0.000 ns，setup failing endpoints：0
- Hold WHS：-0.095 ns，THS：-142.802 ns，hold failing endpoints：1647

说明：上一阶段真实 HLS IP BD skeleton 因外露 AXI-Lite 和 5 路 `m_axi_gmem0..4` 使用 4032 IOB。本阶段将 HLS memory ports 内部化后，IOB 降到 204，已低于 7Z100 管脚数量。hold violation 是 synth/open-run 的中间阶段估计，先记录，不在本阶段做 timing optimization。

### 归档报告

```text
reports/fpga/vivado/slam_accel_hls_mem_harness/
  commands.md
  summary.md
  vivado_bd_validate_log.txt
  vivado_project_synth_log.txt
  vivado_project_synth_runme_log.txt
  vivado_sim_log.txt
  xsim_simulate_log.txt
  slam_accel_hls_mem_harness_project_synth_utilization.txt
  slam_accel_hls_mem_harness_project_synth_timing_summary.txt
```

### 下一步
- 仍不做 XDMA、DDR、PS、bitstream 或上板。
- 下一步进入 golden memory image loader / realistic memory preload 计划：把 `fpga/golden/localization/frame_000001` 中的 scan、pose、map header、active blocks、obs cells 按 HLS ABI 写入仿真 memory image 或 testbench preload，使 wrapper-level simulation 从 data-plane smoke 进入 golden numeric comparison。
- golden loader 通过后，再评估是否把 5 路独立 BRAM target 收敛为 SmartConnect/AXI Interconnect + shared memory model，为后续 DDR/XDMA fabric 做准备。
---

## 15. 2026-06-17 Vivado Generated Project Directory 修正

### 当前阶段状态
- 已修正 `slam_accel_hls_mem_harness` 的 Vivado 生成工程目录组织。
- 生成工程不再默认放到 `C:\lmem_bd`、`C:\lmem_syn`、`C:\lmem_sim`。
- 当前默认实际目录统一放在仓库内 `fpga/vivado/.build/`：
  - BD validate：`fpga/vivado/.build/lmem_bd`
  - project-managed synthesis：`fpga/vivado/.build/lmem_syn`
  - behavioral simulation：`fpga/vivado/.build/lmem_sim`
- `fpga/vivado/.build/` 已加入 `.gitignore`，作为本地 Vivado 生成目录，不纳入 git。

### 本次变更摘要
- 新增 `fpga/vivado/slam_accel_hls_mem_harness/vivado_path.ps1`，封装 Vivado 短路径映射逻辑。
- PowerShell 入口在运行 Vivado 时临时把 `fpga/vivado/.build` 映射到未占用短盘符，例如 `V:\`。
- Vivado 进程内部看到 `V:\lmem_bd`、`V:\lmem_syn`、`V:\lmem_sim` 这类短路径，以规避 Vivado 2018.3 / Windows 260 字符路径限制。
- 实际文件仍落在 `fpga/vivado/.build/lmem_*`，命令结束后自动卸载临时盘符映射。
- 已清理此前由本流程生成的旧 `C:\lmem_bd`、`C:\lmem_syn`、`C:\lmem_sim` 目录。
- 更新 `README.md`、`reports/fpga/vivado/slam_accel_hls_mem_harness/commands.md` 和 `summary.md` 中的路径说明。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_sim.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_project_synth.ps1
```

### 验证结果
- BD validate：PASS，日志 marker 为 `BD_VALIDATE_PASS`。
- Behavioral simulation：PASS，日志 marker 为 `[tb_lmem_bd_smoke] PASS`。
- Project-managed synthesis：PASS，日志 marker 为 `PROJECT_SYNTH_PASS`，`SYNTH_1_STATUS=synth_design Complete!`。
- Synthesis 日志结论仍为 0 errors、0 critical warnings。
- `subst` 检查确认命令结束后没有残留临时盘符映射。

### 下一步
- 后续 Vivado 侧脚本化工程默认都应放在 `fpga/vivado/.build/<flow_name>` 下，并加入 git ignore；不要再默认放到 C 盘根目录。
- 如遇 Windows/Vivado 2018.3 路径长度问题，优先采用“repo 内实际目录 + 临时短盘符映射”的方式解决。
- 继续进入 golden memory image loader / realistic memory preload 计划。

---

## 16. 2026-06-17 Golden Memory Image Loader / Wrapper 数值仿真更新

### 当前阶段状态
- 已新增 golden memory image loader 和 wrapper-level golden RTL simulation 入口。
- 当前仍不做 XDMA、DDR、PS、implementation、bitstream 或上板。
- 现有可综合 `slam_accel_hls_mem_harness` 保持不变：`slam_accel_ctrl` 仍是唯一外露 AXI-Lite 控制入口，真实 HLS IP 的 `m_axi_gmem0..4` 仍接内部 BRAM-backed targets。
- full golden 的 `obs_cells` image 为 60,932,096 bytes，不能作为 7Z100 片上 BRAM preload；本阶段将其作为 simulation-only behavioral AXI memory image。
- Golden RTL numeric simulation 当前 BLOCKED：Vivado 2018.3 XSim 可以 elaborate 并加载 memory image，但 generated HLS floating-point RTL runtime 过慢，64 点 bounded run 超过 15 分钟仍未完成。

### 本次变更摘要
- 新增 `make_golden_mem_images.py`：读取 `fpga/golden/localization/frame_000001`，生成 5 路 HLS AXI bundle 对应的二进制 memory image，并生成 `golden_frame_000001_params.vh`。
- 新增 `axi_memory_model.sv`：仿真专用 AXI4 memory slave，支持二进制 preload、AXI burst read/write、output memory peek。
- 新增 `tb_lmem_golden.sv`：直接实例化 `slam_accel_ctrl`、HLS generated RTL top 和 5 路 behavioral AXI memory model，配置 AXI-Lite 后等待 DONE 并比较 `H_upper/b/counts/residual`。
- 新增 `run_vivado_golden_sim.ps1` 和 `run_golden_sim.tcl`：默认 `-MaxPoints 64`，生成目录为 `fpga/vivado/.build/lmem_golden_sim` 和 `fpga/vivado/.build/golden_frame_000001_n64`；`-FullFrame` 保留完整帧长跑入口。
- 更新 `fpga/vivado/slam_accel_hls_mem_harness/README.md`、`reports/fpga/vivado/slam_accel_hls_mem_harness/commands.md`、`summary.md` 和 `golden_frame_000001_n64/status.md`。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_sim.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_project_synth.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_golden_sim.ps1 -MaxPoints 64

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_golden_sim.ps1 -MaxPoints 64 -RunNumeric
```

### 验证结果
- BD validate：PASS，日志 marker 为 `BD_VALIDATE_PASS`。
- Wrapper smoke simulation：PASS，日志 marker 为 `[tb_lmem_bd_smoke] PASS`。
- Project-managed synthesis：PASS，日志 marker 为 `PROJECT_SYNTH_PASS`，`SYNTH_1_STATUS=synth_design Complete!`。
- Synthesis 日志结论：0 errors、0 critical warnings。
- Golden image generation：PASS，日志 marker 为 `GOLDEN_IMAGE_PASS`。
- Golden RTL elaboration/preload smoke：PASS，默认 `run_vivado_golden_sim.ps1 -MaxPoints 64` 只做 elaborate + memory preload，不跑长时间数值比较。
- Golden bounded expected：64 points，expected `valid/reject/miss = 14/33/17`。
- Golden RTL numeric simulation with `-RunNumeric`：BLOCKED。`tb_lmem_golden_behav` 可 elaborate；5 路 memory image 均可加载；但 64 点 run 超过 15 分钟只推进到约 4.4 ms simulation time，仍在 generated HLS floating-point datapath 中反复输出 DSP48 OPMODE warnings。完整 6963 点 run 也超过 20 分钟未完成。

### 归档报告

```text
reports/fpga/vivado/slam_accel_hls_mem_harness/
  commands.md
  summary.md
  golden_frame_000001_n64/
    golden_image_summary.md
    status.md
    vivado_golden_sim_log.txt
    xsim_golden_simulate_log.txt
```

### 下一步
- 不把 Vivado 2018.3 generated floating-point RTL full/bounded golden simulation 作为常规 per-change gate。
- 保留当前 BD smoke simulation + project synthesis 作为 RTL integration gate。
- 下一步建议做更小的 dedicated synthetic vector，确保 XSim 能快速完成；或改走更快的 wrapper/co-sim 策略，在不依赖完整 Vivado floating-point event simulation 的情况下完成 golden numeric check。
- 后续若进入板级 data plane，应优先设计 DDR/AXI memory model 或 host-driven memory loader，而不是继续扩大内部 BRAM preload。
---

## 17. 2026-06-17 Tiny Synthetic Vector RTL Numeric Simulation 更新

### 当前阶段状态
- 已新增 tiny synthetic vector 快速数值仿真入口。
- 本阶段仍不做 XDMA、DDR、PS、implementation、bitstream 或上板。
- `slam_accel_ctrl` 继续作为唯一外露 AXI-Lite 控制入口。
- 仿真路径直接实例化真实 HLS generated RTL top、`slam_accel_ctrl` 和 5 路 behavioral AXI memory model。
- full/bounded golden RTL numeric simulation 仍记录为 Vivado 2018.3 XSim runtime-blocked 长跑路径，不作为当前 gate。

### 本次变更摘要
- 新增 `fpga/vivado/slam_accel_hls_mem_harness/make_synthetic_mem_images.py`。
- 新增 `fpga/vivado/slam_accel_hls_mem_harness/run_vivado_synthetic_sim.ps1`。
- synthetic fixture 固定为 1 个 scan point、1 个 active block、256 个 obs cells、1 个 valid cell、identity pose。
- synthetic expected normal equation 由现有 HLS-equivalent Python `compute_expected()` 生成，预期 `valid/reject/miss = 1/0/0`。
- 生成目录仍在 `fpga/vivado/.build/synthetic_tiny`，不纳入 git。
- 归档报告新增 `reports/fpga/vivado/slam_accel_hls_mem_harness/synthetic_tiny/`。
- synthetic 生成器会 import golden image helper，Python `__pycache__/` 已作为本地生成物加入 ignore 规则。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_synthetic_sim.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_sim.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_project_synth.ps1
```

### 验证结果
- Synthetic image generation：PASS，日志 marker 为 `SYNTHETIC_IMAGE_PASS`。
- Synthetic RTL numeric simulation：PASS，日志 marker 为 `[tb_lmem_golden] PASS`。
- Synthetic counts：`valid/reject/miss = 1/0/0`。
- Synthetic numeric comparison：`max_abs=2.980232227667301e-09`，`max_rel=2.980232227667301e-09`，满足 `abs <= 1e-4` 或 `rel <= 1e-3`。
- Synthetic XSim 完成时间：testbench `$finish` at `29995 ns`。
- BD validate：PASS，日志 marker 为 `BD_VALIDATE_PASS`。
- BRAM smoke simulation：PASS，日志 marker 为 `[tb_lmem_bd_smoke] PASS`。
- Project-managed synthesis：PASS，日志 marker 为 `PROJECT_SYNTH_PASS`，`SYNTH_1_STATUS=synth_design Complete!`。
- Synthesis 日志结论：`0 errors`、`0 critical warnings`。

### 归档报告

```text
reports/fpga/vivado/slam_accel_hls_mem_harness/
  commands.md
  summary.md
  synthetic_tiny/
    synthetic_image_summary.md
    status.md
    vivado_synthetic_sim_log.txt
    xsim_synthetic_simulate_log.txt
```

### 下一步
- 进入板级 memory/data-plane 方案阶段：确定 5 路 HLS AXI master 到板级 DDR/AXI fabric 的连接方式，不再依赖内部 BRAM 作为最终方案。
- 在进入 board-level BD 前，需要固定 7Z100 开发板信息：XDC、时钟、复位、DDR、PCIe/XDMA 或实际 host 通道。
- 仍不直接进入上板；下一阶段先做 board-level Vivado project/BD 计划和约束/地址映射收敛。

---

## 18. 2026-06-17 AX7Z100 PCIe/XDMA + PL DDR3/MIG 板级骨架更新

### 当前阶段状态
- 已新增脚本化板级 Vivado 骨架：`fpga/vivado/slam_accel_ax7z100_pcie_mig/`。
- 当前仍不做 implementation、bitstream、host runtime 或上板。
- 已确认用户此前 7Z015 方案里的 Orin 100 MHz 继续使用，但本阶段修正为 PCIe endpoint reference clock：接 AX7Z100 `pcie_ref` / XDMA `sys_clk`，不是 PL DDR3/MIG 系统时钟。
- AX7Z100 PL DDR3/MIG 使用板载 200 MHz 差分时钟 `SYS_CLK_P/N = F9/E8`。
- 第一版 PCIe 固定为 Gen2 X4，参考 ALINX `33_PCIe_test`，不直接做 X8。
- `slam_accel_ctrl` 继续作为唯一 AXI-Lite 控制寄存器入口，通过 XDMA `M_AXI_LITE` 访问。
- 真实 HLS IP `unified_surfel_observation_core` 已接入板级 BD。
- HLS `m_axi_gmem0..4` 和 XDMA `M_AXI` 已接入 PL DDR3/MIG-backed AXI memory fabric，不再外露到顶层。

### 本次变更摘要
- 新增 AX7Z100 board profile：记录 docx、`12_ddr3_pl/mig_a.prj`、`33_PCIe_test`、`ch06_xdma_test` 的引用边界。
- 新增 `validate_board_profile.ps1`，静态校验：
  - `xc7z100-ffg900/-2`
  - DDR3 `MT41K256M16XX-125`
  - MIG `InputClkFreq=200`、`TimePeriod=1250`、`DataWidth=32`
  - PL DDR3 SYS_CLK `F9/E8`
  - PCIe refclk `N8/N7`
  - PCIe reset `AB22`
  - XDMA Gen2 X4、128-bit AXI、125 MHz AXI target
- 新增 AXI-Lite BD wrapper：`slam_accel_ctrl_axi_lite_wrapper.v`，用于把 `slam_accel_ctrl` 挂到 XDMA `M_AXI_LITE`。
- 新增 `create_bd.tcl`：
  - 创建 fresh Vivado project，Vivado 内部短名为 `azmig`，规避 Vivado 2018.3 Windows MIG 260 字符路径问题。
  - 导入 HLS IP repo。
  - 实例化 XDMA、MIG 7-series、真实 HLS IP、`slam_accel_ctrl` wrapper、AXI interconnect、reset helper。
  - `pcie_ref` 接 XDMA `sys_clk`；`sys` 接 MIG `SYS_CLK`。
  - `xdma_0/axi_aclk` 驱动控制侧和 HLS `ap_clk`；`mig_7series_0/ui_clk` 驱动 MIG S_AXI；AXI interconnect 做跨时钟/数据宽度转换。
- MIG 说明：
  - `12_ddr3_pl/mig_a.prj` 保留为 native PL DDR3 板级参数来源和静态校验源。
  - 实际 AXI MIG XML 从 ALINX `33_PCIe_test` Tcl 中提取；原因是直接把 native `.prj` 修改成 AXI 口时，Vivado 2018.3 MIG customization 曾出现 failure/crash。
- 新增 `run_vivado_bd_validate.ps1`、`run_vivado_project_synth.ps1`。
- 新增报告目录：`reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/`。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\validate_board_profile.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1
```

### 验证结果
- Board profile static validation：PASS，marker 为 `BOARD_PROFILE_PASS`。
- BD validate：PASS，marker 为 `BD_VALIDATE_PASS`。
- HDL wrapper generation：PASS。
- Project-managed synthesis：PASS。
- Synthesis marker：
  - `SYNTH_1_STATUS=synth_design Complete!`
  - `PROJECT_SYNTH_PASS`
- Synthesis 日志结论：`0 errors`、`0 critical warnings`、`14 warnings`。
- 顶层未外露 HLS `m_axi_gmem0..4`。
- Vivado 生成目录仍在 `fpga/vivado/.build/azmig_bd` 和 `fpga/vivado/.build/azmig_syn`，不纳入 git。

### 资源与时序摘要
- Slice LUTs：61,751 / 277,400（22.26%）
- Slice Registers：69,374 / 554,800（12.50%）
- Block RAM Tile：64.5 / 755（8.54%）
- DSPs：256 / 2,020（12.67%）
- Bonded IOB：74 / 362（20.44%）
- BUFGCTRL：11 / 32（34.38%）
- MMCME2_ADV：3 / 8（37.50%）
- Synth/open-run timing snapshot：
  - WNS：-0.366 ns
  - TNS：-4.014 ns
  - setup failing endpoints：11
  - WHS：-0.643 ns
  - THS：-501.516 ns
  - hold failing endpoints：19,045

说明：本阶段只要求 board-level skeleton 创建、BD validate、wrapper generation 和 synthesis 不报错。上述负时序作为后续 implementation/timing closure 风险记录，本阶段不做 timing optimization。

### 归档报告

```text
reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/
  board_profile_static_validation.md
  commands.md
  summary.md
  vivado_bd_validate_log.txt
  vivado_project_synth_log.txt
  vivado_project_synth_runme_log.txt
  ax7z100_pcie_mig_project_synth_utilization.txt
  ax7z100_pcie_mig_project_synth_timing_summary.txt
```

### 下一步
- 进入板级地址映射与 host bring-up 准备阶段。
- 固定 PL DDR3 中 host/HLS 共用 buffer layout：scan、pose、map header、active blocks、obs cells、output 的 base address 和大小。
- 新增最小 XDMA host smoke：先读写 `slam_accel_ctrl` 寄存器，再做 PL DDR3 memory write/read smoke。
- host smoke 通过后再进入 implementation + bitstream；暂不直接做完整在线 SLAM 或大帧 golden 上板。

---

## 19. 2026-06-17 PL DDR3 地址映射 + XDMA Host Smoke 准备

### 当前阶段状态
- 已完成上板前 host bring-up 准备，不做 implementation、bitstream 或上板。
- `slam_accel_ctrl` 仍是唯一 AXI-Lite 控制入口，后续通过 XDMA user/AXI-Lite BAR 访问。
- HLS `m_axi_gmem0..4` 继续走 MIG-backed PL DDR3 memory fabric。
- Host smoke 默认目标为 Orin/Linux root-complex，默认 XDMA 设备节点为：
  - `/dev/xdma0_user`
  - `/dev/xdma0_h2c_0`
  - `/dev/xdma0_c2h_0`

### 本次变更摘要
- 新增 host smoke 目录：`fpga/host/xdma_smoke/`。
- 固定 1 GB PL DDR3 buffer layout：
  - `SCAN_POINTS_BASE = 0x00000000`
  - `POSE_BASE = 0x01000000`
  - `MAP_HEADER_BASE = 0x01001000`
  - `ACTIVE_BLOCKS_BASE = 0x02000000`
  - `OBS_CELLS_BASE = 0x10000000`
  - `OUTPUT_BASE = 0x30000000`
- 所有 `*_ADDR_HI = 0`，继续满足当前 Vivado HLS 2018.3 生成的 32-bit AXI address contract。
- 新增地址映射常量与校验：
  - `ax7z100_plddr_layout.h`
  - `address_map.py`
  - `validate_address_map.py`
- 新增 Orin/Linux XDMA host smoke 工具：`xdma_smoke.py`。
  - 读 `slam_accel_ctrl.VERSION`，期望 `0x00020002`。
  - 写读 `KERNEL_SEL=4`、`MODE=1`、buffer base/count register。
  - 通过 H2C/C2H 对每个 buffer base 前 4 KB 做 memory pattern write/read。
  - 提供可选 `--start-zero`，只作为 bitstream 后人工 smoke，不作为当前 gate。
- 新增 tiny synthetic host image 生成入口：`make_tiny_synthetic_host_image.py`。
  - 复用 tiny synthetic fixture ABI 数据。
  - 输出 host 可写入 PL DDR3 的分段 binary 和 manifest。
- 更新 AX7Z100 PCIe/MIG README，补充 PL DDR3 layout、XDMA device node 和 host smoke 命令。

### 验证命令

```powershell
python fpga\host\xdma_smoke\validate_address_map.py --report reports\fpga\host\xdma_smoke\address_map_validation.md

python fpga\host\xdma_smoke\xdma_smoke.py --help

python fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py --out-dir fpga\vivado\.build\host_synthetic_tiny --report-dir reports\fpga\host\xdma_smoke\tiny_synthetic

python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\validate_address_map.py fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py fpga\host\xdma_smoke\xdma_smoke.py

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1
```

### 验证结果
- 地址映射校验：PASS，marker 为 `ADDRESS_MAP_PASS`。
- `xdma_smoke.py --help`：PASS。
- Tiny synthetic host image 生成：PASS，marker 为 `HOST_SYNTHETIC_IMAGE_PASS`。
- Python compile check：PASS。
- Board skeleton BD validate：PASS，marker 为 `BD_VALIDATE_PASS`。
- Board skeleton project synthesis：PASS，marker 为 `PROJECT_SYNTH_PASS`。
- Synthesis marker：
  - `SYNTH_1_STATUS=synth_design Complete!`
  - `0 errors`
  - `0 critical warnings`
  - `14 warnings`
- 资源/时序沿用当前板级 skeleton 结果：
  - Slice LUTs：61,751 / 277,400（22.26%）
  - Slice Registers：69,374 / 554,800（12.50%）
  - Block RAM Tile：64.5 / 755（8.54%）
  - DSPs：256 / 2,020（12.67%）
  - Bonded IOB：74 / 362（20.44%）
  - WNS：-0.366 ns
  - WHS：-0.643 ns

说明：负 WNS/WHS 仍作为 implementation/timing closure 风险记录。本阶段只做 host bring-up 准备和 board skeleton recheck，不做 timing optimization。

### 归档报告

```text
reports/fpga/host/xdma_smoke/
  commands.md
  summary.md
  address_map_validation.md
  tiny_synthetic/
    tiny_synthetic_host_image.md
```

### 上板后手动 smoke 预期

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --reg-smoke --ddr-smoke

python3 fpga/host/xdma_smoke/xdma_smoke.py --write-image fpga/vivado/.build/host_synthetic_tiny/manifest.json

python3 fpga/host/xdma_smoke/xdma_smoke.py --reg-smoke --start-zero
```

### 下一步
- 进入 implementation/bitstream 准备阶段前，需要接受当前 synth/open timing 风险，并复核最终板级 XDC、PCIe refclk/reset、MIG DDR3 约束。
- 下一阶段建议先跑 implementation，不立即接完整在线 SLAM。
- bitstream 后第一批真机 gate：XDMA device nodes、`VERSION` read、AXI-Lite register write/read、PL DDR3 4 KB pattern write/read。

---

## 20. 2026-06-17 AX7Z100 Implementation / Bitstream / Windows JTAG 准备

### 当前阶段状态
- 已完成 Windows Vivado 2018.3 implementation 和 bitstream generation。
- 本阶段没有用 Vivado HLS 刷写；Vivado HLS 只用于 `unified_surfel_observation_core` IP export。
- 刷写路径固定为 Windows Vivado Hardware Manager / JTAG。
- 未执行 JTAG 下载、未上板、未运行 Orin XDMA smoke。
- 当前 bitstream 可用于第一轮板级 smoke，但功能验收仍必须等上板后完成 XDMA register/memory 测试。

### 本次变更摘要
- 新增 implementation/bitstream 脚本：
  - `run_project_impl_bitstream.tcl`
  - `run_vivado_impl_bitstream.ps1`
- 新增 Windows JTAG 下载准备脚本：
  - `program_bitstream_jtag.tcl`
  - `program_bitstream_jtag.ps1`
- Implementation flow 保持脚本化 fresh project：
  - 重建 AX7Z100 PCIe/XDMA + PL DDR3/MIG BD。
  - 复用真实 HLS IP 和 `slam_accel_ctrl`。
  - 执行 synthesis、implementation、post-implementation reports、DRC、route status、write bitstream。
- 继续保持当前架构：
  - Orin 100 MHz 为 PCIe refclk。
  - AX7Z100 板载 200 MHz 为 MIG system clock。
  - `slam_accel_ctrl` 是唯一 AXI-Lite 控制入口。
  - HLS `m_axi_gmem0..4` 走 MIG-backed PL DDR3。
  - PL DDR3 buffer layout 沿用 section 19。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\validate_board_profile.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1
```

JTAG 下载脚本已准备，当前未执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

### 验证结果
- Board profile static validation：PASS，marker 为 `BOARD_PROFILE_PASS`。
- BD validate：PASS，marker 为 `BD_VALIDATE_PASS`。
- Project synthesis：PASS，marker 为 `PROJECT_SYNTH_PASS`。
- Implementation + bitstream：PASS，marker 为 `IMPLEMENTATION_BITSTREAM_PASS`。
- Run status：
  - `SYNTH_1_STATUS=synth_design Complete!`
  - `IMPL_1_STATUS=write_bitstream Complete!`
- Bitstream：
  - `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`
  - size：7,738,631 bytes
- Bitgen log：`0 Errors`、`0 Critical Warnings`。
- Route status：121,040 / 121,040 routable nets fully routed，routing errors 为 0。

### Post-Implementation 资源与时序
- Slice LUTs：55,295 / 277,400（19.93%）
- Slice Registers：61,162 / 554,800（11.02%）
- Block RAM Tile：52.5 / 755（6.95%）
- DSPs：256 / 2,020（12.67%）
- Bonded IOB：74 / 362（20.44%）
- BUFGCTRL：10 / 32（31.25%）
- MMCME2_ADV：3 / 8（37.50%）
- WNS：0.085 ns
- TNS：0.000 ns
- setup failing endpoints：0
- WHS：0.032 ns
- THS：0.000 ns
- hold failing endpoints：0
- Timing summary：All user specified timing constraints are met.

### DRC 摘要
- Post-bitgen DRC：`0 Errors`、513 Warnings、312 Advisories。
- 主要 warning/advisory 类别：
  - HLS DSP pipeline 相关：`DPIP`、`DPOP`、`AVAL`
  - clock placer / clock output buffering：`PLCK-23`、`REQP-1709`
  - RAMB async control：`REQP-1839`、`REQP-1840`
  - no routable loads：`RTSTAT-10`
  - PS7 required warning：`ZPS7-1`
- 这些 warning 没有阻塞 bitstream，但上板后必须先做最小 smoke，不能直接声明 SLAM 功能通过。

### 归档报告

```text
reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/
  commands.md
  summary.md
  vivado_impl_bitstream_log.txt
  vivado_impl_bitstream_jou.txt
  vivado_impl_synth_runme_log.txt
  vivado_impl_runme_log.txt
  ax7z100_pcie_mig_impl_utilization.txt
  ax7z100_pcie_mig_impl_timing_summary.txt
  ax7z100_pcie_mig_impl_drc.txt
  ax7z100_pcie_mig_impl_route_status.txt
  ax7z100_pcie_mig_bitstream_path.txt
```

### 下一步
- 用户连接 AX7Z100 JTAG 后，用 Windows Vivado/JTAG 下载 bitstream。
- Orin 侧确认 XDMA device nodes：
  - `/dev/xdma0_user`
  - `/dev/xdma0_h2c_0`
  - `/dev/xdma0_c2h_0`
- 第一批真机 gate：
  - `VERSION` read
  - AXI-Lite register write/read
  - PL DDR3 4 KB pattern H2C/C2H write/read
  - tiny synthetic host image write/read
- `--start-zero` 仍只作为可选 smoke；完整在线 SLAM 和大帧 golden 上板留到后续阶段。

---

## 21. 2026-06-17 Vivado 2018.3 JTAG 下载脚本兼容性修正

### 当前阶段状态
- 用户首次运行 JTAG 下载脚本失败，失败点为 Vivado Tcl 命令 `open_hw_manager` 不存在。
- 该失败发生在连接 hardware server 前，不代表 bitstream、JTAG cable 或开发板本身失败。
- 当前仍使用已生成 bitstream：`fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`。
- 已改用 `hw_server` + `xsdb` 并完成一次 JTAG 临时下载，marker 为 `JTAG_PROGRAM_PASS`。

### 本次变更摘要
- 本机 Vivado 2018.3 batch 环境不暴露 `open_hw_manager` / `open_hw` / `program_hw_devices`，但存在 `hw_server` 和 `xsdb`。
- `program_bitstream_jtag.ps1` 改为启动/复用 `hw_server`，再调用 `xsdb` 执行 JTAG FPGA programming。
- `program_bitstream_jtag.tcl` 改为 XSDB Tcl：`connect`、`targets`、`fpga -file`。
- 新增无 JTAG device 时的明确输出：检查 AX7Z100 上电、USB-JTAG 线/驱动、Vivado hw_server 和 target visibility。
- 不重新跑 synthesis、implementation 或 bitstream。
- 再次强调：JTAG 下载是临时配置，不会固化到 Flash，断电后会丢失。

### 验证命令

```powershell
powershell -NoProfile -Command "`$null = [scriptblock]::Create((Get-Content -Raw .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1)); 'POWERSHELL_PARSE_PASS'"

xsdb -help

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

### 预期结果
- 实测成功，marker 为 `JTAG_PROGRAM_PASS`。
- `FPGA_STATE=FPGA is configured`。
- `CONFIG STATUS` 中 CRC/IDCODE/SECURITY/BAD PACKET error 均为 0，`DONE PIN` 为 1。
- 如果失败在 XSDB `connect`，优先检查 `hw_server`、USB-JTAG 驱动、板卡供电和 JTAG 线。
- 如果失败在 `targets` / `fpga -file`，用 Vivado Hardware Manager GUI 手动确认是否能看到 AX7Z100 JTAG target。

### 下一步
- JTAG 下载成功后，重启或重新枚举 Orin PCIe。
- Orin 侧检查 XDMA nodes 后运行 `xdma_smoke.py --reg-smoke --ddr-smoke`。
- 固化到 QSPI/SD/BOOT.bin 留到 JTAG smoke 通过后再规划。

---

## 22. 2026-06-17 Orin 侧 PCIe/XDMA 枚举排查记录

### 当前现象
- Windows 侧 JTAG 临时下载已成功：
  - `JTAG_PROGRAM_PASS`
  - `FPGA_STATE=FPGA is configured`
  - `DONE PIN = 1`
- Orin 侧用户反馈：`lspci` 未发现 Xilinx 设备。
- 这说明当前问题已经从 bitstream/JTAG 下载阶段转移到 Orin PCIe enumeration / link bring-up / XDMA driver 阶段。
- 注意：JTAG 下载不会固化，AX7Z100 断电后配置会丢失；Orin 枚举 PCIe 时 FPGA 必须已经配置好并保持供电。

### Orin 侧优先排查命令

不要只按 `Xilinx` 字符串搜索，当前 XDMA device ID 可能只显示为 `10ee:7024`：

```bash
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
```

如果没有发现 endpoint，保持 AX7Z100 不断电，尝试 PCIe rescan：

```bash
sudo sh -c 'echo 1 > /sys/bus/pci/rescan'
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
```

如果 rescan 后仍没有，保持 AX7Z100 供电和 JTAG 配置，重启 Orin：

```bash
sudo reboot
```

重启后收集：

```bash
lspci -nn
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee'
```

如果能看到 `10ee:7024` 但没有 `/dev/xdma0_*`，继续检查 XDMA driver：

```bash
lsmod | grep -i xdma
ls -l /dev/xdma*
dmesg | grep -Ei 'xdma|10ee|7024'
```

### 当前怀疑原因排序
- Orin 已经启动并完成 PCIe 枚举后，才通过 JTAG 下载 FPGA；root-complex 没有重新发现 endpoint。
- AX7Z100 曾断电或复位，导致 JTAG 临时配置丢失。
- Orin 提供给 AX7Z100 的 PCIe 100 MHz reference clock 未到达或不稳定。
- PCIe reset / PERST# 未正确释放到 AX7Z100 `AB22`。
- PCIe 线缆、转接板、lane 方向或供电时序不正确。
- Orin 对应 PCIe root port 未启用，或 device tree / kernel 配置与该端口不匹配。
- XDMA driver 未加载；该问题只会导致 `/dev/xdma0_*` 缺失，理论上不应导致 `lspci -nn` 看不到 `10ee:7024`。

### 下一步
- 用户在 Orin 侧执行上述 `lspci`、rescan、reboot 和 `dmesg` 命令，并回传输出。
- 若 `lspci` 仍完全没有 `10ee:7024`，下一阶段定位 PCIe refclk、PERST#、lane wiring 和 Orin root-port enable。
- 若 `lspci` 出现 `10ee:7024` 但无 `/dev/xdma0_*`，下一阶段定位 XDMA Linux driver 编译/加载/device node。

---

## 23. 2026-06-17 PCIe Reset/约束复核与最小修正版 Bitstream

### 当前阶段状态
- 已复核当前 AX7Z100 XDC，未发现“PCIe reset 接到开发板物理按键”的错误。
- 当前物理约束仍保持：
  - `pcie_rst_n = AB22`
  - `pcie_ref_clk_p/n = N8/N7`
  - `sys_clk_p/n = F9/E8`
- 上述 PCIe reset/refclk 约束与 ALINX `33_PCIe_test` 参考工程一致。
- 已发现并修正 BD 级 reset 拓扑差异：原先 `pcie_rst_n` 同时驱动 XDMA `sys_rst_n` 和 MIG `sys_rst`，现在改为 `pcie_rst_n` 只驱动 XDMA `sys_rst_n`。
- MIG `sys_rst` 改由 `mig_rst_hi` 固定到 inactive high，匹配当前 MIG `SysResetPolarity=ACTIVE LOW` 配置。
- 已重新生成 bitstream，并通过 Windows JTAG 临时下载。

### 本次变更摘要
- 修改 `fpga/vivado/slam_accel_ax7z100_pcie_mig/create_bd.tcl`：
  - 新增 `mig_rst_hi` 1-bit constant，值为 `1`。
  - 保持 `pcie_rst_n -> xdma_0/sys_rst_n`。
  - 移除 `pcie_rst_n -> mig_7series_0/sys_rst`。
  - 新增 `mig_rst_hi/dout -> mig_7series_0/sys_rst`。
- 更新 `fpga/vivado/slam_accel_ax7z100_pcie_mig/README.md`，补充 reset topology。
- 更新 `reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/`：
  - `commands.md`
  - `summary.md`
  - `reset_topology_review.md`
  - Vivado/JTAG logs 和 post-implementation reports。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

### 验证结果
- BD validate：PASS，marker 为 `BD_VALIDATE_PASS`。
- Project synthesis：PASS，marker 为 `PROJECT_SYNTH_PASS`。
- Implementation + bitstream：PASS，marker 为 `IMPLEMENTATION_BITSTREAM_PASS`。
- JTAG 临时下载：PASS，marker 为 `JTAG_PROGRAM_PASS`。
- JTAG 状态：
  - `FPGA_STATE=FPGA is configured`
  - `DONE PIN = 1`
  - CRC/IDCODE/SECURITY/BAD PACKET error 均为 0。
- 新 bitstream：
  - `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`
  - size：7,638,099 bytes。

### 资源、时序与风险
- Post-implementation 资源：
  - Slice LUTs：55,269 / 277,400，19.92%
  - Slice Registers：61,162 / 554,800，11.02%
  - Block RAM Tile：52.5 / 755，6.95%
  - DSPs：256 / 2,020，12.67%
  - Bonded IOB：74 / 362，20.44%
- Post-implementation timing：
  - WNS：-0.234 ns
  - TNS：-3.143 ns
  - setup failing endpoints：193
  - WHS：0.038 ns
  - THS：0.000 ns
  - hold failing endpoints：0
- 结论：该 bitstream 可用于 PCIe reset/enumeration 实验，但 timing 未收敛，不能作为可靠功能验证 bitstream。
- Bitstream flow 有 1 个 critical warning，来源为 `Timing 38-282` timing failure。

### Orin 侧下一步排查
在 AX7Z100 保持上电且 JTAG 配置不丢失的前提下，Orin 侧重新枚举：

```bash
sudo reboot
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee'
```

如果仍看不到 `10ee:7024`，下一步优先定位：
- Orin PCIe root port 是否启用，device tree/kernel 是否匹配当前插槽。
- Orin/root-complex 100 MHz PCIe reference clock 是否到达 AX7Z100 `N8/N7`。
- PERST# 是否到达 AX7Z100 `AB22`，并在枚举阶段被释放为高电平。
- PCIe lane wiring、方向、转接和 X4 lane 是否匹配。
- JTAG 下载后 AX7Z100 是否曾断电或复位，导致临时 bitstream 丢失。

如果能看到 `10ee:7024` 但没有 `/dev/xdma0_*`，下一步转向 XDMA Linux driver 编译、加载和 device node 创建。

---

## 24. 2026-06-19 AX7Z100 PCIe Lane Reversal Bring-Up

### 当前阶段状态
- Orin 侧仍无法枚举 `10ee:7024`。
- 已新增并检查 `hardware/` 下的开发板原理图。
- 复核结论：
  - PCIe refclk 仍确认走 Bank112 `CLK0`，即当前 `N8/N7` 约束正确。
  - `PCIE_PERST` 仍对应 `AB22`，没有发现接到物理按键的证据。
  - PCIe x4 lane 在底板到核心板连接中呈反序迹象。
  - 当前/上一版 generated XDMA IP 中 `enable_lane_reversal=false`，这是当前最强枚举失败嫌疑。

### 本次变更摘要
- 修改 `fpga/vivado/slam_accel_ax7z100_pcie_mig/create_bd.tcl`：
  - 在 XDMA 4.1 配置中新增 `CONFIG.enable_lane_reversal {true}`。
  - 保持 Gen2 x4、`GTH_Quad_128`、`N8/N7` refclk、`AB22` PERST 不变。
  - 不改 HLS、MIG、host ABI 或 PL DDR3 地址布局。
- 更新 `fpga/vivado/slam_accel_ax7z100_pcie_mig/README.md`。
- 新增 `reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/lane_reversal_review.md`。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

### 验证结果
- BD validate：PASS，marker 为 `BD_VALIDATE_PASS`。
- Project synthesis：PASS，marker 为 `PROJECT_SYNTH_PASS`。
- Implementation + bitstream：PASS，marker 为 `IMPLEMENTATION_BITSTREAM_PASS`。
- JTAG 临时下载：PASS，marker 为 `JTAG_PROGRAM_PASS`。
- generated XDMA `.xci` 已确认：
  - `PARAM_VALUE.enable_lane_reversal = true`
- 新 bitstream：
  - `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`
  - size：7,638,099 bytes。
- JTAG 状态：
  - `FPGA_STATE=FPGA is configured`
  - `DONE PIN = 1`

### 资源、时序与风险
- Post-implementation 资源：
  - Slice LUTs：55,269 / 277,400，19.92%
  - Slice Registers：61,162 / 554,800，11.02%
  - Block RAM Tile：52.5 / 755，6.95%
  - DSPs：256 / 2,020，12.67%
  - Bonded IOB：74 / 362，20.44%
  - BUFGCTRL：10 / 32，31.25%
- Post-implementation timing：
  - WNS：-0.234 ns
  - TNS：-3.143 ns
  - setup failing endpoints：193
  - WHS：0.038 ns
  - THS：0.000 ns
  - hold failing endpoints：0
- 结论：该 lane-reversal bitstream 只用于 PCIe enumeration bring-up；timing 未收敛前，不作为可靠 accelerator 功能验证 bitstream。

### Orin 侧下一步
JTAG 下载 lane-reversal bitstream 后，AX7Z100 保持上电并重新启动 Orin：

```bash
sudo reboot
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee'
```

若出现 `10ee:7024`，进入 XDMA driver/device node 和 `xdma_smoke.py --reg-smoke --ddr-smoke`。

若仍无 `10ee:7024`，下一阶段改做最小 XDMA-only link diagnostic bitstream，并同时实测 Orin 100 MHz refclk、`AB22` PERST# 电平、lane/转接方向。

---

## 25. 2026-06-19 Vivado 多核心默认化与 Orin XDMA Driver Bring-Up

### 当前阶段状态
- Lane-reversal bitstream 已让 Orin 成功枚举 FPGA PCIe endpoint。
- Orin 侧实测：
  - `0005:01:00.0 Serial controller: Xilinx Corporation Device 7024`
- 结论：PCIe link/enumeration 已从失败推进到 PASS，当前问题转移到 Orin Linux XDMA driver/device node。
- 当前 `/dev/xdma*` 未出现，这是 driver 加载、绑定或 device node 创建阶段的问题；不再优先怀疑 FPGA pinout、lane reversal 或 PERST#。
- 当前 bitstream timing 仍未收敛，仍只作为 bring-up 实验镜像，不作为可靠 accelerator 功能验证镜像。

### 本次变更摘要
- 修改 board-level Vivado 脚本：
  - `run_project_synth.tcl`：新增 `jobs` Tcl 参数，默认 `18`，`launch_runs synth_1 -jobs $jobs`。
  - `run_project_impl_bitstream.tcl`：新增 `jobs` Tcl 参数，默认 `18`，`synth_1` 和 `impl_1 -to_step write_bitstream` 都使用 `$jobs`。
  - `run_vivado_project_synth.ps1`：新增 `-Jobs 18` 参数并传给 Tcl。
  - `run_vivado_impl_bitstream.ps1`：新增 `-Jobs 18` 参数并传给 Tcl。
- 更新 `reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/commands.md` 和 `summary.md`：
  - 记录后续综合/实现/bitstream 默认使用 `-Jobs 18`。
  - 记录 Orin 已枚举 `10ee:7024`。
  - 记录下一步为 XDMA driver bring-up。

### 后续 Vivado 命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

脚本默认值已是 `18`，命令中显式写出 `-Jobs 18` 是为了日志和操作可复核。若需要降低并行度，使用 `-Jobs N` 并在报告中记录原因。

### Orin 侧下一步
先确认 endpoint 和 BAR：

```bash
lspci -nn -s 0005:01:00.0 -vvv
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee|7024'
```

检查 XDMA driver：

```bash
lsmod | grep -i xdma
modinfo xdma 2>/dev/null || true
ls -l /dev/xdma*
dmesg | grep -Ei 'xdma|10ee|7024'
```

如果 `lsmod` 没有 `xdma`，下一步在 Orin 编译/安装 Xilinx XDMA Linux driver，优先参考旧 7Z015 `ch06_xdma_test` 已跑通流程。

如果 driver 已加载但没有节点，重点检查：
- `lspci -vvv` 中 BAR 是否分配成功。
- driver 是否匹配 vendor/device `10ee:7024`。
- `dmesg` 中是否存在 BAR、MSI/MSI-X、probe failed、IOMMU、permission 或 major/minor 创建设备节点失败信息。

### 验收标准
- Orin `lspci -nn` 稳定看到 `10ee:7024`。
- XDMA driver 加载后出现：
  - `/dev/xdma0_user`
  - `/dev/xdma0_h2c_0`
  - `/dev/xdma0_c2h_0`
- 之后运行：

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --reg-smoke --ddr-smoke
```

通过后再进入 tiny synthetic host image 写入和可选 `--start-zero`。

---

## 26. 2026-06-20 Orin 枚举成功但 XDMA Driver Probe 失败

### 当前阶段状态
- Orin 侧已经可以枚举 AX7Z100 PCIe endpoint：
  - `0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]`
- Orin 侧 `xdma.ko` 已加载，且 `modinfo xdma` alias 支持 `10ee:7024`。
- 当前仍没有 `/dev/xdma*`，`lspci -nnk` 中只有 `Kernel modules: xdma`，没有 `Kernel driver in use: xdma`。
- `/sys/bus/pci/devices/0005:01:00.0/enable = 0`，说明 xdma driver 没有成功绑定该 endpoint。
- PCIe link 当前实测为 `Gen2 x1`，endpoint 最大能力为 `Gen2 x4`。这是后续 lane/转接/物理链路性能问题，但不是 `/dev/xdma*` 不出现的第一阻塞点。

### 关键日志与诊断
Orin kernel log 中已经看到 xdma driver probe 被触发，但 probe 失败：

```text
xdma:xdma_device_open: xdma device 0005:01:00.0
xdma:map_single_bar: BAR0 ... length=65536
pcieport 0005:00:00.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer
pcieport 0005:00:00.0: [14] CmpltTO (First)
xdma:map_single_bar: BAR1 ... length=65536
xdma:map_bars: Failed to detect XDMA config BAR
xdma:probe_one: ... err -22.
xdma: probe of 0005:01:00.0 failed with error -22
```

结论：
- Orin PCIe root port、供电、PERST 基础链路已经不是当前第一阻塞点，因为 endpoint 已枚举。
- Orin XDMA 驱动缺失也不是当前第一阻塞点，因为 `xdma.ko` 已加载、ID 已匹配、probe 已触发。
- 当前第一阻塞点转到 FPGA/Vivado 侧：7Z100 当前 bitstream 没有向 Linux XDMA reference driver 暴露可识别、可访问的 XDMA config BAR，或 BAR 路由/访问在 probe 阶段产生 completion timeout。
- 7Z015 能直接出现 `/dev/xdma*`，大概率是因为它使用的是标准/参考 XDMA 工程，BAR 布局与 Xilinx Linux XDMA driver 兼容。

### Orin 侧保留检查步骤
每次更换 bitstream 或 Vivado XDMA 配置后，在 Orin 侧执行：

```bash
lspci -nnk -s 0005:01:00.0
lspci -vv -s 0005:01:00.0
lsmod | grep -i xdma
ls -l /dev/xdma*
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe'
```

通过标准：

```text
Kernel driver in use: xdma
/dev/xdma0_user 存在
/dev/xdma0_h2c_0 存在
/dev/xdma0_c2h_0 存在
dmesg 不再出现 Failed to detect XDMA config BAR
```

### Windows/Vivado 侧下一步
下一步需要回 Windows/Vivado FPGA 侧排查。第一步不要直接调完整 SLAM/HLS/MIG 工程，先建立最小 XDMA-only 7Z100 bitstream：

- 使用 AX7Z100 正确 part/package。
- XDMA 配置保持 Linux XDMA reference driver 兼容。
- 开启标准 H2C/C2H channel。
- 暴露一个 AXI-Lite user BAR，连接最小 version/scratch register。
- 暂时不接 HLS core。
- 暂时不接复杂 MIG/DDR datapath。
- 检查并避免 XDMA config BAR、AXI-Lite user BAR、MSI/MSI-X BAR 配置互相冲突。
- 对比旧 7Z015 `ch06_xdma_test` 或 AX7Z100/ALINX `33_PCIe_test` 的 XDMA IP 参数和 BAR 配置。

最小 XDMA-only bitstream 烧录后，先在 Orin 侧确认 `/dev/xdma*` 出现，再逐步加回：

1. `slam_accel_ctrl` AXI-Lite 寄存器。
2. `xdma_smoke.py --reg-smoke`。
3. PL DDR3/MIG。
4. `xdma_smoke.py --ddr-smoke`。
5. HLS observation core。
6. localization golden CSim/硬件输出对齐。
7. 在线 Orin runtime guarded enable。

### 本阶段验收标准
- Orin `lspci -nnk` 显示 `Kernel driver in use: xdma`。
- `/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 出现。
- `Failed to detect XDMA config BAR` 消失。
- 最小 AXI-Lite scratch register 可读写。
- 完成最小 XDMA-only 验证后，再回到 SLAM/HLS/MIG 集成。

---

## 27. 2026-06-20 XDMA Config BAR 最小诊断工程

### 当前阶段状态
- 已新增最小 XDMA-only 诊断工程：`fpga/vivado/xdma_config_bar_diag/`。
- 目标是隔离 Orin 侧 `xdma:map_bars: Failed to detect XDMA config BAR`，不再把 HLS、MIG、`slam_accel_ctrl` 和 DDR fabric 混入第一轮 driver probe 定位。
- 当前完整 `slam_accel_ax7z100_pcie_mig` 工程保持不破坏；诊断通过后再逐项加回 X4、128-bit AXI、MIG、`slam_accel_ctrl` 和 HLS IP。

### 变更摘要
- 新增 `diag_axi_lite_regs.v`：最小 AXI-Lite scratch/version register block，挂到 XDMA `M_AXI_LITE`。
- 新增 `create_bd.tcl`：只实例化 XDMA 4.1、AXI-Lite register block、AXI BRAM Controller 和 BRAM。
- 诊断 XDMA 配置向 7Z015 可用形态收敛：
  - `mode_selection=Basic`
  - `pf0_device_id=7024`
  - `axilite_master_en=true`
  - `enable_lane_reversal=true`
  - `pl_link_cap_max_link_width=X4`
  - `axi_data_width=64_bit`
  - 不设置手工 `pf0_msix_cap_table_bir/pba_bir` 覆盖，避免沿用完整工程里的 `BAR_1` override
- 新增 PowerShell/Tcl 入口：
  - `run_vivado_bd_validate.ps1`
  - `run_vivado_project_synth.ps1`
  - `run_vivado_impl_bitstream.ps1`
  - `program_bitstream_jtag.ps1`
- 新增报告目录：`reports/fpga/vivado/xdma_config_bar_diag/`。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_impl_bitstream.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\program_bitstream_jtag.ps1
```

默认 bitstream：

```text
fpga/vivado/.build/xdma_diag_impl/xdma_diag.runs/impl_1/xdma_diag_wrapper.bit
```

Orin 侧换 bitstream 后复测：

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
lspci -vvv -s 0005:01:00.0
lsmod | grep -i xdma
ls -l /dev/xdma*
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe'
```

### 当前验证结果
- 脚本/RTL/report 文档：已准备。
- BD validate：PASS；Vivado 2018.3 可创建 XDMA-only BD、生成 wrapper 和报告。
- synthesis：PASS，`run_vivado_project_synth.ps1 -Jobs 18` 完成，日志含 `XDMA_CONFIG_BAR_DIAG_PROJECT_SYNTH_PASS`。
- implementation/bitstream：PASS，`run_vivado_impl_bitstream.ps1 -Jobs 18` 完成，日志含 `XDMA_CONFIG_BAR_DIAG_IMPLEMENTATION_BITSTREAM_PASS`。
- 生成 bitstream：`fpga/vivado/.build/xdma_diag_impl/xdma_diag.runs/impl_1/xdma_diag_wrapper.bit`，大小 3,450,035 bytes。
- post-implementation timing：WNS 1.246 ns，TNS 0.000 ns，WHS 0.033 ns，setup/hold failing endpoints 均为 0。
- post-bitgen/DRC：0 errors，0 critical warnings；DRC 24 warnings，主要是 XDMA/BRAM 相关 warning，未阻塞诊断 bitstream。
- JTAG：PASS，`program_bitstream_jtag.ps1` 完成，`FPGA_STATE=FPGA is configured`，DONE PIN 为 1，`JTAG_PROGRAM_PASS`。
- Orin `/dev/xdma*` retest：待运行。

### 下一步
- 先生成并下载 `xdma_config_bar_diag` bitstream。
- 若 Orin 出现 `Kernel driver in use: xdma` 和 `/dev/xdma0_*`，说明当前完整工程的 XDMA BAR/config、X4/128-bit、MIG/HLS 接入之一触发 driver probe 不兼容；随后按“X4 -> 128-bit -> MIG -> slam_accel_ctrl/HLS”逐项恢复。
- 若最小诊断 bitstream 仍然报 `Failed to detect XDMA config BAR`，下一步直接复刻 ALINX `33_PCIe_test` 或旧 7Z015 `ch06_xdma_test` 的 XDMA IP 参数，逐字段对比 generated `.xci`。

---

## 28. 2026-06-20 X1 诊断 Bitstream 不枚举后的修正

### 当前阶段状态
- X1 XDMA-only 诊断 bitstream 已完成 Windows 侧 BD validate、synthesis、implementation/bitstream 和 JTAG 下载。
- Orin reboot 后 `lspci` 没有枚举出 FPGA endpoint，说明该结果不再是 XDMA Config BAR probe 阶段失败，而是 PCIe link/enumeration 没有建立。
- 结合第 24 节 lane reversal 结论，当前最可疑原因是 AX7Z100 lane 物理反序下，X1 只启用 FPGA lane0，但 Orin/root lane0 实际可能接到 FPGA lane3，导致 X1 link training 失败。
- 之前完整工程 `X4 + enable_lane_reversal=true` 已经能枚举 `10ee:7024`，因此诊断工程不再使用 X1 作为默认 bring-up 配置。

### 变更摘要
- 修改 `fpga/vivado/xdma_config_bar_diag/create_bd.tcl`：
  - `CONFIG.pl_link_cap_max_link_width` 从 `X1` 改为 `X4`。
  - 保持 `CONFIG.enable_lane_reversal {true}`。
  - 保持 `CONFIG.axi_data_width {64_bit}`。
  - `CONFIG.axisten_freq` 从 `125` 调整为 `250`，因为 Vivado XDMA 4.1 对 `X4 + 64-bit AXI` 组合要求 AXI target 频率为 250 MHz。
  - 保持不接 MIG、不接 HLS、不接 `slam_accel_ctrl`。
  - 保持不设置手工 MSI-X BAR indicator override。
- 更新 `xdma_config_bar_diag` README 和 reports，记录 X1 失败现象和 X4 诊断方向。

### 验证命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_impl_bitstream.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\program_bitstream_jtag.ps1
```

### 当前验证结果
- X4 诊断 BD validate：PASS；当前配置为 `Gen2 X4 + 64-bit AXI + 250 MHz AXI target + lane reversal`。
- X4 诊断 synthesis：PASS，`run_vivado_project_synth.ps1 -Jobs 18` 完成，日志含 `XDMA_CONFIG_BAR_DIAG_PROJECT_SYNTH_PASS`。
- X4 诊断 implementation/bitstream：PASS，`run_vivado_impl_bitstream.ps1 -Jobs 18` 完成，日志含 `XDMA_CONFIG_BAR_DIAG_IMPLEMENTATION_BITSTREAM_PASS`。
- X4 诊断 bitstream：`fpga/vivado/.build/xdma_diag_impl/xdma_diag.runs/impl_1/xdma_diag_wrapper.bit`，大小 3,187,655 bytes。
- X4 诊断 timing：WNS 0.290 ns，TNS 0.000 ns，WHS 0.030 ns，setup/hold failing endpoints 均为 0。
- X4 诊断 DRC/bitgen：0 errors，0 critical warnings；DRC 24 warnings，未阻塞诊断 bitstream。
- X4 诊断 JTAG：PASS，`program_bitstream_jtag.ps1` 完成，`FPGA_STATE=FPGA is configured`，DONE PIN 为 1，`JTAG_PROGRAM_PASS`。
- Orin 枚举复测：PASS，已看到 `0005:01:00.0 Serial controller: Xilinx Corporation Device 7024`，并已出现 `/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0`、`/dev/xdma0_control`、`/dev/xdma0_xvc` 和 `/dev/xdma0_events_*`。

### 下一步
- 重新生成并下载 X4 lane-reversal XDMA-only 诊断 bitstream。
- 若 Orin 重新枚举 `10ee:7024`，继续观察是否仍进入 `Failed to detect XDMA config BAR`。
- 若 Orin 出现 `/dev/xdma0_*`，说明 X4 诊断结构解决当前阻塞，再逐步恢复 128-bit AXI、MIG、`slam_accel_ctrl` 和 HLS。
- 若 X4 诊断仍不枚举，先回刷之前能枚举的完整 `azmig_wrapper.bit` 做 control 复测，再判断是否存在板卡上电、Orin root port、JTAG 配置时序或 PERST#/refclk 问题。

---

## 29. 2026-06-20 XDMA 诊断 PASS 后回到完整 azmig_wrapper.bit

### 当前结论
- X4 XDMA-only 诊断 bitstream 已经在 Orin 侧通过枚举和 driver bind。
- Orin 侧实测：
  - `0005:01:00.0 Serial controller: Xilinx Corporation Device 7024`
  - `/dev/xdma0_user`
  - `/dev/xdma0_control`
  - `/dev/xdma0_h2c_0`
  - `/dev/xdma0_c2h_0`
  - `/dev/xdma0_xvc`
  - `/dev/xdma0_events_*`
- 固化失败原因：前一版 X1 诊断 bitstream 在 AX7Z100 反序 x4 lane 布线下不适合作为 bring-up 默认配置；X1 只启用单 lane，可能没有接到 Orin/root complex 实际 lane0，因此 link training 失败。
- 正确 bring-up 基线是 `Gen2 X4 + enable_lane_reversal=true`。

### 本次变更
- 新增 Orin 侧 XDMA-only 诊断 smoke 工具：
  - `fpga/host/xdma_smoke/xdma_diag_smoke.py`
  - 读取 `/dev/xdma0_user + 0x0`，期望 `0x58444d41`
  - 读取 `/dev/xdma0_user + 0x4`，期望 `0x00010000`
  - 写读 scratch `0x8/0xc`
  - 通过 `/dev/xdma0_h2c_0` 和 `/dev/xdma0_c2h_0` 在 BRAM offset `0x0` 做 4KB pattern smoke
- 完整 `slam_accel_ax7z100_pcie_mig` 工程第一轮只修改 XDMA BAR 配置：
  - 保持 `X4 + enable_lane_reversal=true`
  - 保持 `128-bit AXI + 125 MHz`
  - 保持 MIG、HLS、`slam_accel_ctrl` 接法不变
  - 移除 `pf0_msix_cap_table_bir/pba_bir {BAR_1}` 手工覆盖
- HLS IP export 默认目录从异常 `%TEMP%` 路径改为 `fpga/vivado/.build/hls_unified_obs`，并通过临时短盘符传给 Vivado HLS，规避 Vivado 2018.3 Windows 深路径失败；生成物仍不纳入 git。

### Orin 诊断 smoke 命令
该命令只用于 XDMA-only 诊断 bitstream，不用于完整 `azmig_wrapper.bit`：

```bash
python3 fpga/host/xdma_smoke/xdma_diag_smoke.py --user-smoke --bram-smoke
```

### 完整 azmig 重新生成命令

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

### Windows 侧验证结果
- HLS IP export：PASS，`component.xml` 生成于 `fpga/vivado/.build/hls_unified_obs/solution1/impl/ip/component.xml`；Vivado HLS 首次因 `core_revision` 超出 Vivado 2018.3 IP packager 范围失败，脚本已按既有逻辑改写本地 `run_ippack.tcl` revision 为 `1` 后重新 pack 成功。
- BD validate：PASS，日志含 `BD_VALIDATE_PASS`。
- Project synthesis：PASS，`-Jobs 18`，日志含 `PROJECT_SYNTH_PASS` 和 `SYNTH_1_STATUS=synth_design Complete!`。
- Implementation + bitstream：PASS，`-Jobs 18`，日志含 `IMPL_1_STATUS=write_bitstream Complete!` 和 `IMPLEMENTATION_BITSTREAM_PASS`。
- 新完整 bitstream：
  - `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`
  - size：7,638,099 bytes
- JTAG 临时下载：PASS，日志含 `JTAG_PROGRAM_PASS`、`FPGA_STATE=FPGA is configured`、DONE PIN 为 1。
- Post-implementation timing 仍未收敛：
  - WNS：-0.234 ns
  - TNS：-3.143 ns
  - setup failing endpoints：193
  - WHS：0.038 ns
  - THS：0.000 ns
  - hold failing endpoints：0
- 结论：该镜像可用于 XDMA/full-design bring-up 验证，但 timing 未收敛前不作为可靠 accelerator 功能验证镜像。

### 下一步验收
完整 `azmig_wrapper.bit` JTAG 下载后，Orin 保持 AX7Z100 上电并 reboot，然后检查：

```bash
lspci -nn | grep -Ei '10ee|7024|xilinx'
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|BAR|probe|0005:01:00'
```

通过标准：
- `Kernel driver in use: xdma`
- `/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在
- 不再出现 `Failed to detect XDMA config BAR`

通过后再运行完整工程 smoke：

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --reg-smoke --ddr-smoke
```

如果完整 `azmig_wrapper.bit` 仍无法创建 `/dev/xdma0_*`，下一阶段按变量拆分：先保持 X4 lane reversal，逐项隔离 `128-bit AXI`、MIG、`slam_accel_ctrl`、HLS IP。

---

## 30. 2026-06-20 XDMA 诊断 PASS 但正式 azmig 无 `/dev/xdma*` 的分层恢复路线

### 当前结论
- `xdma_config_bar_diag` 已经在 Orin 侧 PASS，说明以下链路可工作：
  - Orin PCIe root complex
  - Xilinx XDMA Linux driver
  - device id `10ee:7024`
  - AX7Z100 `Gen2 X4 + enable_lane_reversal=true`
  - XDMA config BAR 基础访问路径
  - `/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 创建设备节点
- 正式 `azmig_wrapper.bit` 仍然表现为：
  - `lspci` 能看到 `0005:01:00.0 [10ee:7024]`
  - 没有 `/dev/xdma*`
  - xdma driver probe 失败，仍按 `Failed to detect XDMA config BAR + CmpltTO` 处理
- 因此当前问题不再归因于 Orin driver 安装、PCIe 线缆、lane reversal 或基础 XDMA config BAR，而应归因于正式 Vivado BD 内部差异。

### 已知差异
`xdma_config_bar_diag`：
- XDMA 4.1 Basic mode，`Gen2 X4 + enable_lane_reversal=true`
- `CONFIG.axi_data_width = 64_bit`
- `CONFIG.axisten_freq = 250`
- `M_AXI_LITE -> diag_axi_lite_regs`
- `M_AXI -> AXI BRAM Controller + BRAM`
- 不接 MIG、不接 HLS、不接 `slam_accel_ctrl`
- implementation timing clean，WNS 为正
- Orin `/dev/xdma0_*` PASS

正式 `azmig_wrapper.bit`：
- XDMA 4.1 Basic mode，`Gen2 X4 + enable_lane_reversal=true`
- `CONFIG.axi_data_width = 128_bit`
- `CONFIG.axisten_freq = 125`
- `M_AXI_LITE -> slam_accel_ctrl`
- `M_AXI -> AXI interconnect -> MIG`
- HLS `unified_surfel_observation_core` 也接入 AXI memory fabric
- implementation timing 未收敛，存在 `Timing 38-282`
- Orin `/dev/xdma0_*` FAIL

### 当前最高优先级怀疑点
1. `slam_accel_ctrl` / AXI-Lite wrapper / reset / timing 导致 user BAR 读访问 completion timeout。
2. 正式工程 timing 未收敛，影响 XDMA BAR 或 user BAR 响应。
3. `128-bit + 125 MHz` XDMA 配置与当前板级实现组合不稳定。
4. MIG/HLS/AXI interconnect 引入跨时钟、复位或 back-pressure 问题。
5. 正式工程 XDMA generated IP 属性未与诊断工程的 BAR/MSI 配置完全对齐。

注意：Linux XDMA driver probe 会扫描并访问 BAR；如果某个 BAR 后面的 AXI-Lite slave 不响应，也可能表现为 `Failed to detect XDMA config BAR + CmpltTO`，因此不能只检查 XDMA IP 静态参数。

### 本次仓库更新
- 正式 `azmig` Vivado flow 已补齐 XDMA property report：
  - `ax7z100_pcie_mig_xdma_bd_properties.rpt`
  - `ax7z100_pcie_mig_xdma_ip_properties.rpt`
- 三个入口脚本都会把上述报告复制到 `reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/`：
  - `run_vivado_bd_validate.ps1`
  - `run_vivado_project_synth.ps1`
  - `run_vivado_impl_bitstream.ps1`
- Windows 侧下一轮必须先对比正式工程和 `xdma_config_bar_diag` 的 XDMA property report，再继续改 BD。

### Windows 侧分层恢复路线
不要直接继续改完整 `azmig_wrapper.bit`。按下面顺序生成和验证分层 bitstream，每层都必须记录 bitstream 路径、XDMA property diff、timing、Orin `/dev/xdma*` gate 结果。

Step 0：冻结 golden board image
- 保留 `xdma_config_bar_diag` 作为唯一已证明 Orin `/dev/xdma*` PASS 的板级基准。
- 每次修改正式工程后，都与该工程的 XDMA property report 做 diff。

Step 1：`azmig_xdma64_diagregs_bram`
- 使用正式 azmig 工程框架。
- 保持诊断工程已验证组合：`64_bit + 250 MHz`。
- `M_AXI_LITE -> diag_axi_lite_regs`。
- `M_AXI -> AXI BRAM Controller + BRAM`。
- 不接 MIG、不接 HLS、不接 `slam_accel_ctrl`。
- 目标：确认从 diag 工程迁移到 azmig 工程框架后仍能创建 `/dev/xdma*`。

Step 2：`azmig_xdma64_ctrl_bram`
- 保持 `64_bit + 250 MHz`。
- `M_AXI_LITE` 从 `diag_axi_lite_regs` 换成 `slam_accel_ctrl`。
- `M_AXI` 仍接 BRAM。
- 不接 MIG、不接 HLS。
- 若该层失败，优先修 `slam_accel_ctrl`、AXI-Lite wrapper、reset 和 timing。

Step 3：`azmig_xdma128_ctrl_bram`
- 切到正式目标 `128_bit + 125 MHz`。
- `M_AXI_LITE -> slam_accel_ctrl`。
- `M_AXI -> BRAM`。
- 不接 MIG、不接 HLS。
- 若该层失败，优先定位 XDMA width/frequency 组合、时序和 BAR 响应。

Step 4：`azmig_xdma128_ctrl_mig`
- 保持 `128_bit + 125 MHz`。
- 加回 MIG 和 interconnect。
- 暂不接 HLS IP。
- 通过后运行 `xdma_smoke.py --reg-smoke --ddr-smoke`。

Step 5：完整 HLS 集成
- 加回 `unified_surfel_observation_core`。
- HLS 先保持 idle，只做 register smoke。
- 再写入 tiny synthetic image。
- 最后启动 HLS core。

### Orin 侧每层 gate
每个 bitstream JTAG 下载后，Orin 侧执行：

```bash
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma*
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
```

通过标准：
- `Kernel driver in use: xdma`
- `/dev/xdma0_user` 存在
- `/dev/xdma0_h2c_0` 存在
- `/dev/xdma0_c2h_0` 存在
- 不出现 `Failed to detect XDMA config BAR`
- 不出现新的 `CmpltTO`

快速换 bitstream 时可以先尝试：

```bash
sudo sh -c 'echo 1 > /sys/bus/pci/devices/0005:01:00.0/remove'
sudo sh -c 'echo 1 > /sys/bus/pci/rescan'
```

但凡修改 XDMA BAR、lane、width/frequency、MSI/MSI-X 或 PCIe 配置，可靠验收仍建议保持 FPGA 已配置后重启 Orin。

### 阶段性规则
- 在 `/dev/xdma*` 稳定出现前，不进入 HLS 功能验证和在线 SLAM 联调。
- timing 未收敛的 bitstream 只允许用于 bring-up，不允许作为 accelerator 功能正确性证明。
- 若某一层失败，不继续加下一层模块；先用 Orin journal 和 Windows timing/property diff 锁定该层新增变量。
---

## 31. 2026-06-20 XDMA Config BAR 分层恢复工程与教程参数对齐

### 最新结论
- Orin 侧最新日志表明：完整 `azmig_wrapper.bit` 能枚举 `0005:01:00.0 [10ee:7024]`，但 XDMA driver 没有 bind 成功，直接失败点是 `xdma:map_bars: Failed to detect XDMA config BAR`，并伴随 PCIe `CmpltTO`。
- 这不是单纯 `/dev/xdma0_*` 节点没创建，也不是 XDMA driver 没加载；driver 已加载且识别 `10ee:7024`，但 probe 访问 XDMA config BAR 超时。
- X4 XDMA-only 诊断 bitstream 已经让 Orin 出现 `/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0`，所以基础 PCIe、lane reversal、PERST#、device id、Orin XDMA driver 和最小 config BAR 路径成立。
- 当前嫌疑从 pinout/reset 转为完整设计新增变量：`slam_accel_ctrl`、`128_bit + 125 MHz` XDMA AXI、MIG/interconnect、HLS 接入或 timing。

### 术语固定
- `128-bit AXI` 指 XDMA FPGA 内部 `M_AXI` 数据总线宽度，不是 PCIe lane 数。
- `125 MHz` 指 XDMA 用户侧 AXI target clock，不是 Orin 提供的 100 MHz PCIe refclk。
- `MIG` 是 Xilinx PL DDR3 memory controller。
- `HLS` 是 `unified_surfel_observation_core` 生成的 accelerator IP。
- `AXI interconnect` 是 XDMA、MIG、HLS、控制器之间的内部 AXI fabric。

### 教程参数复核结论
- `course/ALINX_ZYNQ(AX7Z100)vivado2023开发平台-pl-ddr教程.pdf` 和 PCIe/Vitis 教程可作为硬件参数参考，但 Vivado 2023 UI 步骤不直接照搬到 Vivado 2018.3。
- PL DDR3/MIG 参数继续固定为：
  - 200 MHz differential `SYS_CLK_P/N = F9/E8`
  - DDR3 `MT41K256M16XX-125`
  - physical DDR data width 32-bit
  - MIG AXI data width 256-bit
  - XDMA memory address offset `0x00000000`
- PCIe 当前仍固定 `Gen2 X4 + enable_lane_reversal=true`，不回退 X1，也不直接切 X8。

### 本次代码/脚本更新
- 新增 `fpga/vivado/xdma_restore_chain/` 分层恢复工程。
- 该工程使用一个参数化 BD 生成脚本，按 `-Stage A|B|C` 生成不同 bitstream：
  - Stage A：`X4 + lane reversal + 64_bit + 250 MHz + slam_accel_ctrl + BRAM`，不接 MIG/HLS。
  - Stage B：`X4 + lane reversal + 128_bit + 125 MHz + slam_accel_ctrl + BRAM`，不接 MIG/HLS。
  - Stage C：`X4 + lane reversal + 128_bit + 125 MHz + slam_accel_ctrl + MIG`，不接 HLS。
- 新增本地 `xdma_restore_slam_accel_ctrl_axi_lite_wrapper.v`，去掉原 wrapper 中固定的 `FREQ_HZ=125000000`。原因是 Stage A 使用 `64_bit + 250 MHz`，复用正式工程 wrapper 会导致 Vivado BD validate 报 `ctrl_0/S_AXI(125000000)` 与 `xdma_0/M_AXI_LITE(250000000)` 不匹配。
- 新增 PowerShell 入口：
  - `run_vivado_bd_validate.ps1 -Stage A|B|C`
  - `run_vivado_project_synth.ps1 -Stage A|B|C -Jobs 18`
  - `run_vivado_impl_bitstream.ps1 -Stage A|B|C -Jobs 18`
  - `program_bitstream_jtag.ps1 -Stage A|B|C`
- 报告目录固定为 `reports/fpga/vivado/xdma_restore_chain/stage_a|stage_b|stage_c/`。

### Windows 验证结果
- PowerShell 脚本 AST parse：PASS。
- `git diff --check`：PASS；当前 sandbox 用户触发 Git `safe.directory` 保护，检查通过一次性 `git -c safe.directory=... diff --check` 完成，未修改全局 Git 配置。
- Stage A BD validate：PASS，日志包含 `XDMA_RESTORE_STAGE_A_BD_VALIDATE_PASS`。
- Stage B BD validate：PASS，日志包含 `XDMA_RESTORE_STAGE_B_BD_VALIDATE_PASS`。
- Stage C BD validate：PASS，日志包含 `XDMA_RESTORE_STAGE_C_BD_VALIDATE_PASS`。
- Stage A project synthesis：PASS，日志包含 `XDMA_RESTORE_STAGE_A_PROJECT_SYNTH_PASS`。
- Stage A implementation + bitstream：PASS，日志包含 `XDMA_RESTORE_STAGE_A_IMPLEMENTATION_BITSTREAM_PASS`。
- Stage A bitstream：
  - `fpga/vivado/.build/xdma_restore_stage_a_impl/xdma_restore_stage_a.runs/impl_1/xdma_restore_stage_a_wrapper.bit`
  - size：3,494,870 bytes
- Stage A post-implementation timing：PASS，WNS 0.281 ns，WHS 0.045 ns。
- 本轮未自动 JTAG 下载 Stage A；下一步应先下载 Stage A bitstream，再让 Orin 做 `/dev/xdma0_*` gate。

Stage A JTAG 下载命令：

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage A
```

### Windows 执行顺序
先只跑 Stage A：

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_bd_validate.ps1 -Stage A
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_project_synth.ps1 -Stage A -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_impl_bitstream.ps1 -Stage A -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage A
```

Stage A 在 Orin 侧 PASS 后，再把 `-Stage A` 换成 `-Stage B`；Stage B PASS 后再进入 Stage C。不要跳过失败阶段继续往后加 MIG/HLS。

### Orin 每阶段 gate
每个 bitstream JTAG 下载后，Orin 侧 reboot 后执行：

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
lspci -vv -s 0005:01:00.0 | grep -Ei 'Region|LnkSta|LnkCap'
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
```

通过标准：
- `Kernel driver in use: xdma`
- `/dev/xdma0_user` 存在
- `/dev/xdma0_h2c_0` 存在
- `/dev/xdma0_c2h_0` 存在
- 不再出现 `Failed to detect XDMA config BAR`
- 不再出现新的 `CmpltTO`

### 下一步判断
- Stage A 失败：优先查 `slam_accel_ctrl` AXI-Lite wrapper、reset、timing 或 AXI-Lite BAR 响应。
- Stage B 失败：优先查 `128_bit + 125 MHz` XDMA 配置和 generated XDMA property diff；必要时第一版 bring-up 暂保留 `64_bit + 250 MHz`。
- Stage C 失败：优先查 MIG reset/clock/interconnect/address map，并按 ALINX 教程参数逐项对齐。
- Stage C PASS 后，才允许进入 Stage D：接回真实 HLS IP，恢复完整 `azmig_wrapper.bit`，再做 `xdma_smoke.py --reg-smoke --ddr-smoke` 和后续 tiny synthetic transaction。

---

## 32. 2026-06-20 XDMA BAR Identity Shim / Stage A2 修正

### 当前结论
- Orin 侧 Stage A 结果：`lspci` 能看到 `0005:01:00.0 [10ee:7024]`，但没有 `/dev/xdma0_*`。
- Stage A 已去掉 MIG、HLS、128-bit XDMA 和 125 MHz 变量；失败点仍在 XDMA driver probe/device-node 创建阶段。
- Windows 侧对比显示，Stage A 与已 PASS 的 `xdma_config_bar_diag` 在 XDMA IP 关键配置上保持一致：`Gen2 X4`、`enable_lane_reversal=true`、`64_bit`、`250 MHz`、`Basic`、`pf0_device_id=7024`。
- 当前最强嫌疑从 PCIe lane、reset、XDMA 静态参数转为 BAR0 后端内容：`xdma_config_bar_diag` 在 BAR0 offset `0x0000` 返回 `0x58444d41`，Stage A/完整 `azmig` 在 offset `0x0000` 直接返回 `slam_accel_ctrl.VERSION=0x00020002`。
- 工作假设：Orin 侧 Xilinx XDMA Linux driver 在创建 `/dev/xdma0_*` 前会探测 BAR0 内容；如果 BAR0 起始页不是 driver 可接受的 XDMA identity/config page，则会表现为 `Failed to detect XDMA config BAR`。

### 本次代码/脚本更新
- 新增 `fpga/vivado/xdma_restore_chain/xdma_restore_bar_shim_ctrl_wrapper.v`。
- 新增 Stage A2：`X4 + lane reversal + 64_bit + 250 MHz + XDMA BAR shim + slam_accel_ctrl@0x1000 + BRAM`，不接 MIG/HLS。
- `xdma_restore_chain` PowerShell/Tcl 入口已支持 `-Stage A2`，且默认 Stage 改为 `A2`。
- BAR0 布局固定为：
  - `0x0000`: shim magic `0x58444d41`
  - `0x0004`: shim version `0x00010000`
  - `0x0008/0x000c`: shim scratch registers
  - `0x1000`: `slam_accel_ctrl` register bank
  - `0x1000 + 0x000`: `slam_accel_ctrl.VERSION = 0x00020002`
- `fpga/host/xdma_smoke/xdma_smoke.py` 新增 `--shim-smoke` 和 `--ctrl-base`；Stage A2/后续 shim 版应使用 `--ctrl-base 0x1000`。
- 正式 `slam_accel_ax7z100_pcie_mig` BD 已预先切到同一个 BAR shim wrapper；但必须先等 Stage A2 在 Orin 侧 PASS 后，再重新生成正式 `azmig_wrapper.bit`。

### Windows 执行命令
```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_bd_validate.ps1 -Stage A2
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_project_synth.ps1 -Stage A2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_impl_bitstream.ps1 -Stage A2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage A2
```

### Orin 验收命令
```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
```

### 下一步判断
- Stage A2 PASS：再进入 Stage B2/正式 `azmig` 修正版，继续保持 BAR shim，逐项恢复 `128_bit + 125 MHz`、MIG、HLS。
- Stage A2 FAIL：不继续加 MIG/HLS；转向 Orin XDMA driver 源码中的 BAR probe 条件，重点核对 `map_bars` / `is_config_bar` 对 BAR identity、BAR index、BAR size 和 AXI-Lite completion 的具体要求。

### Windows 验证结果
- Stage A2 BD validate：PASS，日志包含 `XDMA_RESTORE_STAGE_A2_BD_VALIDATE_PASS`。
- Stage A2 project synthesis：PASS，日志包含 `XDMA_RESTORE_STAGE_A2_PROJECT_SYNTH_PASS`。
- Stage A2 implementation + bitstream：PASS，日志包含 `XDMA_RESTORE_STAGE_A2_IMPLEMENTATION_BITSTREAM_PASS`。
- Stage A2 bitstream 路径：
  `fpga/vivado/.build/xdma_restore_stage_a2_impl/xdma_restore_stage_a2.runs/impl_1/xdma_restore_stage_a2_wrapper.bit`
- bitstream size：3,582,735 bytes。
- post-implementation timing：PASS，WNS 0.269 ns，TNS 0.000 ns，WHS 0.045 ns，THS 0.000 ns。
- DRC：0 errors，0 critical warnings，25 warnings；warning 类型与之前 BRAM/XDMA 诊断路径一致，主要是 RAMB async-control、no routable loads 和 PL-only 设计的 PS7-required warning。

### Orin 验证结果
- Stage A2 Orin driver bind：PASS。
- `lspci -nnk -s 0005:01:00.0` 显示 `Kernel driver in use: xdma`。
- `/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在。
- kernel log 显示：
  - `xdma:map_bars: config bar 1, pos 1.`
  - `xdma:identify_bars: 2 BARs: config 1, user 0, bypass -1.`
  - `xdma:probe_one: 0005:01:00.0 xdma0 ... usr 16, ch 1,1.`
- 未观察到新的 `Failed to detect XDMA config BAR` 或 `CmpltTO`。
- Stage A2 smoke：PASS。

```text
SHIM_SMOKE_PASS
XDMA_SHIM_MAGIC=0x58444d41 XDMA_SHIM_VERSION=0x00010000
REG_SMOKE_PASS
VERSION=0x00020002
CTRL_BASE=0x00001000
KERNEL_SEL=4 MODE=1 SCAN_COUNT=1
```

结论：BAR identity/shim 修正已验证有效，`slam_accel_ctrl` 正确迁移到 BAR0 offset `0x1000`，基础 AXI-Lite 控制路径可用。下一步进入 Stage B2/正式 `azmig` 修正版，继续保持 BAR shim，逐项恢复 `128_bit + 125 MHz`、MIG、HLS。

---

## 33. 2026-06-20 Stage A2 PASS 后的 BAR Shim 分层恢复计划

### 当前结论
- Stage A2 Orin 侧已验收 PASS：`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在，`SHIM_SMOKE_PASS` 和 `REG_SMOKE_PASS` 通过。
- 这证明 BAR identity shim 是必要且有效的修正，`slam_accel_ctrl` 固定迁移到 BAR0 offset `0x1000` 后，XDMA driver probe 和基础 AXI-Lite register access 可用。
- 下一步不把 `azmig_wrapper.bit`、MIG、HLS 一次恢复为首个板上 gate；否则失败时会重新混入 `128_bit/125MHz`、MIG/interconnect、HLS 和 timing 多个变量。

### 本次代码/脚本更新
- `fpga/vivado/xdma_restore_chain/create_stage_bd.tcl` 新增 shim 版恢复阶段：
  - Stage B2：`X4 + lane reversal + 128_bit + 125 MHz + BAR shim + slam_accel_ctrl@0x1000 + BRAM`，不接 MIG/HLS。
  - Stage C2：`X4 + lane reversal + 128_bit + 125 MHz + BAR shim + slam_accel_ctrl@0x1000 + MIG`，不接 HLS。
- PowerShell 入口已支持 `-Stage B2` 和 `-Stage C2`：
  - `run_vivado_bd_validate.ps1`
  - `run_vivado_project_synth.ps1`
  - `run_vivado_impl_bitstream.ps1`
  - `program_bitstream_jtag.ps1`
- 旧 Stage A/B/C 保留为失败对照；A2/B2/C2 是后续主线。
- 正式 `slam_accel_ax7z100_pcie_mig` 继续保持 BAR shim，`slam_accel_ctrl` 仍在 BAR0 offset `0x1000`。

### Windows 下一步命令：Stage B2
```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_bd_validate.ps1 -Stage B2
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_project_synth.ps1 -Stage B2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_impl_bitstream.ps1 -Stage B2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage B2
```

### Orin Stage B2 验收
```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
```

### 后续判断
- Stage B2 PASS：进入 Stage C2，加入 MIG-backed PL DDR3，并额外运行 `xdma_smoke.py --ddr-smoke`。
- Stage B2 FAIL：不继续加 MIG/HLS；优先定位 `128_bit + 125 MHz` XDMA 配置、timing 和 generated XDMA property diff。
- Stage C2 PASS：再重新生成正式 `azmig_wrapper.bit`，该版本才加入真实 HLS IP。
- 正式 `azmig_wrapper.bit` PASS `/dev/xdma0_*`、shim smoke、reg smoke、DDR smoke 后，才进入 HLS tiny synthetic transaction。

---

## 34. 2026-06-20 Stage B2 Windows 生成结果

### 当前变更
- `xdma_restore_chain` 已补齐 Stage B2 / Stage C2 脚手架。
- Stage B2：`X4 + lane reversal + 128_bit + 125 MHz + BAR shim + slam_accel_ctrl@0x1000 + BRAM`，不接 MIG/HLS。
- Stage C2：`X4 + lane reversal + 128_bit + 125 MHz + BAR shim + slam_accel_ctrl@0x1000 + MIG`，不接 HLS。
- 正式 `slam_accel_ax7z100_pcie_mig` 继续保持同一个 BAR shim，`slam_accel_ctrl` 固定在 BAR0 offset `0x1000`。

### Windows 验证结果
- Stage B2 BD validate：PASS，日志包含 `XDMA_RESTORE_STAGE_B2_BD_VALIDATE_PASS`。
- Stage B2 project synthesis：PASS，日志包含 `XDMA_RESTORE_STAGE_B2_PROJECT_SYNTH_PASS`。
- Stage B2 implementation + bitstream：PASS，日志包含 `XDMA_RESTORE_STAGE_B2_IMPLEMENTATION_BITSTREAM_PASS`。
- bitstream 路径：
  `fpga/vivado/.build/xdma_restore_stage_b2_impl/xdma_restore_stage_b2.runs/impl_1/xdma_restore_stage_b2_wrapper.bit`
- bitstream size：3,632,963 bytes。
- post-implementation timing：PASS，WNS 0.844 ns，TNS 0.000 ns，WHS 0.029 ns，THS 0.000 ns。
- DRC：0 errors，0 critical warnings，24 warnings。warning 类型主要为 BRAM async-control、no-routable-load 诊断和 PL-only Zynq PS7-required warning。
- 本轮未自动执行 JTAG 下载；下一步由 Stage B2 板上 gate 验收。

### Stage B2 板上验收命令
Windows 侧 JTAG 下载：
```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage B2
```

Orin 侧：
```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
```

### 后续判断
- Stage B2 PASS：再生成并下载 Stage C2，加入 MIG-backed PL DDR3，并增加 `xdma_smoke.py --ddr-smoke`。
- Stage B2 FAIL：不继续加 MIG/HLS，优先查 `128_bit + 125 MHz` XDMA 配置、timing、BAR completion 和 generated XDMA property diff。
- Stage C2 PASS：再重新生成正式 `azmig_wrapper.bit`，该版本才恢复真实 HLS IP。
- 正式 `azmig_wrapper.bit` 通过 `/dev/xdma0_*`、shim smoke、reg smoke、DDR smoke 后，再进入 HLS tiny synthetic transaction。

---

## 35. 2026-06-20 Stage C2 Windows 生成与 JTAG 下载结果

### 当前变更
- Stage C2 已生成：`X4 + lane reversal + 128_bit + 125 MHz + BAR shim + slam_accel_ctrl@0x1000 + MIG-backed PL DDR3`。
- Stage C2 仍不接 HLS，不生成正式 `azmig_wrapper.bit`。
- BAR0 布局继续保持：`0x0000` shim identity/scratch，`0x1000` 为 `slam_accel_ctrl`。

### Windows 验证结果
- Stage C2 BD validate：PASS，日志包含 `XDMA_RESTORE_STAGE_C2_BD_VALIDATE_PASS`。
- Stage C2 project synthesis：PASS，日志包含 `XDMA_RESTORE_STAGE_C2_PROJECT_SYNTH_PASS`。
- Stage C2 implementation + bitstream：PASS，日志包含 `XDMA_RESTORE_STAGE_C2_IMPLEMENTATION_BITSTREAM_PASS`。
- Stage C2 JTAG download：PASS，日志包含 `JTAG_PROGRAM_PASS`，FPGA state 为 `FPGA is configured`。
- bitstream 路径：
  `fpga/vivado/.build/xdma_restore_stage_c2_impl/xdma_restore_stage_c2.runs/impl_1/xdma_restore_stage_c2_wrapper.bit`
- bitstream size：4,625,939 bytes。
- post-implementation timing：PASS，WNS 0.183 ns，TNS 0.000 ns，WHS 0.030 ns，THS 0.000 ns。
- DRC：0 errors，0 critical warnings，26 warnings。warning 类型主要为 MIG clock placer/clock buffering、BRAM async-control、no-routable-load 诊断和 PL-only Zynq PS7-required warning。

### Orin Stage C2 验收命令
```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

### 后续判断
- Stage C2 Orin PASS：再回到正式 `slam_accel_ax7z100_pcie_mig` / `azmig_wrapper.bit`，接回真实 HLS IP，并保留 BAR shim 与 `slam_accel_ctrl@0x1000`。
- Stage C2 无 `/dev/xdma0_*`：停止，不接 HLS，优先查 MIG/interconnect 是否影响 BAR completion 或 AXI-Lite probe。
- Stage C2 shim/reg PASS 但 DDR smoke FAIL：重点查 MIG init、MIG reset/clock、AXI address map、XDMA memory BAR 到 MIG 的 interconnect。

---

## 36. 2026-06-20 Stage C2 Orin 验收结果与正式 azmig 恢复入口

### Orin 验收结果
- Stage C2 PCIe enumeration：PASS，`0005:01:00.0 [10ee:7024]`。
- XDMA driver bind：PASS，`Kernel driver in use: xdma`。
- device nodes：PASS，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在。
- XDMA probe：PASS，kernel log 显示 `config bar 1, pos 1`、`2 BARs: config 1, user 0, bypass -1`、`probe_one ... usr 16, ch 1,1`。
- shim smoke：PASS，`SHIM_SMOKE_PASS`，`XDMA_SHIM_MAGIC=0x58444d41`，`XDMA_SHIM_VERSION=0x00010000`。
- register smoke：PASS，`REG_SMOKE_PASS`，`VERSION=0x00020002`，`CTRL_BASE=0x00001000`。
- DDR smoke：PASS，`scan_points`、`pose`、`map_header`、`active_blocks`、`obs_cells`、`output` 六个 PL DDR3 buffer base 的 4KB pattern write/read 全部通过。
- 未观察到新的 `Failed to detect XDMA config BAR` 或 `CmpltTO`。

### 风险记录
- 当前 PCIe 实际协商为 Gen2 x1。kernel log 显示 `5.0 GT/s PCIe x1`，同时提示 endpoint/root 组合具备 `5.0 GT/s PCIe x4` 能力。
- x1 链路不阻塞当前功能 bring-up，但会限制带宽；后续性能阶段需要单独排查 lane mapping、Orin root port 配置和物理转接链路。

### 下一步
- 从 C2 恢复到正式 `slam_accel_ax7z100_pcie_mig` / `azmig_wrapper.bit`。
- 正式 `azmig` 继续保持 C2 已验证路径：`X4 + lane reversal + 128_bit + 125 MHz + BAR shim + slam_accel_ctrl@0x1000 + MIG-backed PL DDR3`。
- 在此基础上接回真实 HLS IP `unified_surfel_observation_core`，HLS `m_axi_gmem0..4` 与 XDMA `M_AXI` 共同接入 MIG-backed PL DDR3 fabric。
- 正式 `azmig_wrapper.bit` 通过 `/dev/xdma0_*`、shim smoke、reg smoke、DDR smoke 后，再进入 HLS tiny synthetic host transaction。

---

## 37. 2026-06-20 正式 azmig/HLS 恢复版 Windows 生成与 JTAG 下载结果

### 当前变更
- C2 已验证路径已恢复到正式 `slam_accel_ax7z100_pcie_mig` / `azmig_wrapper.bit`。
- 正式 `azmig` 保持：`X4 + enable_lane_reversal=true + 128_bit + 125 MHz + BAR shim + slam_accel_ctrl@0x1000 + MIG-backed PL DDR3`。
- 已接回真实 HLS IP `unified_surfel_observation_core`。
- HLS `m_axi_gmem0..4` 与 XDMA `M_AXI` 共同接入 MIG-backed PL DDR3 fabric。
- BAR0 布局继续固定：
  - `0x0000`：XDMA shim identity/scratch。
  - `0x1000`：`slam_accel_ctrl` register bank。

### Windows 验证结果
- HLS IP export 检查：PASS，`%TEMP%\lightning_hls_unified_obs\solution1\impl\ip\component.xml` 已存在。
- board profile static validation：PASS，日志包含 `BOARD_PROFILE_PASS`。
- BD validate：PASS，日志包含 `BD_VALIDATE_PASS`。
- project synthesis：PASS，日志包含 `PROJECT_SYNTH_PASS`。
- implementation + bitstream：PASS，日志包含 `IMPLEMENTATION_BITSTREAM_PASS`。
- Windows JTAG download：PASS，日志包含 `JTAG_PROGRAM_PASS`，FPGA state 为 `FPGA is configured`。
- bitstream 路径：
  `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`
- bitstream size：7,792,811 bytes。
- post-implementation timing：PASS，WNS 0.108 ns，TNS 0.000 ns，WHS 0.018 ns，THS 0.000 ns。
- DRC/bitgen：0 errors，0 critical warnings。当前仍有 Vivado warning/advisory，主要为 HLS DSP pipeline、MIG/clock、RAMB async-control、no-routable-load 诊断和 PL-only Zynq PS7-required warning；这些不阻塞本阶段 Orin 功能 gate。
- resource summary：Slice LUTs 55,471 / 277,400 (20.00%)，Slice Registers 61,336 / 554,800 (11.06%)，Block RAM Tile 52.5 / 755 (6.95%)，DSPs 256 / 2,020 (12.67%)，Bonded IOB 74 / 362 (20.44%)，BUFGCTRL 10 / 32 (31.25%)。

### Orin 正式 azmig gate
JTAG 下载已完成后，Orin 侧执行：
```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta|Region'
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

### 验收与分支
- PASS 标准：`Kernel driver in use: xdma`，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 存在，无新的 `Failed to detect XDMA config BAR` / `CmpltTO`，并输出 `SHIM_SMOKE_PASS`、`REG_SMOKE_PASS`、`DDR_SMOKE_PASS`。
- 如果正式 `azmig` 无 `/dev/xdma0_*`：停止，不做 HLS transaction；优先对比 C2 与正式 `azmig` 的新增变量，即 HLS IP、6-SI `mem_axi_ic`、HLS direct/control wiring。
- 如果 shim/reg PASS 但 DDR smoke FAIL：优先查 HLS master 接入后是否影响 MIG fabric、地址映射或 AXI interconnect arbitration。
- 如果 DDR smoke PASS：进入下一阶段 “HLS tiny synthetic host transaction”，写入 synthetic host image，触发 `KERNEL_SEL=4`，验证一次 HLS accelerator transaction 完成。
- PCIe 当前 Gen2 x1 继续作为性能风险记录，不阻塞本阶段功能 gate。

---

## 38. 2026-06-20 正式 azmig/HLS 恢复版 Orin 验收结果

### Orin 验收结果
- 正式 `azmig_wrapper.bit` PCIe enumeration：PASS，`0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]`。
- XDMA driver bind：PASS，`Kernel driver in use: xdma`，`Kernel modules: xdma`。
- BAR 分配：PASS，BAR0 和 BAR1 均为 64KB，kernel log 显示 `config bar 1, user 0`。
- device nodes：PASS，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在。
- XDMA probe：PASS，kernel log 显示 `identify_bars: 2 BARs: config 1, user 0, bypass -1` 和 `probe_one ... usr 16, ch 1,1`。
- shim smoke：PASS，`SHIM_SMOKE_PASS`，`XDMA_SHIM_MAGIC=0x58444d41`，`XDMA_SHIM_VERSION=0x00010000`。
- register smoke：PASS，`REG_SMOKE_PASS`，`VERSION=0x00020002`，`CTRL_BASE=0x00001000`，`KERNEL_SEL=4 MODE=1 SCAN_COUNT=1`。
- DDR smoke：PASS，`scan_points`、`pose`、`map_header`、`active_blocks`、`obs_cells`、`output` 六个 PL DDR3 buffer base 的 4KB pattern write/read 全部通过。
- 未观察到新的 `Failed to detect XDMA config BAR` 或 `CmpltTO`。

### 风险记录
- 当前 PCIe 仍实际协商为 Gen2 x1，kernel log 显示 `4.000 Gb/s available PCIe bandwidth, limited by 5.0 GT/s PCIe x1 link`，并提示硬件能力为 Gen2 x4。
- x1 不阻塞当前 HLS 功能 bring-up；后续性能阶段需要单独排查 lane mapping、Orin root port 配置、转接板/线缆和端点训练状态。

### 下一步
- 进入 “HLS tiny synthetic host transaction”。
- 目标：复用已通过的 PL DDR3 buffer layout，写入 tiny synthetic host image，配置 `slam_accel_ctrl@0x1000`，触发 `KERNEL_SEL=4`，验证真实 HLS IP 一次 transaction 能完成。
- gate：先只要求 accelerator start/done、无 controller error、输出区域可读；通过后再做 `H/b/counts` tiny 数值比较。
- 仍不进入完整 online SLAM、大帧 golden 或性能优化。

---

## 39. 2026-06-20 HLS Tiny Synthetic Host Transaction 工具更新

### 当前变更
- `make_tiny_synthetic_host_image.py` 已扩展 manifest，新增完整 expected：`h_upper[21]`、`b[6]`、`valid/reject/miss`、`flags`、`residual_sum/residual_abs_sum/residual_max_abs`。
- `xdma_smoke.py` 新增 `--hls-tiny <manifest.json>`：
  - 通过 XDMA H2C 写入 tiny synthetic segments 到 PL DDR3。
  - 配置 `slam_accel_ctrl@0x1000`，清状态，触发 `KERNEL_SEL=4`。
  - 轮询 `STATUS.done`，检查 `STATUS.error=0`、`ERROR=0`、`RUN_COUNT` 增加。
  - 通过 C2H 从 `OUTPUT_BASE=0x30000000` 读取 320 bytes normal equation。
  - 按 ABI 解析并比对 `H_upper/b/counts/residual`，容差仍为 `abs <= 1e-4` 或 `rel <= 1e-3`。
- 新增报告：`reports/fpga/host/xdma_smoke/tiny_synthetic/commands.md`。

### Windows 静态验证结果
```powershell
python fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py --out-dir fpga\vivado\.build\host_synthetic_tiny --report-dir reports\fpga\host\xdma_smoke\tiny_synthetic
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

- tiny synthetic host image 生成：PASS，marker 为 `HOST_SYNTHETIC_IMAGE_PASS`。
- Python compile：PASS。
- `xdma_smoke.py --help`：PASS，已显示 `--hls-tiny` 和 `--hls-timeout-sec`。
- 生成 manifest 路径：`fpga/vivado/.build/host_synthetic_tiny/manifest.json`。
- 生成报告路径：`reports/fpga/host/xdma_smoke/tiny_synthetic/tiny_synthetic_host_image.md`。

### Orin 下一步 gate
```bash
python3 fpga/host/xdma_smoke/make_tiny_synthetic_host_image.py --out-dir fpga/vivado/.build/host_synthetic_tiny --report-dir reports/fpga/host/xdma_smoke/tiny_synthetic
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-tiny fpga/vivado/.build/host_synthetic_tiny/manifest.json --ctrl-base 0x1000
```

PASS marker：
```text
HOST_SYNTHETIC_IMAGE_PASS
HLS_TINY_START_PASS
HLS_TINY_DONE_PASS
HLS_TINY_NUMERIC_PASS
```

### 风险与后续
- PCIe Gen2 x1 暂不阻塞本 tiny transaction；修正放在 tiny transaction 和小帧 golden transaction 通过后、进入性能/大帧/在线 SLAM 前。
- 当前最终目标固定为 PCIe 2.0 Gen2 x4，不是 x8。x8 只有在确认 AX7Z100 板卡、转接链路和 Orin root port 实际 8-lane 支持后才另立新阶段。
- 如果 HLS tiny timeout：优先查 HLS AXI master 到 MIG 的 arbitration/address path。
- 如果 HLS tiny done 但数值失败：优先查 output field direct address、manifest ABI、DDR 写读顺序。

### Orin 验证结果
- XDMA 基础 gate：PASS，`0005:01:00.0 [10ee:7024]` 已枚举，`Kernel driver in use: xdma`。
- device nodes：PASS，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在。
- kernel log：PASS，`config bar 1, user 0`，未观察到新的 `Failed to detect XDMA config BAR`、`CmpltTO` 或 AER recovery failure。
- tiny synthetic host image：PASS，`HOST_SYNTHETIC_IMAGE_PASS`。
- shim/register smoke：PASS。

```text
SHIM_SMOKE_PASS
XDMA_SHIM_MAGIC=0x58444d41 XDMA_SHIM_VERSION=0x00010000
REG_SMOKE_PASS
VERSION=0x00020002
CTRL_BASE=0x00001000
KERNEL_SEL=4 MODE=1 SCAN_COUNT=1
```

- DDR smoke：PASS，`scan_points`、`pose`、`map_header`、`active_blocks`、`obs_cells`、`output` 六个 PL DDR3 buffer base 的 4KB pattern write/read 全部通过。
- HLS tiny transaction：PASS。

```text
HOST_IMAGE_WRITE_PASS
HLS_TINY_START_PASS
CTRL_BASE=0x00001000 SCAN_COUNT=1 RUN_COUNT_BEFORE=0
HLS_TINY_DONE_PASS
STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT_AFTER=1
HLS_TINY_NUMERIC_PASS
COUNTS=1/0/0 FLAGS=0x00000000
WORST_FIELD=b[2] MAX_ABS=2.98023e-09 MAX_REL=5.96046e-08
```

结论：正式 `azmig_wrapper.bit` 已完成第一笔真实 HLS IP host transaction。XDMA、BAR shim、`slam_accel_ctrl@0x1000`、PL DDR3 buffer layout、HLS `ap_start/ap_done`、HLS AXI master 到 MIG 路径，以及 tiny synthetic normal-equation 数值对齐均已通过。

---

## 40. 2026-06-20 Golden frame_000001 n64 Host Transaction 准备

### 当前变更
- 新增 `fpga/host/xdma_smoke/make_golden_host_image.py`。
- 输入固定为 `fpga/golden/localization/frame_000001`，第一版使用 `--max-points 64`，不直接跑 full frame。
- 输出固定为 `fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json`。
- 生成器把 golden ABI 拆到当前 PL DDR3 layout：`scan_points`、`pose`、`map_header`、`active_blocks`、`obs_cells`、`output_zero`。
- `MaxPoints=64` 时重新计算 expected normal equation，并在 manifest 写入完整 expected：`h_upper[21]`、`b[6]`、`valid/reject/miss`、`flags`、residual summary。
- `xdma_smoke.py` 新增通用 `--hls-manifest <manifest.json>`；`--hls-tiny` 保留为兼容入口。

### Windows 静态验证结果
```powershell
python fpga\host\xdma_smoke\make_golden_host_image.py --golden-dir fpga\golden\localization\frame_000001 --max-points 64 --out-dir fpga\vivado\.build\host_golden_frame_000001_n64 --report-dir reports\fpga\host\xdma_smoke\golden_frame_000001_n64
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_golden_host_image.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

- golden host image 生成：PASS，marker 为 `HOST_GOLDEN_IMAGE_PASS`。
- Python compile：PASS。
- `xdma_smoke.py --help`：PASS，已显示 `--hls-manifest` 和 `--hls-tiny`。
- full scan count：6963。
- n64 scan count：64。
- active blocks：3719。
- obs cells：952064。
- `scan_points.bin`：1024 bytes。
- `active_blocks.bin`：119008 bytes。
- `obs_cells.bin`：60932096 bytes。
- expected counts：`14/33/17`。
- expected residual sum：`0.87436966027431406`。
- 生成报告：`reports/fpga/host/xdma_smoke/golden_frame_000001_n64/golden_host_image.md`。

### Orin 下一步 gate
```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py --golden-dir fpga/golden/localization/frame_000001 --max-points 64 --out-dir fpga/vivado/.build/host_golden_frame_000001_n64 --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_n64
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json --ctrl-base 0x1000
```

PASS marker：
```text
HOST_GOLDEN_IMAGE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
```

### Orin 实测结果（2026-06-20）
- 测试对象：已通过 Stage 39 tiny synthetic 的正式 `azmig_wrapper.bit`。
- 预处理：本地缺少 `fpga/golden/localization/frame_000001/loc_scan.bin`，已从 `fpga/golden_src/localization/frame_000001` 重新生成 ABI golden；full golden counts 为 `6050/911/2`。
- XDMA gate：PASS，`0005:01:00.0 [10ee:7024]` 绑定 `xdma`，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在。
- Journal gate：PASS，仍为 `config bar 1, user 0`；未见新的 `Failed to detect XDMA config BAR`、`CmpltTO` 或 AER recovery failure。
- Host image：PASS，marker 为 `HOST_GOLDEN_IMAGE_PASS`。
- BAR shim/control register：PASS，marker 为 `SHIM_SMOKE_PASS`、`REG_SMOKE_PASS`；`VERSION=0x00020002`，`CTRL_BASE=0x00001000`。
- PL DDR3 buffer path：PASS，marker 为 `DDR_SMOKE_PASS`。
- HLS transaction 启动/完成：PASS，marker 为 `HLS_MANIFEST_START_PASS`、`HLS_MANIFEST_DONE_PASS`；`STATUS=0x00000204`，`ERROR=0x00000000`，`RUN_COUNT` 从 `1` 增加到 `2`。
- HLS numeric：FAIL，未出现 `HLS_MANIFEST_NUMERIC_PASS`。

失败差异：
```text
expected counts: 14/33/17, flags=0x00000000
actual counts:   64/0/0,   flags=0x00000000
expected residual_abs_sum: 1.3874737319668577
actual residual_abs_sum:   2.2681722148352881
expected residual_max_abs: 0.29527878422266252
actual residual_max_abs:   0.29527878422266252
```

当前结论：
- Stage 40 的 PCIe/XDMA/BAR shim/AXI-Lite/MIG/HLS start-done 路径已经通过。
- 当前阻塞点不是 `/dev/xdma*`、DDR 写读或 HLS timeout，而是 HLS real golden numeric contract。
- 优先回 Windows/HLS 侧检查 `MaxPoints=64` 下的 reject/miss 判定、active map/obs cell lookup ABI、map header 字段解释、output normal equation 写出顺序。
- 在 `HLS_MANIFEST_NUMERIC_PASS` 前，不进入 full `frame_000001` host transaction。

### 风险与后续
- 本阶段不重新生成 bitstream，不改 Vivado BD，不处理 PCIe Gen2 x1 性能风险。
- 如果 timeout：优先查更多点数下 HLS AXI master 到 MIG 的 arbitration/address path，并记录 `STATUS/ERROR/RUN_COUNT`。
- 如果 done 但 counts 不一致：优先查 `MaxPoints=64` scan slicing、active map 拆分、mode/header ABI。
- 如果 counts 一致但 `H/b` 失败：优先查 double endian、output field direct address、expected recompute 逻辑。
- 如果 n64 PASS：下一步跑 full `frame_000001` host transaction；full PASS 后再进入 PCIe Gen2 x4 链路修正和性能阶段。

## 41. 2026-06-20 HLS ABI / DDR Layout 数值不一致定位

### 当前结论
- Stage 40 已证明正式 `azmig_wrapper.bit` 的 PCIe/XDMA/BAR shim/AXI-Lite/MIG/DDR/HLS start-done 链路可用。
- Stage 40 阻塞点是 real golden n64 numeric：expected counts 为 `14/33/17`，actual counts 为 `64/0/0`。
- 该现象不优先解释为 PCIe Gen2 x1、XDMA driver、BAR shim、DDR smoke 或 HLS timeout；更像 HLS 对 active map / obs cell 的读取、lookup、stride 或 ABI 解释与 host expected 不一致。
- 当前 tiny synthetic 只覆盖 1 个 block、cell 0、1 个 valid cell，不足以暴露非零 `first_cell`、非零 cell index、miss/reject 路径问题。

### 本次 Windows 侧变更
- 新增 `fpga/host/xdma_smoke/make_multicell_synthetic_host_image.py`。
- 新 fixture 包含 3 个 scan points、2 个 active blocks、非零 `first_cell=256`、非零 cell index，并覆盖 1 个 valid、1 个 residual reject、1 个 miss。
- 预期 counts 固定为 `1/1/1`。
- `xdma_smoke.py` 增强失败日志：如果 `--hls-manifest` 数值比较失败，会先打印 `EXPECTED_*` 和 `ACTUAL_*` counts/residual summary，再抛错。

### Windows 静态验证结果
```powershell
python fpga\host\xdma_smoke\make_multicell_synthetic_host_image.py --out-dir fpga\vivado\.build\host_synthetic_multicell --report-dir reports\fpga\host\xdma_smoke\multicell_synthetic
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py fpga\host\xdma_smoke\make_multicell_synthetic_host_image.py fpga\host\xdma_smoke\make_golden_host_image.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

- multi-cell host image：PASS，marker 为 `HOST_MULTICELL_SYNTHETIC_IMAGE_PASS`。
- Python compile：PASS。
- `xdma_smoke.py --help`：PASS。
- 生成路径：`fpga/vivado/.build/host_synthetic_multicell/manifest.json`。
- 报告路径：`reports/fpga/host/xdma_smoke/multicell_synthetic/`。

### Orin 下一步 gate
不需要重新生成 bitstream，也不需要重新 JTAG 下载；继续使用当前 Stage 40 的正式 `azmig_wrapper.bit`：

```bash
python3 fpga/host/xdma_smoke/make_multicell_synthetic_host_image.py --out-dir fpga/vivado/.build/host_synthetic_multicell --report-dir reports/fpga/host/xdma_smoke/multicell_synthetic
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_synthetic_multicell/manifest.json --ctrl-base 0x1000
```

PASS marker：
```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
```

### Orin 实测结果（2026-06-20）
- 测试对象：继续使用 Stage 40 的正式 `azmig_wrapper.bit`，未重新 JTAG 下载。
- XDMA gate：PASS，`0005:01:00.0 [10ee:7024]` 绑定 `xdma`，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在。
- Journal gate：PASS，仍为 `config bar 1, user 0`；未见新的 `Failed to detect XDMA config BAR`、`CmpltTO` 或 AER recovery failure。
- Multi-cell host image：PASS，marker 为 `HOST_MULTICELL_SYNTHETIC_IMAGE_PASS`。
- BAR shim/control register：PASS，marker 为 `SHIM_SMOKE_PASS`、`REG_SMOKE_PASS`；`VERSION=0x00020002`，`CTRL_BASE=0x00001000`。
- PL DDR3 buffer path：PASS，marker 为 `DDR_SMOKE_PASS`。
- HLS transaction 启动/完成：PASS，marker 为 `HLS_MANIFEST_START_PASS`、`HLS_MANIFEST_DONE_PASS`；`STATUS=0x00000204`，`ERROR=0x00000000`，`RUN_COUNT` 从 `2` 增加到 `3`。
- HLS numeric：FAIL，未出现 `HLS_MANIFEST_NUMERIC_PASS`。

失败差异：
```text
expected counts: 1/1/1, flags=0x00000000
actual counts:   2/0/1, flags=0x00000000
expected residual_sum:     0.050000000000000044
actual residual_sum:       0.04999995231628418
expected residual_abs_sum: 0.050000000000000044
actual residual_abs_sum:   0.04999995231628418
expected residual_max_abs: 0.050000000000000044
actual residual_max_abs:   0.04999995231628418
```

当前结论：
- Stage 41 进一步确认 PCIe/XDMA/BAR shim/AXI-Lite/MIG/HLS start-done 路径正常。
- Miss path 在该 fixture 中看起来成立：`miss_count` 均为 `1`。
- 主要不一致集中在 residual reject path：HLS 把应 reject 的点计入 valid，导致 `valid_count=2`、`reject_count=0`。
- 下一步优先回 Windows/HLS 侧检查 residual outlier threshold、`abs(residual)` 比较、阈值常量来源、float/double 转换以及 reject 后是否仍累计 normal equation。
- 在 multi-cell `HLS_MANIFEST_NUMERIC_PASS` 前，不进入 Stage 40 n64 复测或 full `frame_000001`。

### 分支判断
- 如果 multi-cell PASS：active block/cell 基本 stride 在小规模下成立，下一步回到 Stage 40 n64，重点查 golden n64 的 neighbor lookup、expected recompute 或 HLS/CPU lookup 逻辑差异。
- 如果 multi-cell 在 `HLS_MANIFEST_DONE_PASS` 后 numeric FAIL：优先修改 HLS active map / obs cell ABI 读取方式，尤其复核 `DATA_PACK`、m_axi struct access width、32B/64B record stride，然后重新 HLS export 和 `azmig_wrapper.bit`。
- 如果 multi-cell timeout：优先查 HLS master 到 MIG 的 AXI arbitration/address path，但目前 Stage 40 已 done，该分支概率较低。

## 42. 2026-06-20 Residual Reject 单点探针

### 当前结论
- Stage 41 已把问题缩小到 residual reject：HLS start/done 正常，miss path 在 multi-cell fixture 中成立，但一个应 reject 的点被计入 valid。
- 本阶段不重新生成 bitstream，不修改 Vivado BD，不修改 HLS `DATA_PACK`；先用单点 probe 区分字段读取问题和 residual 阈值判断问题。

### 本次 Windows 侧变更
- 新增 `fpga/host/xdma_smoke/make_residual_probe_host_images.py`。
- 新增 5 个 manifest：
  - `valid_only`：期望 `1/0/0`。
  - `reject_z_only`：通过 `normal_z + plane_d` 构造 residual > 0.3，期望 `0/1/0`。
  - `reject_x_only`：通过 `normal_x + plane_d` 构造 residual > 0.3，期望 `0/1/0`。
  - `miss_only`：无有效 cell，期望 `0/0/1`。
  - `invalid_flag_only`：cell 坐标命中但 `flags=0`，期望 `0/0/1`。
- `xdma_smoke.py` 新增 `--dump-normal-equation`，可在 HLS output readback 后打印 `H_upper[21]` 与 `b[6]`。
- 更新 `fpga/host/xdma_smoke/README.md` 与 `reports/fpga/host/xdma_smoke/residual_probe/`。

### Windows 静态验证结果
```powershell
python fpga\host\xdma_smoke\make_residual_probe_host_images.py --out-dir fpga\vivado\.build\host_residual_probe --report-dir reports\fpga\host\xdma_smoke\residual_probe
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_residual_probe_host_images.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

- residual probe image：PASS，marker 为 `HOST_RESIDUAL_PROBE_IMAGES_PASS`。
- Python compile：PASS。
- `xdma_smoke.py --help`：PASS，已显示 `--dump-normal-equation`。
- 生成路径：`fpga/vivado/.build/host_residual_probe/`。
- 报告路径：`reports/fpga/host/xdma_smoke/residual_probe/`。

### Orin 下一步 gate
继续使用当前正式 `azmig_wrapper.bit`，不需要重新 JTAG 下载：

```bash
python3 fpga/host/xdma_smoke/make_residual_probe_host_images.py --out-dir fpga/vivado/.build/host_residual_probe --report-dir reports/fpga/host/xdma_smoke/residual_probe
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/valid_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_z_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_x_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/miss_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/invalid_flag_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
```

### Orin 实测结果（2026-06-20）
- 测试对象：继续使用 Stage 40/41 的正式 `azmig_wrapper.bit`，未重新 JTAG 下载。
- XDMA gate：PASS，`0005:01:00.0 [10ee:7024]` 绑定 `xdma`，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 均存在。
- Journal gate：PASS，仍为 `config bar 1, user 0`；未见新的 `Failed to detect XDMA config BAR`、`CmpltTO` 或 AER recovery failure。
- Residual probe image：PASS，marker 为 `HOST_RESIDUAL_PROBE_IMAGES_PASS`。
- BAR shim/control register：PASS，marker 为 `SHIM_SMOKE_PASS`、`REG_SMOKE_PASS`；`VERSION=0x00020002`，`CTRL_BASE=0x00001000`。
- PL DDR3 buffer path：PASS，marker 为 `DDR_SMOKE_PASS`。

单点 probe 结果：
```text
valid_only:        PASS, expected=1/0/0, actual=1/0/0, RUN_COUNT 3 -> 4
reject_z_only:     FAIL, expected=0/1/0, actual=1/0/0, RUN_COUNT 4 -> 5
reject_x_only:     FAIL, expected=0/1/0, actual=1/0/0, RUN_COUNT 5 -> 6
miss_only:         PASS, expected=0/0/1, actual=0/0/1, RUN_COUNT 6 -> 7
invalid_flag_only: PASS, expected=0/0/1, actual=0/0/1, RUN_COUNT 7 -> 8
```

关键 dump：
```text
valid_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,1,2.25,-1.25,0,5.0625,-2.8125,0,1.5625,0,0]
valid_only ACTUAL_B=[0,0,0.04999995231628418,0.1124998927116394,-0.062499940395355225,0]
reject_z_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
reject_z_only ACTUAL_B=[0,0,0,0,0,0]
reject_x_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
reject_x_only ACTUAL_B=[0,0,0,0,0,0]
miss_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
invalid_flag_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
```

当前结论：
- `valid_only` PASS，说明单点 valid 的 H/b 累计路径成立。
- `miss_only` 和 `invalid_flag_only` PASS，说明 active block miss path 与 `ObsCellFloat64.flags` 读取路径成立。
- `reject_z_only` 与 `reject_x_only` 表现一致，说明问题不优先指向 `normal_x/y/z` 字段顺序。
- 两个 reject probe 的 H/b 均为全零，说明 rejected point 没有被累计进 normal equation；但 counts 被写成 `valid=1,reject=0,miss=0`，因此当前首要怀疑是 HLS reject 分支的 counter/classification 写法：outlier path 跳过累计后错误增加 `valid_count`，或没有增加 `reject_count`。
- 下一步回 Windows/HLS 侧优先查 residual outlier 分支的计数更新顺序、`valid_count++` 放置位置、`reject_count++` 是否被综合条件屏蔽；暂不优先查 DDR layout、flags offset、miss path 或 normal 字段 packing。

### 分支判断
- 如果 `reject_z_only` / `reject_x_only` 变成 valid：优先查 residual threshold 或 `normal/plane_d` 字段解释。
- 如果 `invalid_flag_only` 变成 valid：优先查 `ObsCellFloat64.flags` packing/offset。
- 如果 x/z reject 表现不同：优先查 `normal_x/y/z` 字段顺序或 HLS packing。
- 如果五个 probes 全 PASS：回头复核 Stage 41 fixture 构造和 expected recompute。

## 43. 2026-06-20 HLS Reject Counter 写回修正

### 当前结论
- Stage 42 已确认 residual outlier 样本不会累计进 `H/b`，但计数输出为 `valid=1/reject=0/miss=0`。
- 这说明 residual reject 分支已经触发，主要风险在 HLS 对 `SlamNormalEquation` output 计数字段的循环内 read-modify-write 或 field direct port 写回。
- 本阶段保持 BAR shim、`slam_accel_ctrl@0x1000`、PL DDR3 layout、MIG、XDMA、HLS direct ports 不变，只修 HLS output counter 写回方式。

### 本次 Windows 侧变更
- 修改 `fpga/hls/unified_surfel_observation_core/unified_surfel_observation_core.cpp`：
  - `valid_count/reject_count/miss_count` 改为本地变量。
  - `residual_sum/residual_abs_sum/residual_max_abs` 改为本地变量。
  - point loop 内不再直接 `++output->...`。
  - loop 结束后统一写回 output 计数字段和 residual summary。
- 修改 `fpga/hls/unified_surfel_observation_core/obs_tb.cpp`：
  - 增加 single-point residual reject probe。
  - probe 期望 counts 为 `0/1/0`，且 `H/b/residual` 保持 0。
- 修改 `fpga/hls/unified_surfel_observation_core/run_vivado_hls_csynth.ps1`：
  - C Synthesis 默认工程目录从 `%TEMP%` 改为 `fpga/vivado/.build/hls_unified_obs_csynth`。
  - 复用 Vivado 短路径 helper，规避 Vivado HLS 2018.3 在 Windows 长路径/异常 `%TEMP%` 路径下无法创建工程的问题。
- 新增报告目录：`reports/fpga/hls/unified_surfel_observation_core/stage43_reject_counter_fix/`。

### Windows 验证计划
```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
```

### Windows 验证结果
- g++ CSim：PASS。Golden counts `6050/911/2`；新增 reject probe counts `0/1/0`。
- Vivado HLS CSim：PASS，`CSim done with 0 errors`；新增 reject probe counts `0/1/0`。
- Vivado HLS C Synthesis：PASS。Target clock `10.00 ns`，estimated clock `9.307 ns`；资源估算 `BRAM_18K=36`、`DSP48E=256`、`FF=26493`、`LUT=41601`。
- Vivado HLS IP export：PASS。Vivado HLS 2018.3 仍会生成溢出的 `core_revision`，脚本已自动把本地 `run_ippack.tcl` revision 改为 `1` 并重新 pack 成功。
- 新 HLS IP 路径：`fpga/vivado/.build/hls_unified_obs/solution1/impl/ip/component.xml`。

### Vivado 重新生成计划
HLS export PASS 后重新生成正式 `azmig_wrapper.bit`：

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\validate_board_profile.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

### Vivado 重新生成结果
- Board profile static validation：PASS。
- BD validate：PASS；正式 `azmig` 已引用新 HLS IP，HLS `m_axi_gmem0..4` 仍接入 MIG-backed PL DDR3 fabric，没有外露到顶层。
- Project synthesis：PASS，命令使用 `-Jobs 18`。
- Implementation / bitstream：PASS，命令使用 `-Jobs 18`。
- Post-implementation timing：PASS，`WNS=0.145 ns`、`TNS=0.000 ns`、`WHS=0.025 ns`、`THS=0.000 ns`，Vivado 报告 `All user specified timing constraints are met.`。
- DRC：bitstream run 结论为 `0 Errors, 0 Critical Warnings`；普通 warnings/advisories 主要来自 HLS DSP pipelining 和板级/IP advisories。
- 新 bitstream 路径：`fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`。
- Windows JTAG 下载：PASS，marker 为 `JTAG_PROGRAM_PASS`；FPGA 状态为 configured。

### Orin 后续验收
- JTAG 下载新 `azmig_wrapper.bit`。
- `--shim-smoke --reg-smoke --ctrl-base 0x1000` PASS。
- `--ddr-smoke` PASS。
- Stage 42 residual probes 全部 `HLS_MANIFEST_NUMERIC_PASS`。
- Stage 41 multi-cell counts 回到 `1/1/1`。
- Stage 40 n64 golden counts 回到 `14/33/17`，并输出 `HLS_MANIFEST_NUMERIC_PASS`。

### Orin 实测结果（2026-06-20）
- 初始状态：`lspci` 可见 `0005:01:00.0 [10ee:7024]`，`xdma` 显示已绑定，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 存在。
- 但 kernel log 中已有 `CmpltTO`、AER fatal、`xdma_device_offline`、`device recovery failed`；`/sys/bus/pci/devices/0005:01:00.0/enable=0`。
- 初始 `--shim-smoke --reg-smoke --ctrl-base 0x1000` 失败，BAR0 shim magic 读到 `0xffffffff`，说明当时 `/dev/xdma0_*` 是 stale node，BAR 已不可访问。
- 执行 PCIe remove/rescan 后，`xdma` 重新 probe，日志恢复到 `config bar 1, user 0`，`enable=1`，设备节点重新创建。
- Rescan 后 `SHIM_SMOKE_PASS`、`REG_SMOKE_PASS`、`DDR_SMOKE_PASS` 均通过。

Stage 42 residual probe 复测结果：
```text
valid_only:        FAIL, expected=1/0/0, actual=0/0/0, RUN_COUNT 0 -> 1
reject_z_only:     FAIL, expected=0/1/0, actual=1/0/0, RUN_COUNT 1 -> 2
reject_x_only:     FAIL, expected=0/1/0, actual=1/0/0, RUN_COUNT 2 -> 3
miss_only:         PASS, expected=0/0/1, actual=0/0/1, RUN_COUNT 3 -> 4
invalid_flag_only: PASS, expected=0/0/1, actual=0/0/1, RUN_COUNT 4 -> 5
```

关键 dump：
```text
valid_only ACTUAL_COUNTS=0/0/0
valid_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,1,2.25,-1.25,0,5.0625,-2.8125,0,1.5625,0,0]
valid_only ACTUAL_B=[0,0,0.04999995231628418,0.1124998927116394,-0.062499940395355225,0]
reject_z_only ACTUAL_COUNTS=1/0/0
reject_z_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
reject_x_only ACTUAL_COUNTS=1/0/0
reject_x_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
miss_only ACTUAL_COUNTS=0/0/1
invalid_flag_only ACTUAL_COUNTS=0/0/1
```

当前结论：
- Stage 43 Orin 验收未通过，停止在 Stage 42 residual probes；未继续执行 Stage 41 multi-cell 和 Stage 40 n64 golden。
- 新结果不是单纯 Stage 42 的旧失败：`valid_only` 已经出现 H/b 与 residual 正常累计但 `valid_count=0`，说明 output counter 写回仍异常。
- `reject_z_only/reject_x_only` 仍输出 `1/0/0`，说明 reject counter 修正没有在板上达到预期效果，或当前运行的 bitstream/HLS IP 不是 Windows CSim/CSynth 验证过的修正版。
- 下一步优先回 Windows/Vivado 侧核对正式 `azmig_wrapper.bit` 实际打包的 HLS IP 是否为 Stage 43 export 产物，并检查 `SlamNormalEquation` 中 `valid_count/reject_count/miss_count` direct-port/struct offset 写回在综合后是否被正确连接。

### Orin 重启后复测结果（2026-06-20 23:34）
- 重启后 XDMA 状态正常：`0005:01:00.0 [10ee:7024]` 绑定 `xdma`，`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0` 存在，`enable=1`。
- Kernel log 显示本轮启动已重新 probe 到 `config bar 1, user 0`；本次复测前后未见新的 `CmpltTO` 或 AER recovery failure。
- `SHIM_SMOKE_PASS`、`REG_SMOKE_PASS`、`DDR_SMOKE_PASS` 均通过。

重启后 Stage 42 residual probe 复测结果：
```text
valid_only:        FAIL, expected=1/0/0, actual=0/0/0, RUN_COUNT 0 -> 1
reject_z_only:     FAIL, expected=0/1/0, actual=1/0/0, RUN_COUNT 1 -> 2
reject_x_only:     FAIL, expected=0/1/0, actual=1/0/0, RUN_COUNT 2 -> 3
miss_only:         PASS, expected=0/0/1, actual=0/0/1, RUN_COUNT 3 -> 4
invalid_flag_only: PASS, expected=0/0/1, actual=0/0/1, RUN_COUNT 4 -> 5
```

重启后关键 dump：
```text
valid_only ACTUAL_COUNTS=0/0/0
valid_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,1,2.25,-1.25,0,5.0625,-2.8125,0,1.5625,0,0]
valid_only ACTUAL_B=[0,0,0.04999995231628418,0.1124998927116394,-0.062499940395355225,0]
reject_z_only ACTUAL_COUNTS=1/0/0
reject_x_only ACTUAL_COUNTS=1/0/0
miss_only ACTUAL_COUNTS=0/0/1
invalid_flag_only ACTUAL_COUNTS=0/0/1
```

重启后结论：
- 该结果排除了上一次 stale `/dev/xdma0_*` 对 Stage 43 验收的影响。
- Stage 43 仍失败在 output count fields：H/b 与 residual datapath 正常，`miss_count` 正常，但 `valid_count/reject_count` 写回仍不符合 expected。
- 按 failure branch，Stage 41 multi-cell 和 Stage 40 n64 golden 未执行。

## 44. 2026-06-21 HLS output_words 写回修复

### 路线复核结论
- 已回看 `src/` 路线：当前 FPGA 验证目标对应定位侧 `SurfelLocBackend::ComputeObservation` 与 golden replay。
- 建图侧 `LaserMapping` 的 FPGA observation/update 当前仍按 guarded fallback 到 CPU 处理，本阶段不扩大到建图更新、online SLAM、solve6x6 或 runtime 接入。
- Stage 43 失败继续定位在 HLS output counter 写回，不是 PCIe、XDMA、BAR shim、MIG、DDR 或 Orin driver 问题。

### 根因判断
- 旧 HLS IP 将 `SlamNormalEquation` output 拆成多个 direct field ports。
- `valid_count` offset `216` 与 `reject_count` offset `220` 位于同一个 64-bit AXI beat 内。
- Vivado HLS 2018.3 generated RTL 对 direct output offset 按 64-bit word 对齐后，板上无法可靠区分这两个 32-bit 字段，导致 Stage 43 中 `valid/reject` count 写回异常。

### 本次代码/接口变更
- HLS top output 从 per-field direct ports 改为单一 `uint64_t* output_words`。
- host 可见 ABI 不变：`SlamNormalEquation` 仍为 320B，`valid/reject/miss/flags` 仍在 offsets `216/220/224/228`。
- HLS 写回 word layout：
  - `0..20`: `H_upper[21]`
  - `21..26`: `b[6]`
  - `27`: low32=`valid_count`，high32=`reject_count`
  - `28`: low32=`miss_count`，high32=`flags`
  - `29..31`: residual summary
  - `32..39`: reserved/padding 清零
- 正式 BD 连接改为 `ctrl_0/unified_obs_output_addr -> unified_obs_0/output_words`。
- `slam_accel_ctrl` 旧 output field address 输出暂保留为兼容信号，但 Stage 44 正式 HLS IP/BD 不再连接这些端口。
- BAR shim、`slam_accel_ctrl@0x1000`、PL DDR3 layout、MIG、XDMA、lane reversal、host parser 均保持不变。

### Windows 验证命令与结果
```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

结果：
- g++ CSim PASS，包含 golden replay 与 residual reject 单点。
- Vivado HLS CSim PASS，`CSim done with 0 errors`。
- Vivado HLS C Synthesis PASS。
- HLS IP export PASS；repo-local IP 中存在 `output_words`，不存在旧 `output_valid_count/output_reject_count/output_miss_count` ports。
- board BD validate PASS。
- project synthesis PASS。
- implementation/bitstream PASS。
- 新 bitstream 路径：`fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`。
- bitstream size：`7237579` bytes。
- route status：0 routing errors。
- post-implementation timing：WNS `-0.132 ns`，WHS `0.045 ns`。该 bitstream 可用于功能验证，但仍不是最终 timing-clean 版本。
- DRC：0 errors；warnings/advisories 继续记录，包含已知 clock-route override 与 HLS DSP pipeline advisories。

### Orin 下一步验收
先 JTAG 下载新 bitstream：
```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

然后 Orin 侧执行：
```bash
sudo reboot
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/valid_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_z_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_x_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/miss_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/invalid_flag_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
```

验收标准：
- `SHIM_SMOKE_PASS`、`REG_SMOKE_PASS`、`DDR_SMOKE_PASS`。
- `valid_only` counts `1/0/0`。
- `reject_z_only` counts `0/1/0`。
- `reject_x_only` counts `0/1/0`。
- `miss_only` counts `0/0/1`。
- `invalid_flag_only` counts `0/0/1`。

通过后继续：
- Stage 41 multi-cell：counts 必须 `1/1/1`，输出 `HLS_MANIFEST_NUMERIC_PASS`。
- Stage 40 n64 golden：counts 必须回到 `14/33/17`，输出 `HLS_MANIFEST_NUMERIC_PASS`。

如果 residual probes 仍失败：
- 优先检查 Orin 侧是否确实下载了 Stage 44 新 bitstream。
- 再检查 host 读回的 word27/word28 原始 64-bit 值，确认 HLS output_words 是否按预期写到 `OUTPUT_BASE`。
- 暂不进入 full golden、online SLAM 或 PCIe x4 性能修正。

Stage 44 JTAG result 2026-06-21:

```text
JTAG_PROGRAM_PASS
FPGA_STATE=FPGA is configured
```

The programmed image is `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`. Next action is Orin reboot and the Stage 44 residual probe gate.

## 45. 2026-06-21 Golden 数据有效性复核与 n64 真实图定位

### 当前判断

- 暂不建议重录 `frame_000001`。现有 localization golden full frame metadata 为 `6963` scan points，full expected counts 为 `6050/911/2`，miss 只有 `2`，并且此前 Orin replay、Windows g++ CSim、Vivado HLS CSim full frame 均已 PASS。
- Stage 44 后，Stage 42 residual probes 全部 PASS，Stage 41 multi-cell PASS，说明 output 写回、基本 lookup、非零 block/cell、valid/reject/miss 分类的小规模路径已经通。
- 当前剩余失败集中在 real golden n64：expected `14/33/17`，actual `52/12/0`。该现象更像 n64 host image/readback、register 配置、真实 active map lookup/neighbor selection 或 HLS/CPU lookup 差异，不优先判定为录包坏。
- 当前仓库只有 localization golden：`fpga/golden/localization/frame_000001`。Mapping golden 尚未建立，建图 FPGA observation/update 当前仍不作为本阶段 board gate。

### 本次代码/工具变更

- `fpga/host/xdma_smoke/xdma_smoke.py` 新增 Stage 45 诊断开关：
  - `--verify-image-readback`：manifest 写入 PL DDR3 后逐段 C2H 读回并做 SHA-256/字节比对，覆盖大约 60 MB 的 `obs_cells.bin`。
  - `--read-regs-after-config`：HLS start 前回读 `SCAN_COUNT` 和全部 buffer base/control registers，要求看到 `SCAN_COUNT_READBACK=64`。
  - `--dump-output-raw-words`：读取 `OUTPUT_BASE` 后打印 40 个 64-bit raw words，用于确认 Stage 44 `output_words` 写回布局。
- 新增 `fpga/host/xdma_smoke/make_golden_trace_host_images.py`：
  - 读取 `fpga/golden/localization/frame_000001`。
  - 生成 n64 per-point trace：`n64_trace.csv`、`n64_trace.json`。
  - 自动挑选真实 valid/reject/miss 各 1 个 scan point，生成单点 manifest，仍使用完整真实 active map。
- 更新 `fpga/host/xdma_smoke/README.md`，加入 Stage 45 Orin 命令。

### Windows 本地验证结果

命令：

```powershell
python fpga\host\xdma_smoke\make_golden_trace_host_images.py --golden-dir fpga\golden\localization\frame_000001 --max-points 64 --out-dir fpga\vivado\.build\host_golden_trace_n64 --report-dir reports\fpga\host\xdma_smoke\golden_trace_n64
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_golden_host_image.py fpga\host\xdma_smoke\make_golden_trace_host_images.py fpga\host\xdma_smoke\xdma_smoke.py
```

结果：

```text
HOST_GOLDEN_TRACE_PASS
trace_counts=14/33/17
expected_counts=14/33/17
valid_manifest=fpga\vivado\.build\host_golden_trace_n64\real_valid_point\manifest.json
reject_manifest=fpga\vivado\.build\host_golden_trace_n64\real_reject_point\manifest.json
miss_manifest=fpga\vivado\.build\host_golden_trace_n64\real_miss_point\manifest.json
```

选出的真实单点：

| Case | Scan index | Expected | Reason |
| --- | ---: | ---: | --- |
| `real_valid_point` | 0 | `1/0/0` | inlier |
| `real_reject_point` | 1 | `0/1/0` | residual_outlier |
| `real_miss_point` | 19 | `0/0/1` | lookup_miss |

报告：`reports/fpga/host/xdma_smoke/golden_trace_n64/golden_trace.md`。

### Orin 下一步测试

先复测 n64，并启用 image/readback/register/raw dump：

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py \
  --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json \
  --ctrl-base 0x1000 \
  --verify-image-readback \
  --read-regs-after-config \
  --dump-output-raw-words \
  --dump-normal-equation
```

必须先确认：

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=64
```

然后生成 trace/单点 manifest：

```bash
python3 fpga/host/xdma_smoke/make_golden_trace_host_images.py \
  --golden-dir fpga/golden/localization/frame_000001 \
  --max-points 64 \
  --out-dir fpga/vivado/.build/host_golden_trace_n64 \
  --report-dir reports/fpga/host/xdma_smoke/golden_trace_n64
```

再分别跑真实单点：

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_valid_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_reject_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_miss_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
```

验收标准：

- n64 readback gate：`HOST_IMAGE_READBACK_PASS`。
- register gate：`SCAN_COUNT_READBACK=64`，各 buffer base 与 PL DDR layout 一致。
- real valid/reject/miss 单点全部输出 `HLS_MANIFEST_NUMERIC_PASS`。
- 若 real miss point 在板上变成 valid，下一阶段优先修 HLS real-map lookup/neighbor selection。
- 若单点全部 PASS 但 n64 仍 FAIL，下一阶段查多点连续运行时的 lookup 状态、AXI burst/address stride 或 HLS 循环内临时状态复用问题。

### Build-time 规则

- Stage 45 只改 host/diagnostic 工具，不重新综合、不重新 bitstream。
- Host/Python 变更只跑 `py_compile` 和 Orin host 测试。
- 只有确认需要修改 HLS/BD 后，才进入 HLS CSim/CSynth/IP export 与正式 implementation。
- 当前 full board bitstream 30-60 分钟属于可预期范围：fresh Vivado project + XDMA + MIG + HLS floating-point IP 很重；Vivado 2018.3 即使外层 `-Jobs 18`，route/timing/bitgen 的部分内部步骤仍可能只用少量 CPU。

### Orin 验收结果 2026-06-21 10:19 CST

XDMA/base gate 通过：

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/sys/bus/pci/devices/0005:01:00.0/enable = 1
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

当前 journal 窗口没有新的 `Failed to detect XDMA config BAR`、`CmpltTO` 或 AER recovery failure。

n64 diagnostic 结果：

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=64
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
STATUS=0x00000204
ERROR=0x00000000
EXPECTED_COUNTS=14/33/17
ACTUAL_COUNTS=52/12/0
```

关键 register readback：

```text
SCAN_ADDR_LO_READBACK=0x00000000
POSE_ADDR_LO_READBACK=0x01000000
MAP_HEADER_ADDR_LO_READBACK=0x01001000
ACTIVE_BLOCKS_ADDR_LO_READBACK=0x02000000
OBS_CELLS_ADDR_LO_READBACK=0x10000000
OUT_ADDR_LO_READBACK=0x30000000
SCAN_COUNT_READBACK=0x00000040
```

raw output words 中 count layout 与 Stage 44 ABI 一致：

```text
OUTPUT_WORD[27]=0x0000000c00000034  # valid=52, reject=12
OUTPUT_WORD[28]=0x0000000000000000  # miss=0, flags=0
```

trace generation 通过：

```text
HOST_GOLDEN_TRACE_PASS
trace_counts=14/33/17
expected_counts=14/33/17
```

真实单点结果：

| Case | Scan index | Expected | Actual | Result |
| --- | ---: | ---: | ---: | --- |
| `real_valid_point` | 0 | `1/0/0` | `1/0/0` | PASS |
| `real_reject_point` | 1 | `0/1/0` | `0/1/0` | PASS |
| `real_miss_point` | 19 | `0/0/1` | `1/0/0` | FAIL |

`real_miss_point` 失败摘要：

```text
center=(0,1,3)/23
reason=lookup_miss
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=1
OUTPUT_WORD[27]=0x0000000000000001
OUTPUT_WORD[28]=0x0000000000000000
ACTUAL_RESIDUAL_SUM=-0.028110894923855767
ACTUAL_RESIDUAL_ABS_SUM=0.028110894923855767
```

结论：
- Stage 45 排除了 n64 host image 写坏、PL DDR3 readback、register base 配置和 `SCAN_COUNT=64` 写错。
- 真实 valid/reject 单点均 PASS，说明真实 active map 的基本读路径、residual threshold 和 Stage 44 output count 写回仍正常。
- 真实 miss 单点在板上变成 valid，说明当前阻塞点是 HLS real-map lookup/neighbor selection 与 CPU expected 不一致。
- 暂不进入 full frame、online SLAM、mapping update、solve6x6、PCIe x4 性能修正或重新综合。

下一步建议：
- Windows/HLS 侧优先为 scan index `19` 增加 lookup trace，对比 CPU 与 HLS 的 center block/cell、26-neighbor 遍历顺序、cell index 解码、block valid 判断和 flags 判断。
- 复核 `lookup_nearby_type=26` 时 HLS 是否访问了 CPU expected 没有访问或应跳过的 neighbor/cell。
- 修复 lookup/neighbor selection 后，先 rerun `real_miss_point`，再 rerun n64 golden。

## 46. 2026-06-21 Lookup mismatch host-only 反推

### 目标

- 不重新综合、不重新 bitstream。
- 基于 Stage 45 的 `real_miss_point` 板上输出，反推 HLS 实际使用了哪个真实 map cell。
- 判断该 cell 是否属于 CPU 合法 26-neighbor lookup 集合，从而决定下一步是修 HLS lookup/address/packed AXI 读取，还是回查 CPU/Python trace。

### 代码/工具变更

- `fpga/host/xdma_smoke/xdma_smoke.py` 新增 `--save-output-json <path>`：
  - 保存 actual/expected normal equation。
  - 保存 raw output words。
  - 保存 register readback、status/error、run count、manifest path/source point index。
  - 即使 numeric compare 失败，也会先写 JSON。
- 新增 `fpga/host/xdma_smoke/analyze_lookup_mismatch.py`：
  - 输入 `frame_000001` golden、`point-index=19` 和 Orin 保存的 actual JSON。
  - 从 actual `b/residual` 反推 HLS jacobian/normal。
  - 扫描真实 `obs_cells`，输出最接近 HLS actual 的候选 cell offset/block/cell/normal/plane_d/residual。
  - 同时输出 CPU 合法 neighbor probes，用于判断 HLS 命中是否越界。
- 新增报告入口：`reports/fpga/host/xdma_smoke/lookup_mismatch_stage46/commands.md`。

### Orin 命令

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py \
  --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_miss_point/manifest.json \
  --ctrl-base 0x1000 \
  --verify-image-readback \
  --read-regs-after-config \
  --dump-output-raw-words \
  --dump-normal-equation \
  --save-output-json reports/fpga/host/xdma_smoke/golden_trace_n64/real_miss_point_output.json
```

预期仍会 numeric FAIL，但必须先看到：

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=1
HLS_OUTPUT_JSON=reports/fpga/host/xdma_smoke/golden_trace_n64/real_miss_point_output.json
```

### Windows / host-only analyzer

```powershell
python fpga\host\xdma_smoke\analyze_lookup_mismatch.py --golden-dir fpga\golden\localization\frame_000001 --point-index 19 --actual-json reports\fpga\host\xdma_smoke\golden_trace_n64\real_miss_point_output.json --report-dir reports\fpga\host\xdma_smoke\lookup_mismatch_stage46
python -m py_compile fpga\host\xdma_smoke\analyze_lookup_mismatch.py fpga\host\xdma_smoke\xdma_smoke.py
```

### 判断规则

- 若 best inferred HLS candidate 不在 CPU legal neighbor set：下一阶段修 HLS lookup/address/packed AXI 读取。
- 若 best inferred HLS candidate 在 CPU legal neighbor set：回查 CPU/Python expected 和 `SurfelLocBackend` trace。
- 若无法唯一反推：生成 Stage 46 debug bitstream，把 selected block/cell/offset/debug residual 写入 reserved output words `32..39`。

## 47. 2026-06-21 Python bounded golden 负坐标编码修正

### 根因修正

Stage 46 的两个 JSON 已复核：

```text
real_miss_point_output.json:
source_point_index=19
actual_counts=1/0/0
actual_residual=-0.028110894923855767
raw27=0x0000000000000001

lookup_mismatch_analysis.json:
point_world=[-0.7580843194753806, 8.47669783546894, 9.978598542972026]
best_candidate=offset=459031 block=(-1,1,3)/23 score=0
```

该结果不是 HLS 乱读。真正根因是 Python bounded expected/trace 的 `floor_div` 对负 grid 坐标处理错：

```text
old Python encode: (0,1,3)/23
C++/HLS encode:   (-1,1,3)/23
```

修正 `fpga/vivado/slam_accel_hls_mem_harness/make_golden_mem_images.py` 后，Python 使用整数 floor division，匹配 C++/HLS 行为。

### Windows 本地结果

重新生成 n64 host image 和 trace：

```powershell
python fpga\host\xdma_smoke\make_golden_host_image.py --golden-dir fpga\golden\localization\frame_000001 --max-points 64 --out-dir fpga\vivado\.build\host_golden_frame_000001_n64 --report-dir reports\fpga\host\xdma_smoke\golden_frame_000001_n64
python fpga\host\xdma_smoke\make_golden_trace_host_images.py --golden-dir fpga\golden\localization\frame_000001 --max-points 64 --out-dir fpga\vivado\.build\host_golden_trace_n64 --report-dir reports\fpga\host\xdma_smoke\golden_trace_n64
```

结果：

```text
HOST_GOLDEN_IMAGE_PASS
HOST_GOLDEN_TRACE_PASS
expected_counts=52/12/0
trace_counts=52/12/0
```

scan index `19` 修正后：

```text
class=valid
reason=inlier
center=(-1,1,3)/23
cell_offset=459031
residual=-0.028110894923855767
```

### Orin 下一步

不需要重新 bitstream，继续使用当前 Stage 44 `azmig_wrapper.bit`：

```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py --golden-dir fpga/golden/localization/frame_000001 --max-points 64 --out-dir fpga/vivado/.build/host_golden_frame_000001_n64 --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_n64
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
```

验收：

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=64
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
COUNTS=52/12/0
```

### 下一步

- n64 Orin PASS 后，进入 full `frame_000001` host transaction。
- full frame expected 继续使用 `loc_expected_obs.bin`，不使用 bounded recompute 覆盖 full expected。

### Stage 47 Orin 实测结果 2026-06-21

XDMA/base gate 通过：

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/sys/bus/pci/devices/0005:01:00.0/enable = 1
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

重新生成 n64 host image 和 trace：

```text
HOST_GOLDEN_IMAGE_PASS
expected_counts=52/12/0
HOST_GOLDEN_TRACE_PASS
trace_counts=52/12/0
expected_counts=52/12/0
```

Orin n64 transaction 通过：

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=64
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=12 -> 13
COUNTS=52/12/0
```

raw output count words：

```text
OUTPUT_WORD[27]=0x0000000c00000034  # valid=52, reject=12
OUTPUT_WORD[28]=0x0000000000000000  # miss=0, flags=0
```

actual summary：

```text
ACTUAL_RESIDUAL_SUM=0.44294171614182876
ACTUAL_RESIDUAL_ABS_SUM=2.2681722148352881
ACTUAL_RESIDUAL_MAX_ABS=0.29527878422266252
ACTUAL_B=[-0.70513185009762902,-0.42457526330019862,-0.079899540579997208,2.0415549834711988,-5.1626863669195044,2.7286869496388286]
```

结论：
- Stage 47 n64 bounded golden 在 Orin 板上 PASS。
- Stage 40/44/45 的 n64 mismatch 根因确认为 Python bounded expected/trace 的负坐标 floor division 错误，不是 HLS lookup 乱读。
- 下一阶段进入 full `frame_000001` host transaction；full frame expected 继续使用 `loc_expected_obs.bin`。

### Orin 验收结果 2026-06-21 09:48 CST

XDMA/base gate 通过：

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/sys/bus/pci/devices/0005:01:00.0/enable = 1
config bar 1, user 0
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

当前 journal 窗口没有新的 `Failed to detect XDMA config BAR`、`CmpltTO` 或 AER recovery failure。

Stage 42 residual probes 全部通过，说明 `output_words[27/28]` count 写回修复已在板上生效：

| Case | Result | Expected | Actual | Run count |
| --- | --- | ---: | ---: | --- |
| `valid_only` | PASS | `1/0/0` | `1/0/0` | `0 -> 1` |
| `reject_z_only` | PASS | `0/1/0` | `0/1/0` | `1 -> 2` |
| `reject_x_only` | PASS | `0/1/0` | `0/1/0` | `2 -> 3` |
| `miss_only` | PASS | `0/0/1` | `0/0/1` | `3 -> 4` |
| `invalid_flag_only` | PASS | `0/0/1` | `0/0/1` | `4 -> 5` |

Stage 41 multi-cell 通过：

```text
HOST_MULTICELL_SYNTHETIC_IMAGE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=5 -> 6
COUNTS=1/1/1
```

Stage 40 n64 golden 仍未通过：

```text
HOST_GOLDEN_IMAGE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=6 -> 7
EXPECTED_COUNTS=14/33/17
ACTUAL_COUNTS=52/12/0
```

n64 输出摘要：

```text
EXPECTED_RESIDUAL_SUM=0.87436966027431406
EXPECTED_RESIDUAL_ABS_SUM=1.3874737319668577
EXPECTED_RESIDUAL_MAX_ABS=0.29527878422266252
ACTUAL_RESIDUAL_SUM=0.44294171614182876
ACTUAL_RESIDUAL_ABS_SUM=2.2681722148352881
ACTUAL_RESIDUAL_MAX_ABS=0.29527878422266252
```

结论：
- Stage 44 修复了 Stage 43 的 output counter 写回问题；residual reject、miss、invalid flag 的 synthetic 单点路径已经全部对齐。
- Stage 41 也通过，说明小规模 active block/cell stride、`first_cell`、非零 cell index 和 mixed counts 在板上成立。
- 剩余阻塞点转为真实 `frame_000001` n64 golden 的 active-map/lookup/classification 差异：HLS 实际 `miss=0`，而 CPU expected `miss=17`，同时 valid 偏多、reject 偏少。
- 暂不进入 full frame、online SLAM、mapping update、solve6x6 或 PCIe x4 性能修正。

下一步建议：
- Windows/HLS 侧增加 n64 per-point debug manifest 或 trace counter，逐点输出 lookup block/cell index、residual、classification。
- 优先对比 CPU host expected recompute 与 HLS 的 neighbor lookup 顺序、active block hash/index 解码、cell flags/stride、residual threshold 入口。
- 保留 Stage 44 bitstream 作为 synthetic PASS / n64 FAIL 的当前功能基线。

### Stage 46 Orin 实测结果 2026-06-21 10:48 CST

XDMA/base gate 通过：

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/sys/bus/pci/devices/0005:01:00.0/enable = 1
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

`real_miss_point` 重跑结果与 Stage 45 一致，并已保存板上 output JSON：

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=1
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
STATUS=0x00000204
ERROR=0x00000000
HLS_OUTPUT_JSON=reports/fpga/host/xdma_smoke/golden_trace_n64/real_miss_point_output.json
EXPECTED_COUNTS=0/0/1
ACTUAL_COUNTS=1/0/0
OUTPUT_WORD[27]=0x0000000000000001
OUTPUT_WORD[28]=0x0000000000000000
```

Host-only 反推通过：

```text
LOOKUP_MISMATCH_ANALYSIS_PASS
cpu_lookup_result=miss
best_candidate=offset=459031 block=(-1,1,3)/23 legal_cpu_neighbor=False score=0
```

最佳候选 cell：

```text
offset=459031
block=(-1,1,3)
cell_idx=23
legal_cpu_neighbor=False
residual=-0.028110894923855767
normal=[0.14008283615112305, 0.8049452900886536, 0.5765760540962219]
```

CPU legal neighbor probes 结果：center `(0,1,3)/23` 及 26 个邻居全部 `Hit=False`。

结论：
- HLS/board 实际使用的 best inferred cell 不属于 CPU 合法 26-neighbor lookup 集合。
- 当前问题不再指向 golden 录制、config、host DDR 写入或 output counter。
- 下一阶段应优先修 HLS lookup/address/packed AXI 读取或综合后的 neighbor selection。
- 暂不进入 full frame、online SLAM、mapping update、solve6x6 或 PCIe x4 性能修正。

## 48. 2026-06-21 Full `frame_000001` Host Transaction 准备

### 当前阶段状态

- Stage 47 Orin 已 PASS：n64 bounded golden 修正后 `HLS_MANIFEST_NUMERIC_PASS`，counts 为 `52/12/0`。
- 本阶段进入 full `frame_000001` 上板 transaction，使用完整 `6963` 个 scan points。
- full-frame expected 固定来自 `fpga/golden/localization/frame_000001/loc_expected_obs.bin`，不使用 bounded Python recompute 覆盖。
- 本阶段不改 HLS、不改 Vivado、不重新生成 bitstream；继续使用当前 Stage 44 `azmig_wrapper.bit`。
- PCIe Gen2 x1 仍记录为性能风险，只影响运行时间，不阻塞 Stage 48 功能 gate。

### 本次代码/报告更新

- `make_golden_host_image.py --max-points 0` 已确认走 full-frame expected 路径。
- 新增/更新 full-frame host image 报告目录：`reports/fpga/host/xdma_smoke/golden_frame_000001_full/`。
- 更新 `fpga/host/xdma_smoke/README.md`，加入 Stage 48 Orin 命令和验收标准。

### Windows/本地验证结果

```text
HOST_GOLDEN_IMAGE_PASS
generated_dir=fpga/vivado/.build/host_golden_frame_000001_full
manifest=fpga/vivado/.build/host_golden_frame_000001_full/manifest.json
```

full manifest 摘要：

```text
full_scan_count=6963
scan_count=6963
active_blocks=3719
obs_cells=952064
scan_points.bin=111408 bytes
active_blocks.bin=119008 bytes
obs_cells.bin=60932096 bytes
output_zero.bin=320 bytes
expected_counts=6050/911/2
expected_residual_sum=-40.188595298682046
```

### Orin 侧测试命令

```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py \
  --golden-dir fpga/golden/localization/frame_000001 \
  --max-points 0 \
  --out-dir fpga/vivado/.build/host_golden_frame_000001_full \
  --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_full

sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke

sudo python3 fpga/host/xdma_smoke/xdma_smoke.py \
  --hls-manifest fpga/vivado/.build/host_golden_frame_000001_full/manifest.json \
  --ctrl-base 0x1000 \
  --hls-timeout-sec 120 \
  --verify-image-readback \
  --read-regs-after-config \
  --dump-output-raw-words \
  --dump-normal-equation \
  --save-output-json reports/fpga/host/xdma_smoke/golden_frame_000001_full/full_frame_output.json
```

### 验收标准

- `SHIM_SMOKE_PASS`、`REG_SMOKE_PASS`、`DDR_SMOKE_PASS` 继续通过。
- `HOST_IMAGE_READBACK_PASS`。
- `SCAN_COUNT_READBACK=6963`。
- `HLS_MANIFEST_DONE_PASS`。
- `HLS_MANIFEST_NUMERIC_PASS`。
- counts 为 `6050/911/2`。
- `STATUS.error=0` 且 `ERROR=0x00000000`。

### Orin 实测结果

2026-06-21 Orin 侧 full `frame_000001` transaction 已 PASS。

基础 gate：

```text
0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 present
enable=1
```

基础 smoke：

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
CTRL_BASE=0x00001000
VERSION=0x00020002
```

full host image：

```text
HOST_GOLDEN_IMAGE_PASS
scan_count=6963
expected_counts=6050/911/2
expected_residual_sum=-40.188595298682046
```

full HLS transaction：

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=6963
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=13->14
ACTUAL_COUNTS=6050/911/2
COUNTS=6050/911/2
OUTPUT_WORD[27]=0x0000038f000017a2
OUTPUT_WORD[28]=0x0000000000000002
WORST_FIELD=b[4] MAX_ABS=0.0078906 MAX_REL=3.3955e-05
```

残差摘要：

```text
ACTUAL_RESIDUAL_SUM=-40.188062779666957
ACTUAL_RESIDUAL_ABS_SUM=387.50742023750286
ACTUAL_RESIDUAL_MAX_ABS=0.29974957195769858
```

输出 JSON：

```text
reports/fpga/host/xdma_smoke/golden_frame_000001_full/full_frame_output.json
```

本轮 journal 未出现新的 `Failed to detect XDMA config BAR`、`CmpltTO` 或 AER recovery failure。120 秒 timeout 未触发，不需要 300 秒重试。

### 失败分支

- 如果 120 秒 timeout，先保留 manifest/output JSON，并用 `--hls-timeout-sec 300` 重跑一次；若仍 timeout，再查 HLS AXI/MIG arbitration 或 full-frame loop progress。
- 如果 counts mismatch，用 `full_frame_output.json` 做 per-point trace narrowing，不重新录数据。
- 如果 counts 一致但 `H/b` mismatch，优先查浮点累计顺序、double packing 和 host expected parser。

### 下一步

- Stage 48 PASS 后进入 repeated full-frame stability gate。
- repeated full-frame 稳定后，再考虑 PCIe Gen2 x4 链路修正、性能阶段或 Orin runtime 集成。

## 49. 2026-06-21 Full `frame_000001` Repeated Stability Gate

### 当前阶段状态

- Stage 48 已单次 full-frame PASS：`SCAN_COUNT_READBACK=6963`，counts `6050/911/2`，`HLS_MANIFEST_NUMERIC_PASS`。
- Stage 49 不改 HLS、不改 Vivado、不重新生成 bitstream；继续使用当前 Stage 44 `azmig_wrapper.bit`。
- 本阶段只验证连续 full-frame transaction 稳定性，不进入 online SLAM、mapping/update、solve6x6 或 PCIe Gen2 x4 性能修正。

### 本次代码/工具变更

- `xdma_smoke.py` 新增 `--hls-repeat N`，默认 `1`。
- `xdma_smoke.py` 新增 `--repeat-output-dir <dir>`，每轮保存 `full_frame_output_iter_XX.json`。
- repeat 流程中第 1 轮写入并可选 readback 全部 manifest segments；第 2 轮起只重写 `output_zero.bin` 并重新触发 accelerator，避免每轮重复写 60MB `obs_cells`。
- 每轮都会检查 `RUN_COUNT` 增加、`STATUS.error=0`、`ERROR=0`、counts/H/b/residual 容差，并输出 `HLS_REPEAT_ITER_PASS i/N`。
- 全部轮次通过后输出 `HLS_REPEAT_STABILITY_PASS`。
- 新增报告目录：`reports/fpga/host/xdma_smoke/golden_frame_000001_full_stability/`。

### Orin 侧测试命令

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke

sudo python3 fpga/host/xdma_smoke/xdma_smoke.py \
  --hls-manifest fpga/vivado/.build/host_golden_frame_000001_full/manifest.json \
  --ctrl-base 0x1000 \
  --hls-timeout-sec 120 \
  --verify-image-readback \
  --read-regs-after-config \
  --dump-output-raw-words \
  --hls-repeat 10 \
  --repeat-output-dir reports/fpga/host/xdma_smoke/golden_frame_000001_full_stability

journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 160
```

### 验收标准

- 10/10 轮均输出 `HLS_MANIFEST_NUMERIC_PASS`。
- 10/10 轮均输出 `HLS_REPEAT_ITER_PASS i/10`。
- 最终输出 `HLS_REPEAT_STABILITY_PASS`。
- 每轮 counts 均为 `6050/911/2`。
- 每轮 `RUN_COUNT` 单调递增。
- kernel log 无新的 `Failed to detect XDMA config BAR`、`CmpltTO`、AER fatal 或 XDMA offline。
- 最大数值误差仍满足当前容差：`abs <= 1e-4` 或 `rel <= 1e-3`。

### Orin 实测结果

2026-06-21 Orin 侧 10 轮 full-frame repeated stability 已 PASS。

基础 gate：

```text
0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 present
enable=1
```

基础 smoke：

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
CTRL_BASE=0x00001000
VERSION=0x00020002
```

repeat 输出：

```text
HOST_IMAGE_WRITE_PASS
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=6963
HLS_REPEAT_ITER_PASS 1/10
HLS_REPEAT_ITER_PASS 2/10
HLS_REPEAT_ITER_PASS 3/10
HLS_REPEAT_ITER_PASS 4/10
HLS_REPEAT_ITER_PASS 5/10
HLS_REPEAT_ITER_PASS 6/10
HLS_REPEAT_ITER_PASS 7/10
HLS_REPEAT_ITER_PASS 8/10
HLS_REPEAT_ITER_PASS 9/10
HLS_REPEAT_ITER_PASS 10/10
HLS_REPEAT_STABILITY_PASS ITERATIONS=10 MAX_ELAPSED_SEC=1.527302 WORST_FIELD=b[4] MAX_ABS=0.0078906 MAX_REL=3.3955e-05
```

每轮稳定性：

```text
ITER 01 RUN_COUNT=14->15 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 02 RUN_COUNT=15->16 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 03 RUN_COUNT=16->17 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 04 RUN_COUNT=17->18 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 05 RUN_COUNT=18->19 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 06 RUN_COUNT=19->20 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 07 RUN_COUNT=20->21 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 08 RUN_COUNT=21->22 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 09 RUN_COUNT=22->23 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
ITER 10 RUN_COUNT=23->24 COUNTS=6050/911/2 STATUS=0x00000204 ERROR=0x00000000
```

per-iteration JSON 已保存：

```text
reports/fpga/host/xdma_smoke/golden_frame_000001_full_stability/full_frame_output_iter_01.json
...
reports/fpga/host/xdma_smoke/golden_frame_000001_full_stability/full_frame_output_iter_10.json
```

本轮 journal 未出现新的 `Failed to detect XDMA config BAR`、`CmpltTO`、AER fatal 或 XDMA offline。Stage 49 功能稳定性 gate 通过，可进入 Orin runtime 最小集成。

### 失败分支

- 如果某轮 timeout：保留该轮 JSON 和 raw words，重跑 `--hls-repeat 3 --hls-timeout-sec 300`；若仍 timeout，优先查 HLS/MIG 长时间运行或 XDMA/PCIe 链路稳定性。
- 如果某轮 counts/Hb mismatch：比较该轮 JSON 与 Stage 48 PASS JSON，先查 output 清零、RUN_COUNT、旧输出污染，再考虑 HLS 状态残留。
- 如果出现 AER/CmpltTO：暂停 runtime 集成，转入 PCIe 链路稳定性排查。

### 下一步

- Stage 49 PASS 后进入 Orin runtime 最小集成：封装 XDMA host runtime，接 `SurfelLocBackend::ComputeObservation` 的 `SURFEL_FPGA_OBS` 路径，并保留 CPU_SIM fallback。

## 50. 2026-06-21 Orin C++ XDMA Runtime Golden Replay

### 当前阶段目标

- Stage 49 已证明 Python host 工具连续 10 次 full-frame HLS transaction 稳定通过。
- Stage 50 先不直接接在线定位，而是实现 C++ XDMA runtime 和 C++ localization golden replay app。
- 本阶段目标是让 C++ runtime 跑完整 `frame_000001`，输出与 Stage 48/49 一致：`6050/911/2`，`H/b/residual` 满足 `abs <= 1e-4` 或 `rel <= 1e-3`。
- Stage 50 PASS 后，Stage 51 再接入 `LidarLoc` 的 `SURFEL_FPGA_OBS` 路径，并保留 CPU_SIM/NDT fallback。

### 本次代码/工具变更

- 新增 C++ XDMA runtime：
  - 默认设备：`/dev/xdma0_user`、`/dev/xdma0_h2c_0`、`/dev/xdma0_c2h_0`
  - 默认 control base：`0x1000`
  - 支持 register read/write、H2C/C2H `pread/pwrite`、shim/reg smoke、DDR smoke、HLS start/poll/readback
  - 复用 `fpga/abi/slam_accel_abi.h` 和 PL DDR layout 常量
- 新增 app：`run_surfel_loc_xdma_golden`
  - 读取 `fpga/golden/localization/frame_000001`
  - 写入 PL DDR 固定区域
  - 启动 HLS 并读取 320B `SlamNormalEquation`
  - 比较 counts、`H_upper[21]`、`b[6]`、residual
- 保持在线定位主流程不变：Stage 50 不修改 `LidarLoc::Localize` 行为。
- 新增报告目录：`reports/fpga/runtime/stage50_cpp_xdma_golden/`。

### Orin 侧测试命令

```bash
colcon build --packages-select lightning

lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
cat /sys/bus/pci/devices/0005:01:00.0/enable

ros2 run lightning run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --shim_smoke \
  --reg_smoke \
  --ddr_smoke

ros2 run lightning run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --verify_readback \
  --repeat 3 \
  --output_dir reports/fpga/runtime/stage50_cpp_xdma_golden
```

### 验收标准

- `XDMA_CPP_SHIM_SMOKE_PASS`
- `XDMA_CPP_REG_SMOKE_PASS`
- `XDMA_CPP_DDR_SMOKE_PASS`
- 每轮 `scan_count=6963`
- 每轮 `STATUS=0x00000204`
- 每轮 `ERROR=0x00000000`
- 每轮 `RUN_COUNT` 递增
- 每轮 counts 为 `6050/911/2`
- 每轮输出 `XDMA_CPP_GOLDEN_NUMERIC_PASS`
- 最终输出 `XDMA_CPP_GOLDEN_REPEAT_PASS`
- kernel log 无新的 `Failed to detect XDMA config BAR`、`CmpltTO`、AER fatal、XDMA offline

### Orin 实测结果

2026-06-21 Orin 侧 C++ XDMA runtime golden replay 已 PASS。

编译：

```text
colcon build --packages-select lightning
PASS
```

基础 gate：

```text
0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 present
enable=1
```

C++ runtime smoke：

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
CTRL_BASE=0x00001000
XDMA_CPP_DDR_SMOKE_PASS
```

C++ full-frame replay：

```text
XDMA_CPP_GOLDEN_LOAD_PASS
scan_count=6963
active_blocks=3719
active_cells=952064
expected_counts=6050/911/2
```

3 轮结果：

```text
ITER=1/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=24->25 SCAN_COUNT_READBACK=6963 COUNTS=6050/911/2
ITER=2/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=25->26 SCAN_COUNT_READBACK=6963 COUNTS=6050/911/2
ITER=3/3 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=26->27 SCAN_COUNT_READBACK=6963 COUNTS=6050/911/2
OUTPUT_WORD[27]=0x0000038f000017a2
OUTPUT_WORD[28]=0x0000000000000002
XDMA_CPP_COMPARE counts_ok=1 values_ok=1 max_abs=0.0078906 max_rel=4.41926e-05 worst_field=b(4)
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 MAX_ELAPSED_SEC=1.52723
```

per-iteration JSON：

```text
reports/fpga/runtime/stage50_cpp_xdma_golden/cpp_full_frame_output_iter_01.json
reports/fpga/runtime/stage50_cpp_xdma_golden/cpp_full_frame_output_iter_02.json
reports/fpga/runtime/stage50_cpp_xdma_golden/cpp_full_frame_output_iter_03.json
```

本轮 journal 未出现新的 `Failed to detect XDMA config BAR`、`CmpltTO`、AER fatal 或 XDMA offline。Stage 50 通过，可进入 Stage 51 `SURFEL_FPGA_OBS` 在线接入。

### 失败分支

- 如果 C++ smoke 失败：先不接在线定位，回到 BAR shim、control register 或 DDR path。
- 如果 C++ replay timeout：与 Stage 49 Python repeat JSON 对比，确认是否 C++ register/start/poll 流程差异。
- 如果 counts/Hb mismatch：优先比较 C++ 写入 ABI buffer 与 Python host image 的分区内容、map header 和 output zero 清零。
- 如果 C++ PASS：进入 Stage 51 `SURFEL_FPGA_OBS` 在线接入。

## 51. 2026-06-21 Unified Observation Runtime v1 接入 Localization

### 当前阶段目标

- Stage 51 不是“只做定位”的孤立路线，而是统一 observation runtime 的第一条在线接入路径先落到 localization。
- 复用 Stage 50 已验证的 C++ XDMA runtime，把 `LidarLoc` 中 `SURFEL_CPU_SIM` 的 observation 计算替换为 FPGA/HLS observation。
- CPU 仍负责迭代、LDLT solve、位姿更新和 fallback。
- 本阶段不做 mapping 接入、不做 solve6x6、不做 active map cache 优化。
- Stage 51 PASS 后，再进入 mapping observation golden 和 mapping `FPGA_OBS` 接入。

### 本次代码变更

- 新增 localization FPGA observation backend：
  - `src/core/localization/surfel_loc/surfel_loc_xdma_backend.h`
  - `src/core/localization/surfel_loc/surfel_loc_xdma_backend.cc`
- 新 backend 接口与 CPU_SIM observation 对齐：

```cpp
bool ComputeObservation(
  CloudPtr scan_body,
  const SE3& pose_guess,
  const ActiveMapBuffer& active_map,
  LocNormalEquation& out);
```

- `SurfelLocXdmaBackend` 内部复用 Stage 50 的 `fpga::XdmaRuntime::RunLocalizationObservation`。
- FPGA 输出的 `SlamNormalEquation` 通过已有 ABI helper 转回 `LocNormalEquation`。
- `LidarLoc` 后端选择已接入：
  - `fpga.localization.enable=false`：默认仍为 `NDT_OMP`
  - `mode=cpu_sim`：仍为 `SURFEL_CPU_SIM`
  - `mode=fpga_obs`：启用 `SURFEL_FPGA_OBS`
  - `mode=fpga_obs_solve/fpga_full`：本阶段 warning 后降级到 `SURFEL_FPGA_OBS`
- FPGA_OBS 失败时按链路 fallback：

```text
SURFEL_FPGA_OBS -> SURFEL_CPU_SIM -> NDT_OMP
```

- 所有默认 YAML 增加 XDMA runtime 配置，默认仍不启用 FPGA：

```yaml
lidar_loc:
  surfel_fpga_user_dev: /dev/xdma0_user
  surfel_fpga_h2c_dev: /dev/xdma0_h2c_0
  surfel_fpga_c2h_dev: /dev/xdma0_c2h_0
  surfel_fpga_ctrl_base: 0x1000
  surfel_fpga_timeout_sec: 120.0
  surfel_fpga_verify_readback: false
```

### Orin 侧测试命令

Stage 50 C++ golden regression：

```bash
bash -lc 'source install/setup.bash && sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 1'
```

FPGA_OBS online/offline smoke：

```bash
timeout --signal=SIGKILL 60s bash -lc 'source install/setup.bash && sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" ./install/lightning/lib/lightning/run_loc_offline \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config /tmp/lightning_stage51_fpga_obs.yaml \
  --map_path /home/hit/Cheng/FPGA_ACC/lightning-lm-acc/data/new_map/ 2>&1' | tee /tmp/lightning_stage51_fpga_obs.log
```

`/tmp/lightning_stage51_fpga_obs.yaml` 使用：

```yaml
fpga:
  enable: true
  localization:
    enable: true
    mode: fpga_obs
    fallback: ndt_omp
```

### Orin 实测结果

编译：

```text
colcon build --packages-select lightning
PASS
```

Stage 50 C++ golden regression：

```text
XDMA_CPP_GOLDEN_NUMERIC_PASS
scan_count=6963
COUNTS=6050/911/2
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=27->28
```

默认配置启动检查：

```text
[LidarLoc] backend=NDT_OMP
fpga_global_enable=0
fpga_localization_enable=0
```

说明：`run_loc_offline` 在打印 `done` 后出现已有的 headless GLX/EGL teardown 断言；该检查已经完成 backend 验证，且未产生受 git 跟踪的地图文件修改。

在线 smoke 确认真实启用 FPGA_OBS：

```text
[LidarLoc] backend=SURFEL_FPGA_OBS
```

本次 smoke 统计：

```text
surfel FPGA_OBS success=1 frames: 35
localization FPGA_OBS failure/fallback markers: 0
avg_valid=5866.14
avg_reject=733.94
avg_miss=2.17
avg_mean_abs_residual=0.061855
avg_xdma_elapsed_sum=4.395882
max_xdma_elapsed=1.483520
```

首帧和末帧代表值：

```text
valid=2613 reject=259 miss=2 mean_abs_residual=0.0689565 xdma_elapsed_sum=2.36148 xdma_elapsed_max=0.594914
valid=6199 reject=755 miss=1 mean_abs_residual=0.0560587 xdma_elapsed_sum=4.1079 xdma_elapsed_max=1.37255
```

报告目录：

```text
reports/fpga/runtime/stage51_online_fpga_obs/
```

### 当前结论

- Stage 51 第一版在线接入已证明 `mode=fpga_obs` 会真实调用 FPGA/HLS observation，而不是 warning fallback。
- 默认配置仍保持 CPU/NDT，不改变原定位流程。
- 当前版本每次 observation 都重写 scan、pose、active map、output buffer；这是 correctness-first 实现，后续再做 active-map cache 和性能优化。
- 本阶段只接入 localization observation；mapping observation 仍需要先补 golden/replay，再进入 Stage 52。

### 下一步

- Stage 52：补 mapping observation golden 和 host replay。
- Stage 53：将 unified observation runtime 接入 mapping `FPGA_OBS`。
- Stage 54：做 localization `CPU_SIM vs FPGA_OBS` 固定短 bag 轨迹、失败帧、残差、耗时对比报告。

## 52. 2026-06-21 Mapping Observation Golden/Replay

### 当前阶段目标

- Stage 52 不直接打开在线 `mapping.mode=fpga_obs`。
- 先补 mapping observation golden 和 host replay，确认建图侧 observation ABI 与当前 HLS/unified runtime 可以对齐。
- golden 来源必须是 `LaserMapping::ObsModelCpu` 当前真实建图前端，而不是复用 localization golden 假装通过。

### 本次配置注释更新

所有 `config/default*.yaml` 已补充 FPGA/surfel 切换说明：

```yaml
fpga:
  enable: false        # Master switch. false forces mapping and localization to CPU paths.
  mode: cpu            # Global default mode if a subsystem mode is omitted.
  mapping:
    enable: true       # Effective only when fpga.enable=true.
    mode: cpu_sim      # cpu/cpu_sim are safe today. fpga_obs* modes are future mapping stages.
    fallback: cpu
  localization:
    enable: false
    mode: cpu_sim      # cpu_sim or fpga_obs.
    fallback: ndt_omp
```

`lidar_loc` 下的 surfel 注释也已说明：

```text
surfel_cell_resolution/min_support/quality_max/lookup_nearby_type
  Shared by localization CPU_SIM and FPGA_OBS active map.

surfel_max_iterations/min_valid_count/max_mean_residual
  CPU pose update and quality gates for surfel localization.

surfel_fpga_*
  Used only by localization mode=fpga_obs.
```

### Stage 52 需要补的代码入口

当前代码状态：

```text
LaserMapping::ObsModelFpgaObservation()
  -> warning
  -> ObsModelCpu()
```

因此 Stage 52 的正确顺序是：

1. 新增 `BlockSurfelMap -> ActiveMapBuffer` 导出工具，保持 floor-div/block/cell 编码与 FPGA ABI 一致。
2. 在 `LaserMapping::ObsModelCpu()` 中增加一次性 capture hook。
3. 导出 mapping golden source：

```text
fpga/golden_src/mapping/frame_000001/
  scan_body_downsampled.pcd
  mapping_pose.txt
  active_map.bin
  expected_mapping_obs.bin
  frame_meta.yaml
```

4. 生成 replay golden：

```text
fpga/golden/mapping/frame_000001/
  map_scan.bin
  map_pose.bin
  map_active_map.bin
  map_expected_obs.bin
  map_meta.yaml
```

5. 新增 mapping replay app，目标 marker：

```text
MAPPING_CPU_REPLAY_PASS
MAPPING_XDMA_REPLAY_PASS
```

### 报告目录

```text
reports/fpga/runtime/stage52_mapping_golden_replay/
  commands.md
  summary.md
```

### 本次实现结果

已新增 Orin 侧 mapping golden/replay 链路：

```text
BlockSurfelMap::ExportActiveMap()
LaserMapping::SetMappingGoldenFrameCapture()
export_mapping_golden_frame
build_surfel_mapping_golden
run_surfel_mapping_golden_replay
run_surfel_mapping_xdma_golden
```

本阶段明确只导出 surfel-map plane observation：

```text
default_livox.yaml 中 surfel_fallback_mode=ivox
完整 ObsModelCpu 会混入 iVox fallback plane terms
Stage52 golden 只捕获 surfel_corr.valid && !fallback 的统一 surfel observation kernel 输入/输出
```

### 本次验证结果

YAML 解析检查：

```text
config/default*.yaml parse PASS
fpga.enable=false for all default configs
mapping.mode=cpu_sim for all default configs
localization.mode=cpu_sim for all default configs
surfel_fpga_ctrl_base=4096
```

编译：

```text
colcon build --packages-select lightning
PASS
```

Mapping golden source：

```text
fpga/golden_src/mapping/frame_000001
frame_index=20
timestamp=1773380976.68870282
scan_points=782
active_blocks=73
active_cells=18688
effect_feat_surf=667
plane_icp_weight=300
surfel_only_expected_counts=611/0/171
MAPPING_GOLDEN_EXPORT_PASS
```

Mapping golden ABI：

```text
fpga/golden/mapping/frame_000001
MAPPING_GOLDEN_BUILD_PASS
expected_counts=611/0/171
```

CPU replay：

```text
MAPPING_CPU_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
values_ok=1
max_abs=0.0337705
max_rel=2.21971e-05
worst_field=b(3)
```

XDMA replay：

```text
MAPPING_XDMA_REPLAY_FAIL
STATUS=0x204
ERROR=0x0
RUN_COUNT=145->146
SCAN_COUNT_READBACK=782
counts actual=585/68/129 expected=611/0/171
values_ok=0
max_abs=4.49101e+06
max_rel=1.01612
worst_field=H(3,3)
```

### 当前结论

- Orin 侧 mapping golden 导出、ABI 构建、CPU replay 已通过。
- XDMA 传输和 HLS start/done 正常，`STATUS=0x204`、`ERROR=0`、`RUN_COUNT` 递增。
- 当前 FPGA/HLS 输出仍带 localization-style residual reject 行为：硬件 `reject_count=68`，而 mapping surfel-only golden 期望 `reject_count=0`。
- 因此 Stage 52 不能标记为完整硬件 PASS，Stage 53 暂不能接在线 `mapping.mode=fpga_obs`。
- 下一步应回 Windows/HLS 侧修正 `unified_surfel_observation_core` 的 mapping mode：使用 mapping plane observation 的有效点规则、`plane_icp_weight`、以及 mapping H/b 累计语义，然后用同一份 `fpga/golden/mapping/frame_000001` 复测到 `MAPPING_XDMA_REPLAY_PASS`。

收尾检查：

```text
git diff --check
PASS
```

### 验收标准

- 默认配置仍显示：

```text
[LaserMapping] mapping_backend=CPU fpga_global_enable=0
[LidarLoc] backend=NDT_OMP fpga_global_enable=0
```

- `mapping.mode=fpga_obs` 在 Stage 52 结束前仍不得作为在线 PASS 条件。
- mapping golden 必须来自 `LaserMapping::ObsModelCpu` 的真实建图 observation。
- CPU host replay 已通过，但 XDMA replay 未通过。
- XDMA replay 通过后，Stage 53 才允许接入在线 mapping `FPGA_OBS`。
## Stage 53 修正版：Mapping 参数 ABI 与 HLS Mapping Observation 语义修复

### 目标

Stage 52 的失败根因已经从 PCIe/XDMA/DDR 收敛到 HLS mapping mode 语义：
硬件链路可 start/done，但 HLS 仍按 localization observation 的 residual
reject 规则和 Jacobian 累计方式处理 mapping golden。配置文件中的外参和
`plane_icp_weight` 不会被 FPGA 自动读取，必须由 Orin runtime 显式写入 DDR
并通过控制器 direct address 传给 HLS。

### 本次代码变更

- 新增 128B ABI：`SlamAccelObservationParams`。
- 新增 PL DDR segment：`PARAMS_BASE = 0x01002000`。
- 新增控制寄存器：

```text
0x054 PARAMS_ADDR_LO
0x058 PARAMS_ADDR_HI
```

- `slam_accel_ctrl` 新增 `unified_obs_params_addr[31:0]` direct output。
- `unified_surfel_observation_core` 新增 `params` m_axi direct pointer。
- `RunLocalizationObservation()` 写 localization params。
- `RunMappingObservation()` 写 mapping params，包含 mode、`plane_icp_weight`、`residual_outlier_th`、`mapping_gate_scale`、`extrinsic_R[9]`、`extrinsic_T[3]`。

### HLS 语义

Localization 保持 Stage 48/49 已验证逻辑：

```text
lookup miss -> miss_count
nonfinite scan/residual -> reject_count
abs(residual) > residual_outlier_th -> reject_count
H += J^T J
b += J^T residual
```

Mapping 改为 CPU surfel-map observation 语义：

```text
lookup miss -> miss_count
nonfinite scan/residual -> reject_count
point_body.norm() <= mapping_gate_scale * residual^2 -> miss_count
res = -residual
H += J^T J * plane_icp_weight
b += J^T res * plane_icp_weight
```

Mapping Jacobian 使用 `extrinsic_R/extrinsic_T`，并从 lidar pose 与外参恢复
body/world 旋转关系。当前默认配置虽然 `extrinsic_R=identity`，但 ABI 已按
非 identity rotation 预留并实现，不再把外参假设写死在 HLS 中。

### 当前验证结果

Windows g++ CSim：

```text
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
PASS
localization counts actual=6050/911/2 expected=6050/911/2
reject_probe counts=0/1/0
max_abs=0.0078906
max_rel=4.41926e-05
```

Vivado HLS 2018.3 CSim：

```text
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
PASS
CSim done with 0 errors
localization counts actual=6050/911/2 expected=6050/911/2
reject_probe counts=0/1/0
```

Vivado HLS 2018.3 C Synthesis / IP export:

```text
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
PASS
target clock: 10.00 ns
estimated clock: 9.307 ns
BRAM_18K=36 DSP48E=256 FF=27475 LUT=41633

powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
PASS
component.xml: %TEMP%\lightning_hls_unified_obs\solution1\impl\ip\component.xml
generated RTL: single direct params port confirmed
```

Tool note: do not use `DATA_PACK` on the 128B params struct. Vivado HLS 2018.3
packs it into a 1024-bit object and can crash during C Synthesis. The final
implementation keeps the external `SlamAccelObservationParams` ABI but exposes
the HLS input as `uint64_t* params` with 16 words and decodes it inside the core.

Windows 当前仓库没有本地 `fpga/golden/mapping/frame_000001`，mapping CSim
需要在 Orin 同步 mapping golden 后执行。

### 下一步

Windows 侧继续：

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

JTAG 下载新 `azmig_wrapper.bit` 后，Orin 侧回归：

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

验收标准：

```text
localization PASS, counts 6050/911/2
mapping PASS, counts 611/0/171
no Failed to detect XDMA config BAR / CmpltTO / AER fatal
```

在 mapping XDMA replay 通过前，online `mapping.mode=fpga_obs` 仍保持禁用。

## Stage 53 Windows board-level result: Mapping Params ABI + HLS IP bitstream

### Current status

Stage 53 Windows-side code, HLS, BD validation, synthesis, implementation, and bitstream generation are complete. The key change is the new 128-byte `SlamAccelObservationParams` ABI. Orin runtime now writes `plane_icp_weight`, `residual_outlier_th`, `mapping_gate_scale`, `extrinsic_R[9]`, and `extrinsic_T[3]` into PL DDR at `PARAMS_BASE=0x01002000`, then passes that address through `PARAMS_ADDR_LO/HI=0x054/0x058`.

The FPGA does not read YAML configuration files. Every localization or mapping observation must explicitly write the active params block before starting HLS.

### Windows verification

```text
run_gpp_csim.ps1: PASS
run_vivado_hls_csim.ps1: PASS
run_vivado_hls_csynth.ps1: PASS
run_vivado_hls_export_ip.ps1: PASS
localization counts: 6050/911/2
reject_probe counts: 0/1/0
HLS target clock: 10.00 ns
HLS estimated clock: 9.307 ns
HLS resources: BRAM_18K=36 DSP48E=256 FF=27475 LUT=41633
```

```text
run_vivado_bd_validate.ps1: PASS
run_vivado_project_synth.ps1 -Jobs 18: PASS
run_vivado_impl_bitstream.ps1 -Jobs 18: PASS
bitstream: fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
```

Post-implementation timing:

```text
WNS=0.046 ns
TNS=0.000 ns
WHS=0.045 ns
THS=0.000 ns
All user specified timing constraints are met.
```

Post-implementation utilization:

```text
Slice LUTs:      65329 / 277400 = 23.55%
Slice Registers: 71135 / 554800 = 12.82%
Block RAM Tile: 53.5 / 755 = 7.09%
DSPs:           373 / 2020 = 18.47%
Bonded IOB:     74 / 362 = 20.44%
```

DRC result:

```text
0 errors
0 critical warnings
748 warnings
456 advisories
```

### Toolchain note

Do not use HLS `DATA_PACK` directly on the 128-byte `SlamAccelObservationParams` struct. Vivado HLS 2018.3 packs it into a 1024-bit object and can crash during C Synthesis. The final implementation keeps the external 128-byte ABI but exposes HLS `params` as `uint64_t* params`, then decodes 16 words inside the core.

### Next Orin acceptance

Windows JTAG download:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

Orin regression:

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

Acceptance:

```text
localization XDMA replay PASS, counts 6050/911/2
mapping XDMA replay PASS, counts 611/0/171
no Failed to detect XDMA config BAR / CmpltTO / AER fatal
```

Before mapping XDMA replay passes, keep online `mapping.mode=fpga_obs` disabled.

### Orin acceptance result, 2026-06-21

XDMA gate:

```text
PASS
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user, /dev/xdma0_h2c_0, /dev/xdma0_c2h_0 present
enable=1
no new Failed to detect XDMA config BAR / CmpltTO / AER fatal
```

Build and smoke:

```text
colcon build --packages-select lightning: PASS
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

Mapping CPU replay:

```text
MAPPING_CPU_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
max_abs=0.0337705
max_rel=2.21971e-05
worst_field=b(3)
```

Mapping XDMA replay:

```text
MAPPING_XDMA_REPLAY_FAIL
STATUS=0x204
ERROR=0x0
RUN_COUNT=0->1, retry 1->2
SCAN_COUNT_READBACK=782
counts actual=600/0/182 expected=611/0/171
max_abs=270562
max_rel=6.38949
worst_field=H(3,3)
```

Interpretation:

```text
Stage 52 actual: 585/68/129
Stage 53 actual: 600/0/182
Expected:        611/0/171
```

Stage 53 fixed the mapping residual-reject semantics: `reject_count` is now `0`
as expected. The remaining mismatch is 11 points that HLS reports as `miss`
while CPU mapping replay reports as `valid`. The next debug target is therefore
mapping-mode lookup / candidate selection / mapping gate behavior, not XDMA,
BAR, DDR, output counter packing, or the params ABI transport.

Online `mapping.mode=fpga_obs` smoke was skipped because mapping XDMA replay did
not pass. Keep online mapping FPGA disabled until this same fixture reaches
`MAPPING_XDMA_REPLAY_PASS`.

## Stage 54: Mapping Lookup Selection Fix (2026-06-21)

Stage 53 narrowed the remaining mapping failure to lookup/candidate selection:

```text
expected mapping counts: 611/0/171
Stage 53 XDMA counts:    600/0/182
```

The fix is mode-specific neighbor selection inside
`unified_surfel_observation_core`:

- localization keeps centroid-distance-first lookup, preserving Stage 48/49
  localization behavior.
- mapping now matches CPU `mapping_golden::BetterMappingCell()`: compare
  absolute plane residual first using `1e-4` tolerance, then centroid squared
  distance using `1e-4` tolerance, then lower `quality`.

No XDMA, MIG, BAR shim, PL DDR layout, params ABI, Orin runtime register map, or
HLS mapping residual/gate semantics were changed.

Windows verification:

```text
g++ CSim: PASS
Vivado HLS CSim: PASS
Vivado HLS C Synthesis: PASS
Vivado HLS IP export: PASS
BD validate: PASS
project synthesis: PASS
implementation/bitstream: PASS
```

Observed CSim markers:

```text
localization golden counts: 6050/911/2
reject_probe counts: 0/1/0
mapping_lookup_probe counts: 1/0/0
[obs_tb] PASS
```

Implementation summary:

```text
WNS=0.084 ns, TNS=0.000 ns
WHS=0.033 ns, THS=0.000 ns
All user specified timing constraints are met.
Bitgen Completed Successfully, 0 Critical Warnings, 0 Errors.
```

New bitstream:

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
```

Required Orin gate after JTAG:

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

Acceptance:

```text
localization XDMA replay PASS, counts 6050/911/2
mapping XDMA replay PASS, counts 611/0/171
no Failed to detect XDMA config BAR / CmpltTO / AER fatal
```

Orin result:

```text
XDMA gate: PASS
  0005:01:00.0 [10ee:7024]
  Kernel driver in use: xdma
  /dev/xdma0_user, /dev/xdma0_h2c_0, /dev/xdma0_c2h_0 present
  enable=1
  config bar 1, user 0
  no new Failed to detect XDMA config BAR / CmpltTO / AER fatal

C++ runtime smoke: PASS
  XDMA_CPP_SHIM_SMOKE_PASS
  XDMA_CPP_REG_SMOKE_PASS
  XDMA_CPP_DDR_SMOKE_PASS

localization XDMA replay: PASS
  scan_count=6963
  STATUS=0x00000204
  ERROR=0x00000000
  RUN_COUNT=0->1
  SCAN_COUNT_READBACK=6963
  counts actual=6050/911/2 expected=6050/911/2
  values_ok=1
  max_abs=0.0078906
  max_rel=4.41926e-05

mapping CPU replay: PASS
  counts actual=611/0/171 expected=611/0/171
  values_ok=1

mapping XDMA replay: PASS
  STATUS=0x204
  ERROR=0x0
  RUN_COUNT=1->2
  SCAN_COUNT_READBACK=782
  counts actual=611/0/171 expected=611/0/171
  values_ok=1
  max_abs=0.268571
  max_rel=1.99295e-05
  worst_field=H(3,3)
  MAPPING_XDMA_REPLAY_PASS
```

Stage 54 hardware replay is complete. Online `mapping.mode=fpga_obs` remains a
separate integration stage because `LaserMapping::ObsModelFpgaObservation()`
still falls back to CPU in the current Orin code.

## Stage 55: Online Mapping FPGA_OBS Integration (2026-06-21)

Stage 55 connects the already validated mapping XDMA runtime to the online
`LaserMapping` observation path.

Implementation:

```text
LaserMapping::ObsModelFpgaObservation()
  -> scan_down_body_
  -> BlockSurfelMap::ExportActiveMap()
  -> XdmaRuntime::RunMappingObservation()
  -> SlamNormalEquation -> ESKF HTH/HTr
  -> CPU EKF update
```

The first online version only covers surfel plane observation. If
`enable_icp_part=true`, or if active-map export / XDMA / HLS fails, the code logs
`mapping FPGA_OBS failed -> CPU fallback` and falls back to `ObsModelCpu()` when
`fpga.mapping.fallback=cpu`.

Configuration was unified with a shared runtime block:

```yaml
fpga:
  runtime:
    user_dev: /dev/xdma0_user
    h2c_dev: /dev/xdma0_h2c_0
    c2h_dev: /dev/xdma0_c2h_0
    ctrl_base: 0x1000
    timeout_sec: 120.0
    verify_readback: false
```

`fpga.runtime.*` is now used by both localization and mapping FPGA_OBS paths.
The old `lidar_loc.surfel_fpga_*` keys remain as localization compatibility
defaults.

Stage 55 also adds XDMA observation transaction locking:

```text
process-local mutex
cross-process file lock: /tmp/lightning_xdma_observation.lock
```

This is required because localization and mapping share the same PL DDR layout
and control registers. Concurrent two-process golden replay now serializes and
passes:

```text
localization XDMA replay: PASS, counts 6050/911/2, RUN_COUNT=681->682
mapping XDMA replay: PASS, counts 611/0/171, RUN_COUNT=682->683
```

Build:

```text
colcon build --packages-select lightning: PASS
```

## Stage 56: Mapping FPGA_OBS Online Smoke (2026-06-21)

Stage 56 runs a mapping-only online smoke using a temporary config:

```yaml
fpga:
  enable: true
  mapping:
    enable: true
    mode: fpga_obs
    fallback: cpu
  localization:
    enable: false
fasterlio:
  enable_icp_part: false
```

Observed:

```text
[LaserMapping] mapping_backend=FPGA_OBS
mapping FPGA_OBS success frames: 672
mapping FPGA_OBS fallback frames: 0
error markers: 0
xdma_elapsed_sec_min=0.073607
xdma_elapsed_sec_mean=0.110806
xdma_elapsed_sec_max=0.140664
run_count_first=5->6
run_count_last=676->677
```

Representative frames:

```text
success_count=1   scan_points=812 active_blocks=66  active_cells=16896 valid/reject/miss=533/0/279 status=0x204 error=0x0
success_count=672 scan_points=734 active_blocks=120 active_cells=30720 valid/reject/miss=656/0/78  status=0x204 error=0x0
```

The process was manually interrupted after sufficient smoke coverage to avoid
running the full bag. No new XDMA config BAR / CmpltTO / AER fatal markers were
observed.

Stage 56 clears the gate for Stage 57 joint mapping + localization FPGA_OBS
testing.

## Stage 57: Joint Mapping + Localization FPGA_OBS Bring-up (Next)

Stage 57 is now allowed to start, but it should remain a short-bag bring-up
stage, not a long-run production test.

Temporary joint config:

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
fasterlio:
  enable_icp_part: false
```

Required checks:

```text
mapping log:      mapping_backend=FPGA_OBS and mapping FPGA_OBS success=1
localization log: backend=SURFEL_FPGA_OBS and surfel FPGA_OBS success=1
fallback counts:  recorded separately for mapping and localization
XDMA health:      no /dev/xdma* loss, no Failed to detect XDMA config BAR, no CmpltTO, no AER fatal
runtime lock:     concurrent access serializes through /tmp/lightning_xdma_observation.lock
```

Stage 57 acceptance should compare a fixed short bag against CPU baseline and
record trajectory drift, failed frames, fallback frames, observation counts, and
XDMA elapsed time.

## Stage 57 Result: Joint FPGA_OBS Online Performance Evidence (2026-06-21)

The correct online localization command is:

```bash
ros2 run lightning run_loc_online --config ./config/default_livox.yaml
```

With the temporary joint FPGA configuration, logs confirm that both online paths
really entered FPGA_OBS:

```text
[LaserMapping] mapping_backend=FPGA_OBS
[LidarLoc] backend=SURFEL_FPGA_OBS
```

Therefore the current online slowdown is not caused by a missing config switch.
The observed issue is performance, not golden correctness.

Profiling inputs:

```text
data/profile/fpga_obs_trace.csv
data/profile/loc_fpga_obs_trace.csv
```

Observed mapping FPGA_OBS profile:

```text
scan_points mean ~= 840
active_cells mean ~= 36,597
h2c_map mean ~= 6 ms
hls_wait mean ~= 178 ms
total mean ~= 344 ms
mutex_wait p95 ~= 1610 ms
```

Observed localization FPGA_OBS profile:

```text
scan_points mean ~= 5,756
active_blocks = 3,719
active_cells = 952,064
h2c_map mean ~= 147 ms
hls_wait mean ~= 1536 ms
total mean ~= 1852 ms
first rebuild_window ~= 213 ms
```

Correlation summary:

```text
Mapping hls_wait vs scan_points corr ~= 0.775
Mapping hls_wait vs miss_count corr ~= 0.876
Localization hls_wait vs scan_points corr ~= 0.908
Localization hls_wait vs miss_count corr ~= 0.771
```

Current diagnosis:

```text
Primary bottleneck: HLS observation lookup / PL DDR random access.
Secondary bottleneck: PCIe Gen2 x1, mainly visible in H2C map transfer.
Runtime contention: mapping and localization share one XDMA/HLS runtime lock.
Backlog symptoms: abnormal dt, lidar stream stall, and unstable trajectory happen after slow processing accumulates.
```

PCIe x1 still needs to be fixed later, but it is not the first-order cause of
the current 1Hz-class behavior. For localization, `h2c_map` is about `147 ms`,
while `hls_wait` is about `1536 ms`; even a large H2C improvement alone cannot
reach a 30Hz target.

Stage 57 is therefore not accepted as a real joint online bring-up. It is
accepted only as evidence that the online switches work and that the next work
must focus on unified observation performance.

## Stage 58: Windows/HLS Unified Observation Performance Optimization (Next)

Stage 58 should be performed on the Windows/Vitis HLS side before continuing
longer online joint tests.

Goals:

```text
Keep mapping golden counts at 611/0/171.
Keep localization golden counts at 6050/911/2.
Keep H/b within abs <= 1e-4 or rel <= 1e-3.
Reduce full localization hls_wait by at least 5x, preferably 20x+.
```

Required HLS performance cases:

```text
mapping golden frame_000001
localization golden frame_000001
synthetic sweep:
  scan_points = 256/512/1024/2048/4096/6963
  active_cells = 16k/32k/64k/128k/256k/512k/952k
```

Add debug counters in reserved output words or a debug build:

```text
point_count
neighbor_probe_count
block_lookup_count
obs_cell_read_count
exact_hit / neighbor_hit / miss
max_probe_per_point
```

Optimization priorities:

```text
1. Cache active_blocks in BRAM/URAM.
2. Reduce 26-neighbor binary searches per point.
3. Add hash/direct-index assist for block lookup.
4. Improve obs cell locality and burst behavior.
5. Check point-loop II, latency, cycles, and resource usage.
```

If the current lookup ABI cannot reach the required scale, move to ABI v2:

```text
Orin precomputes candidate block/cell indices.
FPGA performs only residual, Jacobian, HTH, HTr accumulation.
```

Stage 58 acceptance requires both mapping and localization XDMA golden replay to
remain numeric PASS after optimization.

## Stage 59: Orin Online Invocation and Active Window Optimization (Next)

Stage 59 should run in parallel with Stage 58, but it must not hide the HLS
kernel bottleneck.

Testing rules:

```yaml
# Mapping-only performance test
fpga:
  enable: true
  mapping:
    enable: true
    mode: fpga_obs
  localization:
    enable: false

# Localization-only performance test
fpga:
  enable: true
  mapping:
    enable: false
  localization:
    enable: true
    mode: fpga_obs
```

Do not use joint mapping + localization FPGA_OBS as the default performance
test, because it measures XDMA lock contention in addition to kernel time.

Localization active window should be bounded for FPGA_OBS:

```yaml
lidar_loc:
  surfel_fpga_max_active_blocks: 256
  surfel_fpga_max_active_cells: 65536
  surfel_fpga_window_radius_m: 30.0
```

These limits should only affect FPGA_OBS. NDT and CPU_SIM defaults should remain
unchanged.

Online invocation changes to evaluate:

```text
1. Smoke with max_iterations=1 for both mapping and localization FPGA_OBS.
2. Reuse one XdmaRuntime instance instead of reconstructing per observation.
3. Split PrepareFrame(scan/map upload) from RunPoseObservation(pose/output/control only).
4. Add active map cache so unchanged windows are not rewritten every iteration.
5. Later evaluate correspondence reuse / one-shot observation.
```

Stage 59 acceptance:

```text
mapping-only FPGA_OBS has no second-level mutex_wait tail.
localization-only FPGA_OBS has no mapping contention.
active_cells and h2c_map drop substantially.
hls_wait decreases with active_cells/scan_points.
No continuous abnormal dt or lidar stream stall.
```

## Stage 60: Joint Mapping + Localization FPGA_OBS Re-entry Gate

Only re-enter true joint Orin/FPGA mapping + localization bring-up after:

```text
Stage58 HLS golden replay performance improves substantially.
Stage59 mapping-only online smoke is stable.
Stage59 localization-only online smoke is stable.
No XDMA timeout / CmpltTO / AER fatal in either single-path test.
```

Joint configuration:

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

Stage 60 acceptance:

```text
mapping_backend=FPGA_OBS
localization backend=SURFEL_FPGA_OBS
XDMA mutex_wait no longer has second-level waits
Proc Lidar stays below the lidar frame period
No sustained abnormal dt / lidar stream stall
CPU baseline vs FPGA_OBS trajectory difference, failed frames, and fallback counts are recorded
```

## Stage 58 Windows/HLS Result: Active-Block Cache Optimization

Stage 58 Windows side has been implemented and verified. This stage only
optimizes unified observation lookup performance; it does not change math
semantics, BAR shim, XDMA/MIG topology, register map, PL DDR layout, or the
host-visible normal-equation ABI.

Implemented changes:

```text
HLS copies active_blocks[0..num_blocks) into local BRAM once per kernel launch.
LookupCell block binary search now reads the BRAM cache instead of PL DDR.
LookupNearest reuses per-point block-index results across the 27 center/neighbor probes.
obs_cells still stays in PL DDR.
output_words[32..39] now carry Stage 58 debug/performance counters.
```

Windows golden availability:

```text
localization golden: fpga/golden/localization/frame_000001
mapping golden:      fpga/golden/mapping/frame_000001
```

Windows validation results:

```text
g++ CSim:                 PASS
Vivado HLS 2018.3 CSim:   PASS
Vivado HLS C Synthesis:   PASS
Vivado HLS IP export:     PASS
Vivado BD validate:       PASS
Vivado project synthesis: PASS, -Jobs 18
Vivado implementation:    PASS, -Jobs 18
Bitstream generation:     PASS
```

Correctness stayed unchanged:

```text
localization frame_000001: 6050/911/2 PASS
mapping frame_000001:      611/0/171 PASS
reject_probe:              PASS
mapping_lookup_probe:      PASS
synthetic sweep:           PASS
```

Stage 58 debug counters from g++ CSim:

```text
localization:
  point_count=6963
  exact_hit=3573
  neighbor_hit=3388
  lookup_miss=2
  neighbor_probe=88140
  block_lookup=11467
  block_search_steps=136966
  obs_cell_read=94827
  valid_candidate=29160
  invalid_candidate=65943
  max_probe_per_point=27
  active_block_cache_count=3719

mapping:
  point_count=782
  exact_hit=384
  neighbor_hit=269
  lookup_miss=129
  neighbor_probe=10348
  block_lookup=1338
  block_search_steps=8339
  obs_cell_read=10735
  valid_candidate=1100
  invalid_candidate=10030
  max_probe_per_point=27
  active_block_cache_count=73
```

Vivado HLS C Synthesis summary:

```text
target clock:    10.00 ns
estimated clock: 9.307 ns
BRAM_18K:        184 / 1510 = 12%
DSP48E:          348 / 2020 = 17%
FF:              64051 / 554800 = 11%
LUT:             102449 / 277400 = 36%
```

Implementation summary:

```text
bitstream:
  fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
post-route WNS: 0.090 ns
post-route WHS: 0.028 ns
timing errors:  0
DRC errors:     0
critical warnings: 0
Slice LUTs:     75597 / 277400 = 27.25%
Slice Registers:88385 / 554800 = 15.93%
Block RAM Tile: 85.5 / 755 = 11.32%
DSPs:           348 / 2020 = 17.23%
Bonded IOB:     74 / 362 = 20.44%
```

Known implementation warnings remain non-fatal but must stay recorded:

```text
RAMB asynchronous-control warnings in generated HLS/XDMA FIFOs.
MIG clock placement warning relies on the existing CLOCK_DEDICATED_ROUTE exception.
Many HLS floating-point DSP input-pipeline advisories.
```

Build-time note: `-Jobs 18` is still required for board-level synthesis and
implementation. Full bitstream generation can still take tens of minutes
because Vivado 2018.3 uses only a small number of CPUs inside several route,
timing, and bitgen substeps.

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

After both golden replays still pass, measure `hls_wait` against Stage 57/54
baseline. Stage 58 target remains at least `5x` localization full-frame
`hls_wait` reduction. If this target is not reached, proceed to ABI v2:
Orin precomputes candidate block/cell indices and FPGA performs residual,
Jacobian, and H/b accumulation.

## Stage 58 Orin Result: Correctness PASS, Performance Improved but Below 5x Gate

Stage 58 Orin-side validation was run on 2026-06-22.

Report:

```text
reports/fpga/runtime/stage58_orin_optimization/
```

XDMA / PCIe gate:

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user present
/dev/xdma0_h2c_0 present
/dev/xdma0_c2h_0 present
enable=1
LnkCap: Speed 5GT/s, Width x4
LnkSta: Speed 5GT/s, Width x1 (downgraded)
```

Smoke:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

Localization full-frame golden replay:

```text
scan_count=6963
active_blocks=3719
active_cells=952064
expected_counts=6050/911/2
iter 1: STATUS=0x204 ERROR=0x0 RUN_COUNT=0->1 elapsed=0.350222s counts=6050/911/2
iter 2: STATUS=0x204 ERROR=0x0 RUN_COUNT=1->2 elapsed=0.350393s counts=6050/911/2
iter 3: STATUS=0x204 ERROR=0x0 RUN_COUNT=2->3 elapsed=0.349656s counts=6050/911/2
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3
```

Mapping full-frame golden replay:

```text
iter 1: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, wall real=0.17s
iter 2: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, wall real=0.16s
iter 3: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, wall real=0.17s
```

Stage 58 debug counters were visible in localization `output_words[32..39]`.
Decoded last iteration:

```text
point_count=6963
exact_hit=3573
neighbor_hit=3388
lookup_miss=2
neighbor_probe_count=88140
block_lookup_count=11467
block_search_steps=136966
obs_cell_read_count=94827
valid_candidate_count=29160
invalid_candidate_count=65943
max_probe_per_point=27
active_block_cache_count=3719
```

Performance result:

```text
Stage57 localization baseline hls_wait ~= 1.536s
Stage58 localization elapsed mean = 0.350090s
Speedup = 4.39x
5x gate = <= 0.307s
20x ideal = <= 0.077s
```

Conclusion:

```text
Correctness: PASS
Optimization effect: real and substantial
5x performance gate: FAIL
Joint online bring-up: keep blocked
Next HLS direction: ABI v2, Orin precomputes candidate block/cell indices and FPGA accumulates residual/Jacobian/H/b
```

Host-state note: the first localization replay attempt failed before HLS start
because `/tmp/lightning_xdma_observation.lock` was a stale user-owned file that
sudo could not write on this system. Recreating the lock file as root fixed the
host-state issue; this was not an FPGA/HLS failure.

## Stage 61 Windows/HLS Result: ABI V2 Candidate Observation

Stage61 implements the ABI V2 optimization after Stage58 improved correctness
and performance but missed the agreed 5x localization full-frame gate.

Current implementation:

- V1 fallback remains available when `SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2` is
  not set.
- V2 reuses `OBS_CELLS_BASE` as `candidate_cells[scan_count]`.
- Orin precomputes the final candidate `ObsCellFloat64` per scan point using
  the CPU/golden lookup policy.
- Orin writes `flags=0` for lookup miss candidates.
- FPGA reads `scan_points[i]` and `candidate_cells[i]` sequentially and only
  computes residual/Jacobian/H/b accumulation.
- BAR shim, XDMA/MIG, AXI-Lite register map, PL DDR base layout, and
  `SlamNormalEquation` output ABI remain unchanged.

Windows validation on 2026-06-22:

```text
g++ CSim:                 PASS
Vivado HLS CSim:          PASS
Vivado HLS C Synthesis:   PASS
Vivado HLS IP export:     PASS
Vivado BD validate:       PASS
Vivado project synthesis: PASS
Vivado implementation:    PASS
Bitstream generation:     PASS
Windows JTAG program:     PASS
```

Correctness:

```text
V1 localization: 6050/911/2 PASS
V1 mapping:      611/0/171 PASS
V2 localization: 6050/911/2 PASS
V2 mapping:      611/0/171 PASS
reject_probe:    PASS
mapping_probe:   PASS
```

Stage61 V2 debug counters confirm the lookup bottlenecks are bypassed:

```text
debug_magic=0x53543631 ("ST61")
localization V2: point_count=6963, candidate_valid=6961, candidate_miss=2,
                 block_lookup=0, block_search_steps=0, obs_cell_read=0
mapping V2:      point_count=782, candidate_valid=653, candidate_miss=129,
                 block_lookup=0, block_search_steps=0, obs_cell_read=0
```

Vivado HLS C Synthesis:

```text
target clock:    10.00 ns
estimated clock: 9.307 ns
BRAM_18K:        184 / 1510 = 12%
DSP48E:          348 / 2020 = 17%
FF:              66007 / 554800 = 11%
LUT:             105315 / 277400 = 37%
```

Board bitstream:

```text
bitstream: fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
post-route WNS: 0.071 ns
post-route WHS: 0.009 ns
timing: all user timing constraints met
DRC: 0 errors, 0 critical warnings
Slice LUTs: 76854 / 277400 = 27.71%
Slice Registers: 89411 / 554800 = 16.12%
Block RAM Tile: 85.5 / 755 = 11.32%
DSPs: 348 / 2020 = 17.23%
JTAG: JTAG_PROGRAM_PASS, FPGA_STATE=FPGA is configured, DONE pin 1
```

Next Orin gate:

```bash
./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates

./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates
```

Acceptance:

- localization V2 PASS: `6050/911/2`
- mapping V2 PASS: `611/0/171`
- Stage61 debug magic `0x53543631`
- V2 counters keep `block_lookup=0` and `obs_cell_read=0`
- localization full-frame `hls_wait <= 0.307s`
- no XDMA config BAR failure, `CmpltTO`, or AER fatal

If both V2 golden replays pass and the performance gate is met, enable
`fpga.runtime.candidate_abi_v2: true` first in mapping-only or
localization-only online smoke with `max_iterations=1`; do not immediately run
joint mapping + localization online.

## Stage 61 Orin Result: ABI V2 Candidate Golden PASS

Stage 61 Orin-side validation was run on 2026-06-22.

Report:

```text
reports/fpga/runtime/stage61_abi_v2_orin/
```

XDMA / PCIe gate:

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user present
/dev/xdma0_h2c_0 present
/dev/xdma0_c2h_0 present
enable=1
LnkCap: Speed 5GT/s, Width x4
LnkSta: Speed 5GT/s, Width x1 (downgraded)
```

Smoke:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

V1 regression remains valid:

```text
abi_v2_candidates=0
elapsed=0.373969s
counts=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
```

V2 localization golden replay:

```text
candidate_count=6963
candidate_valid=6961
candidate_miss=2
candidate_bytes=445632
iter 1: elapsed=0.120245s counts=6050/911/2 PASS
iter 2: elapsed=0.120295s counts=6050/911/2 PASS
iter 3: elapsed=0.120330s counts=6050/911/2 PASS
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 ABI_V2_CANDIDATES=1
```

V2 mapping golden replay:

```text
iter 1: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0150208
iter 2: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0149113
iter 3: MAPPING_XDMA_REPLAY_PASS, counts actual=611/0/171 expected=611/0/171, hls_wait_sec=0.0149318
candidate_count=782
candidate_valid=653
candidate_miss=129
candidate_bytes=50048
```

V2 debug counters confirmed the candidate path:

```text
debug_magic=0x53543631
point_count=6963
exact_hit=6961
neighbor_hit=0
lookup_miss=2
neighbor_probe_count=0
block_lookup_count=0
block_search_steps=0
obs_cell_read_count=0
valid_candidate_count=6961
invalid_candidate_count=2
debug_flags=0x00000001
```

Performance:

```text
Stage57 localization baseline = 1.536000s
Stage58 localization mean     = 0.350090s
Stage61 V2 localization mean  = 0.120290s
Speedup vs Stage57            = 12.77x
Speedup vs Stage58            = 2.91x
5x gate threshold             = <= 0.307s
Stage61 performance gate      = PASS
```

Conclusion:

```text
Correctness: PASS
V2 candidate path: PASS
Performance gate: PASS
PCIe link: still Gen2 x1, but Stage61 golden gate passes at x1
Next stage: Stage62 mapping-only and localization-only online V2 smoke
```

Stage62 should enable `fpga.runtime.candidate_abi_v2: true` only in controlled
single-path online tests first. Keep `max_iterations=1` for the first smoke and
do not immediately resume joint mapping + localization online.

## Stage 62 Windows Result: Localization Solve6x6 HLS / Bitstream Ready

Stage 62 Windows-side implementation was run on 2026-07-06.

Purpose:

- Move localization 6x6 solve onto FPGA as an optional extension after
  Candidate ABI V2 observation.
- Keep the first 320B `SlamNormalEquation` ABI unchanged.
- Append a 128B `SlamSolve6x6Result` at `OUTPUT_BASE + 0x140`.
- Keep BAR shim, XDMA/MIG, AXI-Lite register map, PL DDR layout, and Candidate
  ABI V2 unchanged.

Code/API changes:

- `SLAM_ACCEL_OBS_FLAG_SOLVE6X6 = 1 << 1`.
- `SlamSolve6x6Result` contains `magic/version/status/flags/dx[6]` plus
  damping/pivot/residual diagnostics.
- HLS `output_words` depth is now 56 64-bit words:
  - words `0..39`: existing observation output/debug counters
  - words `40..55`: solve6x6 output
- HLS uses double LDLT on `H + 1e-6 * I` and solves `dx = (H + damping I)^-1 * (-b)`.
- Orin runtime can call `RunLocalizationObservationV2Solve6x6()`.
- `run_surfel_loc_xdma_golden` now accepts `--fpga_solve6x6`.

Windows validation:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Results:

```text
g++ CSim: PASS
Vivado HLS CSim: PASS, CSim done with 0 errors
HLS C Synthesis: PASS
HLS IP export: PASS after existing Vivado 2018.3 core_revision workaround
BD validate: PASS
Project synthesis: PASS
Implementation/bitstream: PASS
```

Correctness gates in CSim:

```text
localization V1 PASS: 6050/911/2
localization V2 PASS: 6050/911/2
localization V2 solve6x6 PASS: status=1, dx matched testbench LDLT reference
mapping V1 PASS: 611/0/171
mapping V2 PASS: 611/0/171
```

HLS C Synthesis summary:

```text
target clock:    10.00 ns
estimated clock: 9.307 ns
BRAM_18K:        194 / 1510 = 12%
DSP48E:          365 / 2020 = 18%
FF:              78040 / 554800 = 14%
LUT:             118656 / 277400 = 42%
```

Post-implementation summary:

```text
bitstream: fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
WNS: 0.090 ns
WHS: 0.030 ns
Timing: all user specified timing constraints are met
DRC: 0 errors, 0 critical warnings; ordinary warnings/advisories remain
Slice LUTs: 86589 / 277400 = 31.21%
Slice Registers: 99787 / 554800 = 17.99%
Block RAM Tile: 90.5 / 755 = 11.99%
DSPs: 365 / 2020 = 18.07%
```

Next Orin gate:

```bash
./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates \
  --fpga_solve6x6

./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates
```

Acceptance:

- localization observation still `6050/911/2`
- `LOC_XDMA_SOLVE6X6_PASS`
- `dx[6]` tolerance: `abs <= 1e-7` or `rel <= 1e-5`
- mapping observation V2 still `611/0/171`
- no XDMA config BAR failure, `CmpltTO`, or AER fatal

## Stage 62 Orin Result: Localization Solve6x6 Golden PASS

Stage 62 Orin-side validation was run on 2026-07-06 after JTAG downloading the
Stage62 `azmig_wrapper.bit` and rebooting Orin.

XDMA gate:

```text
0005:01:00.0 [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
enable=1
PCIe link: 5GT/s x1, endpoint capability x4
```

Smoke:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

Localization V2 regression:

```text
abi_v2_candidates=1
fpga_solve6x6=0
scan_count=6963
COUNTS=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
HLS_WAIT_SEC=0.12032
```

Localization V2 + FPGA solve6x6:

```text
abi_v2_candidates=1
fpga_solve6x6=1
LOC_XDMA_SOLVE6X6_PASS
FPGA_SOLVE6X6_STATUS=1
COUNTS=6050/911/2
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 ABI_V2_CANDIDATES=1
```

Measured solve result:

```text
elapsed_sec=[0.120416260, 0.120113495, 0.120796971]
elapsed_mean=0.120442242
speedup_vs_stage57_1536ms=12.753x
speedup_vs_stage61_120290ms=0.999x
dx=[-0.048509941555978785,
    -0.041637405753014667,
     0.023276896564930594,
     0.0017501070996257212,
     0.0058700982657821452,
    -0.0012874587746111517]
dx_norm=0.068321888
solve max_abs=6.93889e-18
solve max_rel=6.93889e-18
```

Mapping V2 regression:

```text
MAPPING_XDMA_REPLAY_PASS
STATUS=0x204
ERROR=0x0
RUN_COUNT=4->5
SCAN_COUNT_READBACK=782
abi_v2_candidates=1
candidate_count=782
candidate_valid=653
candidate_miss=129
hls_wait_sec=0.0149056
counts actual=611/0/171 expected=611/0/171
values_ok=1
max_abs=0.268571
max_rel=1.99295e-05
worst_field=H(3,3)
```

Conclusion:

```text
Stage62 Orin golden gate: PASS
Localization observation V2: PASS
Localization FPGA solve6x6: PASS
Mapping observation V2 regression: PASS
Next stage: Stage63 online SURFEL_FPGA_OBS_SOLVE runtime integration
```

Report:

```text
reports/fpga/runtime/stage62_solve6x6_orin/
```

## Stage 63 Plan: Localization FPGA_OBS_SOLVE Runtime

Stage63 starts only after Stage62 Orin golden PASS.

- `SURFEL_FPGA_OBS_SOLVE` should stop degrading to `SURFEL_FPGA_OBS`.
- Localization online path uses FPGA observation + FPGA solve `dx`.
- CPU still applies `SE3::exp(dx) * pose`, convergence checks, quality gates,
  and fallback.
- Keep `SURFEL_FPGA_OBS`, `SURFEL_CPU_SIM`, and NDT fallback.
- Add profile fields: `fpga_solve_sec`, `fpga_solve_status`, `dx_norm`,
  `dx[6]`.
- First online smoke is localization-only with `max_iterations=1`.

## Stage 63 Code Result: Online FPGA_OBS_SOLVE Runtime Integrated

Stage63 Orin-side code integration was completed on 2026-07-06.

Implemented:

- `fpga.localization.mode=fpga_obs_solve` and `fpga_solve` now select
  `SURFEL_FPGA_OBS_SOLVE` instead of degrading to `SURFEL_FPGA_OBS`.
- `fpga_full` currently warns and uses `SURFEL_FPGA_OBS_SOLVE`, because Stage63
  covers observation + localization solve6x6 only.
- `SurfelLocXdmaBackend` now exposes `ComputeObservationAndSolve6x6()` and calls
  `XdmaRuntime::RunLocalizationObservationV2Solve6x6()`.
- Online `LidarLoc` uses FPGA-returned `dx[6]` for
  `SURFEL_FPGA_OBS_SOLVE`; CPU still applies `SE3::exp(dx) * pose`, convergence
  checks, quality gates, output transform, PGO, UI, and fallback.
- UI, `[loc_profile]`, and `loc_fpga_obs_trace.csv` now include
  `fpga_solve_status`, `fpga_solve_ms`, and `dx_norm`.

Regression:

```text
colcon build --packages-select lightning: PASS
Stage62 golden replay with --abi_v2_candidates --fpga_solve6x6: PASS
LOC_XDMA_SOLVE6X6_PASS status=1 max_abs=6.93889e-18 max_rel=6.93889e-18
COUNTS=6050/911/2
HLS_WAIT_SEC=0.120614
```

Online smoke configuration:

```yaml
fpga:
  enable: true
  runtime:
    candidate_abi_v2: true
  mapping:
    enable: false
  localization:
    enable: true
    mode: fpga_obs_solve
    fallback: ndt_omp
lidar_loc:
  surfel_max_iterations: 1
```

Expected online markers:

```text
backend=SURFEL_FPGA_OBS_SOLVE
fpga_solve_status=1
dx_norm=...
fallback_cpu_sim=0
fallback_ndt=0
```

Stage63 online smoke result:

```text
PASS
command: ros2 run lightning run_loc_online --config ./config/default_livox.yaml
bag: /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3
mapping_backend=CPU
backend=SURFEL_FPGA_OBS_SOLVE
candidate_abi_v2=1
online solve calls: 46
fpga_solve_status=1 on captured calls
fallback_cpu_sim=0
fallback_ndt=0
mapping FPGA_OBS success lines: 0
```

Timing summary:

```text
xdma total mean: 121.033 ms
hls_wait mean: 118.972 ms
h2c_map mean: 1.166 ms
h2c_candidate mean: 1.166 ms
mutex_wait mean: 0.0007 ms
dx_norm mean: 0.02036
```

Representative `[loc_profile]`:

```text
frame=30 backend=SURFEL_FPGA_OBS_SOLVE success=1 loc_total_ms=139.070
lio_frontend_ms=4.602 lidar_loc_ms=137.723 pgo_ms=1.303
scan_points=7033 active_blocks=663 active_cells=169728 iterations=1
valid/reject/miss=6545/482/6
xdma_total_ms=127.545 hls_wait_ms=125.315
h2c_map_ms=1.289 h2c_candidate_ms=1.289 mutex_wait_ms=0.001
fpga_solve_status=1 dx_norm=0.017 fallback_cpu_sim=0 fallback_ndt=0
status=0x204 error=0x0
```

Conclusion:

- `fpga.localization.mode=fpga_obs_solve` now truly enters online
  `SURFEL_FPGA_OBS_SOLVE`.
- FPGA solve6x6 online path is functionally enabled.
- Remaining online runtime is dominated by FPGA observation/HLS wait, not the
  solve6x6 step.

## Stage 64 Plan: Mapping ESKF Update CPU Golden Refactor

Do not write HLS for mapping update before this stage passes.

- Extract the lidar/surfel update portion of `ESKF::Update()` into a CPU-testable
  function.
- Fixed inputs: `HTH/HTr`, propagated `P`, current `dx`, `R`, degeneracy
  threshold, step limits, and state snapshot.
- Fixed outputs: updated `dx_current[NavState::dim]`, status/debug flags, and
  either updated covariance `P` or enough intermediate data for CPU covariance
  update.
- Generate mapping update golden and prove the extracted function matches the
  current CPU path before any FPGA EKF update work.

Stage64 implementation result:

```text
PASS
colcon build --packages-select lightning: PASS
export_mapping_eskf_update_golden: PASS
run_mapping_eskf_update_golden_replay: PASS
```

What changed:

- The lidar/surfel update math from `ESKF::Update()` is now factored into a
  standalone CPU helper.
- The online CPU path still calls the same math and keeps the original
  iteration, convergence, reject, AA, covariance, and fallback behavior.
- `LaserMapping` can capture a real mapping update golden from a rosbag run.
- `run_mapping_eskf_update_golden_replay` replays the helper against the saved
  golden.

Stage64 golden:

```text
fpga/golden/mapping_update/frame_000001/update_input.bin
fpga/golden/mapping_update/frame_000001/update_expected.bin
fpga/golden/mapping_update/frame_000001/update_meta.yaml
```

Observed replay:

```text
MAPPING_ESKF_UPDATE_CPU_REPLAY_PASS
frame_index=20
iteration_index=0
nullity=0
dx_norm=0.00471868
dx_max_abs=0
cov_max_abs=0
state_max_abs=6.50049e-20
flags_ok=1
```

Observation regression after refactor:

```text
MAPPING_CPU_REPLAY_PASS counts actual=611/0/171 expected=611/0/171
MAPPING_XDMA_REPLAY_PASS counts actual=611/0/171 expected=611/0/171
```

Conclusion:

- Stage64 CPU golden gate is complete.
- Stage65 may start, but mapping EKF update must be implemented as a separate
  HLS IP/core and must keep Stage61 observation V2 as the fallback path.

## Stage 65 Plan: Mapping EKF Update HLS Core

Stage65 starts only after Stage64 CPU golden PASS.

- Add a separate HLS IP such as `slam_ekf_update_core`; do not merge it into
  `unified_surfel_observation_core`.
- First version only supports fixed-dimension lidar/surfel pose observation
  update.
- Runtime sequence: FPGA observation V2 -> FPGA EKF update -> CPU policy and
  fallback.
- If full 23D covariance update is too expensive, first land FPGA solve/update
  `dx` and keep covariance on CPU, recorded as `FPGA_OBS_SOLVE_PARTIAL`.

Guardrails:

- Stage61 Candidate ABI V2 remains the default observation performance path and
  fallback.
- `FPGA_FULL` is not considered complete until Stage65 mapping EKF update gates
  pass.
- PCIe Gen2 x1/x4 performance work remains separate from solve/update
  correctness.
