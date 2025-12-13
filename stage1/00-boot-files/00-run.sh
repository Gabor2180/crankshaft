#!/bin/bash -e

# Handle both modern (/boot/firmware) and legacy (/boot) boot locations
if [ -d "${ROOTFS_DIR}/boot/firmware" ]; then
	BOOT_DIR="${ROOTFS_DIR}/boot/firmware"
else
	BOOT_DIR="${ROOTFS_DIR}/boot"
fi

install -m 644 files/cmdline.txt "${BOOT_DIR}/"
install -m 644 files/config.txt "${BOOT_DIR}/"
