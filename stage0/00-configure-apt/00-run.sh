#!/bin/bash -e

install -m 644 files/sources.list "${ROOTFS_DIR}/etc/apt/"
install -m 644 files/raspi.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"

if [ -n "$APT_PROXY" ]; then
	install -m 644 files/51cache "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
	sed "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache" -i -e "s|APT_PROXY|${APT_PROXY}|"
else
	rm -f "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
fi

# Use modern apt-key handling with signed-by in sources
install -d "${ROOTFS_DIR}/etc/apt/keyrings"
install -m 644 files/raspberrypi.gpg.key "${ROOTFS_DIR}/etc/apt/keyrings/raspberrypi-archive-keyring.asc"

# Update raspi.list to use signed-by
sed -i 's|^deb |deb [signed-by=/etc/apt/keyrings/raspberrypi-archive-keyring.asc] |' "${ROOTFS_DIR}/etc/apt/sources.list.d/raspi.list"

on_chroot << EOF
apt-get update
apt-get dist-upgrade -y
EOF
