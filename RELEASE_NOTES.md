# X6525 / Infinix Smart 8 - SukiSU kernel release

Version: 5.4.302-kekse+
Boot image SHA-256: 7c6199a99552ade128197ac1992e16e8baa59b17e3d2eb5ab648501dd7286bf3

This is an unofficial community kernel built from the Bocchi-The-Dev kernel fork with
SukiSU Ultra integrated. SukiSU itself is NOT shipped in this release; build requires
an external SukiSU builtin checkout pinned at:

- repo: SukiSU-Ultra/SukiSU-Ultra
- branch: builtin
- commit: 1cfa57340590971cba7521ed536da8ebbedc5f0a
- KSU_VERSION: 41165 / VERSION_TAG: 4.3.0

Compile-time optimizations actually applied:
- KCFLAGS="-O3" applied after CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE (-O2)
- CONFIG_LTO_CLANG=y
- CONFIG_THINLTO disabled -> full monolithic LTO
- CONFIG_CFI_CLANG=y + CONFIG_CFI_CLANG_SHADOW=y
- stock module compatibility patch: vermagic/CRC mismatches become warnings

Known-good device flashing:
  fastboot flash boot boot-image/boot-SukiSU-X6525.img (64MiB image)

Rollback:
  fastboot flash boot /path/to/boot_stock.img

The matching SukiSU manager used for this release is external and must be installed
separately. Keep the stock boot image outside the repository to avoid bloating commits.