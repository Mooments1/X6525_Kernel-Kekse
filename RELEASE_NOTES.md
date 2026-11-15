# X6525 / Infinix Smart 8 - SukiSU kernel release

Version: 5.4.302-kekse+

This is an unofficial community kernel built from the Bocchi-The-Dev kernel fork
with SukiSU Ultra, SUSFS and KPM integrated. SukiSU sources live in
`src/drivers/kernelsu` and are pinned at:

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

Boot images are build artifacts and are not stored in this repository. Build one
locally with `build-susfs.sh` from a stock boot image, then flash it:

  fastboot flash boot boot-image/SUKISU-Kekse-SUSFS-KPM.img (64MiB image)

The matching SukiSU manager is external and must be installed separately.

Updating this release:
1. pull/update source on main and bump CONFIG_LOCALVERSION
2. repeat build + repack commands, KEEP the same toolchain
3. create a new tag (v5.4.302-kekse.N+1), do not recycle old ones
4. push main + tags, then upload the new image as a release asset
