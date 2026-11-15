#!/usr/bin/env bash
# Build the X6525 kernel with full optimization (full LTO + -O3 + CFI)
# and SukiSU builtin with SUSFS + KPM, then repack a flashable boot image.
#
# Requirements:
#   - clang toolchain with LLVM binutils in PATH (LLVM=1 + LLVM_IAS=1)
#   - stock boot image (STOCK=/path/to/boot_stock.img)
#   - SukiSU source in src/drivers/kernelsu (pinned builtin branch)
#
# usage: ./build-susfs.sh [config|image|repack|all]
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
KDIR="$ROOT_DIR/src"
OUT="${OUT:-$ROOT_DIR/out-susfs}"
LOGS="${LOGS:-$ROOT_DIR/logs-susfs}"
JOBS="${JOBS:-8}"
STOCK="${STOCK:-$HOME/x6525/boot_stock.img}"
IMAGE="${IMAGE:-$ROOT_DIR/boot-image/SUKISU-Kekse-SUSFS-KPM.img}"
SIZE="${SIZE:-67108864}"
TC="${TC:-$ROOT_DIR/toolchain/clang-r416183b}"

export PATH="$TC/bin:${LLVM_BIN:-/usr/lib/llvm/22/bin}:$PATH"
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export LLVM=1
export LLVM_IAS=1
export KBUILD_BUILD_USER=build-user
export KBUILD_BUILD_HOST=build-host

MK=(make -C "$KDIR" O="$OUT" ARCH=arm64 LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu-)
mkdir -p "$OUT" "$LOGS"

case "${1:-all}" in
  config)
    "${MK[@]}" bg6_defconfig
    "$KDIR/scripts/config" --file "$OUT/.config" \
        --disable DEBUG_INFO --disable DEBUG_INFO_BTF \
        --disable UAPI_HEADER_TEST --disable THINLTO --disable NOMOUNT \
        --enable LTO_CLANG --enable KPM --enable KSU_SUSFS
    "${MK[@]}" olddefconfig
    grep -E '^(CONFIG_(KSU|KSU_|KPM|LOCALVERSION|LTO|THINLTO|LTO_CLANG|CFI|CFI_CLANG|CFI_CLANG_SHADOW|CC_OPTIMIZE_FOR_PERFORMANCE))=' "$OUT/.config"
    ;;
  image)
    KCFLAGS="-O3" "${MK[@]}" -j"$JOBS" Image 2>&1 | tee "$LOGS/build.log"
    ;;
  repack)
    [ -f "$STOCK" ] || { echo "missing STOCK=$STOCK" >&2; exit 1; }
    mkdir -p "$(dirname "$IMAGE")"
    "$ROOT_DIR/repack_boot.py" "$STOCK" "$OUT/arch/arm64/boot/Image" "$OUT/boot-raw.img"
    "$ROOT_DIR/postprocess_avb.py" "$OUT/boot-raw.img" "$STOCK" "$IMAGE" "$SIZE"
    ( cd "$(dirname "$IMAGE")" && sha256sum "$(basename "$IMAGE")" )
    ;;
  all)
    "$0" config
    "$0" image
    "$0" repack
    ;;
  *)
    echo "usage: $0 {config|image|repack|all}" >&2; exit 1
    ;;
esac
