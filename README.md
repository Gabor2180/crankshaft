# Crankshaft

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)

A turnkey GNU/Linux solution that transforms a Raspberry Pi to an Android Auto head unit.

https://getcrankshaft.com/

## Supported Hardware

- Raspberry Pi 3 Model B/B+ (arm64)
- Raspberry Pi 4 Model B (arm64)
- Raspberry Pi 5 (arm64)
- Raspberry Pi Compute Module 4/5 (arm64)

## Requirements

- Debian Trixie (13) based build environment
- Docker for cross-compilation builds
- QEMU binfmt support for ARM64 emulation

## Android Auto Compatibility

This build is designed to work with the latest Android Auto protocol. Make sure your Android phone has the latest Android Auto app installed.

## Docker build image

- Ensure binfmt support installed [binfmt-support](binfmt-misc.md)

- Create config for pi-gen
```bash
cp config.example config
```
- Build image
```bash
./build-docker.sh
```

## Build Environment

The build system uses:
- Debian Trixie (13) as the base OS
- ARM64 (aarch64) architecture for modern Pi support
- DRM/KMS graphics stack with vc4-kms-v3d driver
- Qt 5.15+ for the OpenAuto application
- PulseAudio for audio management
- BlueZ 5 for Bluetooth support

## Building arm64 Prebuilts (Qt5 & OpenAuto)

The Qt5 and OpenAuto binaries need to be compiled for arm64. A build script is provided:

```bash
# On a Raspberry Pi 4/5 running arm64 Debian Trixie:
./build-arm64-prebuilts.sh all

# Or build individual components:
./build-arm64-prebuilts.sh deps      # Install dependencies
./build-arm64-prebuilts.sh qt        # Build Qt 5.15
./build-arm64-prebuilts.sh aasdk     # Build Android Auto SDK
./build-arm64-prebuilts.sh openauto  # Build OpenAuto
./build-arm64-prebuilts.sh package   # Package prebuilts
```

**Note:** Building Qt5 from source takes several hours on a Raspberry Pi. Consider using a Pi 5 with adequate cooling for faster builds.

## Changes from Buster

- Migrated from armhf to arm64 architecture
- Updated from Debian Buster to Trixie
- Replaced deprecated packages (ntp → chrony, locate → plocate, etc.)
- Updated Boost libraries to 1.83
- Updated Protobuf to version 32
- Modern KMS graphics driver instead of legacy FKMS
- Python 3.11+ with virtual environment support
- Built-in exFAT support (no DKMS module needed)

