# B 方案改动清单（删 iVox + 块哈希 + 块内连续 + 点自由 surfel）

## 一句话总结
把原 iVox 局部地图替换为 **block-hash 目录 + 块内 256 个连续 cell + 点自由
surfel 统计**；`ObsModel` 改为 O(1) surfel 直查，`MapIncremental` 改为
基于 cell 饱和度的批量更新。**移除热路径 KNN 与在线平面拟合**。

## 新增
- `src/core/block_surfel_map/block_surfel_map.h`
- `src/core/block_surfel_map/block_surfel_map.cc`
- `src/core/block_surfel_map/test_standalone.cpp` — 零依赖单测（26 用例全过）
- `src/core/block_surfel_map/README.md`

## 删除
- 整个 `src/core/ivox3d/` 目录（按"直接替换"模式）

## 修改
| 文件 | 改动 |
|---|---|
| `src/core/lio/laser_mapping.h` | `#include` 改为 block_surfel_map；`IVoxType` 删除，新增 `using MapType = BlockSurfelMap`；`ivox_options_`/`ivox_` 替换为 `surfel_map_options_`/`surfel_map_`；`nearest_points_` 替换为 `surfel_corr_` |
| `src/core/lio/laser_mapping.cc::Init` | `ivox_` 创建改为 `surfel_map_` 创建 |
| `src/core/lio/laser_mapping.cc::LoadParamsFromYAML` | 读取新 yaml 字段 `surfel_min_support/_quality_max/_block_capacity`；保留 `ivox_grid_resolution` 名字以兼容 |
| `src/core/lio/laser_mapping.cc::Run` 首帧 | `ivox_->AddPoints` → `surfel_map_->Initialize` |
| `src/core/lio/laser_mapping.cc::Run` 日志 | `Map grid num` → `Surfel blocks / valid surfels / fallback` |
| `src/core/lio/laser_mapping.cc::ObsModel` | **核心改动**：每点调 `LookupSurfel`，直接获取预计算 plane；命中失败入 fallback 队列；删除 GetClosestPoint + esti_plane |
| `src/core/lio/laser_mapping.cc::MapIncremental` | **核心改动**：完全重写为饱和度准则；不再依赖 nearest_points_，单线程过滤后 BatchUpdate；原 FIXME 并发问题彻底消失 |
| `src/core/lio/laser_mapping.cc` ICP 部分 | `nearest_points_[i][0]` → `surfel_corr_[i].centroid` |
| `src/CMakeLists.txt` | 加入 `core/block_surfel_map/block_surfel_map.cc` |
| `config/*.yaml` (6 个) | 加入 `surfel_min_support / quality_max / block_capacity` 三个新字段 |

## 行为变化（必须知道）
1. **写入决策语义改变**：原本"邻居点距离比较" → 现在"cell 饱和度"。
   静态区域的写入被砍掉的比例可能很大，这是预期行为，不是 bug。
2. **观测的对应几何变了**：原本 K=5 个邻居在线拟合平面 → 现在 cell 内全
   部历史点的统计 surfel。退化 / 多平面 cell 不会再被发现，会被
   `quality_max` 阈值过滤掉，落入 fallback 计数。
3. **fallback 第一版只统计不回退**。`FallbackCount()` 每帧打印一次再清零；
   如果稳态下 `fallback / cnt_pts > 5%`，需要先调 `surfel_quality_max` 或
   `surfel_min_support`，不要急于上 FPGA。

## 我没能在沙箱内验证的部分（请你在本地确认）
- 集成层是否编译通过（沙箱无 PCL/Eigen/glog）
- ESKF 收敛行为（需要 rosbag）
- 在你目标数据集上的 APE/RPE
- `<execution>` 在你工具链里是否需要 `-ltbb`

## 已经在沙箱内通过的部分
- `test_standalone.cpp` 26 个用例全过：编码、累加、Jacobi 拟合、噪声/球面拒绝、排序连续性都正确
