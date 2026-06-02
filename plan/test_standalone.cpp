// Standalone algorithm test — verifies the core math of BlockSurfelMap
// without pulling in Eigen / PCL / glog. Builds with:
//   g++ -std=c++17 -O2 -pthread test_standalone.cpp -o test_sa && ./test_sa
//
// 此测试逐行复制 block_surfel_map.cc 的核心算法（编码、累加、Jacobi 拟合），
// 用最小化的 POD 替代 Vec3f/PointType。若此测试通过，
// 集成进 Lightning-LM 后只剩接口层风险。

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <random>
#include <unordered_map>
#include <vector>

// ---------- 算法核心：照搬 block_surfel_map.cc ----------
namespace bsm {

struct BlockGeom {
    static constexpr int BX = 8;
    static constexpr int BY = 8;
    static constexpr int BZ = 4;
    static constexpr int CELLS_PER_BLOCK = BX * BY * BZ;
    static inline int LocalCellIndex(int lx, int ly, int lz) noexcept {
        return (lz * BY + ly) * BX + lx;
    }
};

struct alignas(64) VoxelCell {
    uint32_t count = 0;
    uint32_t flags = 0;
    float sum[3] = {0, 0, 0};
    float scatter[6] = {0, 0, 0, 0, 0, 0};
    float nx = 0, ny = 0, nz = 0;
    float d = 0;
    float quality = 0;
    uint32_t last_update_frame = 0;
    // 凑到 128B = 32 个 float，对应 1 个 UltraRAM 72-bit × 2 元素或 2 行 cache line
    float _pad[15] = {0};
};
static_assert(sizeof(VoxelCell) == 128, "");

enum CellFlag : uint32_t {
    FLAG_DIRTY        = 1u << 0,
    FLAG_VALID_SURFEL = 1u << 1,
};

struct alignas(64) VoxelBlock {
    int64_t morton_key = 0;
    uint32_t version = 0;
    uint32_t valid_cell_count = 0;
    VoxelCell cells[BlockGeom::CELLS_PER_BLOCK];
};

struct BlockKey {
    int32_t x = 0, y = 0, z = 0;
    bool operator==(const BlockKey& r) const noexcept { return x==r.x && y==r.y && z==r.z; }
};
struct BlockKeyHash {
    size_t operator()(const BlockKey& k) const noexcept {
        uint64_t h = static_cast<uint64_t>(k.x) * 73856093u;
        h ^= static_cast<uint64_t>(k.y) * 19349663u;
        h ^= static_cast<uint64_t>(k.z) * 83492791u;
        return static_cast<size_t>(h);
    }
};

// ---------- 编码 ----------
void Encode(float px, float py, float pz, float inv_res, BlockKey& bk, int& cell_idx) {
    auto div_floor = [](int a, int b) -> int {
        int q = a / b;
        int r = a - q * b;
        if ((r != 0) && ((r < 0) != (b < 0))) --q;
        return q;
    };
    auto mod_floor = [](int a, int b) -> int {
        int r = a % b;
        if ((r != 0) && ((r < 0) != (b < 0))) r += b;
        return r;
    };
    const int gx = static_cast<int>(std::floor(px * inv_res));
    const int gy = static_cast<int>(std::floor(py * inv_res));
    const int gz = static_cast<int>(std::floor(pz * inv_res));
    bk.x = div_floor(gx, BlockGeom::BX);
    bk.y = div_floor(gy, BlockGeom::BY);
    bk.z = div_floor(gz, BlockGeom::BZ);
    cell_idx = BlockGeom::LocalCellIndex(
        mod_floor(gx, BlockGeom::BX),
        mod_floor(gy, BlockGeom::BY),
        mod_floor(gz, BlockGeom::BZ));
}

// ---------- 3x3 对称 Jacobi 特征分解 ----------
void FitSurfel(VoxelCell& c, float qmax) {
    if (c.count < 3) {
        c.flags &= ~FLAG_VALID_SURFEL;
        c.flags &= ~FLAG_DIRTY;
        return;
    }
    const float inv_n = 1.0f / static_cast<float>(c.count);
    const float cx = c.sum[0] * inv_n;
    const float cy = c.sum[1] * inv_n;
    const float cz = c.sum[2] * inv_n;

    float A[3][3];
    A[0][0] = c.scatter[0] * inv_n - cx * cx;
    A[0][1] = c.scatter[1] * inv_n - cx * cy;
    A[0][2] = c.scatter[2] * inv_n - cx * cz;
    A[1][0] = A[0][1];
    A[1][1] = c.scatter[3] * inv_n - cy * cy;
    A[1][2] = c.scatter[4] * inv_n - cy * cz;
    A[2][0] = A[0][2];
    A[2][1] = A[1][2];
    A[2][2] = c.scatter[5] * inv_n - cz * cz;

    float V[3][3] = {{1,0,0},{0,1,0},{0,0,1}};
    for (int sweep = 0; sweep < 8; ++sweep) {
        for (int pq = 0; pq < 3; ++pq) {
            int p, q;
            if (pq == 0) { p = 0; q = 1; }
            else if (pq == 1) { p = 0; q = 2; }
            else { p = 1; q = 2; }
            float apq = A[p][q];
            if (std::fabs(apq) < 1e-20f) continue;
            float app = A[p][p], aqq = A[q][q];
            float diff = aqq - app;
            float t;
            if (std::fabs(diff) > 1e6f * std::fabs(apq)) {
                t = apq / diff;
            } else {
                float theta = 0.5f * diff / apq;
                t = 1.0f / (std::fabs(theta) + std::sqrt(1.0f + theta * theta));
                if (theta < 0) t = -t;
            }
            float cs = 1.0f / std::sqrt(1.0f + t * t);
            float sn = t * cs;
            A[p][p] = app - t * apq;
            A[q][q] = aqq + t * apq;
            A[p][q] = 0;
            A[q][p] = 0;
            for (int i = 0; i < 3; ++i) {
                if (i == p || i == q) continue;
                float aip = A[i][p], aiq = A[i][q];
                A[i][p] = cs * aip - sn * aiq;
                A[i][q] = sn * aip + cs * aiq;
                A[p][i] = A[i][p];
                A[q][i] = A[i][q];
            }
            for (int i = 0; i < 3; ++i) {
                float vip = V[i][p], viq = V[i][q];
                V[i][p] = cs * vip - sn * viq;
                V[i][q] = sn * vip + cs * viq;
            }
        }
    }
    float l[3] = {A[0][0], A[1][1], A[2][2]};
    int min_idx = 0;
    if (l[1] < l[min_idx]) min_idx = 1;
    if (l[2] < l[min_idx]) min_idx = 2;
    float trace = l[0] + l[1] + l[2];
    if (trace < 1e-12f) {
        c.flags &= ~FLAG_VALID_SURFEL;
        c.flags &= ~FLAG_DIRTY;
        return;
    }
    float quality = l[min_idx] / trace;
    if (quality > qmax) {
        c.flags &= ~FLAG_VALID_SURFEL;
        c.flags &= ~FLAG_DIRTY;
        c.quality = quality;
        return;
    }
    float nx = V[0][min_idx], ny = V[1][min_idx], nz = V[2][min_idx];
    float nrm = std::sqrt(nx*nx + ny*ny + nz*nz);
    if (nrm < 1e-12f) { c.flags &= ~FLAG_VALID_SURFEL; c.flags &= ~FLAG_DIRTY; return; }
    nx /= nrm; ny /= nrm; nz /= nrm;
    c.nx = nx; c.ny = ny; c.nz = nz;
    c.d = -(nx * cx + ny * cy + nz * cz);
    c.quality = quality;
    c.flags |= FLAG_VALID_SURFEL;
    c.flags &= ~FLAG_DIRTY;
}

} // namespace bsm

