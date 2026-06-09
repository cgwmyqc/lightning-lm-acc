# Lightning-LM FPGA Normal Equation 加速实施路线

## 1. 当前目标

本项目基于当前已经改造好的 Lightning-LM surfel 版本，继续实现 FPGA 协处理器加速。

当前 Lightning-LM 已具备：

```text
1. BlockSurfelMap
2. surfel 主路径 + iVox fallback
3. surfel_min_support: 3
4. surfel_cell_resolution: 0.8
5. surfel_lookup_nearby_type: 26
6. surfel fallback ratio 已经降到可接受范围
```

第一阶段 FPGA 目标为：

```text
P0：加速 surfel 命中点的 residual / Jacobian / HTH-HTr 累加
```

第一阶段不做：

```text
1. 不做完整 SLAM
2. 不做 iVox KNN
3. 不做 surfel map lookup
4. 不做 ESKF solve
5. 不做地图更新
6. 不做 fixed-point
7. 不做多 lane 并行优化
```

第一阶段的核心原则：

```text
CPU 负责找对应关系；
FPGA 负责数值累加；
CPU 继续做 ESKF 更新。
```

------

## 2. Git 开发策略

本项目统一在一个分支上开发：

```bash
dev-fpga
```

所有 Orin 端、Windows HLS 端、Vivado 端修改都在 `dev-fpga` 分支完成。

推荐两端工作前都执行：

```bash
git checkout dev-fpga
git pull
git status
```

每次完成一个小阶段后及时提交：

```bash
git add .
git commit -m "说明本次修改"
git push
```

------

## 3. 为什么统一使用 dev-fpga 分支

当前项目由同一人同时在 AGX Orin 和 Windows 上开发。统一使用 `dev-fpga` 分支的好处是：

```text
1. Orin 改了接口，Windows pull 后马上能看到。
2. Windows 改了 HLS/testbench，Orin pull 后马上能看到。
3. 不需要在多个分支之间 merge。
4. INTERFACE_SPEC.md、GOLDEN_DATA_FORMAT.md、fpga_types.h 能保持同步。
5. Codex 不容易拿到旧接口。
```

虽然统一使用 `dev-fpga` 分支，但仍然必须严格保持目录边界，避免 Orin 端和 Windows 端互相污染。

------

## 4. 当前项目目录约定

当前项目根目录结构：

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

新增 FPGA 相关目录后，推荐结构：

```text
lightning-lm-acc/
├── src/
│   └── fpga/                         # Orin 端参与 Lightning-LM 编译的 C++ FPGA 后端
│
└── fpga/                             # FPGA 相关工程、文档、HLS、Vivado、测试工具
    ├── docs/
    ├── hls/
    ├── vivado/
    ├── host_tools/
    ├── golden_small/
    └── README.md
```

------

## 5. 各目录职责

### 5.1 `src/fpga/`

该目录放 Orin 端会参与 Lightning-LM 主程序编译的 C++ 代码。

建议文件：

```text
src/fpga/
├── fpga_types.h
├── normal_equation_backend.h
├── cpu_normal_equation_backend.h
├── cpu_normal_equation_backend.cc
├── fpga_normal_equation_backend.h
├── fpga_normal_equation_backend.cc
├── fpga_golden_writer.h
├── fpga_golden_writer.cc
├── xdma_user.h
└── xdma_user.cc
```

职责：

```text
1. 定义 CPU/FPGA 共用数据结构
2. 定义 NormalEquationBackend 抽象接口
3. 实现 CPU backend
4. 实现 FPGA backend
5. 生成 golden data
6. 封装 XDMA 用户态读写
```

------

### 5.2 `fpga/docs/`

两端共用文档目录。

建议文件：

```text
fpga/docs/
├── FPGA_NORMAL_EQ_IMPLEMENTATION_ROADMAP.md
├── INTERFACE_SPEC.md
├── GOLDEN_DATA_FORMAT.md
├── BUILD_AND_TEST.md
└── CURRENT_STATUS.md
```

职责：

```text
1. 记录总体路线
2. 固定 CPU/FPGA 接口
3. 固定 golden 文件格式
4. 记录构建和测试方法
5. 记录当前开发状态
```

