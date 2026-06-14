# XDMA Diagnostics

This helper collects Orin-side PCIe/XDMA status when `lspci` can see the FPGA
endpoint but `/dev/xdma*` is missing.

Default read-only run:

```bash
cd <repo-root>
bash fpga/host_tools/xdma_diag/xdma_diagnose.sh
```

If the Xilinx device id is visible but the `xdma` module is not loaded:

```bash
bash fpga/host_tools/xdma_diag/xdma_diagnose.sh --try-modprobe
```

If the module is loaded but not bound, and no process is using XDMA:

```bash
bash fpga/host_tools/xdma_diag/xdma_diagnose.sh --rescan
```

If auto-detection does not select the right PCIe function:

```bash
bash fpga/host_tools/xdma_diag/xdma_diagnose.sh --bdf 0005:01:00.0
```

Use the generated output together with `fpga/docs/XDMA_DEBUG.md`.
