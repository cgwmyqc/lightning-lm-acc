# Lightning-LM 点面 ICP 正规方程 FPGA 加速行动路线（x64 Ubuntu 22.04 + XDMA User BAR 版 v4）

> 目标读者：Codex / 代码开发助手 / 后续人工开发者  
> 当前平台：x64 Lenovo 台式机 + Ubuntu 22.04 + ROS2 Humble + Xilinx XDMA PCIe FPGA 板卡  
> 当前硬件状态：已在 Vivado BD 中打开 `PCIe to AXI Lite Master Interface`，保留 `AXI Memory Mapped` DMA 数据接口；`/dev/xdma0_user → AXI GPIO → LED`、H2C/C2H DDR 写读回均已通过；阶段 4 正在集成 HLS 导出的 `simple_accel_core` 标准 IP。当前 Address Editor 采用：
> - `xdma_0/M_AXI → HP0_DDR_LOWOCM`：`0x00000000 [1G]`
> - `xdma_0/M_AXI_LITE → axi_gpio_0/S_AXI`：`0x00000000 [4K]`
> - `xdma_0/M_AXI_LITE → simple_accel_core_0/s_axi_control`：`0x00001000 [4K]`
> - `simple_accel_core_0/Data_m_axi_gmem → HP0_DDR_LOWOCM`：`0x02000000 [32M]`。  
> 核心原则：不要把整个 Lightning-LM 搬到 FPGA；第一阶段只加速 `LaserMapping::ObsModel()` 中点面 ICP 的 `JᵀJ / Jᵀr` 构建与累加。  
> 重要变更：上一版路线以“没有 `/dev/xdma0_user`”为前提，推荐 DDR mailbox 轮询。现在硬件已增加 User BAR/AXI-Lite 控制通道，因此主线应改为 **XDMA AXI-MM DDR 数据通道 + `/dev/xdma0_user` AXI-Lite 控制寄存器通道**。DDR mailbox 仅保留为备选方案。

---

## 0. 当前状态与路线修正

### 0.1 已完成或正在完成的工作

当前已经完成：

```text
1. x64 Ubuntu 22.04 主机能识别 FPGA PCIe 设备。
2. XDMA 驱动已能编译并加载。
3. 早期版本已生成 /dev/xdma0_h2c_0、/dev/xdma0_c2h_0、/dev/xdma0_control。
4. Vivado BD 已从“仅 DMA/Config BAR”升级为：
   - XDMA M_AXI       → 数据通道 → Zynq PS HP0 → DDR
   - XDMA M_AXI_LITE → 控制通道 → AXI GPIO / 后续算法 IP S_AXI_LITE
5. bitstream 已固化到 FPGA。
```

当前最重要的验证目标已经变成：

```text
1. Linux 侧是否出现 /dev/xdma0_user。
2. /dev/xdma0_user 是否能读写 AXI GPIO 寄存器。
3. AXI GPIO 输出是否能点亮/翻转板载 LED。
4. /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 是否仍能稳定读写 DDR。
```

### 0.2 上一版路线中需要废弃或降级的内容

上一版文档有一条核心假设：

```text
当前没有 user BAR，因此第一版不要依赖 /dev/xdma0_user，采用 DDR mailbox 轮询控制。
```

该假设已经不再作为主线。现在改为：

```text
主线：
    /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 负责大块数据搬运
    /dev/xdma0_user 负责算法 IP 控制寄存器读写

备选：
    DDR mailbox 轮询保留为备用路线，仅当 /dev/xdma0_user 无法稳定识别或 AXI-Lite 控制路径失败时使用。
```

---

## 1. 修正后的总体架构

推荐最终架构：

```text
x64 Ubuntu / ROS2 / Lightning-LM
    │
    ├── /dev/xdma0_h2c_0
    │       pwrite(input packet, input_addr)
    │
    ├── /dev/xdma0_user
    │       write input_addr / output_addr / num_points / start
    │       poll status.done
    │
    └── /dev/xdma0_c2h_0
            pread(result, output_addr)

FPGA
    │
    ├── XDMA M_AXI
    │       ↓
    │   axi_smc_data
    │       ↓
    │   Zynq PS S_AXI_HP0
    │       ↓
    │   Zynq DDR
    │
    └── XDMA M_AXI_LITE
            ↓
        axi_smc_ctrl
            ↓
        AXI GPIO / simple_accel_core.S_AXI_LITE / icp_plane_accel_core.S_AXI_LITE
```

