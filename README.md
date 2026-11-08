# Kernel-Kekse

This is the X6525 / Infinix Smart 8 UMS9230 SukiSU kernel release, configured for
the optimized and monolithic LTO build.

The kernel source is derived from the community transsion UMS9230 tree. Node-level
SukiSU sources are intentionally not bundled (see `src/INTEGRATE_SUKISU.md`). To
get running quickly, use `boot-image/SUKISU-Kekse.img`; the build recipes, patches
and reproducibility settings are all here.

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

## Upstreams

- base source: `Bocchi-The-Dev/kernel_transsion_ums9230`, branch `master`
- SukiSU Ultra: `SukiSU-Ultra/SukiSU-Ultra`, branch `builtin`,
  commit `1cfa57340590971cba7521ed536da8ebbedc5f0a`
- KSU version: `41165`
- VERSION_TAG: `4.3.0`
