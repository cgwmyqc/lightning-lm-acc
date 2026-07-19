# Stage70 Localization Full Iterative ABI Summary

Status: COMPLETE on Windows/design side.

Stage70 fixes the boundary for a new localization full iterative FPGA path:

```text
SURFEL_FPGA_FULL_ITERATIVE
```

Current localization FPGA mode remains:

```text
SURFEL_FPGA_OBS_SOLVE
```

In the current mode, each localization iteration launches a separate FPGA observation/solve transaction and the CPU applies `SE3::exp(dx) * pose`, checks convergence, and handles fallback.

The Stage70 target is one FPGA transaction per localization frame. The FPGA core consumes scan points and precomputed Candidate ABI V2 cells, then performs repeated observation accumulation, solve6x6, pose update, and convergence checks internally.

The Stage70 ABI is intentionally separate from `slam_ekf_update_core`. The EKF update core is mapping-specific and operates on mapping state/covariance, while localization full iteration is a pose registration loop.

Real iterative golden data is not present on Windows yet:

```text
fpga/golden/localization_iterative/frame_000001
```

Next stage: Stage71 standalone HLS core, followed by Stage72 Orin golden export and runtime integration.