// ============================================================================
// 测试框架
// ============================================================================
static int g_passed = 0, g_failed = 0;
#define CHECK(cond, msg) do { \
    if (cond) { ++g_passed; } \
    else { ++g_failed; std::fprintf(stderr, "FAIL line %d: %s\n", __LINE__, msg); } \
} while (0)
#define CHECK_NEAR(a, b, tol, msg) do { \
    float _d = std::fabs(static_cast<float>(a) - static_cast<float>(b)); \
    if (_d <= (tol)) { ++g_passed; } \
    else { ++g_failed; std::fprintf(stderr, "FAIL line %d: |%g-%g|=%g > %g (%s)\n", __LINE__, (double)(a),(double)(b),(double)_d,(double)(tol),msg); } \
} while (0)

// ---------- 测试 1：编码 ----------
static void test_encode_basic() {
    std::printf("[test_encode_basic]\n");
    const float inv_res = 1.0f / 0.5f;  // cell=0.5m，block=4x4x2m

    bsm::BlockKey bk;
    int ci;

    // 原点周围
    bsm::Encode(0.1f, 0.1f, 0.1f, inv_res, bk, ci);
    CHECK(bk.x == 0 && bk.y == 0 && bk.z == 0, "origin point should be in block (0,0,0)");

    // block 边界外的点
    bsm::Encode(4.1f, 0.1f, 0.1f, inv_res, bk, ci);
    CHECK(bk.x == 1 && bk.y == 0 && bk.z == 0, "(4.1, *, *) should be in block (1,0,0)");

    // 负坐标
    bsm::Encode(-0.1f, -0.1f, -0.1f, inv_res, bk, ci);
    CHECK(bk.x == -1 && bk.y == -1 && bk.z == -1, "(-0.1,*,*) should be in block (-1,-1,-1)");

    // cell index 范围
    bsm::Encode(0.0f, 0.0f, 0.0f, inv_res, bk, ci);
    CHECK(ci == 0, "cell at origin should be index 0");
    bsm::Encode(3.9f, 3.9f, 1.9f, inv_res, bk, ci);
    CHECK(ci == 255, "max corner cell should be 255 (8*8*4 - 1)");
}

