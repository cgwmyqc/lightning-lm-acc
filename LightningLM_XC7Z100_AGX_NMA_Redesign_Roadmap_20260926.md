# Lightning-LM：AGX Orin + XC7Z100 导航建图协处理器整改路线
## 面向真实芯片化应用的 FPGA 架构、资源预算、验证与 CODEX 执行计划

**版本**：2026-09-26  
**目标器件**：AMD/Xilinx Zynq-7000 `XC7Z100-2FFG900I`  
**当前主机**：NVIDIA Jetson AGX Orin  
**当前互联**：PCIe Gen2 ×4 + XDMA + PL DDR3/MIG  
**Windows 开发机**：Vivado / Vivado HLS 2018.3，JTAG 已连接 FPGA  
**Orin 地址**：`192.168.31.119`  
**代码基线**：以最新 `src(1).zip` 为 Orin 侧基线，结合当前 `fpga.zip` 与 `vivado.zip`  
**最终定位**：将 FPGA 设计收敛为可复用的“Navigation & Mapping Accelerator（NMA）”硬件模块，未来可从 PCIe FPGA 原型迁移为 SoC/ASIC 中专门辅助 CPU 的导航建图加速模块。

---

# 0. CODEX 执行总原则

本路线不是“继续往 FPGA 里增加更多小 Kernel”，而是重构为一个面向真实产品的、可复用的导航建图协处理器。

CODEX 必须遵守以下原则：

1. **任何大改之前必须先完成 Phase 0 可行性论证。**
2. **每次只改变一个主要变量**，例如先改变 XDMA Runtime，再改变 Map Residency，再改变 Search，再改变 Pipeline；禁止一次同时修改所有层。
3. **任何优化都必须同时回答四个问题**：
   - 算法结果是否仍与 CPU/GOLDEN 对齐；
   - 实际 wall-clock 是否变快；
   - FPGA kernel cycle 是否减少；
   - LUT / FF / BRAM / DSP / Timing 是否在预算内。
4. **不能只看 Vivado HLS 的百分比资源报告。**
   当前存档 HLS 日志虽然设置了 `xc7z100ffg900-2`，但出现过与 XC7Z020 类似的资源基数。后续必须记录绝对 LUT/FF/BRAM/DSP 数，并用 XC7Z100 Vivado OOC/整机综合再次核验。
5. **Vivado 工程必须脚本化。**
   不允许把 GUI 中手工连线作为唯一工程源。修改 `create_bd.tcl`、约束 Tcl、IP export Tcl，再由脚本生成工程。
6. **保留 CPU fallback。**
   FPGA timeout、map version 不一致、硬件 error、PCIe 掉线时必须能够退回 CPU，而不是让 SLAM 整体失效。
7. **最终硬件边界围绕 Scan-to-Map 内循环设计。**
   ROS2、传感器接入、IMU 预处理、全局地图管理、PGO/UI 等继续由 CPU 负责。
8. **产品接口不绑定 XDMA。**
   XDMA/PCIe 只是当前开发板传输层；核心 NMA 应只依赖 AXI4 Master、AXI-Lite/descriptor、IRQ 和片外存储抽象，未来可替换为 SoC NoC/系统 DDR。

---

# 1. 当前工程状态判断

最新 Orin 代码已经增加：

```text
SURFEL_FPGA_FULL_ITERATIVE
        ↓
RunLocalizationIterative()
        ↓
kernel_sel = 6
```

因此定位模式已经从：

```text
Iter0 → PCIe
Iter1 → PCIe
Iter2 → PCIe
Iter3 → PCIe
```

改善为：

```text
一次 H2C
   ↓
FPGA 内部 Iter0
   ↓
FPGA 内部 Iter1
   ↓
FPGA 内部 Iter2
   ↓
FPGA 内部 Iter3
   ↓
一次 C2H
```

这是正确方向，必须保留。

但最新版仍存在五个结构性问题。

## 1.1 Candidate 仍由 Orin 计算

当前 `surfel_loc_xdma_backend.cc` 在调用 FPGA 前仍会根据初始 `pose_guess`：

```text
Transform Point
     ↓
TryLookupNearest()
     ↓
生成 candidate_cells[]
```

因此最重要的 Map Lookup/Search 仍然在 CPU 上。

---

## 1.2 FPGA 多轮迭代没有每轮重新建立 Correspondence

CPU 算法：

```text
Pose0
 ↓
Search0
 ↓
Solve
 ↓
Pose1
 ↓
Search1
 ↓
Solve
 ↓
Pose2
```

当前 FPGA FULL ITERATIVE：

```text
Pose0
 ↓
CPU Search0 一次
 ↓
FPGA
 ↓
Iter0 使用 candidate0
 ↓
Pose1
 ↓
Iter1 仍使用 candidate0
 ↓
Pose2
 ↓
Iter2 仍使用 candidate0
```

因此当前 FPGA 模式还不是严格等价的 iterative scan-to-map。

**下一阶段必须把 Search 放进 FPGA iteration loop。**

---

## 1.3 HLS Point Loop 没有形成真正流水线

当前 `slam_loc_iterative_core.cpp`：

```cpp
for (iter ...) {
    for (point ...) {
        TransformPoint(...);
        residual = ...;
        Jacobian = ...;
        Accumulate(H, b);
    }
    Solve6x6(...);
}
```

点循环只有 `LOOP_TRIPCOUNT`，没有真正解决：

```text
H += JᵀJ
b += Jᵀr
```

导致的 loop-carried dependency。

必须重构为：

```text
Point Stream
  ├── PE0 → partial H0/b0
  ├── PE1 → partial H1/b1
  ├── PE2 → partial H2/b2
  └── PE3 → partial H3/b3
                 ↓
            Tree Reduction
                 ↓
                H/b
```

---

## 1.4 Mapping 的 FPGA_FULL 仍不是完整迭代

当前 Mapping FULL 大致仍是：

```text
ExportActiveMap
     ↓
CPU candidate
     ↓
PCIe
     ↓
kernel 4 Observation
     ↓
PCIe 返回
     ↓
kernel 5 EKF Update
     ↓
PCIe 返回
```

并且 `iteration_index=0 / finish_update=true`。

最终应变成一个 FPGA 内部闭环：

```text
State0
 ↓
Search
 ↓
Observation/Hb
 ↓
ESKF Update
 ↓
State1
 ↓
重新 Search
 ↓
Observation/Hb
 ↓
ESKF Update
 ↓
...
```

---

