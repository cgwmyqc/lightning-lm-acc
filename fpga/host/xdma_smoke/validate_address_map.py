#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

import argparse
from pathlib import Path

from address_map import REGIONS, region_table, validate_layout


def main():
    parser = argparse.ArgumentParser(description="Validate AX7Z100 PL DDR address layout.")
    parser.add_argument("--report", default="")
    args = parser.parse_args()

    validate_layout()
    print("ADDRESS_MAP_PASS")
    print(region_table())

    if args.report:
        report = Path(args.report)
        report.parent.mkdir(parents=True, exist_ok=True)
        lines = ["# AX7Z100 PL DDR Address Map Validation", "", "ADDRESS_MAP_PASS", ""]
        lines.append("| Region | Base | Size |")
        lines.append("| --- | ---: | ---: |")
        for region in REGIONS:
            lines.append(f"| {region.name} | `0x{region.base:08x}` | `0x{region.size:08x}` |")
        report.write_text("\n".join(lines) + "\n", encoding="utf-8")
        print(f"report={report}")


if __name__ == "__main__":
    main()

