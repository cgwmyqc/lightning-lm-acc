# Stage 63 Localization FPGA_OBS_SOLVE Runtime Plan

Status: planned after Stage62 Orin golden PASS.

Scope:

- Enable localization online runtime mode where FPGA returns both observation normal equation and `dx[6]`.
- CPU still applies `SE3::exp(dx) * pose`, convergence checks, quality gates, and fallback policy.
- Keep `SURFEL_FPGA_OBS`, `SURFEL_CPU_SIM`, and NDT fallback available.

Required gate before implementation:

- Stage62 Orin golden command with `--abi_v2_candidates --fpga_solve6x6` must output `LOC_XDMA_SOLVE6X6_PASS`.
- Mapping V2 golden replay must remain PASS.

Planned runtime additions:

- `SURFEL_FPGA_OBS_SOLVE` should no longer degrade to `SURFEL_FPGA_OBS`.
- Profile CSV fields: `fpga_solve_sec`, `fpga_solve_status`, `dx_norm`, `dx[6]`.
- First online smoke: localization-only, `max_iterations=1`.
