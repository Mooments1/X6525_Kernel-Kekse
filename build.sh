#!/usr/bin/env bash
# Build optimized x6525 kernel release.
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TC="${TC:-$ROOT_DIR/toolchain/clang-r416183b}"
KDIR="${ROOT_DIR}/src"
OUT="${OUT:-$ROOT_DIR/out}"
LOGS="${LOGS:-$ROOT_DIR/logs}"
JOBS="${JOBS:-8}"

export PATH="$TC/bin:$PATH"
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
        --disable DEBUG_INFO --disable DEBUG_INFO_BTF --disable UAPI_HEADER_TEST
    "${MK[@]}" olddefconfig
    grep -E '^(CONFIG_(KSU|KSU_|KPM|LOCALVERSION|LOCALVERSION_AUTO|LTO|THINLTO|LTO_CLANG|LTO_NONE|CFI|CFI_CLANG|CFI_PERMISSIVE|MODVERSIONS|MODULE_SIG|MODULE_SIG_FORCE|MODULE_FORCE_LOAD|KPROBES|KRETPROBES|EXT4_FS|DEBUG_INFO|DEBUG_INFO_BTF|UAPI_HEADER_TEST|KALLSYMS|KALLSYMS_ALL)=)' "$OUT/.config"
    ;;
  image)
    "${MK[@]}" -j"$JOBS" Image 2>&1 | tee "$LOGS/build.log"
    ;;
  modules)
    "${MK[@]}" -k -j"$JOBS" modules 2>&1 | tee "$LOGS/modules.log"
    ;;
  all)
    "$0" config
    "$0" image
    ;;
  *)
    echo "usage: $0 {config|image|modules|all}" >&2; exit 1
    ;;
esac