// ---------- 测试 2：水平平面拟合 ----------
static void test_plane_xy() {
    std::printf("[test_plane_xy]\n");
    bsm::VoxelCell c;
    std::mt19937 rng(42);
    std::uniform_real_distribution<float> u(-0.2f, 0.2f);
    std::uniform_real_distribution<float> jit(-0.02f, 0.02f);
    // 平面 z = 1.0，撒 100 个点
    for (int i = 0; i < 100; ++i) {
        float x = u(rng), y = u(rng), z = 1.0f + jit(rng);
        c.count++;
        c.sum[0] += x; c.sum[1] += y; c.sum[2] += z;
        c.scatter[0] += x*x; c.scatter[1] += x*y; c.scatter[2] += x*z;
        c.scatter[3] += y*y; c.scatter[4] += y*z; c.scatter[5] += z*z;
    }
    c.flags |= bsm::FLAG_DIRTY;
    bsm::FitSurfel(c, 0.05f);
    std::printf("  n=(%.4f,%.4f,%.4f) d=%.4f q=%.5f\n", c.nx, c.ny, c.nz, c.d, c.quality);
    CHECK(c.flags & bsm::FLAG_VALID_SURFEL, "should be valid surfel");
    CHECK_NEAR(std::fabs(c.nz), 1.0f, 0.01f, "|nz| ~ 1");
    CHECK(std::fabs(c.nx) < 0.05f, "nx ~ 0");
    CHECK(std::fabs(c.ny) < 0.05f, "ny ~ 0");
    CHECK_NEAR(std::fabs(c.d), 1.0f, 0.02f, "|d| ~ 1");
    CHECK(c.quality < 0.01f, "quality should be tiny");
}

