# How to build and release this kernel for Git

## 1. Build prerequisites (Linux)

- `aarch64-linux-gnu-gcc` / binutils (target: ARM64)
- clang toolchain `r416183b`, Android 12.0.5 (LineageOS mirror archives)
- Python 3
- `magiskboot`; a copy of stock `boot.img`; firmware v1964 for a real device
- downstream SukiSU builtin (see `src/INTEGRATE_SUKISU.md`, pinned to commit
  `1cfa57340590971cba7521ed536da8ebbedc5f0a`)

## 2. Build (example for this release)

```bash
TC=<release-root>/toolchain/clang-r416183b
export PATH="$TC/bin:$PATH"
export ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 LLVM_IAS=1
make -C src O=out ARCH=arm64 LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- bg6_defconfig
src/scripts/config --file out/.config --disable THINLTO --disable DEBUG_INFO --disable DEBUG_INFO_BTF --disable UAPI_HEADER_TEST
make -C src O=out ARCH=arm64 LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
KCFLAGS="-O3" make -C src O=out ARCH=arm64 LLVM=1 LLVM_IAS=1 CROSS_COMPILE=aarch64-linux-gnu- -j8 Image
./repack.sh
./verify.sh out/boot-SukiSU-X6525.img
```

Result:
- `out/boot-SukiSU-X6525.img` (64MiB AVB layout, header v4, OS 13.0.0 / patch level 2025-10)
- kernel version: `5.4.302-kekse+`

## 3. Release-version workflow

### Local repository (offline)

```bash
git init
git checkout -b main
echo "*.img" >> .gitignore   # boot-image is a separate release asset
echo "*.apk" >> .gitignore
git add -A
git commit -m "release: x6525 kernel kekse / SukiSU 4.3.0-r2 41165"
git tag -a v5.4.302-kekse.1 -m "X6525 SukiSU 4.3.0 / compile date tag"
git tag -l
```

### Remote publish

```bash
gh auth login   # or export GIT_AUTHOR_*
git remote add origin https://github.com/<user>/<repo>.git
git push -u origin main
git push origin v5.4.302-kekse.1

# attach binary, checksum, manager apk and source tarball to the same release
git archive --format=tar.gz --output=x6525-kernel-source-v5.4.302-kekse.1.tar.gz HEAD
gh release create v5.4.302-kekse.1 \
  --title "x6525 SukiSU kernel kekse" \
  --notes-file RELEASE_NOTES.md \
  boot-image/boot-SukiSU-X6525.img boot-image/SHA256SUMS \
  apk/SukiSU_v4.3.0-r2_41165-arm64-v8a-release.apk \
  x6525-kernel-source-v5.4.302-kekse.1.tar.gz
```

### Notes

- Always bump `CONFIG_LOCALVERSION` for the new release (`src/arch/arm64/configs/bg6_defconfig`).
- Always release `boot-image/SHA256SUMS` with the .img so the boot target cannot be mismatched.
- Do not merge `KernelSU` into this repository if you want the source-only recipe; keep it as an explicit pinned rclone/clone step in `src/INTEGRATE_SUKISU.md`.
- Do not commit `out/`, `logs/`, `work/`, or device images under `.git`; `.gitignore` and `boot-image` exceptions handle this.