## 1.5 XDMA Runtime 仍有明显 Host 开销

最新版仍存在：

```text
每次 Run
 ↓
open /dev/xdma0_user
open /dev/xdma0_h2c_0
open /dev/xdma0_c2h_0
 ↓
配置寄存器
 ↓
START
 ↓
轮询 STATUS
 ↓
sleep 1 ms
 ↓
再次轮询
 ↓
close
```

另外 Mapping 当前还在函数内部临时构造 `XdmaRuntime`。

这属于 bring-up 写法，不是产品化实时写法。

---

# 2. XC7Z100-2FFG900I 资源基线与硬预算

AMD 官方 Zynq-7000 资源表中，XC7Z100 PL 资源为：

| 资源 | XC7Z100 |
|---|---:|
| Logic Slices | 69,350 |
| LUT | 277,400 |
| FF | 554,800 |
| BRAM36 | 755 |
| BRAM 总容量 | 27,180 Kb，约 3.32 MiB raw |
| DSP48E1 | 2,020 |
| MMCM/PLL | 8 |

注意：

> **3.32 MiB BRAM 是整个 FPGA 的总片上 RAM，不是全部都可以分给地图。**

还必须给：

- XDMA；
- MIG/AXI；
- Scan Buffer；
- Search Cache；
- FIFO；
- H/b accumulator；
- 控制寄存器；
- 调试逻辑；
- CDC；

留下资源。

---

# 3. 本项目 FPGA 资源预算规则

不要追求 95% 资源利用率。

真实芯片产品需要：

- 时序余量；
- 后续功能扩展；
- 布线余量；
- Debug/安全逻辑；
- 工程稳定性。

建议设置以下资源闸门。

## 3.1 Algorithm Core 目标预算

NMA 算法核心本身优先控制在：

| 资源 | 建议目标 |
|---|---:|
| LUT | ≤ 130k，约 47% |
| FF | ≤ 220k，约 40% |
| DSP | ≤ 900，约 45% |
| BRAM36 | ≤ 420，约 56% |

这是**设计目标**，不是理论极限。

---

## 3.2 整机实现硬闸门

包含：

- XDMA；
- MIG；
- AXI；
- NMA；
- Controller；
- CDC；
- IRQ；

整个 bitstream 建议不得长期超过：

| 资源 | Hard Gate |
|---|---:|
| LUT | ≤ 72% |
| FF | ≤ 65% |
| DSP | ≤ 65% |
| BRAM | ≤ 75% |

超过该值时优先：

1. 减少 PE；
2. 降低 Cache；
3. 共享 Solver/ESKF；
4. 使用混合精度；

而不是继续堆资源。

---

# 4. 地图大小分析：为什么正式架构不能依赖“整图进 BRAM”

当前 ABI：

```cpp
ObsCellFloat64 = 64 B
ActiveBlockRecord = 32 B
CellsPerBlock = 8 × 8 × 4 = 256
```

已知当前项目中曾出现约：

```text
active_blocks ≈ 295
active_cells  ≈ 75,520
```

则仅 Cell：

| Cell 格式 | 75,520 cells 占用 |
|---|---:|
| 当前 64 B | 4.61 MiB |
| 32 B | 2.30 MiB |
| 24 B | 1.73 MiB |
| 16 B | 1.15 MiB |

XC7Z100 全部 BRAM raw 只有约：

```text
3.32 MiB
```

所以：

### 当前 64 B 数据结构已经不可能整图放入 BRAM。

32 B 虽然理论上能放下当前规模，但会吃掉约 69% 全部 BRAM，剩余空间不足以支持：

- 多 PE；
- Scan Ping-Pong；
- Hash Table；
- FIFO；
- 其他系统 IP。

因此正式方案确定为：

# **PL DDR / System DDR = 权威地图**
# **BRAM = 热点 Block Cache**

---

# 5. 面向未来芯片的最终硬件边界

定义新的硬件模块：

# `Navigation & Mapping Accelerator — NMA`

逻辑边界如下：

```text
                    CPU / Orin
                        │
          ┌─────────────┴─────────────┐
          │                           │
        ROS2                      Global Map
        IMU                       PGO / Loop
        LiDAR                     UI / Logging
        Undistort                 CPU Fallback
        Downsample                    │
          │                           │
          └─────────────┬─────────────┘
                        │
                  command/scan/map delta
                        │
                        ▼
════════════════════════════════════════════
               NMA Hardware Module
════════════════════════════════════════════
                        │
           ┌────────────▼────────────┐
           │   Persistent Map Store │
           │   DDR + BRAM Cache     │
           └────────────┬────────────┘
                        │
                  Block Lookup
                        │
                  Cell Search
                        │
                  Best Surfel
                        │
                 Residual/J
                        │
                Multi-PE H/b
                        │
                  6×6 Solver
                        │
          ┌─────────────┴─────────────┐
          │                           │
    Localization Update          Mapping ESKF
          │                           │
          └─────────────┬─────────────┘
                        │
                  Convergence
                        │
                  Final State
                        │
                     IRQ
```

---

# 6. 为什么该架构适合甲方最终“芯片”

当前：

```text
Orin
  ↕ PCIe
XC7Z100
  ↕
PL DDR
```

只是验证平台。

NMA 核心不得依赖：

```text
XDMA device path
/dev/xdma...
PCIe BAR 特定地址
```

最终设计接口抽象为：

```text
AXI4 Memory Master
AXI-Lite / Descriptor Queue
Interrupt
Clock / Reset
```

未来做 ASIC / SoC 时：

```text
PCIe/XDMA → SoC NoC
PL DDR    → System DDR
BRAM      → SRAM Macro
DSP48     → MAC/FPU
```

而：

```text
Search
Residual
H/b
Solver
ESKF
```

主体不变。

这就是本次整改必须从“开发板工程”升级为“芯片 IP 架构”的原因。

---

# 7. Windows CODEX 能否统一完成整个开发流程

## 结论

**可以以 Windows CODEX 作为唯一开发控制台。**

但含义是：

> CODEX 在 Windows 上统一编辑、调用 Vivado、调用 JTAG、通过 SSH 控制 Orin。

不是：

> 把 Orin Linux 编译过程搬到 Windows。

推荐执行模型：

```text
                Windows CODEX
                     │
       ┌─────────────┼──────────────┐
       │             │              │
       ▼             ▼              ▼
  Vivado HLS      Vivado/JTAG     PowerShell
       │             │              │
       ▼             ▼              ▼
  CSim/CSynth     Program FPGA   ssh/scp
                                      │
                                      ▼
                              192.168.31.119
                                      │
                              Build Lightning-LM
                              Run XDMA Test
                              Run ROS2 Bag
                              Collect Profile
```