所有接口变化必须先更新：

```text
fpga/docs/INTERFACE_SPEC.md
fpga/docs/GOLDEN_DATA_FORMAT.md
fpga/docs/CURRENT_STATUS.md
```

------

### 5.3 `fpga/hls/`

Windows 端 HLS 工程目录。

建议结构：

```text
fpga/hls/
└── normal_eq_accel/
    ├── normal_eq_accel.h
    ├── normal_eq_accel.cpp
    ├── testbench.cpp
    ├── run_csim.tcl
    ├── run_csynth.tcl
    ├── export_ip.tcl
    └── README.md
```

职责：

```text
1. 实现 HLS normal_eq_accel 内核
2. 实现 HLS C simulation testbench
3. 读取 Orin 导出的 golden data
4. 输出 H_upper[21]、b[6]
5. 和 CPU golden 结果对齐
6. 导出 HLS IP
```

------

### 5.4 `fpga/vivado/`

Vivado 工程脚本目录。

建议结构：

```text
fpga/vivado/
├── README.md
├── scripts/
│   ├── create_project.tcl
│   ├── build_bitstream.tcl
│   └── export_hardware.tcl
├── constraints/
│   └── top.xdc
├── bd/
│   └── design_1_bd.tcl
└── ip_repo/
    └── normal_eq_accel/
```

职责：

```text
1. 保存 Vivado 工程重建脚本
2. 保存 BD 脚本
3. 保存 XDC 约束
4. 保存 HLS 导出的 IP repo
5. 记录地址映射和寄存器偏移
```

不要提交 Vivado 自动生成目录。

------

### 5.5 `fpga/host_tools/`

Orin 端独立测试工具目录。

建议结构：

```text
fpga/host_tools/
├── normal_eq_replay/
│   ├── CMakeLists.txt
│   ├── normal_eq_replay.cpp
│   └── README.md
└── xdma_test/
    ├── CMakeLists.txt
    ├── xdma_basic_test.cpp
    └── README.md
```

职责：

```text
1. 不启动 ROS2，也能测试 golden -> FPGA -> result
2. 独立测试 XDMA H2C / C2H / user BAR
3. 对比 CPU/FPGA HTH-HTr 误差
```

------

### 5.6 `fpga/golden_small/`

少量小 golden 文件目录。

```text
fpga/golden_small/
├── README.md
└── frame_000100.bin
```

职责：

```text
1. 保存少量小型 golden 文件
2. 用于 Windows HLS testbench 回归
3. 可以提交 Git
```

大 golden 文件不要提交 Git，应放在：

```text
/tmp/lightning_fpga_golden/
fpga/golden_large/
```

并由 `.gitignore` 忽略。

------

## 6. 目录创建命令

Linux / Orin：

```bash
mkdir -p src/fpga
mkdir -p fpga/docs
mkdir -p fpga/hls/normal_eq_accel
mkdir -p fpga/vivado/scripts
mkdir -p fpga/vivado/constraints
mkdir -p fpga/vivado/bd
mkdir -p fpga/vivado/ip_repo
mkdir -p fpga/host_tools/normal_eq_replay
mkdir -p fpga/host_tools/xdma_test
mkdir -p fpga/golden_small
```

Windows PowerShell：

```powershell
mkdir src\fpga
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
```

------

## 7. 单分支下的目录边界

虽然统一使用 `dev-fpga` 分支，但 Orin 和 Windows 仍然按目录分工。

### 7.1 Orin 端主要修改

Orin 端主要允许修改：

```text
src/
config/
cmake/
scripts/
fpga/docs/
fpga/host_tools/
```

Orin 端原则上不要修改：

```text
fpga/hls/
fpga/vivado/
```

除非只是同步 README 或接口文档。

------

### 7.2 Windows 端主要修改

Windows 端主要允许修改：

```text
fpga/hls/
fpga/vivado/
fpga/docs/
fpga/golden_small/
```

Windows 端原则上不要修改：

```text
src/
config/
cmake/
ROS2 主工程逻辑
```

除非只是同步接口文档。

------

## 8. `.gitignore` 建议

在根目录 `.gitignore` 中追加：

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

