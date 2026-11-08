# X6525 kernel build notes

- Source base: `Bocchi-The-Dev/kernel_transsion_ums9230`, branch `master`
  (`5.4.302`, ACK android12-5.4)
- Localized release: Linux 5.4.302, LOCALVERSION `-kekse`
- Toolchain: Android clang `r416183b` (12.0.5)
- SukiSU: builtin (pinned SHA), KSU_VERSION `41165`, VERSION_TAG `4.3.0`
- LTO: full (CONFIG_LTO_CLANG only; ThinLTO disabled)
- Compile: `KCFLAGS="-O3"` overrides `-O2`
- CFI: enabled
- Defconfig: `arch/arm64/configs/bg6_defconfig`
- Output kernel: `5.4.302-kekse+`
- Output image SHA256:
  `7c6199a99552ade128197ac1992e16e8baa59b17e3d2eb5ab648501dd7286bf3`

Requirements:
- stock vendor boot modules must load: patched module.c turns vermagic/CRC mismatch
  into warnings.
- stock bootloader is unlocked; stock vbmeta(blob passthrough) is reused exactly by
  `postprocess_avb.py`.

Build:

```bash
./build.sh config
./build.sh image
# manually repack using release-local repack.sh or your tool
./verify.sh boot-image/boot-SukiSU-X6525.img
```

Rollback:
- fastboot `boot_stock.img` (not part of this repo)