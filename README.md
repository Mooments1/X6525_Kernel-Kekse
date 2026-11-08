# X6525_Kernel-Kekse

This folder is a **source release** of the custom X6525 / Infinix Smart 8 UMS9230
SukiSU kernel. It is not an official Infinix/transsion kernel. It was built from the
community transsion/ums9230 source with SukiSU Ultra, then optimized with `-O3`,
monolithic LTO, and CFI.

## Key artifact

- `boot-image/boot-SukiSU-X6525.img`
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

## What was changed

- `src/arch/arm64/configs/bg6_defconfig`: KSU enable, SukiSU version pin,
  monolithic LTO flags, localversion `-kekse`
- `src/fs/exec.c`, `src/fs/open.c`, `src/fs/read_write.c`, `src/fs/stat.c`:
  manual SukiSU handling
- `src/drivers/kernelsu` integration is prepared through patches/compat scripts

## Release status

- compile verification: `2635` `.cmd` files include `-O3`
- SukiSU source is not bundled in this repository even though kernel side
  expects it from an external clone
- prepared for Git with proper `.gitignore` and tags metadata
- source tree only; manager and proprietary binaries are intentionally out

## Next

1. configure `git` author identity
2. `git init && git checkout -b main`
3. `git add -A && git commit -m "..."`
4. `git tag -a ...` and publish to GitHub
5. publish the binary + SHA256 only as release asset

See `docs/BUILD_AND_RELEASE.md`.