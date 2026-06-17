# golden_frame_000001_n64 status

Date: 2026-06-17

## Result

- Image generation: PASS (`GOLDEN_IMAGE_PASS`)
- Vivado elaboration/preload smoke: PASS; HLS generated RTL, floating-point IP, controller,
  and five behavioral AXI memory models build into `tb_lmem_golden_behav`.
- Memory preload: PASS; all five generated binary images load.
- Numeric comparison with `-RunNumeric`: BLOCKED by Vivado 2018.3 XSim runtime.

## Details

The bounded run uses the first 64 scan points from
`fpga/golden/localization/frame_000001`. The generator computes the matching
expected normal equation for that bounded input.

Expected bounded counts:

```text
valid/reject/miss = 14/33/17
```

The 64-point RTL run exceeded 15 minutes and had advanced only to roughly
4.4 ms simulation time while still emitting repeated HLS floating-point DSP48
OPMODE warnings. A full 6963-point run also exceeded 20 minutes before
completion. The generated logs are archived in this directory.

## Next

Do not use Vivado 2018.3 full generated floating-point RTL simulation as a
routine golden numeric gate. Keep the BD smoke simulation and project synthesis
as the RTL integration gate, and move the golden numeric check to a faster
wrapper/co-sim strategy or a dedicated tiny synthetic vector that completes
quickly under XSim.