后续正式算法 IP 建议接口：

```text
icp_plane_accel_core
    S_AXI_LITE：控制寄存器，由 /dev/xdma0_user 访问
    M_AXI     ：主动访问 Zynq DDR，读取输入 packet，写回 result
```

---

## 2. 新的阶段划分

### 阶段 1：重新枚举 PCIe，确认 User BAR

每次 bitstream 固化或重刷后，建议冷启动主机，或者执行 PCIe remove/rescan。

检查命令：

```bash
sudo rmmod xdma || true
sudo insmod ~/Data1/fpga_acc/lightlm_fpga_acc/dma_ip_drivers/XDMA/linux-kernel/xdma/xdma.ko poll_mode=1

lspci -nnk -d 10ee:
ls -l /dev/xdma*
sudo dmesg | grep -Ei "xdma|identify_bars|map_single_bar|user|10ee" | tail -100
```

期望结果：

```text
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/dev/xdma0_control
/dev/xdma0_user
```

dmesg 中期望看到：

```text
identify_bars: 2 BARs: config ..., user ..., bypass -1
```

不能再是：

```text
user -1
```

如果仍然没有 `/dev/xdma0_user`：

```text
1. 确认 XDMA IP 的 PCIe : BARs 页面已勾选 PCIe to AXI Lite Master Interface。
2. 确认 User BAR size 合理，建议 64KB 或 Vivado 允许的最小值。
3. 确认重新生成 bitstream、重新 Generate Output Products、重新 Create HDL Wrapper。
4. 确认主机重新枚举 PCIe；只下载 bitstream 不一定会刷新 BAR。
5. 暂时回退到上一版 DDR mailbox 路线。
```

---

### 阶段 2：验证 `/dev/xdma0_user → AXI GPIO → LED`

AXI GPIO 地址假设：

```text
Address Editor:
    xdma_0/M_AXI_LITE
        axi_gpio_0/S_AXI
            Offset Address = 0x00000000
            Range          = 64K 或 4K
```

AXI GPIO 常用寄存器偏移：

```text
0x00 GPIO_DATA：第 1 通道数据寄存器
0x04 GPIO_TRI ：第 1 通道方向寄存器，bit=0 输出，bit=1 输入
```

推荐先把 AXI GPIO 配置成：

```text
GPIO Width = 1 或 4
All Outputs = true
Dual Channel = false
Interrupt = false
```

如果 LED 接在 `GPIO_0_tri_o[0]`，XDC 示例：

```tcl
set_property PACKAGE_PIN <LED_PIN> [get_ports {GPIO_0_tri_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_0_tri_o[0]}]
```

`<LED_PIN>` 必须替换成板卡原理图或卖家 XDC 中真实 LED 管脚。

测试程序建议新增：

```text
tools/reg_rw_user.c
```

也可以直接使用 Xilinx `tools/reg_rw`。

测试命令：

```bash
# 设置 GPIO 为输出
sudo ./reg_rw /dev/xdma0_user 0x04 w 0x00000000

# 输出 1
sudo ./reg_rw /dev/xdma0_user 0x00 w 0x00000001
sudo ./reg_rw /dev/xdma0_user 0x00 r

# 输出 0
sudo ./reg_rw /dev/xdma0_user 0x00 w 0x00000000
sudo ./reg_rw /dev/xdma0_user 0x00 r
```

验收标准：

```text
1. /dev/xdma0_user 存在。
2. 0x00 写入后能读回。
3. GPIO_0 对应 LED 能随 0/1 翻转，注意有些 LED 是低电平点亮。
```

---

### 阶段 3：验证 XDMA AXI-MM DDR 写读回

保留上一版 DDR 测试。

推荐 DDR 测试地址：

```text
0x0100_0000：基础读写测试区
0x0200_0000：后续输入 buffer
0x0300_0000：后续输出 buffer
```

测试：

```bash
python3 - <<'PY'
from pathlib import Path
p = Path('/tmp/xdma_pattern_4k.bin')
p.write_bytes(bytes((i * 17 + 3) & 0xff for i in range(4096)))
print(p, p.stat().st_size)
PY

sudo ./tools/dma_to_device \
  -d /dev/xdma0_h2c_0 \
  -f /tmp/xdma_pattern_4k.bin \
  -s 4096 \
  -a 0x01000000 \
  -c 1

sudo ./tools/dma_from_device \
  -d /dev/xdma0_c2h_0 \
  -f /tmp/xdma_readback_4k.bin \
  -s 4096 \
  -a 0x01000000 \
  -c 1

cmp /tmp/xdma_pattern_4k.bin /tmp/xdma_readback_4k.bin && echo PASS
```

