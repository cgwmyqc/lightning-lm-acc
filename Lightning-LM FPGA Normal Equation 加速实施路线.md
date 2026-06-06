# Lightning-LM FPGA Normal Equation 加速实施路线

## 1. 当前项目目录约定

当前项目根目录为：

```text
lightning-lm-acc/
├── cmake/
├── config/
├── docker/
├── pcd/
├── plan/
├── scripts/
├── src/
├── srv/
├── thirdparty/
├── CMakeLists.txt
├── package.xml
└── .git/
```

建议新增：

```text
lightning-lm-acc/
├── src/
│   └── fpga/                         # Orin 端会参与 Lightning-LM 编译的 C++ FPGA 后端
│
└── fpga/                             # 新增：FPGA 工程、文档、HLS、Vivado、host_tools
    ├── docs/
    ├── hls/
    ├── vivado/
    ├── host_tools/
    ├── golden_small/
    └── README.md
```

目录职责如下：

```text
src/fpga/
  Orin 端 C++ 代码，会被 Lightning-LM 主程序编译。
  例如 NormalEquationBackend、CpuBackend、FpgaBackend、XDMA runtime、golden writer。

fpga/docs/
  两端共用文档，给 Codex、人、Orin、Windows HLS 统一接口。

fpga/hls/
  Windows 端 HLS 加速核工程。

fpga/vivado/
  Vivado 工程脚本、BD 重建脚本、约束文件、IP repo，不放大量自动生成文件。

fpga/host_tools/
  Orin 端独立测试工具，例如 normal_eq_replay、xdma_test。

fpga/golden_small/
  少量小 golden 文件，可提交 Git，用于 HLS testbench 回归。
```

---

## 2. Git 分支约定

当前采用双分支开发：

```text
dev_orin:
  AGX Orin 端开发分支。

dev_win_hls:
  Windows HLS / Vivado 端开发分支。
```

### 2.1 dev_orin 分支职责

`dev_orin` 主要修改：

```text
src/
config/
cmake/
scripts/
fpga/docs/
fpga/host_tools/
```

`dev_orin` 不应修改：

```text
fpga/hls/
fpga/vivado/
```

除非只是同步接口文档。

### 2.2 dev_win_hls 分支职责

`dev_win_hls` 主要修改：

```text
fpga/hls/
fpga/vivado/
fpga/docs/
fpga/golden_small/
```

`dev_win_hls` 不应修改：

```text
src/
config/
cmake/
ROS2 主工程逻辑
```

除非只是同步接口文档。

---

## 3. 推荐新增目录

在项目根目录执行：

```bash
mkdir -p fpga/docs
mkdir -p fpga/hls/normal_eq_accel
mkdir -p fpga/vivado/scripts
mkdir -p fpga/vivado/constraints
mkdir -p fpga/vivado/bd
mkdir -p fpga/vivado/ip_repo
mkdir -p fpga/host_tools/normal_eq_replay
mkdir -p fpga/host_tools/xdma_test
mkdir -p fpga/golden_small
mkdir -p src/fpga
```

Windows PowerShell 等价：

```powershell
mkdir fpga
mkdir fpga\docs
mkdir fpga\hls
mkdir fpga\hls\normal_eq_accel
mkdir fpga\vivado
mkdir fpga\vivado\scripts
mkdir fpga\vivado\constraints
mkdir fpga\vivado\bd
mkdir fpga\vivado\ip_repo
mkdir fpga\host_tools
mkdir fpga\host_tools\normal_eq_replay
mkdir fpga\host_tools\xdma_test
mkdir fpga\golden_small
mkdir src\fpga
```

---

## 4. 推荐最终目录结构