---

# 8. Windows 环境必须先补齐的自动化

CODEX 首先增加：

```text
tools/
├── windows/
│   ├── env.ps1
│   ├── 00_preflight.ps1
│   ├── 10_hls_csim.ps1
│   ├── 11_hls_csynth.ps1
│   ├── 12_hls_export_ip.ps1
│   ├── 20_vivado_build.ps1
│   ├── 21_program_jtag.ps1
│   ├── 30_orin_preflight.ps1
│   ├── 31_orin_build.ps1
│   ├── 32_orin_pcie_rescan.ps1
│   ├── 33_run_golden.ps1
│   ├── 34_run_benchmark.ps1
│   └── 90_collect_reports.ps1
│
└── orin/
    ├── pcie_rescan.sh
    ├── xdma_benchmark.sh
    ├── build_lightning.sh
    ├── run_lightning_benchmark.sh
    └── collect_tegrastats.sh
```

`env.ps1` 不允许写死密码，只定义：

```powershell
$env:ORIN_HOST = "192.168.31.119"
$env:ORIN_USER = "<USER>"
$env:ORIN_ROOT = "<LIGHTNING_REPO_PATH>"

$env:VIVADO_2018_3 = "C:\Xilinx\Vivado\2018.3"
$env:VIVADO_HLS_2018_3 = "C:\Xilinx\Vivado\2018.3"
```

SSH 必须使用 key。

CODEX 不应依赖 Remote Desktop GUI 操作 Orin。

---

# 9. JTAG 更新后的 PCIe 恢复流程

重新下载 bitstream 后 PCIe Endpoint 会重置。

必须自动测试：

```text
JTAG Program
    ↓
Orin lspci
    ↓
Endpoint 仍在？
    │
    ├── YES → 继续
    │
    └── NO
         ↓
PCI remove/rescan
         ↓
仍失败？
         │
         ├── NO → 继续
         └── YES → reboot Orin
```

`pcie_rescan.sh` 应：

1. 找到 Xilinx BDF；
2. 安全卸载 XDMA；
3. remove endpoint；
4. `/sys/bus/pci/rescan`；
5. 重新加载 `xdma.ko`；
6. 检查 `/dev/xdma*`；
7. 输出：

```text
LnkSta: Speed 5GT/s, Width x4
```

如果硬件不支持稳定热重枚举，则保留 reboot fallback。

---

# 10. Phase 0 — 必须先做可行性论证

# **禁止在 Phase 0 PASS 前重构大架构。**

目的不是优化，而是建立：

```text
真实 CPU baseline
真实 FPGA baseline
真实 PCIe latency/bandwidth
真实 HLS cycle
真实资源
真实 accuracy
```

---

## P0.1 建立代码基线

CODEX：

1. 将最新 `src(1)` 作为 `src/`；
2. 与当前 `fpga/`、`vivado/` 合并；
3. 打 tag：

```text
baseline_20260926_before_nma_redesign
```

4. 保存：
   - YAML；
   - bitstream；
   - HLS IP；
   - Orin executable；
   - rosbag；
   - golden。

---

## P0.2 验证 Windows → Orin 自动控制

Windows 执行：

```powershell
ssh $env:ORIN_USER@$env:ORIN_HOST "hostname && uname -a"
```

然后：

```powershell
ssh ... "lspci -nn | grep -i 10ee"
ssh ... "ls -l /dev/xdma*"
```

PASS 条件：

- CODEX 可以非交互 SSH；
- 可以 scp；
- 可以远程 build；
- 可以远程启动 benchmark；
- 可以自动收回 CSV/log。

---

## P0.3 验证 JTAG 自动编程

新建：

```text
program_hw.tcl
```

使用：

```tcl
open_hw_manager
connect_hw_server
open_hw_target
set_property PROGRAM.FILE <bit> [current_hw_device]
program_hw_devices [current_hw_device]
```

Windows：

```powershell
vivado.bat -mode batch -source program_hw.tcl
```

PASS：

- 能自动下载；
- Orin 可以恢复 PCIe；
- XDMA smoke PASS。

---

## P0.4 PCIe/XDMA 基线

测试 payload：

```text
4 KiB
64 KiB
128 KiB
512 KiB
1 MiB
8 MiB
32 MiB
```

分别测：

```text
H2C
C2H
Round Trip
```

输出：

```csv
size_bytes,h2c_MBps,c2h_MBps,h2c_us,c2h_us
```

必须确认：

```text
PCIe = Gen2 ×4
```

大块顺序传输若明显低于约 0.7~1 GB/s，优先处理：

- PCIe link；
- XDMA；
- CPU affinity；
- driver；
- buffer；

不要先优化 HLS。

---

## P0.5 增加真正的 FPGA Cycle 计数

现有 RTL 已有：

```text
CTRL_CYCLE_COUNT = 0x018
```

CODEX 应先做一个**仅 profiling 的小补丁**：

`XdmaRuntime` 每次 DONE 后读取：

```text
CYCLE_COUNT
```

计算：

```text
kernel_ms = cycle_count / kernel_clk_hz × 1000
```

必须同时输出：

```text
host_hls_wait_ms
fpga_cycle_ms
polling_overhead_ms
```

---

## P0.6 CPU vs FPGA 基线

同一个 rosbag、同一个 YAML、同一个下采样参数。

至少测试：

```text
CPU
FPGA_OBS
FPGA_FULL_ITERATIVE
```

每种：

- warmup 100 frames；
- 统计后续 ≥500 frames。

输出：

```csv
frame,
backend,
num_points,
iterations,
candidate_build_ms,
map_export_ms,
pack_scan_ms,
open_ms,
h2c_scan_ms,
h2c_candidate_ms,
h2c_map_ms,
reg_ms,
fpga_cycles,
fpga_kernel_ms,
host_wait_ms,
c2h_ms,
total_fpga_call_ms,
eskf_ms,
frame_total_ms,
cpu_usage,
active_blocks,
active_cells
```

统计：

```text
mean
P50
P95
max
std
```

---

## P0.7 当前 FPGA 真实资源基线

对当前三个核心：

```text
unified_surfel_observation_core
slam_loc_iterative_core
slam_ekf_update_core
```

执行：

```text
CSim
CSynth
Export IP
Vivado OOC Synthesis
```

记录绝对值：

