# X6525_Kernel-Kekse

This is **my** custom X6525 / Infinix Smart 8 (UMS9230) SukiSU kernel release.
It is unofficial: I rebuilt it from a community transsion source and added SukiSU Ultra, then
tuned it with -O3, monolithic LTO, and CFI for speed and a cleaner memory layout. If you
only want a boot image, use `boot-image/SUKISU-Kekse.img`; the source side is still here
so anyone can inspect the changes, but the KernelSU core itself is intentionally omitted and
must be imported separately.

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