```text
lightning-lm-acc/
├── src/
│   ├── ...
│   └── fpga/
│       ├── fpga_types.h
│       ├── normal_equation_backend.h
│       ├── cpu_normal_equation_backend.h
│       ├── cpu_normal_equation_backend.cc
│       ├── fpga_normal_equation_backend.h
│       ├── fpga_normal_equation_backend.cc
│       ├── fpga_golden_writer.h
│       ├── fpga_golden_writer.cc
│       ├── xdma_user.h
│       └── xdma_user.cc
│
├── fpga/
│   ├── README.md
│   │
│   ├── docs/
│   │   ├── FPGA_NORMAL_EQ_IMPLEMENTATION_ROADMAP.md
│   │   ├── INTERFACE_SPEC.md
│   │   ├── GOLDEN_DATA_FORMAT.md
│   │   ├── BUILD_AND_TEST.md
│   │   └── CURRENT_STATUS.md
│   │
│   ├── hls/
│   │   └── normal_eq_accel/
│   │       ├── normal_eq_accel.h
│   │       ├── normal_eq_accel.cpp
│   │       ├── testbench.cpp
│   │       ├── run_csim.tcl
│   │       ├── run_csynth.tcl
│   │       ├── export_ip.tcl
│   │       └── README.md
│   │
│   ├── vivado/
│   │   ├── README.md
│   │   ├── scripts/
│   │   │   ├── create_project.tcl
│   │   │   ├── build_bitstream.tcl
│   │   │   └── export_hardware.tcl
│   │   ├── constraints/
│   │   │   └── top.xdc
│   │   ├── bd/
│   │   │   └── design_1_bd.tcl
│   │   └── ip_repo/
│   │       └── normal_eq_accel/
│   │
│   ├── host_tools/
│   │   ├── normal_eq_replay/
│   │   │   ├── CMakeLists.txt
│   │   │   ├── normal_eq_replay.cpp
│   │   │   └── README.md
│   │   └── xdma_test/
│   │       ├── CMakeLists.txt
│   │       ├── xdma_basic_test.cpp
│   │       └── README.md
│   │
│   └── golden_small/
│       ├── README.md
│       └── frame_000100.bin
```

---

## 5. .gitignore 建议

在根目录 `.gitignore` 追加：

```gitignore
# Vivado generated files
*.jou
*.log
*.str
*.dmp
*.backup
*.wdb
*.wcfg

# Vivado generated directories
.Xil/
*.cache/
*.runs/
*.sim/
*.hw/
*.ip_user_files/
*.gen/

# HLS generated directories
solution*/
.sim/
.syn/
.impl/
.tb/
csim/
csynth/
vitis_hls.log
vivado_hls.log

# Large FPGA artifacts
*.bit
*.ltx
*.hwh
*.xsa

# Large golden data
fpga/golden/
fpga/golden_large/
*.bag
*.db3

# Archives
*.zip
*.7z
*.tar.gz
```

如果需要保留正式发布 bitstream，可新增：

```text
fpga/releases/
```

并在 `.gitignore` 中加例外：

```gitignore
!fpga/releases/*.bit
!fpga/releases/*.hwh
!fpga/releases/*.xsa
!fpga/releases/README.md
```

---

## 6. 实施阶段总览

整体分为 6 个阶段：

```text
阶段 0：整理目录和文档
阶段 1：Orin 端 CPU backend + golden dump
阶段 2：Windows 端 HLS normal_eq_accel + testbench
阶段 3：Orin 端 XDMA wrapper + normal_eq_replay
阶段 4：Windows 端 Vivado IP/bitstream 集成
阶段 5：Orin 端 run_slam_online fpga_check / fpga active 接入
```

当前第一目标不是马上提速，而是：

```text
1. 接口稳定
2. golden data 可复现
3. CPU/HLS/FPGA 数值一致
4. XDMA 数据通路跑通
5. Lightning-LM 可切换 backend
```

---

# 阶段 0：整理目录和文档

## 0.1 新增 docs

在 `fpga/docs/` 下新增：

```text
FPGA_NORMAL_EQ_IMPLEMENTATION_ROADMAP.md
INTERFACE_SPEC.md
GOLDEN_DATA_FORMAT.md
BUILD_AND_TEST.md
CURRENT_STATUS.md
```

### `INTERFACE_SPEC.md`

必须定义：

```text
1. 接口版本号
2. FpgaCorrInput 结构
3. FpgaStateInput 结构
4. FpgaNormalEqOutput 结构
5. H_upper[21] 排列顺序
6. 坐标系约定
7. residual 公式
8. Jacobian 公式
9. float32 / little-endian / 对齐要求
```

### `GOLDEN_DATA_FORMAT.md`

必须定义：

```text
1. GoldenHeader 结构
2. golden 文件布局
3. 文件命名规则
4. Orin 如何生成
5. Windows HLS 如何读取
6. normal_eq_replay 如何读取
```