```text
LUT
FF
DSP48
BRAM36
Latency
II
Fmax / Slack
```

### 不允许只记录百分比。

最终对完整 Vivado BD：

```tcl
report_utilization
report_timing_summary
report_power
```

保存到：

```text
reports/baseline/
```

---

# 11. Phase 0 GO / NO-GO 闸门

以下全部 PASS 才进入大改。

| 项目 | GO 条件 |
|---|---|
| Windows SSH Orin | 全自动 |
| Windows JTAG | 全自动 |
| PCIe | Gen2 ×4 稳定 |
| XDMA | 大块吞吐无异常 |
| Current Golden | PASS |
| CPU Baseline | 已记录 |
| FPGA Baseline | 已记录 |
| FPGA Cycle Count | 已可读取 |
| Vivado Utilization | 已有绝对值 |
| Timing | 当前 bitstream 可正常闭合 |

如果其中任何一个 FAIL：

> **先修基础设施，不进入 NMA V3。**

---

# 12. Phase 1 — 先消灭 Host/XDMA 软件开销

这一阶段不改算法。

目标：

```text
相同 FPGA kernel
相同输出
只减少 Orin↔FPGA 软件延迟
```

---

## P1.1 XdmaRuntime 持久化

当前：

```text
Run()
 ↓
open
 ↓
work
 ↓
close
```

改成：

```text
XdmaRuntime::Open()
    ↓
程序生命周期保持
    ↓
Run()
Run()
Run()
...
    ↓
XdmaRuntime::Close()
```

长期保持：

```text
user_fd
h2c_fd
c2h_fd
```

Mapping 不允许每 frame：

```cpp
XdmaRuntime runtime(...);
```

必须成为长生命周期对象。

---

## P1.2 BAR mmap

测试：

```text
/dev/xdma0_user
```

是否可 mmap。

如果驱动支持：

```text
Read32 / Write32
```

从：

```text
pread/pwrite syscall
```

改为：

```text
volatile uint32_t* BAR
```

如果 mmap 不可靠，则保留 persistent fd + pread/pwrite。

---

## P1.3 去除 1 ms Polling

短期：

```text
1 ms
 ↓
20~50 us polling
```

长期：

```text
XDMA user IRQ / MSI-X
```

硬件：

```text
NMA done
 ↓
IRQ
 ↓
XDMA event
 ↓
Orin wake
```

---

## P1.4 Production 模式关闭 verify_readback

默认：

```text
verify_readback = false
```

仅：

```text
debug/golden
```

开启。

---

## P1 验收

算法结果完全不变。

要求：

```text
FPGA kernel_cycles == Phase0
```

但：

```text
total_fpga_call_ms
```

必须明显下降。

如果不下降，停止并找 syscall/DMA 开销。

---

# 13. Phase 2 — Localization V3：把 Search 放进 FPGA Iteration Loop

这是本轮整改的**第一核心阶段**。

新的：

```text
slam_loc_iterative_v3_core
```

输入不再是：

```text
scan + candidate
```

而是：

```text
scan
initial_pose
map_header
active_blocks
obs_cells
params
```

FPGA 每轮：

```text
Pose
 ↓
Transform
 ↓
Map Lookup
 ↓
Neighbor Search
 ↓
Best Cell
 ↓
Residual/J
 ↓
H/b
 ↓
Solve
 ↓
Pose Update
 ↓
重新 Search
```

---

# 14. Phase 2 先做 Micro-Benchmark，不立刻接 Lightning

先新增：

```text
fpga/hls/lookup_bench_core/
```

功能：

```text
scan + pose + map
 ↓
Search
 ↓
输出 candidate index / hit/miss
```

不计算 H/b。

---

## P2.1 Lookup 正确性测试

必须覆盖：

```text
positive coordinate
negative coordinate
block boundary
cell boundary
6-neighbor
18-neighbor
26-neighbor
empty cell
invalid block
mapping selection rule
localization selection rule
```

必须与 CPU：

```text
SurfelLocBackend::TryLookupNearest()
```

逐点对齐。

未经证明禁止修改算法语义。

---

## P2.2 Lookup 性能可行性闸门

使用真实 golden：

```text
~7k–8k points
```

测：

```text
Orin BuildCandidateCells()
vs
FPGA lookup_bench
```

### GO 条件

推荐：

```text
FPGA Search kernel
≤ 0.5 × Orin Candidate Build time
```

至少必须：

```text
FPGA Search < Orin Search
```

否则：

> 不允许马上集成进 full iterative，需要先优化 Cache/Search。

这是整个项目是否值得把 Search 搬 FPGA 的关键实验。

---

# 15. Map Storage V3：DDR 权威地图 + BRAM Cache

## 15.1 第一版先保留 64B Cell

第一版不要同时改变：

```text
Search Architecture
+
Cell Precision
```

先沿用：

```text
ObsCellFloat64 = 64B
```

保证算法完全等价。

地图在 PL DDR 常驻。

---

## 15.2 Block Directory 常驻 BRAM

当前 Block metadata 很小。

例如：

```text
8192 block × 32 B
≈ 256 KiB
```

可以放 BRAM。

第一版：

```text
sorted ActiveBlockRecord
+
binary search
```

先保持 CPU 算法一致。

第二版再改：

```text
BRAM Hash Directory
```

---

# 16. Block Hash Directory

最终产品不建议每个 point 对 block list 做 binary search。

设计：

```text
block_xyz
   ↓
hash
   ↓
set / open addressing
   ↓
block DDR address
```

建议：

```text
2-way / 4-way
```

或：

```text
linear probe max 4~8
```

必须设置：

```text
hash_miss
hash_collision
max_probe
```

性能计数器。

如果 Hash 失败，可以：

```text
fallback binary search
```

保证功能正确。

---

# 17. BRAM Hot Block Cache

一个 Block：

```text
256 cells
```

如果当前 64 B：

```text
16 KiB / block
```

若以后 32 B：

```text
8 KiB / block
```

因此可以设计约 1 MiB Cell Cache：

| Cell | Cache line | 1 MiB 可缓存 |
|---|---:|---:|
| 64B | 16 KiB/block | 64 blocks |
| 32B | 8 KiB/block | 128 blocks |

推荐第一版：

```text
64 block cache
2-way set associative
```

Map Cell Cache 占约：

```text
1 MiB
```

---

# 18. Block Cache 必须 bank 化

如果只使用普通 Dual-Port BRAM：

```text
一次只能读 1~2 cell
```

不能发挥 26 邻域并行。

