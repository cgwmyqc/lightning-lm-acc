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
