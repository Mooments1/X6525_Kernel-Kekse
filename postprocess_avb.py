#!/usr/bin/env python3
"""Give a repacked boot image the same on-flash layout as the stock/APatch image.

Layout (matches apatch_patched_*.img):
    [boot content][stock vbmeta blob][zero padding][AVB footer at last 64 bytes]

The vbmeta blob is copied verbatim from the stock image, exactly like APatch
does. On an unlocked bootloader verification is not enforced, but keeping the
footer keeps the partition layout identical to a known-booting image.

usage: postprocess_avb.py <repacked.img> <stock.img> <output.img> [size]
"""
import struct
import sys

PAGE = 4096


def footer(img):
    off = len(img) - 64
    if img[off:off + 4] != b"AVBf":
        raise SystemExit("stock image has no AVB footer")
    orig, vboff, vbsize = struct.unpack_from(">QQQ", img, off + 12)
    return orig, vboff, vbsize


def main():
    if len(sys.argv) < 4:
        raise SystemExit(__doc__)
    raw_path, stock_path, out_path = sys.argv[1:4]
    stock = open(stock_path, "rb").read()
    out_size = int(sys.argv[4]) if len(sys.argv) > 4 else len(stock)
    _, vbmeta_off, vbmeta_size = footer(stock)
    vbmeta = stock[vbmeta_off:vbmeta_off + vbmeta_size]

    raw = open(raw_path, "rb").read()
    # If magiskboot already carried the stock footer over, strip to boot content.
    if len(raw) >= 64 and raw[-64:-60] == b"AVBf":
        raw_orig = struct.unpack_from(">Q", raw, len(raw) - 64 + 12)[0]
        raw = raw[:raw_orig]

    content = raw
    if len(content) % PAGE:
        content += b"\x00" * (PAGE - len(content) % PAGE)
    orig = len(content)

    if orig + vbmeta_size + 64 > out_size:
        raise SystemExit(
            "new kernel too large: content %d + vbmeta %d + footer 64 > %d"
            % (orig, vbmeta_size, out_size)
        )

    out = bytearray(out_size)
    out[:orig] = content
    out[orig:orig + vbmeta_size] = vbmeta

    f = bytearray(64)
    f[0:4] = b"AVBf"
    struct.pack_into(">II", f, 4, 1, 0)          # version 1.0
    struct.pack_into(">QQQ", f, 12, orig, orig, vbmeta_size)
    out[out_size - 64:out_size] = f

    open(out_path, "wb").write(out)
    print("content=%d vbmeta=%d output=%d" % (orig, vbmeta_size, out_size))


if __name__ == "__main__":
    main()