如果需要保留正式 bitstream，可新增：

```text
fpga/releases/
```

并添加例外：

```gitignore
!fpga/releases/*.bit
!fpga/releases/*.hwh
!fpga/releases/*.xsa
!fpga/releases/README.md
```

------

## 9. 单分支 Git 工作流

### 9.1 每次开始工作前

Orin 和 Windows 两端都执行：

```bash
git checkout dev-fpga
git pull
git status
```

如果有未提交内容，先处理完再 pull。

------

### 9.2 Orin 端提交

Orin 端修改后：

```bash
colcon build --symlink-install

git status
git add src config cmake scripts fpga/docs fpga/host_tools
git commit -m "orin: add normal equation backend and golden dump"
git push
```

如果只改文档，可以不执行 `colcon build`，但 commit message 要说明。

------

### 9.3 Windows 端提交

Windows 端修改后：

```powershell
git status
git add fpga\hls fpga\vivado fpga\docs fpga\golden_small
git commit -m "win: add HLS normal equation accelerator"
git push
```

如果修改 HLS 内核，提交前应运行 HLS C simulation。

------

### 9.4 避免冲突的原则

```text
1. 不要让 Orin 和 Windows 同时修改同一个文件。
2. 接口变化必须先改 docs。
3. 改完一个小阶段就 commit + push。
4. 另一端开始工作前必须 pull。
5. 不提交 Vivado/HLS 自动生成的大量中间文件。
6. 如果 Codex 改动跨越了不该改的目录，必须人工 review 后再提交。
```

------

## 10. 给 Orin Codex 的提示词

在 Orin 上运行 Codex 时使用：

```text
当前 Git 分支是 dev-fpga。
你在 Jetson AGX Orin Ubuntu 22.04 上开发 Lightning-LM 主程序。

你主要允许修改：
- src/
- config/
- cmake/
- scripts/
- fpga/docs/
- fpga/host_tools/

你不要修改：
- fpga/hls/
- fpga/vivado/

当前目标是实现 FPGA P0 的 Orin 侧接入：
1. 新增 src/fpga/fpga_types.h；
2. 新增 NormalEquationBackend 抽象接口；
3. 新增 CpuNormalEquationBackend；
4. 新增 FpgaNormalEquationBackend；
5. 从 surfel 命中点构造 FpgaCorrInput；
6. fallback 点继续走原 CPU iVox 路径；
7. 新增 golden data dump；
8. 新增 fpga_check 模式；
9. 新增 XDMA wrapper；
10. 新增 normal_eq_replay 工具；
11. 保证 normal_equation_backend=cpu 时结果和当前代码一致；
12. 每次修改后优先运行 colcon build --symlink-install。

请先阅读：
- fpga/docs/FPGA_NORMAL_EQ_IMPLEMENTATION_ROADMAP.md
- fpga/docs/INTERFACE_SPEC.md
- fpga/docs/GOLDEN_DATA_FORMAT.md
- fpga/docs/CURRENT_STATUS.md

不要重写整个 LaserMapping。
不要删除 iVox。
不要把 surfel lookup 放到 FPGA。
不要实现 ESKF solve。
第一阶段只实现 surfel 命中点的 normal equation backend。
```

------

## 11. 给 Windows Codex 的提示词

在 Windows 上运行 Codex 时使用：

```text
当前 Git 分支是 dev-fpga。
你在 Windows 上开发 HLS/Vivado 工程。

你主要允许修改：
- fpga/hls/
- fpga/vivado/
- fpga/docs/
- fpga/golden_small/

你不要修改：
- src/
- config/
- cmake/
- ROS2 主工程

当前目标是实现 normal_eq_accel HLS 内核和 testbench：
1. 输入 FpgaStateInput + FpgaCorrInput array；
2. 输出 FpgaNormalEqOutput；
3. 使用 float32；
4. 计算 residual；
5. 计算 Jacobian；
6. 累加 H_upper[21]；
7. 累加 b[6]；
8. 写 testbench.cpp，读取 golden bin；
9. 输出 max_abs_error 和 max_rel_error；
10. 编写 run_csim.tcl、run_csynth.tcl、export_ip.tcl；
11. HLS C simulation 必须通过。

请先阅读：
- fpga/docs/FPGA_NORMAL_EQ_IMPLEMENTATION_ROADMAP.md
- fpga/docs/INTERFACE_SPEC.md
- fpga/docs/GOLDEN_DATA_FORMAT.md
- fpga/docs/CURRENT_STATUS.md

不要实现 surfel lookup。
不要实现 KNN。
不要实现 ESKF。
不要实现地图更新。
第一阶段只做 residual/Jacobian/HTH-HTr。
```