### `CURRENT_STATUS.md`

每次阶段推进后更新，包含：

```text
1. 当前接口版本
2. 当前参数
3. dev_orin 状态
4. dev_win_hls 状态
5. 最新 golden 文件
6. 当前误差
7. 当前问题
8. 下一步
```

---

# 阶段 1：Orin 端 CPU backend + golden dump

工作分支：

```bash
git checkout dev_orin
```

## 1.1 新增 `src/fpga/fpga_types.h`

定义统一二进制结构：

```cpp
#pragma once

#include <cstdint>

namespace lightning::fpga {

constexpr uint32_t kFpgaMagic = 0x4C464750;
constexpr uint32_t kFpgaInterfaceVersion = 1;
constexpr uint32_t kGoldenMagic = 0x4C474F4C;

struct alignas(32) FpgaCorrInput {
    float px;
    float py;
    float pz;
    float nx;
    float ny;
    float nz;
    float d;
    float weight;
};

struct alignas(64) FpgaStateInput {
    uint32_t magic;
    uint32_t version;
    uint32_t num_points;
    uint32_t reserved0;

    float R[9];
    float t[3];

    uint32_t reserved1[8];
};

struct alignas(64) FpgaNormalEqOutput {
    uint32_t magic;
    uint32_t version;
    uint32_t valid_count;
    uint32_t reserved0;

    float H_upper[21];
    float b[6];

    float residual_sum;
    float residual_abs_sum;
    float reserved1[7];
};

struct alignas(64) GoldenHeader {
    uint32_t magic;
    uint32_t version;
    uint32_t frame_id;
    uint32_t num_points;

    float R[9];
    float t[3];

    float H_upper_cpu[21];
    float b_cpu[6];

    float residual_sum_cpu;
    float residual_abs_sum_cpu;

    uint32_t reserved[16];
};

static_assert(sizeof(FpgaCorrInput) == 32, "FpgaCorrInput must be 32 bytes");

}  // namespace lightning::fpga
```

注意：如果实际 namespace 和项目风格不同，Codex 可以按项目现有风格调整，但必须同步更新 `INTERFACE_SPEC.md`。

---

## 1.2 新增 backend 抽象接口

新增：

```text
src/fpga/normal_equation_backend.h
```

接口：

```cpp
#pragma once

#include <string>
#include <vector>
#include <Eigen/Core>
#include "fpga_types.h"

namespace lightning::fpga {

struct NormalEquationState {
    Eigen::Matrix3f R = Eigen::Matrix3f::Identity();
    Eigen::Vector3f t = Eigen::Vector3f::Zero();
};

struct NormalEquationResult {
    Eigen::Matrix<float, 6, 6> H =
        Eigen::Matrix<float, 6, 6>::Zero();

    Eigen::Matrix<float, 6, 1> b =
        Eigen::Matrix<float, 6, 1>::Zero();

    float residual_sum = 0.0f;
    float residual_abs_sum = 0.0f;
    int valid_count = 0;
};

class NormalEquationBackend {
public:
    virtual ~NormalEquationBackend() = default;

    virtual bool Accumulate(
        const std::vector<FpgaCorrInput>& corr,
        const NormalEquationState& state,
        NormalEquationResult* result) = 0;

    virtual std::string Name() const = 0;
};

}  // namespace lightning::fpga
```

---

## 1.3 新增 CPU backend

新增：

```text
src/fpga/cpu_normal_equation_backend.h
src/fpga/cpu_normal_equation_backend.cc
```

计算公式：

```text
p_world = R * p + t
r = n^T * p_world + d

J = [ -n^T * R * skew(p), n^T ]

H += weight * J^T * J
b += weight * J^T * r
```

要求：

```text
1. 使用 float。
2. 输出完整 6x6 H。
3. b 是 6x1。
4. CPU backend 结果要和原始代码中 surfel 命中点的 HTH/HTr 一致。
```

---

## 1.4 在 LaserMapping 中构造 `FpgaCorrInput`

在当前 surfel 命中分支中新增：

```cpp
std::vector<lightning::fpga::FpgaCorrInput> fpga_corrs;
```

每个 surfel 命中点：

