#!/usr/bin/env bash
# Offline verification for a packaged boot image.
# Set STOCK=path to a known-good stock image and MB=path to magiskboot.
set -euo pipefail
MB=${MB:-magiskboot}
IMG=${1:-boot-image/boot-SukiSU-X6525.img}
STOCK=${STOCK:?Set STOCK=/path/to/boot_stock.img}
WORK=${WORK:-./work/verify}

[ -f "$IMG" ] || { echo "missing $IMG" >&2; exit 1; }
rm -rf "$WORK"; mkdir -p "$WORK"; cd "$WORK"
echo "=== header of $IMG ==="
"$MB" unpack -h "$IMG" || true
cat header 2>/dev/null || true
echo "=== size ==="
ls -la "$IMG"
echo "=== kernel version string ==="
strings -a kernel | grep -m3 'Linux version' || true
echo "=== SukiSU markers ==="
strings -a kernel | grep -m5 -i -E 'kernelsu|sukisu' || true
echo "=== sha256 ==="
sha256sum "$IMG" "$STOCK"
