# Stage72E Loc Full Scan Cap Fastfix Commands

```bash
colcon build --packages-select lightning
source install/setup.bash

./install/lightning/lib/lightning/run_surfel_loc_iterative_xdma_golden \
  --golden_dir fpga/golden/localization_iterative/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 1 \
  --verify_readback

git diff --check
```

The golden replay was run as the normal user because this Orin image rejects
root `O_CREAT` opens on an existing user-owned `/tmp/lightning_xdma_observation.lock`
under the sticky `/tmp` protection policy.
