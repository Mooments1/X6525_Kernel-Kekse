#!/usr/bin/env python3
"""Repack a stock boot image (header v3/v4) with a freshly built raw kernel Image.

Keeps the stock ramdisk, header fields and cmdline untouched, replacing only
the kernel section. The result is a plain boot image without the AVB footer;
run postprocess_avb.py afterwards to restore the stock vbmeta + footer layout.

usage: repack_boot.py <stock.img> <kernel-Image> <output-raw.img>
"""
import struct
import sys

PAGE = 4096


def align(value, page=PAGE):
    return (value + page - 1) // page * page


def main():
    if len(sys.argv) != 4:
        raise SystemExit(__doc__)
    stock_path, kernel_path, out_path = sys.argv[1:4]

    stock = open(stock_path, "rb").read()
    kernel = open(kernel_path, "rb").read()

    if stock[:8] != b"ANDROID!":
        raise SystemExit("stock image has no ANDROID! magic")

    kernel_size, ramdisk_size = struct.unpack_from("<2I", stock, 8)
    header_size, = struct.unpack_from("<I", stock, 20)
    header_version, = struct.unpack_from("<I", stock, 40)
    if header_version not in (3, 4):
        raise SystemExit("unsupported boot header version %d" % header_version)

    stock_kernel_off = PAGE
    stock_ramdisk_off = align(stock_kernel_off + kernel_size)
    ramdisk = stock[stock_ramdisk_off:stock_ramdisk_off + ramdisk_size]
    if len(ramdisk) != ramdisk_size:
        raise SystemExit("stock image is shorter than its ramdisk")

    new_kernel_size = len(kernel)
    header = bytearray(stock[:PAGE])
    struct.pack_into("<I", header, 8, new_kernel_size)
    struct.pack_into("<I", header, 12, ramdisk_size)
    if header_version == 4:
        struct.pack_into("<I", header, header_size - 4, 0)  # signature_size

    out = bytearray(header)
    out += kernel
    out += b"\x00" * (align(len(out)) - len(out))
    out += ramdisk
    out += b"\x00" * (align(len(out)) - len(out))

    open(out_path, "wb").write(out)
    print("kernel=%d ramdisk=%d content=%d -> %s"
          % (new_kernel_size, ramdisk_size, len(out), out_path))


if __name__ == "__main__":
    main()