缓存必须拆成：

```text
BANK0
BANK1
BANK2
BANK3
...
```

建议从：

```text
4 banks
```

开始。

若资源/时序允许再做：

```text
8 banks
```

Cell：

```text
bank = cell_index % NUM_BANKS
row  = cell_index / NUM_BANKS
```

Neighbor Scheduler 负责处理 bank conflict。

---

# 19. DDR Cache Miss

Cache miss 时：

```text
Block Key
 ↓
DDR Address
 ↓
Burst Read 整个 Block
 ↓
BRAM Cache Line
```

不要：

```text
一个 neighbor
 ↓
一次随机 DDR read
```

这是 FPGA 性能关键。

必须统计：

```text
cache_hit
cache_miss
cache_eviction
cache_hit_ratio
ddr_block_fill_bytes
ddr_block_fill_cycles
```

真实 rosbag warm-up 后建议目标：

```text
cache_hit_ratio ≥ 85%
```

如果长期低于 70%，暂停增加 PE，先解决 Map locality/cache。

---

# 20. Scan Buffer

当前最大：

```text
kMaxScanPoints = 8192
```

每点：

```text
16 B
```

单帧：

```text
128 KiB
```

使用 Ping-Pong：

```text
Scan Buffer A = 128 KiB
Scan Buffer B = 128 KiB
```

总计：

```text
256 KiB
```

Frame N FPGA 计算时：

```text
CPU / DMA 准备 Frame N+1
```

---

# 21. 片上 BRAM 粗预算

第一版可按：

```text
Scan Ping-Pong         ~256 KiB
Block Directory        ~128~256 KiB
Cell Block Cache       ~1024 KiB
FIFO / Queue           ~128 KiB
Partial H/b            很小
Control/Metadata       ~64 KiB
Reserve                ≥512 KiB
```

目标：

```text
NMA BRAM 使用 ≈ 1.5~1.8 MiB
```

而不是把全部 3.32 MiB 用满。

---

# 22. Phase 3 — 真正做 FPGA Pipeline

这是第二核心阶段。

不要在原 CPU C++ 外面简单添加：

```cpp
#pragma HLS PIPELINE
```

必须重构数据通路。

---

# 23. 推荐 Dataflow

```text
┌──────────────┐
│ Scan Loader  │
└──────┬───────┘
       │ stream
       ▼
┌──────────────┐
│ Transform    │
│ + Encode     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Block Lookup │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Neighbor Gen │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Cell Cache   │
│ + Miss Fill  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Best Surfel  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Residual/J   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Partial H/b  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Reduction    │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Solve/Update │
└──────────────┘
```

使用：

```cpp
#pragma HLS DATAFLOW
```

连接：

```text
hls::stream
```

---

# 24. Neighbor Offset 不要动态三层循环

当前：

```cpp
for dz
  for dy
    for dx
```

产品版本建议变为静态 ROM：

```text
neighbor_offsets_6[6]
neighbor_offsets_18[18]
neighbor_offsets_26[26]
```

根据 mode 选择有效长度。

好处：

- 更利于 unroll；
- 更利于 scheduler；
- 分支减少；
- 延迟可预测。

---

# 25. Point Transform 使用 FP32 数据路径

输入 scan 与 map 本来是 FP32。

建议：

```text
Point Transform    FP32
Search Distance    FP32
Residual           FP32
Jacobian           FP32
```

不要一进入 FPGA 就全部转 `double`。

---

# 26. H/b 使用“混合精度”逐级验证

不能直接为了资源把全部 double 删除。

分三组实验。

### A — Golden Baseline

```text
FP32 点运算
FP64 H/b accumulation
FP64 Solve
```

先追求精度。

### B — Mixed Precision

```text
FP32 partial H/b
FP64 final reduction
FP64 Solve
```

### C — Full FP32 Experimental

仅用于性能对比。

只有：

- Golden；
- APE/RPE；
- 实际项目精度；

全部无明显下降时，才允许使用。

---

# 27. Multi-PE H/b

先做：

```text
PE = 1
```

证明 correctness。

然后：

```text
PE = 2
PE = 4
PE = 8
```

每种都做：

```text
CSynth
OOC synth
Timing
Resource
Real FPGA benchmark
```

---

## 27.1 推荐第一产品目标

先以：

# **4 PE**

作为主目标。

不直接做 8 PE。

---

## 27.2 4 PE 结构

```text
Point Scheduler
     │
 ┌───┼────┬────┐
 ▼   ▼    ▼    ▼
PE0 PE1  PE2  PE3
 │   │    │    │
H0  H1   H2   H3
b0  b1   b2   b3
 └───┼────┴────┘
     ▼
 Tree Reduce
     ▼
    H/b
```

---

# 28. 解决 H/b Loop Dependency

每个 PE 不要所有 point 更新同一个 accumulator。

可以使用：

```text
ACC_BANKS = 8 / 16
```

按 point index：

```text
acc_bank = point_index % ACC_BANKS
```

每组有：

```text
H_upper[21]
b[6]
```

point loop 完成后：

```text
bank reduction
 ↓
PE reduction
```

这样给 floating add latency 留出足够间隔。

---

# 29. Clock Plan

当前：

```text
XDMA AXI = 125 MHz
HLS      = 125 MHz
```

新架构：

```text
PCIe/XDMA domain = 125 MHz
Control domain   = 125 MHz

        CDC / AXI Clock Converter

Algorithm domain = 150→175→200 MHz
```

---

## 29.1 升频顺序

禁止一开始要求 200 MHz。

按：

```text
125 MHz
 ↓
150 MHz
 ↓
175 MHz
 ↓
200 MHz
```

每一步都必须：

```text
post-route timing PASS
```

建议最终：

```text
WNS > 0
```

并尽量保留至少：

```text
0.2~0.3 ns
```

工程余量。

---

# 30. 200 MHz 的意义

8192 点，4 iterations：

```text
32768 point-iterations
```

若有效：

```text
II = 8
```

仅 point pipeline 理论时间：

```text
32768 × 8 / 200 MHz
≈ 1.31 ms
```

若：

```text
II = 4
```

约：

```text
0.66 ms
```

真实时间还包括：

- Search；
- cache miss；
- solver；
- DDR；

因此不能把该理论值当最终性能，但它说明：

> **Pipeline/II 比单纯把 125 MHz 提到 200 MHz 更重要。**

---

# 31. Phase 3 可行性判据

4 PE 只有满足：

```text
speedup(4PE vs 1PE) ≥ 2.5×
```