验收标准：

```text
Ubuntu → H2C → DDR → C2H → Ubuntu 完整闭环 PASS。
```

---

### 阶段 4：HLS 标准 IP 版 simple_accel_core 协处理链路验证

本阶段目标是验证真正的协处理器闭环：

```text
Host 通过 /dev/xdma0_h2c_0 写 input 到 DDR
Host 通过 /dev/xdma0_user 写 simple_accel_core 控制寄存器
simple_accel_core 通过 M_AXI 主动读 DDR
simple_accel_core 计算 sum
simple_accel_core 通过 M_AXI 主动写 DDR
Host 通过 /dev/xdma0_c2h_0 读 output 并校验
```

该阶段通过后，正式 ICP 核可以沿用同样的 `S_AXI_LITE + M_AXI + DDR buffer` 框架。

#### 4.1 HLS IP 生成注意事项

Vivado HLS 2018.3 导出 IP 时在 2026 年可能遇到 `core_revision` 溢出问题：

```text
bad lexical cast
set_property core_revision 2605220956
```

解决方式：

```text
推荐方案：
    临时把 Windows 系统时间改到 2021 年左右，再 Export RTL 为 IP Catalog。

备选方案：
    Export 失败后，手动修改 solution1/impl/ip/run_ippack.tcl 中的 core_revision 为 1，
    再用 vivado.bat -mode batch -source run_ippack.tcl 打包。
```

HLS Solution 的时钟周期需要与 XDMA AXI 时钟一致。当前系统 `xdma_0.axi_aclk` 为 62.5 MHz，因此 HLS 中建议：

```text
Clock Period = 16 ns
```

若 BD 中仍出现 `FREQ_HZ` 不匹配，确认 `simple_accel_core_0/ap_clk` 接 `xdma_0.axi_aclk` 后，可在 BD Tcl Console 中修正接口属性：

```tcl
set_property CONFIG.FREQ_HZ 62500000 [get_bd_intf_pins simple_accel_core_0/s_axi_control]
set_property CONFIG.FREQ_HZ 62500000 [get_bd_intf_pins simple_accel_core_0/Data_m_axi_gmem]
validate_bd_design
save_bd_design
```

接口名以实际 BD 为准，可能是 `m_axi_gmem` 或 `Data_m_axi_gmem`。

#### 4.2 使用标准 HLS IP，不再手动 Add Module 三个 Verilog

阶段 4 主线应使用 HLS Export RTL 后生成的标准 IP：

```text
solution1/impl/ip
```

在 Vivado 主工程中：

```text
Tools → Settings → IP → Repository → 添加 solution1/impl/ip
IP Catalog → 搜索 simple_accel_core / simple_acc_core
Add IP
```

不要长期使用手动加载：

```text
simple_accel_core.v
simple_accel_core_control_s_axi.v
simple_accel_core_gmem_m_axi.v
```

原因是手动 Add Module 容易导致：

```text
RUSER_WIDTH / WUSER_WIDTH 不匹配
AXI 接口时钟关联不清楚
Address Editor 映射异常
FREQ_HZ 属性缓存不一致
```

#### 4.3 当前推荐 BD 连接

控制路径：

```text
xdma_0.M_AXI_LITE
    → axi_smc1.S00_AXI

axi_smc1.M00_AXI
    → axi_gpio_0.S_AXI

axi_smc1.M01_AXI
    → simple_accel_core_0.s_axi_control
```

数据路径：

```text
xdma_0.M_AXI
    → axi_smc.S00_AXI

simple_accel_core_0.Data_m_axi_gmem
    → axi_smc.S01_AXI

axi_smc.M00_AXI
    → processing_system7_0.S_AXI_HP0
```

时钟统一：

```text
xdma_0.axi_aclk
    → axi_smc.aclk
    → axi_smc1.aclk
    → axi_gpio_0.s_axi_aclk
    → simple_accel_core_0.ap_clk
    → processing_system7_0.S_AXI_HP0_ACLK
```

复位统一：