```cpp
lightning::fpga::FpgaCorrInput corr;
corr.px = p_body.x();
corr.py = p_body.y();
corr.pz = p_body.z();

corr.nx = surfel.normal.x();
corr.ny = surfel.normal.y();
corr.nz = surfel.normal.z();
corr.d = surfel.d;

corr.weight = 1.0f;
fpga_corrs.push_back(corr);
```

注意：

```text
p_body 必须与现有 CPU Jacobian 使用的点坐标一致。
normal/d 必须与当前 residual 使用的平面一致。
fallback 点不要加入 fpga_corrs。
```

---

## 1.5 fallback 点保持原 CPU 路径

当前 fallback 逻辑继续保留：

```text
surfel invalid
  ↓
iVox GetClosestPoint
  ↓
esti_plane
  ↓
CPU residual/Jacobian/HTH-HTr
```

最终合并：

```text
H_total = H_surfel_backend + H_fallback_cpu
b_total = b_surfel_backend + b_fallback_cpu
```

---

## 1.6 新增配置项

在配置文件中新增：

```yaml
normal_equation_backend: cpu   # cpu / fpga_check / fpga

fpga:
  enable: false
  golden_dump_enable: false
  golden_dump_dir: "/tmp/lightning_fpga_golden"
  golden_dump_every_n_frames: 100
  golden_dump_max_files: 50

  xdma_h2c: "/dev/xdma0_h2c_0"
  xdma_c2h: "/dev/xdma0_c2h_0"
  xdma_user: "/dev/xdma0_user"

  input_addr: 0x02000000
  output_addr: 0x03000000
  max_points: 4096
  timeout_ms: 100

  compare_with_cpu: true
  max_abs_error: 1.0e-2
  max_rel_error: 1.0e-3
  fallback_to_cpu_on_error: true
```

---

## 1.7 新增 golden writer

新增：

```text
src/fpga/fpga_golden_writer.h
src/fpga/fpga_golden_writer.cc
```

功能：

```text
1. 输入 frame_id、state、corrs、CPU result。
2. 写出 GoldenHeader。
3. 后接 FpgaCorrInput[num_points]。
4. 文件名为 frame_XXXXXX.bin。
```

默认导出路径：

```text
/tmp/lightning_fpga_golden/
```

---

## 1.8 阶段 1 验收

执行：

```bash
colcon build --symlink-install
```

运行 CPU baseline：

```bash
source install/setup.bash
taskset -c 4-11 ros2 run lightning run_slam_online --ros-args \
  -p normal_equation_backend:=cpu
```

开启 golden dump：

```bash
taskset -c 4-11 ros2 run lightning run_slam_online --ros-args \
  -p normal_equation_backend:=cpu \
  -p fpga.golden_dump_enable:=true \
  -p fpga.golden_dump_dir:=/tmp/lightning_fpga_golden
```

验收：

```text
[ ] colcon build 通过
[ ] normal_equation_backend=cpu 可运行
[ ] 轨迹不发散
[ ] surfel hit/fallback 正常
[ ] /tmp/lightning_fpga_golden/ 生成 frame_xxxxxx.bin
```

提交：

```bash
git add .
git commit -m "orin: add normal equation CPU backend and golden dump"
git push origin dev_orin
```

---

# 阶段 2：Windows HLS normal_eq_accel

工作分支：

```bash
git checkout dev_win_hls
```

## 2.1 新增 HLS 文件

在：

```text
fpga/hls/normal_eq_accel/
```

新增：

```text
normal_eq_accel.h
normal_eq_accel.cpp
testbench.cpp
run_csim.tcl
run_csynth.tcl
export_ip.tcl
README.md
```

---

## 2.2 HLS 内核接口

函数建议：

```cpp
void normal_eq_accel(
    const FpgaStateInput* state,
    const FpgaCorrInput* corr,
    FpgaNormalEqOutput* out,
    int num_points
);
```

HLS pragma：

```cpp
#pragma HLS INTERFACE m_axi port=state offset=slave bundle=gmem
#pragma HLS INTERFACE m_axi port=corr  offset=slave bundle=gmem
#pragma HLS INTERFACE m_axi port=out   offset=slave bundle=gmem
#pragma HLS INTERFACE s_axilite port=state bundle=control
#pragma HLS INTERFACE s_axilite port=corr  bundle=control
#pragma HLS INTERFACE s_axilite port=out   bundle=control
#pragma HLS INTERFACE s_axilite port=num_points bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control
```