才认为并行有效。

如果：

```text
4PE ≈ 1PE
```

说明瓶颈在：

```text
DDR
Cache
Search
Bank Conflict
```

禁止继续堆 8 PE。

---

# 32. Phase 4 — Persistent Map / Dirty Block

当前每次：

```text
ExportActiveMap
 ↓
传整个 Map
```

不是产品架构。

新的协议：

```text
MAP_RESET
MAP_FULL_LOAD
MAP_DIRTY_UPDATE
MAP_DELETE_BLOCK
LOCATE_FRAME
MAP_FRAME
```

---

## 32.1 Map Version

维护：

```text
window_id
window_version
block_version
```

FPGA：

```text
map_version_current
```

CPU 发：

```text
expected_map_version
```

不一致：

```text
ERROR_MAP_VERSION
```

禁止使用错误地图计算。

---

## 32.2 Dirty Block Update

Mapping CPU 更新地图后：

```text
Dirty Blocks
 ↓
PCIe
 ↓
PL DDR
 ↓
invalidate/update corresponding BRAM cache
```

而不是下一帧重新发送整个地图。

---

# 33. 当前 1 GB PL DDR 的使用原则

当前地址窗口：

```text
0x00000000..0x3fffffff
```

即：

```text
1 GiB
```

因此产品原型完全可以让：

```text
Local Sparse Map
```

长期常驻。

例如 8192 blocks：

### 64 B cell

```text
8192 × 256 × 64
≈ 128 MiB
```

### 32 B cell

```text
≈ 64 MiB
```

均远小于 1 GiB。

因此：

> 地图容量问题应该由 DDR 解决，BRAM 只解决 latency/bandwidth。

---

# 34. Phase 5 — Cell ABI 压缩

这一步必须排在：

```text
in-loop lookup PASS
+
persistent map PASS
```

以后。

不能一开始同时改精度。

---

## 34.1 先统计真实数据分布

CODEX 增加 histogram：

```text
centroid range
normal range
plane_d range
quality range
count max/P95/P99
```

再决定压缩。

---

## 34.2 推荐 32B 目标格式

目标类似：

```text
centroid xyz     12 B
normal xyz       12 B
plane_d           4 B
meta              4 B
----------------------
                  32 B
```

其中 `meta` 可根据真实数据决定：

```text
flags
count
quality quantized
```

如果 quality 不能安全量化，则不要强行 32 B。

---

## 34.3 16B 只作为实验

16B 可以让当前约 75k cells 只占：

```text
~1.15 MiB
```

但必须量化：

- centroid；
- normal；
- quality；

算法风险更高。

因此 16B 不是第一产品版本的强制目标。

---

# 35. Phase 6 — Localization V3 正式集成

到此时 `SURFEL_FPGA_FULL_ITERATIVE` 改为：

```text
Scan
Initial Pose
Map ID/Version
Params
```

不再传：

```text
candidate_cells[]
```

---

## 35.1 FPGA 内部语义必须等价 CPU

每次 iteration：

```text
Pose_i
 ↓
重新 Search
 ↓
Correspondence_i
 ↓
H_i / b_i
 ↓
Solve
 ↓
Pose_i+1
```

必须与：

```text
SurfelLocBackend CPU
```

逐 iteration 比较：

```text
valid
reject
miss
H
b
dx
pose
```

---

# 36. Localization V3 验收

至少三层。

## 36.1 Unit Golden

```text
point lookup exact
counts exact
pose tolerance pass
```

## 36.2 Frame Golden

真实帧：

```text
CPU iterative
vs
FPGA iterative
```

## 36.3 Trajectory

同一数据集：

```text
CPU trajectory
vs
FPGA trajectory
```

输出：

```text
ATE / APE
RPE
max translation diff
max rotation diff
```

---

# 37. Phase 7 — Mapping Iterative Core

Localization 稳定以后才进入。

不要继续维持：

```text
kernel 4 observation
+
kernel 5 EKF
```

两个 PCIe transaction。

---

# 38. 共享计算引擎，而不是复制 Core

甲方最终芯片不应同时放：

```text
Localization Observation Core
Mapping Observation Core
Localization Solver Core
Mapping Solver Core
EKF Core
```

大量重复资源。

最终：

```text
Shared Search Engine
Shared Residual/J Engine
Shared H/b Engine
Shared Small Matrix Engine
```

通过：

```text
MODE = LOCALIZATION
MODE = MAPPING
```

时分复用。

---

# 39. Mapping Iterative 数据流

CPU：

```text
IMU Propagation
 ↓
start_state
P
scan
```

FPGA：

```text
Iteration 0
  Search(state0)
  Observation
  H/b
  ESKF
  state1

Iteration 1
  Search(state1)
  Observation
  H/b
  ESKF
  state2

...

Convergence
```

返回：

```text
Final State
Final P
Statistics
```

一次 H2C + 一次 C2H。

---

# 40. Map Incremental 第一版仍留 CPU

不要同时做全部 Mapping。

第一产品阶段：

```text
FPGA:
Search
Observation
H/b
Iteration
ESKF

CPU:
MapIncremental
Dirty Block generation
```

这是合理边界。

---

# 41. 后续才搬 BatchUpdate / DirtyRefit

只有 Mapping iterative 性能和精度稳定后，再考虑：

```text
BatchUpdate
DirtyRefit
Surfel refit
```

进入 FPGA。

这些属于下一轮芯片化，不属于本次第一优先级。

---

# 42. Phase 8 — 产品化 NMA Command Interface

定义统一 descriptor：

```cpp
struct NmaCommand {
    uint32_t opcode;
    uint32_t flags;

    uint64_t scan_addr;
    uint32_t scan_count;

    uint64_t map_addr;
    uint32_t map_version;

    uint64_t state_in_addr;
    uint64_t state_out_addr;

    uint32_t max_iterations;
    uint32_t nearby_type;
};
```

Opcode：

```text
NOP
MAP_RESET
MAP_FULL_LOAD
MAP_DIRTY_UPDATE
LOCALIZE
MAPPING_UPDATE
GET_STATS
```

当前 PCIe 版本可将它映射到：

```text
PL DDR + BAR doorbell
```

未来 SoC：

```text
Shared DDR + MMIO doorbell
```

---

# 43. NMA 必须提供硬件 Performance Counters

至少：

```text
total_cycles
scan_load_cycles
map_lookup_cycles
cache_hit
cache_miss
hash_collision
neighbor_probe
valid_count
reject_count
miss_count
hb_cycles
solve_cycles
ekf_cycles
ddr_read_bytes
ddr_write_bytes
iteration_count
timeout_count
error_code
```