```text
xdma_0.axi_aresetn
    → axi_smc.aresetn
    → axi_smc1.aresetn
    → axi_gpio_0.s_axi_aresetn
    → simple_accel_core_0.ap_rst_n
```

`interrupt` 当前不接，软件轮询 `AP_CTRL.ap_done`。

#### 4.4 当前推荐 Address Editor 分配


> 重要修正：当前 XDMA User BAR 实测很可能只有 64KB。如果把 `simple_accel_core_0/s_axi_control` 放在 `0x00010000`，Linux 侧访问 `0x00010010` 会越过 64KB User BAR 边界，可能触发 `xdma` 驱动内核 Oops。因此阶段 4 改为把 GPIO 和 simple 控制寄存器都放在低 64KB 内：GPIO 使用 `0x00000000 [4K]`，simple 控制寄存器使用 `0x00001000 [4K]`。

以当前已通过 Validate 的配置为准：

```text
xdma_0/M_AXI
    processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM
        Offset = 0x00000000
        Range  = 1G
```

```text
xdma_0/M_AXI_LITE
    axi_gpio_0/S_AXI
        Offset = 0x00000000
        Range  = 4K

    simple_accel_core_0/s_axi_control
        Offset = 0x00001000
        Range  = 4K
```

```text
simple_accel_core_0/Data_m_axi_gmem
    processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM
        Offset = 0x02000000
        Range  = 32M
```

注意：此前文档中出现过 `0x02000000 [256M]`，这是错误组合。原因是 `256M = 0x1000000`，起始地址必须按 256M 对齐；`0x02000000` 只能最大对齐到 32M。因此阶段 4 使用：

```text
0x02000000 [32M]
```

该范围覆盖：

```text
0x02000000 ~ 0x03FFFFFF
```

包含测试用：

```text
input_addr  = 0x02000000
output_addr = 0x03000000
```

#### 4.5 当前 HLS simple_accel_core 寄存器偏移

以 HLS 生成的 `simple_accel_core_control_s_axi.v` 为准，当前版本是：

```text
0x00 : AP_CTRL
       bit0 ap_start
       bit1 ap_done
       bit2 ap_idle
       bit3 ap_ready
       bit7 auto_restart

0x04 : GIE
0x08 : IER
0x0C : ISR

0x10 : in_buf
0x14 : reserved
0x18 : out_buf
0x1C : reserved
0x20 : num_items
0x24 : reserved
```

当前 HLS 版本的 `in_buf/out_buf` 是 32-bit 地址寄存器，不需要写高 32 位寄存器。

当前 `simple_accel_core_0/s_axi_control` 的 base 为 `0x00001000`，Linux 访问地址为：

```text
AP_CTRL   = 0x00001000
in_buf    = 0x00001010
out_buf   = 0x00001018
num_items = 0x00001020
```

#### 4.6 bitstream 生成后上板测试步骤

烧录新 bitstream 后，建议重新加载驱动，必要时重启或重新枚举 PCIe：

```bash
sudo rmmod xdma || true
sudo insmod ~/Data1/fpga_acc/lightlm_fpga_acc/dma_ip_drivers/XDMA/linux-kernel/xdma/xdma.ko poll_mode=1

ls -l /dev/xdma*
sudo dmesg | grep -Ei "xdma|identify_bars|map_single_bar|user" | tail -100
```

确认：

```text
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/dev/xdma0_user
```

先回归 GPIO：

```bash
cd ~/Data1/fpga_acc/lightlm_fpga_acc/dma_ip_drivers/XDMA/linux-kernel/tools

sudo ./reg_rw /dev/xdma0_user 0x00000004 w 0x00000000
sudo ./reg_rw /dev/xdma0_user 0x00000000 w 0x00000001
sudo ./reg_rw /dev/xdma0_user 0x00000000 w 0x00000000
```

再回归 DDR 写读：

```bash
python3 - <<'PY'
from pathlib import Path
p = Path('/tmp/xdma_pattern_4k.bin')
p.write_bytes(bytes((i * 17 + 3) & 0xff for i in range(4096)))
print(p, p.stat().st_size)
PY

sudo ./dma_to_device \
  -d /dev/xdma0_h2c_0 \
  -a 0x01000000 \
  -s 4096 \
  -f /tmp/xdma_pattern_4k.bin \
  -c 1

sudo ./dma_from_device \
  -d /dev/xdma0_c2h_0 \
  -a 0x01000000 \
  -s 4096 \
  -f /tmp/xdma_readback_4k.bin \
  -c 1

cmp /tmp/xdma_pattern_4k.bin /tmp/xdma_readback_4k.bin && echo PASS
```

