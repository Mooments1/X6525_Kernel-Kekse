# How to build and release this kernel

## 1. Build prerequisites (Linux)

- `aarch64-linux-gnu-gcc` / binutils (target: ARM64)
- clang toolchain `r416183b` (Android 12.0.5, LineageOS mirror archives),
  placed in `toolchain/clang-r416183b` or passed via `TC=`
- Python 3
- a stock `boot.img` for the target firmware
- SukiSU Ultra builtin, already bundled in `src/drivers/kernelsu` and pinned in
  `patches/sukisu-builtin-upstream.sha`

## 2. Build

```bash
./build-susfs.sh config
./build-susfs.sh image
STOCK=/path/to/stock_boot.img ./build-susfs.sh repack
```

Result: `boot-image/SUKISU-Kekse-SUSFS-KPM.img` (64MiB AVB layout, header v4,
OS 13.0.0 / patch level 2025-10) with kernel version `5.4.302-kekse+`.

`build.sh` is the smaller source-only build without SUSFS/KPM.

## 3. Publish to GitHub

Build outputs are not committed. `out/`, `out-susfs/`, `logs/`, `logs-susfs/`,
`toolchain/` and `boot-image/` are ignored, as are root-level images and
archives.

```bash
git add -A
git commit -m "release: x6525 5.4.302-kekse.N"
git tag -a v5.4.302-kekse.N -m "X6525 SukiSU 4.3.0 / compile date tag"
git push origin main
git push origin v5.4.302-kekse.N
```

Attach the locally built image and its checksum to the GitHub release:

```bash
sha256sum boot-image/SUKISU-Kekse-SUSFS-KPM.img > boot-image/SHA256SUMS
gh release create v5.4.302-kekse.N \
  --title "x6525 SukiSU kernel kekse" \
  --notes-file RELEASE_NOTES.md \
  boot-image/SUKISU-Kekse-SUSFS-KPM.img boot-image/SHA256SUMS
```

## Notes

- Bump `CONFIG_LOCALVERSION` in `src/arch/arm64/configs/bg6_defconfig` for a new
  release.
- Always publish a checksum with the boot image so the target cannot be
  mismatched.
- Do not commit boot images, toolchains or build outputs; keep them as release
  assets.