未来性能问题不能继续依赖猜测。

---

# 44. 双缓冲与 CPU/FPGA 并行

目标：

```text
Frame N:
FPGA Scan-to-Map

同时：

Frame N+1:
Orin preprocess / undistort / downsample
```

通过：

```text
Scan Buffer A
Scan Buffer B
```

交替。

Map Dirty Update 可以排在 frame boundary。

---

# 45. 不要优先升级 PCIe ×8

当前 Gen2 ×4 对最终目标数据量足够。

未来没有 Candidate 后：

```text
8192 points × 16 B
≈ 128 KiB/frame
```

10 Hz：

```text
≈ 1.25 MiB/s
```

即使加 Dirty Map，也远低于 Gen2 ×4 带宽。

当前瓶颈主要是：

- transaction；
- search；
- DDR random access；
- pipeline；
- H/b dependency；

不是 PCIe 理论带宽。

PCIe ×8 排在系统优化后期。

---

# 46. 实际应用性能目标

由于真实激光雷达约 10 Hz，整个系统并不需要追求无意义的数百 Hz。

芯片模块真正价值应定义为：

1. **降低 CPU 占用；**
2. **提高最坏情况确定性；**
3. **为导航/建图留出 AI / Planning CPU 资源；**
4. **降低整体算力平台压力；**
5. **形成可固化 IP。**

建议指标分三级：

### Must

```text
AGX+FPGA end-to-end 不得慢于纯 AGX
```

### Target

```text
Scan-to-map inner loop ≥ 1.5× CPU
CPU SLAM workload 明显下降
```

### Stretch

典型：

```text
~8k points
4 iterations
```

硬件 inner loop：

```text
约数 ms 级
```

最终数值必须由 Phase 0~3 实测确定，不能在未测试前写死。

---

# 47. Real Application Test Matrix

至少测试：

```text
静态室内
窄走廊
大平面
多墙角
楼梯/高低变化
快速旋转
低纹理/低结构
长距离运行
回到旧区域
地图窗口切换
```

参数组合：

```text
nearby = 6
nearby = 18
nearby = 26

points:
2k
4k
8k

iterations:
1
2
4
8
```

---

# 48. Synthetic Stress Test

生成：

```text
active_blocks:
64
256
512
1024
2048
4096
8192
```

测试：

```text
Cache hit
Cache miss storm
Hash collision
DDR throughput
Worst-case 26 neighbor
```

这样才能证明架构能从实验地图扩展到真实项目。

---

# 49. 每一个 Stage 的 CODEX 交付物

每阶段必须生成：

```text
CURRENT_STATUS.md
CHANGELOG_STAGE_xx.md
benchmark/*.csv
reports/*.rpt
logs/*.log
```

并明确：

```text
PASS / FAIL
```

禁止只有“代码已修改”。

---

# 50. 每阶段固定执行顺序

CODEX 必须遵守：

```text
1. 修改代码
2. CPU unit/golden
3. HLS CSim
4. HLS CSynth
5. 记录绝对资源
6. Export IP
7. Vivado OOC
8. Vivado timing
9. Integrate BD
10. Generate bit
11. JTAG program
12. Orin PCIe recover
13. XDMA smoke
14. FPGA golden
15. Real rosbag benchmark
16. Accuracy comparison
17. 写结论
```

任何一步 FAIL：

```text
STOP
```

不要自动进入下一阶段。

---

# 51. 建议 Stage 划分

## Stage R0 — Baseline & Automation

完成 Phase 0。

结果：

```text
BASELINE_PASS
```

---

## Stage R1 — XDMA Runtime Optimization

只改：

```text
persistent FD
BAR access
poll/IRQ
cycle count
```

结果：

```text
XDMA_RUNTIME_OPT_PASS
```

---

## Stage R2 — Lookup Microbench

建立：

```text
lookup_bench_core
```

证明 FPGA Search 值得做。

结果：

```text
FPGA_LOOKUP_FEASIBILITY_PASS
```

---

## Stage R3 — Persistent Map + In-loop Lookup

建立：

```text
loc_iter_v3
```

先 1 PE、125 MHz。

结果：

```text
LOC_V3_FUNCTION_PASS
```

---

## Stage R4 — Block Cache

加入：

```text
DDR authoritative map
BRAM cache
cache counters
```

结果：

```text
MAP_CACHE_PASS
```

---

## Stage R5 — Pipeline + Multi-PE

依次：

```text
1PE
2PE
4PE
```

结果：

```text
LOC_PIPELINE_4PE_PASS
```

---

## Stage R6 — 150/175/200 MHz

逐级 Timing Closure。

结果：

```text
LOC_200MHZ_PASS
```

若 200 MHz 不划算：

```text
LOC_175MHZ_FINAL
```

也可以接受。

不能为了数字牺牲稳定性。

---

## Stage R7 — Cell Format Optimization

64B → 32B experimental。

结果：

```text
CELL32_ACCURACY_PASS
```

---

## Stage R8 — Mapping Iterative Unified Core

共享：

```text
Search
Residual
H/b
Small Matrix
```

结果：

```text
MAPPING_ITERATIVE_PASS
```

---

## Stage R9 — Dirty Map / Product NMA Interface

实现版本化 persistent map。

结果：

```text
NMA_V1_PRODUCT_ARCH_PASS
```

---

# 52. 第一轮建议 CODEX 只执行到哪里

本轮不要一次做到 R9。

建议第一轮只做到：

```text
R0
 ↓
R1
 ↓
R2
```

也就是：

# **先证明 FPGA Lookup + Pipeline 在真实地图上有性能价值。**

只有：

```text
FPGA_LOOKUP_FEASIBILITY_PASS
```

以后，才投入较大工作重构 `loc_iter_v3`。

这是整个方案最重要的风险控制点。

---

# 53. Phase 0 后必须回答的 10 个问题

CODEX 在开始 R3 前必须写报告回答：

1. 纯 Orin 每帧平均/P95 多久？
2. 最新 FPGA FULL ITERATIVE 每帧平均/P95 多久？
3. CPU Candidate Search 多久？
4. H2C 多久？
5. FPGA 真实 cycle time 多久？
6. 1 ms polling 浪费多少？
7. C2H 多久？
8. 当前核心各自 LUT/FF/BRAM/DSP 多少？
9. 当前完整 bitstream Timing/Resource 如何？
10. FPGA lookup_bench 是否比 Orin Search 快？

