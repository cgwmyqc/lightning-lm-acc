# Stage67 Full Design Timing Closure Summary

Date: 2026-07-18

## Result

- BD validate: PASS
- Project synthesis: PASS
- Implementation / bitstream: PASS
- Post-route timing: PASS
- DRC: 0 errors, 0 critical warnings

## Bitstream

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
```

Bitstream size:

```text
12454775 bytes
```

## Post-Route Timing

- WNS: 0.123 ns
- TNS: 0.000 ns
- Setup failing endpoints: 0
- WHS: 0.016 ns
- THS: 0.000 ns
- Hold failing endpoints: 0

Vivado report conclusion:

```text
All user specified timing constraints are met.
```

The Stage66B failing `unified_obs_0` double multiply DSP path no longer appears as a timing violation after regenerating observation HLS with an 8 ns target clock.

## Utilization

- Slice LUTs: 147113 / 277400, 53.03%
- Slice registers: 171772 / 554800, 30.96%
- Block RAM tile: 127.5 / 755, 16.89%
- DSPs: 792 / 2020, 39.21%

## Next Orin Regression

After JTAG downloading the timing-clean bitstream, run:

```bash
./install/lightning/lib/lightning/run_surfel_loc_xdma_golden --golden_dir fpga/golden/localization/frame_000001 --ctrl_base 0x1000 --timeout_sec 120 --abi_v2_candidates
./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden --golden_dir fpga/golden/mapping/frame_000001 --ctrl_base 0x1000 --timeout_sec 120 --abi_v2_candidates
./install/lightning/lib/lightning/run_mapping_ekf_update_xdma_golden --golden_dir fpga/golden/mapping_update/frame_000001 --ctrl_base 0x1000 --timeout_sec 120 --repeat 50 --output_dir reports/fpga/runtime/stage66_ekf_update_stability
```

