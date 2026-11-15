# Kernel-Kekse

X6525 / Infinix Smart 8 UMS9230 SukiSU kernel source, configured for the
optimized and monolithic LTO build.

The kernel source is derived from the community transsion UMS9230 tree. SukiSU
Ultra (builtin branch, pinned in `patches/sukisu-builtin-upstream.sha`) is
bundled in `src/drivers/kernelsu`, together with SUSFS and KPM support.

## Source layout

- `src/` kernel source
- `patches/` upstream pins and kernel-side changes
- `build.sh`, `build-susfs.sh` build scripts
- `repack_boot.py`, `postprocess_avb.py` boot image tools
- `docs/BUILD_AND_RELEASE.md` build and release instructions

## Building

```txt
./build-susfs.sh config
./build-susfs.sh image
./build-susfs.sh repack
```

Kernel version: `5.4.302-kekse+`.

Build outputs, toolchains and boot images are intentionally not committed. The
flashable boot image is built locally from a stock boot image and attached to a
GitHub release when needed.