// ---------- 测试 3：倾斜平面 ----------
static void test_plane_tilted() {
    std::printf("[test_plane_tilted]\n");
    bsm::VoxelCell c;
    std::mt19937 rng(99);
    std::uniform_real_distribution<float> u(0.1f, 0.4f);
    std::uniform_real_distribution<float> jit(-0.005f, 0.005f);
    // 平面 x + y + z = 1
    for (int i = 0; i < 120; ++i) {
        float x = u(rng), y = u(rng);
        float z = 1.0f - x - y + jit(rng);
        c.count++;
        c.sum[0] += x; c.sum[1] += y; c.sum[2] += z;
        c.scatter[0] += x*x; c.scatter[1] += x*y; c.scatter[2] += x*z;
        c.scatter[3] += y*y; c.scatter[4] += y*z; c.scatter[5] += z*z;
    }
    c.flags |= bsm::FLAG_DIRTY;
    bsm::FitSurfel(c, 0.05f);
    std::printf("  n=(%.4f,%.4f,%.4f) d=%.4f q=%.5f\n", c.nx, c.ny, c.nz, c.d, c.quality);
    CHECK(c.flags & bsm::FLAG_VALID_SURFEL, "should be valid surfel");
    const float inv_s3 = 1.0f / std::sqrt(3.0f);
    float dot = c.nx * inv_s3 + c.ny * inv_s3 + c.nz * inv_s3;
    CHECK_NEAR(std::fabs(dot), 1.0f, 0.02f, "|n . (1,1,1)/sqrt(3)| ~ 1");
    CHECK(c.quality < 0.02f, "quality small for true plane");
    // 残差验证
    for (auto pt_check : {std::make_tuple(0.2f, 0.2f, 0.6f), std::make_tuple(0.3f, 0.4f, 0.3f)}) {
        auto [x, y, z] = pt_check;
        float r = c.nx * x + c.ny * y + c.nz * z + c.d;
        std::printf("  residual at (%.2f,%.2f,%.2f) = %.4f\n", x, y, z, r);
        CHECK(std::fabs(r) < 0.05f, "residual on plane should be small");
    }
}

// ---------- 测试 4：随机噪声应被拒绝 ----------
static void test_random_noise_rejected() {
    std::printf("[test_random_noise_rejected]\n");
    bsm::VoxelCell c;
    std::mt19937 rng(7);
    std::uniform_real_distribution<float> u(0.0f, 0.5f);
    for (int i = 0; i < 100; ++i) {
        float x = u(rng), y = u(rng), z = u(rng);
        c.count++;
        c.sum[0] += x; c.sum[1] += y; c.sum[2] += z;
        c.scatter[0] += x*x; c.scatter[1] += x*y; c.scatter[2] += x*z;
        c.scatter[3] += y*y; c.scatter[4] += y*z; c.scatter[5] += z*z;
    }
    c.flags |= bsm::FLAG_DIRTY;
    bsm::FitSurfel(c, 0.05f);
    std::printf("  quality=%.5f, valid=%d\n", c.quality, (c.flags & bsm::FLAG_VALID_SURFEL) != 0);
    CHECK(!(c.flags & bsm::FLAG_VALID_SURFEL), "random noise should NOT be valid surfel");
    CHECK(c.quality > 0.05f, "noise quality should exceed threshold");
}

// ---------- 测试 5：球面（强非平面）应被拒绝 ----------
static void test_sphere_rejected() {
    std::printf("[test_sphere_rejected]\n");
    bsm::VoxelCell c;
    std::mt19937 rng(13);
    std::uniform_real_distribution<float> a(0, 2 * M_PI);
    std::uniform_real_distribution<float> b(0, M_PI);
    const float r = 0.2f;
    for (int i = 0; i < 100; ++i) {
        float theta = a(rng), phi = b(rng);
        float x = 0.25f + r * std::sin(phi) * std::cos(theta);
        float y = 0.25f + r * std::sin(phi) * std::sin(theta);
        float z = 0.25f + r * std::cos(phi);
        c.count++;
        c.sum[0] += x; c.sum[1] += y; c.sum[2] += z;
        c.scatter[0] += x*x; c.scatter[1] += x*y; c.scatter[2] += x*z;
        c.scatter[3] += y*y; c.scatter[4] += y*z; c.scatter[5] += z*z;
    }
    c.flags |= bsm::FLAG_DIRTY;
    bsm::FitSurfel(c, 0.05f);
    std::printf("  quality=%.5f, valid=%d\n", c.quality, (c.flags & bsm::FLAG_VALID_SURFEL) != 0);
    CHECK(!(c.flags & bsm::FLAG_VALID_SURFEL), "sphere shell should be rejected (3D blob)");
}

