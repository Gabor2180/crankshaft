#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
	bootstrap trixie "${ROOTFS_DIR}" http://deb.debian.org/debian/
fi
