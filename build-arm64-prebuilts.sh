#!/bin/bash
# Build Qt5 and OpenAuto for arm64 (Debian Trixie)
# Run this script on a Raspberry Pi 4/5 running arm64 Debian Trixie

set -e

# Configuration
QT_VERSION="5.15"
QT_FULL_VERSION="5.15.15"
AASDK_REPO="https://github.com/opencardev/aasdk.git"
AASDK_BRANCH="newdev"
OPENAUTO_REPO="https://github.com/opencardev/openauto.git"
OPENAUTO_BRANCH="crankshaft-ng"

# Detect CPU cores
CPU_CORES=${CPU_CORES:-$(nproc)}

# Working directory
BUILD_DIR="${BUILD_DIR:-$HOME/crankshaft-build}"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "=== Building Crankshaft components for arm64 ==="
echo "Build directory: $BUILD_DIR"
echo "Using $CPU_CORES CPU cores"

# Install dependencies
install_deps() {
    echo "=== Installing build dependencies ==="
    sudo apt-get update
    sudo apt-get install -y \
        build-essential cmake git pv \
        libboost-all-dev libusb-1.0-0-dev libssl-dev \
        libprotobuf-dev protobuf-compiler \
        libtag1-dev libgps-dev librtaudio-dev \
        libpulse-dev libasound2-dev \
        libgles2-mesa-dev libdrm-dev \
        libgbm-dev libinput-dev libudev-dev \
        libxkbcommon-dev libfontconfig1-dev \
        libfreetype-dev libx11-dev libx11-xcb-dev \
        libxcb-glx0-dev libxcb-icccm4-dev libxcb-image0-dev \
        libxcb-keysyms1-dev libxcb-randr0-dev libxcb-render-util0-dev \
        libxcb-shape0-dev libxcb-shm0-dev libxcb-sync-dev \
        libxcb-xfixes0-dev libxcb-xinerama0-dev libxcb-xkb-dev \
        libxkbcommon-x11-dev libxcb-cursor-dev
}

# Build Qt 5.15
build_qt() {
    echo "=== Building Qt $QT_FULL_VERSION ==="
    
    QT_FILENAME="qt-everywhere-opensource-src-${QT_FULL_VERSION}.tar.xz"
    QT_URL="https://download.qt.io/official_releases/qt/${QT_VERSION}/${QT_FULL_VERSION}/single/${QT_FILENAME}"
    
    # Download if not exists
    if [ ! -f "$QT_FILENAME" ]; then
        echo "Downloading Qt source..."
        wget "$QT_URL"
    fi
    
    # Extract if not exists
    if [ ! -d "qt-everywhere-src-${QT_FULL_VERSION}" ]; then
        echo "Extracting Qt source..."
        pv "$QT_FILENAME" | tar -xJf -
    fi
    
    # Configure and build
    mkdir -p qt_build
    cd qt_build
    
    # Detect Pi model for optimal device config
    DEVICE_OPT="linux-aarch64-gnu-g++"
    if grep -q "Raspberry Pi 5" /proc/cpuinfo 2>/dev/null; then
        echo "Detected Raspberry Pi 5"
        # Pi 5 uses linux-aarch64-gnu-g++ or custom device
    elif grep -q "Raspberry Pi 4" /proc/cpuinfo 2>/dev/null; then
        echo "Detected Raspberry Pi 4"
        # May need custom device spec for Pi 4 arm64
    fi
    
    echo "Configuring Qt with device: $DEVICE_OPT"
    
    ../qt-everywhere-src-${QT_FULL_VERSION}/configure \
        -prefix /usr/local/qt5 \
        -opensource -confirm-license \
        -release \
        -opengl es2 -eglfs -kms -xcb \
        -nomake examples -no-compile-examples \
        -skip qtwebengine -skip qtwayland \
        -reduce-exports \
        -ssl -evdev \
        -system-freetype -fontconfig \
        -glib \
        -no-pch \
        2>&1 | tee ../qt_configure.log
    
    echo "Building Qt (this will take several hours)..."
    make -j"$CPU_CORES" 2>&1 | tee ../qt_make.log
    
    echo "Installing Qt..."
    sudo make install 2>&1 | tee ../qt_install.log
    
    cd "$BUILD_DIR"
    echo "Qt build complete!"
}