只要第 10 项答案是：

```text
NO
```

就不允许盲目继续集成。

---

# 54. 第一阶段最值得 CODEX 立即修改的文件

Orin：

```text
core/fpga/xdma_runtime.h
core/fpga/xdma_runtime.cc

core/localization/surfel_loc/
core/localization/lidar_loc/

core/lio/laser_mapping.cc
```

FPGA：

```text
fpga/abi/slam_accel_abi.h

fpga/hls/slam_loc_iterative_core/
fpga/hls/unified_surfel_observation_core/

新增：
fpga/hls/lookup_bench_core/
```

Vivado：

```text
vivado/slam_accel_ax7z100_pcie_mig/create_bd.tcl
rtl/slam_accel_ctrl/
```

---

# 55. 不建议本轮优先修改的内容

暂时不要投入大量时间到：

```text
PGO
Loop Closure
ROS UI
Map Visualization
FPGA Full MapIncremental
PCIe ×8
FPGA PS Cortex-A9
```

这些不是当前性能瓶颈。

---

# 56. 重要：不要让 XC7Z100 上存在三套重复数学硬件

当前：

```text
Unified Obs
Loc Iter
EKF Update
```

逐渐演进后可能资源重复。

最终 NMA 应设计成：

```text
one Search Engine
one Observation Engine
one H/b Engine
one Solver Engine
one ESKF Engine
```

由 FSM/Command Scheduler：

```text
Localization
Mapping
```

分时复用。

这样最符合未来芯片 IP。

---

# 57. 推荐最终物理结构

```text
                       NMA
┌────────────────────────────────────────────┐
│ AXI-Lite / Command Queue                  │
│               │                            │
│        Command Scheduler / FSM            │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Scan Ping-Pong  │                   │
│      └────────┬────────┘                   │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Transform Engine│                   │
│      └────────┬────────┘                   │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Block Hash/Dir  │◄──── BRAM         │
│      └────────┬────────┘                   │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Block Cell Cache│◄──── BRAM Banks   │
│      └────────┬────────┘                   │
│               │ miss                       │
│               ├──────────► AXI DDR Master  │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Search Engine   │                   │
│      └────────┬────────┘                   │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Residual/J PE   │                   │
│      └────────┬────────┘                   │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Partial H/b PE  │                   │
│      └────────┬────────┘                   │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Reduction       │                   │
│      └────────┬────────┘                   │
│               │                            │
│      ┌────────▼────────┐                   │
│      │ Small Matrix    │                   │
│      │ Solve / ESKF    │                   │
│      └────────┬────────┘                   │
│               │                            │
│      State/Pose Update / Iteration FSM     │
│               │                            │
│            Result / IRQ                    │
└────────────────────────────────────────────┘
```

---

# 58. 最终验收关注的不只是“FPS”

未来甲方芯片模块的报告至少包含：

```text
Latency
P95 Latency
CPU offload ratio
FPGA utilization
FPGA power
DDR bandwidth
PCIe bandwidth
Cache hit
Iteration count
Accuracy
Long-run stability
Fallback count
```

---

# 59. 最终设计决策总结

本次整改正式采用：

## 决策 1

```text
CPU 管系统
FPGA 管 Scan-to-Map 内循环
```

## 决策 2

```text
地图 DDR 常驻
BRAM Hot Cache
```

而不是：

```text
整张地图强塞 BRAM
```

## 决策 3

```text
FPGA 每轮重新 Search
```

而不是：

```text
CPU 初始 candidate 固定多轮
```

## 决策 4

```text
Pipeline + Multi-PE
```

优先于：

```text
单纯升频
```

## 决策 5

```text
Localization 先证明
Mapping 后复用
```

## 决策 6

```text
共享硬件引擎
```

而不是堆大量独立 HLS Core。

## 决策 7

```text
Windows CODEX 统一编排
```

本地完成：

```text
HLS + Vivado + JTAG
```

通过 SSH 远程完成：

```text
Orin build + run + benchmark
```

## 决策 8

```text
先 R0/R1/R2 测试论证
```

只有 FPGA Search 真实优于 Orin Search 后，才进入大规模架构整改。

---

# 60. CODEX 第一条执行指令

CODEX 收到本文档后，**不要立即重写 HLS Core**。

第一任务应为：

```text
Stage R0 — Baseline & Automation
```

完成：

1. Windows→Orin SSH 自动化；
2. Vivado/JTAG 自动化；
3. PCIe/XDMA benchmark；
4. CPU baseline；
5. FPGA baseline；
6. Cycle Counter；
7. HLS/Vivado absolute resource report；
8. Golden；
9. 输出 `R0_FEASIBILITY_REPORT.md`。

只有：

```text
R0_BASELINE_PASS
```

后，进入：

```text
Stage R1
```

再进入：

```text
Stage R2 lookup_bench_core
```

---

# 61. R0_FEASIBILITY_REPORT.md 必须包含的最终结论模板

```markdown
# R0 Feasibility Report

## Hardware
- FPGA:
- PCIe:
- DDR:
- XDMA:

## CPU Baseline
- frame mean:
- frame P95:
- ESKF mean:
- candidate/search mean:

## FPGA Baseline
- frame mean:
- frame P95:
- candidate build:
- H2C:
- kernel cycle:
- host wait:
- C2H:

## PCIe Benchmark
...

## Current Resource
| Core | LUT | FF | BRAM | DSP | Clock | Timing |
...

## Accuracy
...

## Risks
...

## GO / NO-GO

R0_BASELINE_PASS = YES/NO
```

---

# 62. 最后的工程原则

本项目最终目的不是证明：

> “某个数学公式可以在 FPGA 上运行。”

而是证明：

> **“导航建图中最重、最重复、最确定的 Scan-to-Map 内循环，可以作为独立硬件模块，以可预测的延迟、有限的片上资源和可扩展的外部地图容量，长期辅助 CPU 工作。”**

因此本次整改所有选择都应围绕：

```text
可测量
可复现
可流水
可缓存
可共享
可扩展
可回退
可芯片化
```

展开。

---

## 参考器件资料

资源基线应以 AMD Zynq-7000 Technical Reference Manual / Device Resource Table 中 XC7Z100 的绝对资源数为准。  
当前工程使用 Vivado/Vivado HLS 2018.3，因此 HLS 百分比只能作为辅助信息；最终资源与时序必须以 `XC7Z100-2FFG900` Vivado 综合/实现报告为准。