// ---------- 测试 6：与 Eigen SVD ground-truth 的对比（用解析公式） ----------
// 对于纯平面 z=z0，已知协方差是 diag(σ²_x, σ²_y, 0)，
// 最小特征值是 0，对应特征向量是 (0,0,1)。
static void test_against_analytical() {
    std::printf("[test_against_analytical]\n");
    bsm::VoxelCell c;
    // 解析点云：网格化的 z=2.5 平面，5x5 个点
    for (int i = 0; i < 5; ++i) {
        for (int j = 0; j < 5; ++j) {
            float x = 0.05f * i;
            float y = 0.05f * j;
            float z = 2.5f;
            c.count++;
            c.sum[0] += x; c.sum[1] += y; c.sum[2] += z;
            c.scatter[0] += x*x; c.scatter[1] += x*y; c.scatter[2] += x*z;
            c.scatter[3] += y*y; c.scatter[4] += y*z; c.scatter[5] += z*z;
        }
    }
    c.flags |= bsm::FLAG_DIRTY;
    bsm::FitSurfel(c, 0.05f);
    std::printf("  n=(%.6f,%.6f,%.6f) d=%.6f q=%.6e\n", c.nx, c.ny, c.nz, c.d, c.quality);
    CHECK(c.flags & bsm::FLAG_VALID_SURFEL, "exact plane should be valid");
    CHECK_NEAR(std::fabs(c.nz), 1.0f, 1e-4f, "perfect plane: |nz| = 1");
    CHECK(std::fabs(c.nx) < 1e-4f, "perfect plane: nx ~ 0");
    CHECK(std::fabs(c.ny) < 1e-4f, "perfect plane: ny ~ 0");
    CHECK_NEAR(std::fabs(c.d), 2.5f, 1e-4f, "perfect plane: |d| = 2.5");
    CHECK(c.quality < 1e-5f, "perfect plane: quality ~ 0");
}

// ---------- 测试 7：分桶排序稳定 + 同 block 连续 ----------
static void test_sort_stability() {
    std::printf("[test_sort_stability]\n");
    const float inv_res = 1.0f / 0.5f;
    std::mt19937 rng(0);
    std::uniform_real_distribution<float> u(-20, 20);

    struct E {
        bsm::BlockKey bk;
        int ci;
        int pi;
        size_t h;
    };
    std::vector<E> es;
    es.reserve(2000);
    bsm::BlockKeyHash hasher;
    for (int i = 0; i < 2000; ++i) {
        E e;
        e.pi = i;
        bsm::Encode(u(rng), u(rng), u(rng), inv_res, e.bk, e.ci);
        e.h = hasher(e.bk);
        es.push_back(e);
    }
    std::sort(es.begin(), es.end(), [](const E& a, const E& b) {
        if (a.h != b.h) return a.h < b.h;
        if (!(a.bk == b.bk)) {
            if (a.bk.x != b.bk.x) return a.bk.x < b.bk.x;
            if (a.bk.y != b.bk.y) return a.bk.y < b.bk.y;
            return a.bk.z < b.bk.z;
        }
        return a.ci < b.ci;
    });

    // 验证：所有同 block 的项是连续的
    bool ok = true;
    for (size_t i = 1; i < es.size(); ++i) {
        if (es[i].bk == es[i-1].bk) continue;
        // 跳到新 block 后，后面不应再见到 es[i-1].bk
        bsm::BlockKey prev = es[i-1].bk;
        for (size_t j = i + 1; j < es.size(); ++j) {
            if (es[j].bk == prev) { ok = false; break; }
        }
        if (!ok) break;
    }
    CHECK(ok, "same-block entries must be contiguous after sort");
}

int main() {
    test_encode_basic();
    test_plane_xy();
    test_plane_tilted();
    test_random_noise_rejected();
    test_sphere_rejected();
    test_against_analytical();
    test_sort_stability();
    std::printf("\n=== %d passed, %d failed ===\n", g_passed, g_failed);
    return g_failed == 0 ? 0 : 1;
}