# Build aasdk
build_aasdk() {
    echo "=== Building aasdk ==="
    
    if [ ! -d "aasdk" ]; then
        git clone -b "$AASDK_BRANCH" "$AASDK_REPO"
    else
        cd aasdk
        git fetch && git reset --hard origin/"$AASDK_BRANCH"
        cd "$BUILD_DIR"
    fi
    
    rm -rf aasdk_build
    mkdir -p aasdk_build
    cd aasdk_build
    
    cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
    make -j"$CPU_CORES" 2>&1 | tee ../aasdk_make.log
    
    cd "$BUILD_DIR"
    echo "aasdk build complete!"
}

# Build OpenAuto
build_openauto() {
    echo "=== Building OpenAuto ==="
    
    if [ ! -d "openauto" ]; then
        git clone -b "$OPENAUTO_BRANCH" "$OPENAUTO_REPO"
    else
        cd openauto
        git fetch && git reset --hard origin/"$OPENAUTO_BRANCH"
        cd "$BUILD_DIR"
    fi
    
    rm -rf openauto_build
    mkdir -p openauto_build
    cd openauto_build
    
    export PATH=/usr/local/qt5/bin:$PATH
    export LD_LIBRARY_PATH=/usr/local/qt5/lib:$LD_LIBRARY_PATH
    
    cmake -DCMAKE_BUILD_TYPE=Release \
        -DRPI3_BUILD=FALSE \
        -DAASDK_INCLUDE_DIRS="$BUILD_DIR/aasdk/include" \
        -DAASDK_LIBRARIES="$BUILD_DIR/aasdk_build/lib/libaasdk.so" \
        -DAASDK_PROTO_INCLUDE_DIRS="$BUILD_DIR/aasdk_build" \
        -DAASDK_PROTO_LIBRARIES="$BUILD_DIR/aasdk_build/lib/libaasdk_proto.so" \
        ../openauto
    
    make -j"$CPU_CORES" 2>&1 | tee ../openauto_make.log
    
    cd "$BUILD_DIR"
    echo "OpenAuto build complete!"
}

# Package prebuilts
package_prebuilts() {
    echo "=== Packaging prebuilts ==="
    
    OUTPUT_DIR="$BUILD_DIR/prebuilts_arm64"
    mkdir -p "$OUTPUT_DIR"/{qt5,openauto}
    
    # Package Qt5
    echo "Packaging Qt5..."
    cd /usr/local
    tar -cJf "$OUTPUT_DIR/qt5/Qt_5151_arm64_OpenGLES2.tar.xz" qt5/
    
    # Split for GitHub (50MB parts)
    cd "$OUTPUT_DIR/qt5"
    split -b 50M Qt_5151_arm64_OpenGLES2.tar.xz Qt_5151_arm64_OpenGLES2.tar.xz.part
    
    # Copy OpenAuto binaries
    echo "Copying OpenAuto binaries..."
    cp "$BUILD_DIR/openauto_build/bin/autoapp" "$OUTPUT_DIR/openauto/"
    cp "$BUILD_DIR/openauto_build/bin/autoapp_helper" "$OUTPUT_DIR/openauto/" 2>/dev/null || true
    cp "$BUILD_DIR/openauto_build/bin/btservice" "$OUTPUT_DIR/openauto/"
    cp "$BUILD_DIR/aasdk_build/lib/libaasdk.so" "$OUTPUT_DIR/openauto/"
    cp "$BUILD_DIR/aasdk_build/lib/libaasdk_proto.so" "$OUTPUT_DIR/openauto/"
    
    # Generate checksums
    cd "$OUTPUT_DIR/openauto"
    for f in *; do
        md5sum "$f" > "$f.md5"
    done
    
    echo ""
    echo "=== Prebuilts packaged to: $OUTPUT_DIR ==="
    echo "Upload these files to the prebuilts repository:"
    ls -la "$OUTPUT_DIR/qt5/"
    ls -la "$OUTPUT_DIR/openauto/"
}

# Main
case "${1:-all}" in
    deps)
        install_deps
        ;;
    qt)
        build_qt
        ;;
    aasdk)
        build_aasdk
        ;;
    openauto)
        build_openauto
        ;;
    package)
        package_prebuilts
        ;;
    all)
        install_deps
        build_qt
        build_aasdk
        build_openauto
        package_prebuilts
        ;;
    *)
        echo "Usage: $0 {deps|qt|aasdk|openauto|package|all}"
        echo ""
        echo "  deps     - Install build dependencies"
        echo "  qt       - Build Qt 5.15"
        echo "  aasdk    - Build aasdk library"
        echo "  openauto - Build OpenAuto application"
        echo "  package  - Package prebuilts for distribution"
        echo "  all      - Run all steps (default)"
        exit 1
        ;;
esac

echo "Done!"