------

# 阶段 0：文档和接口冻结

## 0.1 新增 `INTERFACE_SPEC.md`

路径：

```text
fpga/docs/INTERFACE_SPEC.md
```

内容必须包括：

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

------

## 0.2 新增 `GOLDEN_DATA_FORMAT.md`

路径：

```text
fpga/docs/GOLDEN_DATA_FORMAT.md
```

内容必须包括：

```text
1. GoldenHeader 结构
2. golden 文件布局
3. 文件命名规则
4. Orin 如何生成
5. Windows HLS 如何读取
6. normal_eq_replay 如何读取
```

------

## 0.3 新增 `CURRENT_STATUS.md`

路径：

```text
fpga/docs/CURRENT_STATUS.md
```

模板：

~~~markdown
# Current Status

## Branch

- Current branch: dev-fpga

## Interface

- Interface version: 1
- FpgaCorrInput size: 32 bytes
- FpgaStateInput size: TBD
- FpgaNormalEqOutput size: TBD
- GoldenHeader size: TBD

## Current Surfel Parameters

```yaml
surfel_min_support: 3
surfel_cell_resolution: 0.8
surfel_lookup_nearby_type: 26
surfel_quality_max: 0.05
~~~

## Orin Side

-  NormalEquationBackend
-  CpuNormalEquationBackend
-  FpgaNormalEquationBackend
-  golden dump
-  XDMA wrapper
-  fpga_check mode
-  colcon build passed

## Windows HLS Side

-  normal_eq_accel.cpp
-  testbench.cpp
-  run_csim.tcl
-  run_csynth.tcl
-  export_ip.tcl
-  C simulation passed
-  C synthesis passed

## Latest Golden Files

- TBD

## Notes

记录当前问题、下一步任务、已知限制。

```
---

# 阶段 1：Orin 端 CPU backend + golden dump

## 1.1 新增 `src/fpga/fpga_types.h`

定义统一数据结构。

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

如果 namespace 与项目不一致，Codex 可按现有代码风格调整，但必须同步更新文档。

------

## 1.2 新增 NormalEquationBackend

路径：

```text
src/fpga/normal_equation_backend.h
```

内容：

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

------

## 1.3 新增 CPU backend

路径：

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

验收：

```text
1. CPU backend 输出与原 CPU surfel 命中点 HTH/HTr 结果一致。
2. normal_equation_backend=cpu 时轨迹不变。
```

------

## 1.4 在 LaserMapping 中构造 FpgaCorrInput

找到 surfel 命中分支。

新增：

```cpp
std::vector<lightning::fpga::FpgaCorrInput> fpga_corrs;
```

对于 surfel 命中点：

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
1. p_body 必须与当前 CPU Jacobian 使用的点坐标一致。
2. normal/d 必须与当前 residual 使用的平面一致。
3. fallback 点不要加入 fpga_corrs。
```

------

## 1.5 保留 fallback CPU 路径

fallback 点继续走：

```text
surfel invalid
  ↓
iVox GetClosestPoint
  ↓
esti_plane
  ↓
CPU residual/Jacobian/HTH-HTr
```

最终：

```text
H_total = H_surfel_backend + H_fallback_cpu
b_total = b_surfel_backend + b_fallback_cpu
```

------

## 1.6 新增配置项

在配置文件中增加：

```yaml
normal_equation_backend: cpu   # cpu / fpga_check / fpga

