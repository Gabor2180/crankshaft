#!/bin/bash -e

# For arm64 builds, we need Qt5 compiled for aarch64
# The prebuilts need to be updated for arm64/Trixie compatibility
# For now, skip the Qt5 installation as it requires arm64 binaries

# Note: Qt5 prebuilts will need to be rebuilt for arm64
# cat $BASE_DIR/prebuilts/qt5/Qt_5151_arm64_OpenGLES2.tar.xz* > files/qt5/Qt5_OpenGLES2.tar.xz
# tar -xf files/qt5/Qt5_OpenGLES2.tar.xz -C ${ROOTFS_DIR}/

echo "Note: Qt5 prebuilts need to be rebuilt for arm64 architecture"
echo "The OpenAuto application will need arm64 compiled binaries"