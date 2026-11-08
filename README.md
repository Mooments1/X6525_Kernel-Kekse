# Kernel-Kekse

This is the X6525 / Infinix Smart 8 UMS9230 SukiSU kernel release, configured for
the optimized and monolithic LTO build.

The kernel source is derived from the community transsion UMS9230 tree. SukiSU sources are intentionally not bundled in this repository; apply the compatibility patch and upstream pin before building.

## Key artifact

- `boot-image/SUKISU-Kekse.img`
- `SHA-256`: `7c6199a99552ade128197ac1992e16e8baa59b17e3d2eb5ab648501dd7286bf3`
- version: `5.4.302-kekse+`

## Source layout

- `src/` kernel source (without embedded SukiSU source; integrate externally)
- `patches/` kernel-side changes to apply
- `build.sh`, `postprocess_avb.py`, `verify.sh`
- `boot-image/SHA256SUMS`
- documentation: `README.md`, `NOTES.md`, `docs/BUILD_AND_RELEASE.md`,
  `RELEASE_NOTES.md`