#### 4.7 simple_accel_core 独立功能测试

生成输入：

```bash
python3 - <<'PY'
import struct
from pathlib import Path

N = 1024
data = b''.join(struct.pack('<I', i) for i in range(N))
Path('/tmp/simple_input.bin').write_bytes(data)
print('N =', N)
print('bytes =', len(data))
print('golden =', sum(range(N)), hex(sum(range(N))))
PY
```

写 input 到 DDR：

```bash
sudo ./dma_to_device \
  -d /dev/xdma0_h2c_0 \
  -a 0x02000000 \
  -s 4096 \
  -f /tmp/simple_input.bin \
  -c 1
```

建议读回确认输入：

```bash
sudo ./dma_from_device \
  -d /dev/xdma0_c2h_0 \
  -a 0x02000000 \
  -s 4096 \
  -f /tmp/simple_input_readback.bin \
  -c 1

cmp /tmp/simple_input.bin /tmp/simple_input_readback.bin && echo INPUT_PASS
```

写控制寄存器：

```bash
# in_buf = 0x02000000
sudo ./reg_rw /dev/xdma0_user 0x00001010 w 0x02000000

# out_buf = 0x03000000
sudo ./reg_rw /dev/xdma0_user 0x00001018 w 0x03000000

# num_items = 1024
sudo ./reg_rw /dev/xdma0_user 0x00001020 w 0x00000400

# ap_start = 1
sudo ./reg_rw /dev/xdma0_user 0x00001000 w 0x00000001
```

轮询完成：

```bash
sudo ./reg_rw /dev/xdma0_user 0x00001000 w
```

读到类似 `0x0000000e` 表示：

```text
ap_done  = 1
ap_idle  = 1
ap_ready = 1
```

读取输出：

```bash
sudo ./dma_from_device \
  -d /dev/xdma0_c2h_0 \
  -a 0x03000000 \
  -s 8 \
  -f /tmp/simple_output.bin \
  -c 1
```

解析结果：

```bash
python3 - <<'PY'
import struct
from pathlib import Path

data = Path('/tmp/simple_output.bin').read_bytes()
lo, hi = struct.unpack('<II', data[:8])
value = (hi << 32) | lo
expected = sum(range(1024))

print('lo =', hex(lo))
print('hi =', hex(hi))
print('sum =', value, hex(value))
print('expected =', expected, hex(expected))
print('PASS' if value == expected else 'FAIL')
PY
```

期望：

```text
sum = 523776 0x7fe00
PASS
```



#### 4.9 E2E 性能对比测试程序

阶段 4 独立功能 PASS 后，使用更新后的端到端测试程序：

```text
xdma_simple_benchmark_e2e_v2.cpp
```

默认地址：

```text
simple_base = 0x00001000
input_addr  = 0x02000000
output_addr = 0x03000000
```

运行方式：

```bash
chmod +x build_xdma_simple_benchmark_e2e_v2.sh
./build_xdma_simple_benchmark_e2e_v2.sh

sudo ./xdma_simple_benchmark_e2e_v2 --mode cpu  --n 1024 --iters 20 --verbose
sudo ./xdma_simple_benchmark_e2e_v2 --mode fpga --n 1024 --iters 20 --verbose
sudo ./xdma_simple_benchmark_e2e_v2 --mode both --n 1024 --iters 20 --verbose
```

该程序比较的是：

```text
CPU e2e:
    host input memory → CPU 开始计算 → host 得到 result

CPU+FPGA e2e:
    host input memory → H2C → FPGA DDR → 写寄存器启动 → ap_done → C2H → host 得到 result
```

如果再次出现 `Killed`，先检查是否仍在访问 `0x00010010` 这类越界 User BAR 地址；正确的 simple 寄存器地址应为 `0x00001010 / 0x00001018 / 0x00001020 / 0x00001000`。

#### 4.8 阶段 4 验收标准

必须同时满足：

```text
1. /dev/xdma0_user 存在。
2. AXI GPIO LED 仍可控制。
3. XDMA H2C/C2H DDR 写读回 PASS。
4. simple_accel_core 控制寄存器能写入并读回。
5. 写 AP_CTRL.ap_start 后 AP_CTRL.ap_done 变 1。
6. output DDR 读出 sum = 523776。
7. Python 校验 PASS。
```

