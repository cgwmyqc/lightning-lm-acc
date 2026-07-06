# Stage 64 Mapping EKF Update Golden Plan

Status: planned, no HLS changes in Stage64.

Scope:

- Extract the lidar/surfel update portion of `ESKF::Update()` into a CPU-testable function.
- Build a mapping update golden fixture before designing any FPGA EKF update core.
- Keep Stage61 Candidate ABI V2 observation as the default observation path.

Planned ABI inputs:

- `HTH/HTr`
- propagated covariance `P`
- current `dx`
- observation covariance / `R`
- degeneracy threshold and step limits
- state snapshot fields needed for boxplus and policy checks

Planned outputs:

- updated `dx_current[NavState::dim]`
- status/debug flags
- covariance update result or enough intermediate data for CPU to finish covariance update

Gate:

- Extracted CPU function must match the current `ESKF::Update()` behavior on mapping golden replay before Stage65 HLS starts.