fpga:
  enable: false
  golden_dump_enable: false
  golden_dump_dir: "/tmp/lightning_fpga_golden"
  golden_dump_every_n_frames: 100
  golden_dump_max_files: 50

  xdma_h2c: "/dev-fpga/xdma0_h2c_0"
  xdma_c2h: "/dev-fpga/xdma0_c2h_0"
  xdma_user: "/dev-fpga/xdma0_user"

  input_addr: 0x02000000
  output_addr: 0x03000000
  max_points: 4096
  timeout_ms: 100

  compare_with_cpu: true
  max_abs_error: 1.0e-2
  max_rel_error: 1.0e-3
  fallback_to_cpu_on_error: true
```

------

## 1.7 新增 golden writer

路径：

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

------

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

------

# 阶段 2：Windows HLS normal_eq_accel

## 2.1 新增 HLS 工程文件

路径：

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

------

## 2.2 HLS 内核接口

函数：

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

第一版：

```text
1. 使用 float32
2. single lane
3. 不做 fixed-point
4. 不做 surfel lookup
5. 不做 KNN
6. 不做 ESKF
```

------

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

------

## 2.4 HLS testbench

`testbench.cpp` 支持：

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

------

# 阶段 3：Orin XDMA wrapper + normal_eq_replay

## 3.1 新增 XDMA wrapper

路径：

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

------

## 3.2 新增 FPGA backend

路径：

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

如果 FPGA 尚未准备好，先实现 fake mode：

```text
fpga_backend_fake:
  内部调用 CPU backend
  用于验证 Lightning-LM backend 切换流程
```

------

## 3.3 新增 normal_eq_replay

路径：

```text
fpga/host_tools/normal_eq_replay/
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

------

# 阶段 4：Windows Vivado IP / bitstream

## 4.1 HLS 导出 IP

输出目录：

```text
fpga/vivado/ip_repo/normal_eq_accel/
```

------

## 4.2 Vivado 工程脚本化

新增：

```text
fpga/vivado/scripts/create_project.tcl
fpga/vivado/scripts/build_bitstream.tcl
fpga/vivado/scripts/export_hardware.tcl
fpga/vivado/bd/design_1_bd.tcl
fpga/vivado/constraints/top.xdc
```

不要提交：

```text
*.runs/
*.cache/
*.gen/
*.hw/
*.sim/
.Xil/
```

------

# 阶段 5：run_slam_online 接入 FPGA

## 5.1 `fpga_check` 模式

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

------

## 5.2 `fpga` active 模式

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

------

# 阶段 6：验收标准

## 6.1 Orin 端验收

```text
[ ] colcon build 通过
[ ] normal_equation_backend=cpu 正常运行
[ ] golden dump 正常生成
[ ] CpuNormalEquationBackend 和原逻辑一致
[ ] fallback 点仍走 iVox
[ ] fpga_check 模式可启动
[ ] profile 字段正常输出
```

------

## 6.2 Windows HLS 端验收

```text
[ ] normal_eq_accel.cpp 实现
[ ] testbench.cpp 实现
[ ] 能读取 golden bin
[ ] H_upper 对齐
[ ] b 对齐
[ ] residual_sum 对齐
[ ] C simulation PASS
[ ] C synthesis PASS
[ ] export IP 成功
```

------

## 6.3 集成验收

```text
[ ] Orin 能通过 XDMA 调用 FPGA
[ ] normal_eq_replay fpga_check PASS
[ ] run_slam_online fpga_check PASS
[ ] run_slam_online fpga active 不发散
[ ] profile 中 fpga_total_ms 可观测
[ ] CPU/FPGA 轨迹对比无明显异常
```

------

# 阶段 7：后续扩展，不属于当前 P0

当前 P0 完成后，再考虑：

```text
P1：FPGA LookupBatch
P2：FPGA BatchUpdate / dirty surfel refit
P3：iVox fallback 批量化
P4：fixed-point 和多 lane 优化
```

当前不要提前做这些，避免开发范围失控。

------

# 8. 当前最重要原则

```text
1. 全部在 dev-fpga 分支开发。
2. 严格保持目录边界。
3. 接口变化先改文档。
4. Orin 改完 push，Windows pull。
5. Windows 改完 push，Orin pull。
6. 不提交 Vivado/HLS 自动生成中间文件。
7. 不删除 iVox。
8. 不重写 LaserMapping。
9. 第一阶段只做 normal equation acceleration。
```