---


### 阶段 5：Lightning-LM 离线复现

这部分沿用上一版：

```bash
cd ~/Data1/fpga_acc/lightlm_fpga_acc/lightning-lm
source /opt/ros/humble/setup.bash
colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
source install/setup.bash

ros2 run lightning run_slam_offline \
  --input_bag ~/data/NCLT/20130110/20130110.db3 \
  --config ./config/default_nclt.yaml
```

建议新增：

```text
tools/run_lightning_cpu_baseline.sh
config/default_nclt_fpga.yaml
```

默认：

```yaml
fpga:
  enable: false

fasterlio:
  enable_icp_part: false

system:
  with_loop_closing: false
  with_ui: false
  with_2dui: false
  with_g2p5: false
```

---

### 阶段 6：Lightning-LM 源码重构，先 CPU_SIM / DUMP

这一部分保持上一版核心原则不变：

```text
不要搬 iVox 最近邻。
不要搬 math::esti_plane() 平面拟合。
不要搬有效点筛选。
不要搬 ESKF。
不要搬点到点 ICP。
只搬 corr_pts_ + corr_norm_ → J → JᵀJ / Jᵀr。
```

Lightning-LM 加速切入点仍然是：

```text
src/core/lio/laser_mapping.cc
LaserMapping::ObsModel(NavState &s, ESKF::CustomObservationModel &obs)
```

CPU 等价公式：

```cpp
Vec3f point_this_be = corr_pts_[i].head<3>();
Vec3f point_this = off_R * point_this_be + off_t;
Mat3f point_crossmat = math::SKEW_SYM_MATRIX(point_this);
Vec3f norm_vec = corr_norm_[i].head<3>();
Vec3f C = Rt * norm_vec;
Vec3f A = point_crossmat * C;

J << norm_vec[0], norm_vec[1], norm_vec[2], A[0], A[1], A[2];
res = -corr_pts_[i][3];

HTH += plane_icp_weight * J.transpose() * J;
HTr += plane_icp_weight * J.transpose() * res;
```

FPGA packet 仍采用最小计算数据：

```text
每帧：
    Rt = R_wiᵀ
    plane_weight
    frame_id / iter_id / num_points

每点：
    point_this = R_il * p_l + t_il
    normal = n_w
    residual = corr_pts_[i][3]
```

---

### 阶段 7：HLS/RTL 实现 icp_plane_accel_core

#### 7.1 推荐接口

正式 ICP 核采用：

```text
icp_plane_accel_core
    S_AXI_LITE：控制寄存器，由 /dev/xdma0_user 访问
    M_AXI     ：访问 DDR，读取 input packet，写 result
```

#### 7.2 ICP 核寄存器表

建议沿用 simple_accel_core：

```text
0x00 CTRL
0x04 STATUS
0x08 VERSION
0x0C ERROR_CODE

0x10 INPUT_ADDR_LOW
0x14 INPUT_ADDR_HIGH
0x18 OUTPUT_ADDR_LOW
0x1C OUTPUT_ADDR_HIGH
0x20 NUM_POINTS
0x24 INPUT_BYTES
0x28 OUTPUT_BYTES
0x2C FRAME_ID
0x30 ITER_ID
0x34 CONFIG
```

#### 7.3 HLS 计算内容

```text
for each point:
    p = [px, py, pz]
    n = [nx, ny, nz]
    C = R_wi_t * n
    A = skew(p) * C
    J = [nx, ny, nz, Ax, Ay, Az]
    res = -residual
    H += weight * JᵀJ
    b += weight * Jᵀres
```

输出：

```text
FpgaIcpResult:
    magic/version/frame_id/iter_id/used_points/error
    H_upper[21]
    b[6]
```

资源建议：

```text
CPU golden 使用 double。
HLS 第一版内部可使用 float。
若误差过大，再考虑分块累加、Kahan-like compensation、fixed-point 或局部 double。
```

---

### 阶段 8：Lightning-LM 接入真 FPGA

#### 8.1 新模式命名

上一版的 `XDMA_MM_DDR` 模式需要改名，避免误解为 mailbox。

推荐：

