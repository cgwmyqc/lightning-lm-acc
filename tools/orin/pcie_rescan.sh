#!/usr/bin/env bash
set -euo pipefail

exec sudo -n /usr/local/sbin/lightning-pcie-control recover