第一版使用：

```text
float32
single lane
不做 fixed-point
不做 lookup
不做 KNN
不做 ESKF
```

---

## 2.3 HLS 计算内容

伪代码：

```cpp
float H[21] = {0};
float b[6] = {0};
float residual_sum = 0;
float residual_abs_sum = 0;

for i in 0..num_points-1:
    read corr[i]

    p_world = R * p + t
    r = n dot p_world + d

    J_rot = -n^T * R * skew(p)
    J_trans = n^T

    J[0..5] = [J_rot, J_trans]

    H_upper += weight * J^T * J
    b += weight * J^T * r

    residual_sum += r
    residual_abs_sum += abs(r)

write output
```

---

## 2.4 HLS testbench

`testbench.cpp` 必须支持：

```powershell
normal_eq_csim.exe path\to\frame_002290.bin
```

功能：

```text
1. 读取 GoldenHeader。
2. 读取 FpgaCorrInput array。
3. 调用 normal_eq_accel。
4. 对比 H_upper_cpu 和 H_upper_fpga。
5. 对比 b_cpu 和 b_fpga。
6. 打印 max_abs_error / max_rel_error。
7. 输出 PASS / FAIL。
```

验收阈值：

```text
max_abs_error <= 1e-2
max_rel_error <= 1e-3
```

---

## 2.5 阶段 2 验收

执行 HLS C simulation。

验收：

```text
[ ] HLS C simulation PASS
[ ] 能读取 Orin 导出的 golden 文件
[ ] H_upper 对齐
[ ] b 对齐
[ ] residual_sum 对齐
[ ] README 记录运行方式
```

提交：

```bash
git add .
git commit -m "win_hls: add normal equation HLS kernel and csim"
git push origin dev_win_hls
```

---

# 阶段 3：Orin 端 XDMA wrapper + normal_eq_replay

工作分支：

```bash
git checkout dev_orin
```

## 3.1 新增 XDMA wrapper

新增：

```text
src/fpga/xdma_user.h
src/fpga/xdma_user.cc
```

接口：

```cpp
class XdmaUser {
public:
    bool Open(const std::string& h2c,
              const std::string& c2h,
              const std::string& user);

    bool WriteH2C(uint64_t fpga_addr, const void* data, size_t size);
    bool ReadC2H(uint64_t fpga_addr, void* data, size_t size);

    bool WriteReg(uint32_t offset, uint32_t value);
    bool ReadReg(uint32_t offset, uint32_t* value);

    bool Start(uint64_t input_addr,
               uint64_t output_addr,
               uint32_t num_points);

    bool WaitDone(int timeout_ms);

    void Close();
};
```

---

## 3.2 新增 FPGA backend

新增：

```text
src/fpga/fpga_normal_equation_backend.h
src/fpga/fpga_normal_equation_backend.cc
```

功能：

```text
1. 接收 fpga_corrs 和 state。
2. 构造 FpgaStateInput。
3. 写 H2C 到 input_addr。
4. 设置寄存器。
5. start。
6. WaitDone。
7. C2H 读回 FpgaNormalEqOutput。
8. 转换为 NormalEquationResult。
```

如果 FPGA 未连接，可先实现 fake mode：

```text
fpga_backend_fake:
  内部调用 CPU backend
  用于验证 Lightning-LM backend 切换流程
```

---

## 3.3 新增 normal_eq_replay

在：

```text
fpga/host_tools/normal_eq_replay/
```

新增工具：

```text
normal_eq_replay.cpp
CMakeLists.txt
README.md
```

功能：

```bash
./normal_eq_replay frame_002290.bin --backend cpu
./normal_eq_replay frame_002290.bin --backend fpga_check
./normal_eq_replay frame_002290.bin --backend fpga
```

用途：

```text
不启动 ROS2，也能测试 golden -> XDMA -> FPGA -> output -> compare。
```

---

## 3.4 阶段 3 验收

```text
[ ] XDMA wrapper 可编译
[ ] normal_eq_replay 可编译
[ ] backend fake mode 可运行
[ ] 如果 FPGA 已连接，能跑单帧 replay
[ ] 错误处理完整：设备不存在、timeout、误差超限
```

提交：