```cpp
enum class Mode {
    DISABLED,
    CPU_SIM,
    DUMP,
    XDMA_USERBAR_DDR,  // 主线
    XDMA_MAILBOX_DDR   // 备选
};
```

YAML：

```yaml
fpga:
  enable: false
  mode: cpu_sim   # cpu_sim / dump / xdma_userbar_ddr / xdma_mailbox_ddr
  compare_cpu: true
  fallback_cpu: true
  dump_dir: ./data/fpga_dump
  dump_max_frames: 200
  log_every_n_frames: 10

  xdma_userbar_ddr:
    h2c: /dev/xdma0_h2c_0
    c2h: /dev/xdma0_c2h_0
    user: /dev/xdma0_user

    input_addr: 0x02000000
    output_addr: 0x03000000
    max_input_bytes: 0x01000000
    max_output_bytes: 0x00001000

    reg_ctrl: 0x00
    reg_status: 0x04
    reg_version: 0x08
    reg_error: 0x0C
    reg_input_addr_low: 0x10
    reg_input_addr_high: 0x14
    reg_output_addr_low: 0x18
    reg_output_addr_high: 0x1C
    reg_num_points: 0x20
    reg_input_bytes: 0x24
    reg_output_bytes: 0x28
    reg_frame_id: 0x2C
    reg_iter_id: 0x30
    reg_config: 0x34

    poll_interval_us: 50
    timeout_ms: 1000
    align_bytes: 64
```

#### 8.2 Host 侧流程

```text
1. 构造 input buffer：FpgaIcpFrameParam + FpgaPlanePoint[N]。
2. 用 /dev/xdma0_h2c_0 pwrite 到 input_addr。
3. 用 /dev/xdma0_user 写 input_addr/output_addr/num_points/input_bytes/output_bytes/frame_id/iter_id。
4. 写 CTRL.start=1。
5. 轮询 STATUS.done。
6. 用 /dev/xdma0_c2h_0 从 output_addr 读取 FpgaIcpResult。
7. 校验 magic/version/frame_id/iter_id/used_points。
8. 恢复 HTH/HTr，填入 ESKF observation。
9. compare_cpu=true 时与 CPU golden 对比。
10. 任意错误 fallback CPU。
```

---

## 3. 需要修改的文件清单

### 3.1 工具与验证脚本

新增：

```text
tools/build_xdma_x64_ubuntu22.sh
tools/check_xdma_lenovo.sh
tools/xdma_mm_ddr_rw_test.sh
tools/xdma_userbar_gpio_test.sh
tools/xdma_userbar_sum_test.cpp
tools/run_lightning_cpu_baseline.sh
tools/run_lightning_fpga_compare.sh
```

### 3.2 Lightning-LM 源码

新增：

```text
src/core/fpga/fpga_icp_packet.h
src/core/fpga/fpga_icp_accel.h
src/core/fpga/fpga_icp_accel.cc
src/core/fpga/fpga_icp_cpu_sim.cc
src/core/fpga/fpga_icp_dump.cc
src/core/fpga/fpga_icp_xdma_userbar_ddr.cc
src/core/fpga/xdma_mm_device.h
src/core/fpga/xdma_mm_device.cc
src/core/fpga/xdma_user_device.h
src/core/fpga/xdma_user_device.cc
```

修改：

```text
src/core/lio/laser_mapping.h
src/core/lio/laser_mapping.cc
src/CMakeLists.txt
config/*.yaml
```

### 3.3 FPGA/HLS

新增：

```text
fpga/hls/simple_accel_core.cpp
fpga/hls/tb_simple_accel_core.cpp
fpga/hls/icp_plane_accel_core.cpp
fpga/hls/tb_icp_plane_accel_core.cpp
fpga/README_USERBAR_DDR.md
fpga/FLASH_TEST_CHECKLIST.md
```

---

## 4. 更新后的 commit 计划

### Commit 1：User BAR 与 GPIO 验证工具

```text
- 新增 check_xdma_lenovo.sh
- 新增 xdma_userbar_gpio_test.sh
- 记录 /dev/xdma0_user 检查方式
- 记录 AXI GPIO 0x00/0x04 寄存器测试
```

### Commit 2：DDR 读写回归测试

```text
- 新增 xdma_mm_ddr_rw_test.sh
- 固定测试地址 0x01000000
- 验证 h2c/c2h 不因新增 User BAR 失效
```

### Commit 3：simple_accel_core + userbar 控制测试

```text
- HLS/RTL simple_accel_core
- S_AXI_LITE 控制寄存器
- M_AXI 访问 DDR
- 新增 xdma_userbar_sum_test.cpp
```

### Commit 4：Lightning-LM CPU baseline 复现

```text
- 新增 baseline 脚本
- 新增 fpga 配置模板，默认 fpga.enable=false
- 保存 CPU baseline 计时日志
```

### Commit 5：ObsModel 重构

```text
- 抽离 MatchAndBuildCorrespondences
- 抽离 ComputePlaneNormalEquationCPU
- 抽离 AccumulatePointToPointICPIfEnabled
- fpga.enable=false 时结果与原版一致
```

### Commit 6：CPU_SIM + DUMP

```text
- 新增 packet
- 新增 FpgaIcpAccel
- 实现 cpu_sim
- 实现 dump
- compare_cpu 对齐 H/b
```

### Commit 7：ICP HLS C model

```text
- 读取 dump 数据
- 输出 H_upper/b
- 与 golden_result 比较误差
```

### Commit 8：icp_plane_accel_core + userbar 控制

```text
- S_AXI_LITE + M_AXI 架构
- 单独 xdma_userbar_icp_test 验证
- 不接 Lightning-LM 前先用 dump packet 上板验证
```

### Commit 9：Lightning-LM xdma_userbar_ddr 接入

```text
- fpga.mode=xdma_userbar_ddr
- h2c 写 input
- user 写寄存器启动
- user 轮询 done
- c2h 读 result
- CPU fallback
```

### Commit 10：性能统计与实验报告

```text
- Timer 项完善
- CPU vs CPU_SIM vs FPGA 对比
- 日志与误差表
- FLASH_TEST_CHECKLIST.md
```

---

## 5. Codex 开发约束更新

Codex 必须遵守：

```text
1. 默认 fpga.enable=false。
2. 不允许删除 CPU 路径。
3. FPGA 出错必须 fallback CPU。
4. 不搬 iVox、不搬平面拟合、不搬 ESKF。
5. 主线采用 /dev/xdma0_user 控制寄存器 + h2c/c2h DDR 数据。
6. DDR mailbox 只作为备选，不再作为主线。
7. 不要逐点 PCIe 传输，必须一帧一批。
8. 所有 packet 结构必须 pack，明确版本号、magic、对齐和大小端。
9. H 只回传上三角，host 端恢复对称矩阵。
10. compare_cpu 必须可开关。
11. 所有硬件错误、超时、NaN/Inf、magic 错误都必须 fallback。
12. 新增 dump 二进制文件不能提交 git。
13. 每阶段单独 commit。
14. 新增脚本使用 set -euo pipefail。
```

---

## 6. 当前最推荐的下一步

当前阶段 1~3 已经通过，阶段 4 的 BD 地址也已修正为：

```text
xdma_0/M_AXI → DDR: 0x00000000 [1G]
xdma_0/M_AXI_LITE → axi_gpio_0: 0x00000000 [4K]
xdma_0/M_AXI_LITE → simple_accel_core_0/s_axi_control: 0x00001000 [4K]
simple_accel_core_0/Data_m_axi_gmem → DDR: 0x02000000 [32M]
```

下一步按下面顺序执行：

```text
1. 等待 bitstream 编译完成。
2. 烧录 FPGA。
3. 重新加载 xdma.ko，确认 /dev/xdma0_user、h2c、c2h 均存在。
4. 回归 AXI GPIO LED 测试。
5. 回归 DDR H2C/C2H 写读回测试。
6. 写 /tmp/simple_input.bin 到 0x02000000。
7. 通过 /dev/xdma0_user 写 simple_accel_core 控制寄存器：
   - in_buf = 0x02000000
   - out_buf = 0x03000000
   - num_items = 1024
   - AP_CTRL.ap_start = 1
8. 轮询 AP_CTRL.ap_done。
9. 从 0x03000000 读 8 字节输出，确认 sum=523776。
10. 若阶段 4 PASS，再进入 Lightning-LM CPU baseline、CPU_SIM、DUMP、ICP HLS。
```

这样分层最清楚：

```text
User BAR 控制问题
DMA DDR 读写问题
算法 IP M_AXI 访存问题
Lightning-LM 数值一致性问题
ICP 加速性能问题
```

任何一层失败，都先在该层解决，不要混到 Lightning-LM 里一起调。