```bash
git add .
git commit -m "orin: add xdma wrapper and normal equation replay"
git push origin dev_orin
```

---

# 阶段 4：Windows Vivado IP / bitstream 集成

工作分支：

```bash
git checkout dev_win_hls
```

## 4.1 导出 HLS IP

Windows 端完成：

```text
fpga/hls/normal_eq_accel/export_ip.tcl
```

导出到：

```text
fpga/vivado/ip_repo/normal_eq_accel/
```

---

## 4.2 Vivado 工程脚本化

在：

```text
fpga/vivado/scripts/
```

新增：

```text
create_project.tcl
build_bitstream.tcl
export_hardware.tcl
```

在：

```text
fpga/vivado/bd/
```

新增：

```text
design_1_bd.tcl
```

在：

```text
fpga/vivado/constraints/
```

新增：

```text
top.xdc
```

不要提交 Vivado 自动生成目录：

```text
*.runs/
*.cache/
*.gen/
*.hw/
*.sim/
.Xil/
```

---

## 4.3 阶段 4 验收

```text
[ ] HLS IP export 成功
[ ] Vivado project 可由 Tcl 重建
[ ] bitstream 可生成
[ ] README 记录地址映射和寄存器偏移
```

提交：

```bash
git add .
git commit -m "win_hls: add vivado scripts for normal equation accelerator"
git push origin dev_win_hls
```

---

# 阶段 5：Orin run_slam_online 接入 FPGA

工作分支：

```bash
git checkout dev_orin
```

## 5.1 fpga_check 模式

行为：

```text
1. CPU backend 计算 cpu_result。
2. FPGA backend 计算 fpga_result。
3. 比较误差。
4. 最终使用 cpu_result 进入 ESKF。
5. 如果误差超限，保存 golden。
```

运行：

```bash
taskset -c 4-11 ros2 run lightning run_slam_online --ros-args \
  -p normal_equation_backend:=fpga_check
```

验收：

```text
[ ] 连续运行不崩溃
[ ] max_abs_error 在阈值内
[ ] max_rel_error 在阈值内
[ ] 超限帧保存 golden
[ ] 轨迹不变
```

---

## 5.2 fpga active 模式

行为：

```text
1. FPGA backend 计算 surfel 命中点 H/b。
2. CPU 计算 fallback 点 H/b。
3. 合并 H/b。
4. 使用合并结果进入 ESKF。
```

运行：

```bash
taskset -c 4-11 ros2 run lightning run_slam_online --ros-args \
  -p normal_equation_backend:=fpga
```

验收：

```text
[ ] 轨迹不发散
[ ] gravity norm 约 9.81
[ ] effective_surface_points 无异常下降
[ ] surfel hit/fallback 正常
[ ] fpga_total_ms 可观测
[ ] obs_total_ms / plane_icp_ms 有可测变化
```

---

# 20. 给 Codex 的开发边界

## Orin Codex 必须遵守

```text
1. 只在 dev_orin 分支工作。
2. 不修改 fpga/hls 和 fpga/vivado。
3. 不删除 iVox。
4. 不重写 LaserMapping。
5. 不修改 HLS 内核。
6. normal_equation_backend=cpu 必须保持原结果。
7. 所有新功能必须有配置开关。
8. colcon build 必须通过。
```

## Windows Codex 必须遵守

```text
1. 只在 dev_win_hls 分支工作。
2. 不修改 src 和 ROS2 主工程。
3. 不实现 surfel lookup。
4. 不实现 KNN。
5. 不实现 ESKF。
6. 第一版使用 float32。
7. 必须能读取 golden bin。
8. HLS C simulation 必须通过。
```

---

# 21. 当前阶段最终目标

完成当前 P0 后，应达到：

```text
1. Orin 能生成 golden data。
2. Windows HLS 能读取 golden data。
3. HLS 输出 H/b 与 CPU 对齐。
4. Orin 能通过 XDMA 调用 FPGA。
5. run_slam_online 支持 cpu / fpga_check / fpga 三种模式。
6. FPGA P0 可稳定运行。
```

下一阶段再考虑：

```text
P1: FPGA LookupBatch
P2: FPGA BatchUpdate / dirty surfel refit
P3: iVox fallback 批量化
P4: fixed-point 和多 lane 优化
```
