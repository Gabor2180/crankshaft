# Crankshaft

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)

A turnkey GNU/Linux solution that transforms a Raspberry Pi to an Android Auto head unit.

https://getcrankshaft.com/

---

## Table of Contents

- [What is Crankshaft?](#what-is-crankshaft)
- [Supported Hardware](#supported-hardware)
- [What You'll Need](#what-youll-need)
- [Installation Guide](#installation-guide)
  - [Step 1: Download the Image](#step-1-download-the-image)
  - [Step 2: Flash the SD Card](#step-2-flash-the-sd-card)
  - [Step 3: First Boot Setup](#step-3-first-boot-setup)
  - [Step 4: Connect Your Phone](#step-4-connect-your-phone)
- [Configuration](#configuration)
  - [Display Settings](#display-settings)
  - [Audio Settings](#audio-settings)
  - [WiFi Setup](#wifi-setup)
  - [GPIO Configuration](#gpio-configuration)
- [Troubleshooting](#troubleshooting)
- [Advanced Topics](#advanced-topics)
  - [Standby Dashboard Customization](#standby-dashboard-customization)
- [Building from Source](#building-from-source)
  - [Recompiling OpenAuto for Customization](#recompiling-openauto-for-customization)
  - [Creating Flashable Releases](#creating-flashable-releases)

---

## What is Crankshaft?

Crankshaft transforms your Raspberry Pi into a dedicated Android Auto head unit. Simply connect your Android phone via USB, and your Pi becomes a touchscreen display for Android Auto - perfect for car installations or DIY infotainment projects.

**Features:**
- Full Android Auto support (maps, music, calls, messaging)
- Works with touchscreens or mouse/keyboard
- Bluetooth audio support
- Camera integration (rear camera, dashcam)
- Day/night mode with automatic switching
- WiFi hotspot mode
- Low power consumption

---

## Supported Hardware

### Raspberry Pi Models
| Model | Status | Notes |
|-------|--------|-------|
| Raspberry Pi 5 | ✅ Recommended | Best performance |
| Raspberry Pi 4 Model B | ✅ Supported | 2GB+ RAM recommended |
| Raspberry Pi 3 Model B/B+ | ✅ Supported | Minimum recommended |
| Raspberry Pi Compute Module 4/5 | ✅ Supported | For custom builds |

### Displays
- Official Raspberry Pi 7" Touchscreen
- HDMI displays (any resolution)
- DSI displays with compatible drivers
- Most USB touchscreens

### Audio Options
- HDMI audio output
- 3.5mm jack (built-in)
- USB audio devices
- I2S DAC boards (HiFiBerry, etc.)

---

## What You'll Need

### Required
- ✅ Raspberry Pi 3, 4, or 5
- ✅ MicroSD card (16GB minimum, 32GB recommended)
- ✅ Power supply (5V 3A for Pi 4/5, 5V 2.5A for Pi 3)
- ✅ Display (HDMI or DSI touchscreen)
- ✅ Android phone with Android Auto app installed
- ✅ Good quality USB cable (data-capable, not charge-only)

### Recommended
- 📱 Touchscreen display for easier interaction
- 🔊 External speakers or amplifier for better audio
- 📷 Raspberry Pi Camera Module (for rear camera/dashcam)
- 🌡️ Heatsink/cooling for the Pi (especially Pi 4/5)

### Software
- [Raspberry Pi Imager](https://www.raspberrypi.com/software/) or [balenaEtcher](https://www.balena.io/etcher/)
- Android Auto app (latest version from Google Play)

---

## Installation Guide

### Step 1: Download the Image

Download the latest Crankshaft image from the [Releases page](https://github.com/opencardev/crankshaft/releases).

Choose the appropriate image for your Pi:
- `crankshaft-ng-arm64.img.zip` - For Pi 3/4/5 (recommended)
- `crankshaft-ng-arm64-pi3.img.zip` - Optimized for Pi 3

### Step 2: Flash the SD Card

#### Using Raspberry Pi Imager (Recommended)

1. **Download and install** [Raspberry Pi Imager](https://www.raspberrypi.com/software/)

2. **Insert your SD card** into your computer

3. **Open Raspberry Pi Imager**
   - Click "Choose OS" → "Use custom" → Select the downloaded Crankshaft image
   - Click "Choose Storage" → Select your SD card
   - Click "Write" and wait for completion

#### Using balenaEtcher

1. **Download and install** [balenaEtcher](https://www.balena.io/etcher/)

2. **Open balenaEtcher**
   - Click "Flash from file" → Select the Crankshaft image
   - Click "Select target" → Choose your SD card
   - Click "Flash!" and wait for completion

⚠️ **Warning:** This will erase all data on the SD card!

### Step 3: First Boot Setup

1. **Insert the SD card** into your Raspberry Pi

2. **Connect your display**
   - HDMI: Connect to HDMI port (use HDMI0 on Pi 4/5)
   - DSI Touchscreen: Connect ribbon cable to DSI port

3. **Connect power** to boot the Pi

4. **Wait for first boot** (may take 1-2 minutes)
   - You'll see the Crankshaft splash screen
   - The system will automatically configure itself

5. **First boot completion:**
   - The display will show "Waiting for device..."
   - This means Crankshaft is ready for Android Auto

### Step 4: Connect Your Phone

1. **On your Android phone:**
   - Install/update **Android Auto** from Google Play
   - Open Android Auto and complete initial setup
   - Grant all required permissions

2. **Connect phone to Pi via USB:**
   - Use a **good quality USB data cable** (not a charge-only cable)
   - Connect to any USB port on the Pi
   - On your phone, allow USB debugging if prompted

3. **Android Auto should start automatically:**
   - Your phone screen may ask "Allow Android Auto?"
   - Tap "Allow" or "OK"
   - Android Auto will appear on the Pi's display

🎉 **Congratulations!** You're now running Android Auto on your Raspberry Pi!

---

## Configuration

Configuration files are stored on the boot partition for easy access:

### Accessing Configuration Files

**From a computer:**
1. Remove SD card from Pi
2. Insert into your computer
3. Open the `boot` partition
4. Navigate to `crankshaft/` folder

**From SSH (if enabled):**
```bash
sudo nano /boot/crankshaft/crankshaft_env.sh
```

### Display Settings

Edit `/boot/crankshaft/crankshaft_env.sh`:

```bash
# Flip screen 180 degrees (for inverted mounting)
FLIP_SCREEN=1

# Brightness control
BR_DAY=255      # Daytime brightness (0-255)
BR_NIGHT=30     # Nighttime brightness (0-255)

# Screen timeout after disconnect (seconds)
DISCONNECTION_SCREEN_POWEROFF_SECS=120
```

### Audio Settings

```bash
# Startup volume limits
STARTUP_VOL_MIN=30    # Minimum volume at boot
STARTUP_VOL_MAX=100   # Maximum volume at boot
```

For DAC boards (like HiFiBerry):
- Edit `/boot/config.txt`
- Add appropriate dtoverlay for your DAC

### WiFi Setup

For WiFi connectivity (useful for updates and SSH access):

```bash
# Edit /boot/crankshaft/crankshaft_env.sh

# Your country code
WIFI_COUNTRY=US

# Home/work WiFi
WIFI_SSID="YourWiFiName"
WIFI_PSK="YourWiFiPassword"

# Phone hotspot (optional secondary)
WIFI2_SSID="PhoneHotspot"
WIFI2_PSK="HotspotPassword"

# Or enable hotspot mode (creates WiFi network)
ENABLE_HOTSPOT=1
# Default hotspot password: 1234567890
```

### GPIO Configuration

For custom buttons, indicators, or sensors:

```bash
# Enable GPIO features
ENABLE_GPIO=1

# Device connected indicator LED (GPIO pin number, 0=disabled)
ANDROID_PIN=17

# Rear camera trigger pin
REARCAM_PIN=27

# Day/Night mode switch pin
DAYNIGHT_PIN=22
```

---

## Troubleshooting

### Phone Not Connecting

1. **Check USB cable:**
   - Use a data-capable cable (not charge-only)
   - Try a different cable
   - Try different USB ports

2. **Check Android Auto app:**
   - Update to latest version
   - Clear app cache: Settings → Apps → Android Auto → Clear Cache
   - Re-grant permissions

3. **On phone, check:**
   - Developer Options → Default USB Configuration → File Transfer/MTP

### No Display / Black Screen

1. **Check HDMI connection:**
   - Use HDMI0 port on Pi 4/5
   - Try a different HDMI cable

2. **For DSI displays:**
   - Check ribbon cable orientation
   - Ensure proper seating

3. **Edit `/boot/config.txt`:**
   ```bash
   # Force HDMI output
   hdmi_force_hotplug=1
   ```

### No Audio

1. **Check audio output setting:**
   - Edit `/boot/crankshaft/openauto.ini`:
   ```ini
   [Audio]
   OutputBackendType=1   # 0=HDMI, 1=Analog
   ```

2. **For USB audio:**
   - Ensure device is connected before boot

### System Won't Boot

1. **Re-flash SD card:**
   - Download fresh image
   - Use a different SD card if possible

2. **Check power supply:**
   - Ensure adequate amperage (3A for Pi 4/5)
   - Look for lightning bolt icon (under-voltage)

### Enabling SSH for Remote Access

1. **Enable Dev Mode** (allows network access):
   - Edit `/boot/crankshaft/crankshaft_env.sh`:
   ```bash
   DEV_MODE=1
   ```

2. **Default credentials:**
   - Username: `pi`
   - Password: `raspberry`

3. **Connect via SSH:**
   ```bash
   ssh pi@crankshaft-ng.local
   # Or use IP address: ssh pi@192.168.x.x
   ```

---

## Advanced Topics

### Rear Camera Setup

**Using Raspberry Pi Camera:**
```bash
# Edit /boot/crankshaft/crankshaft_env.sh
RPICAM_ROTATION=0      # 0, 90, 180, 270
RPICAM_HFLIP=0         # Horizontal flip
RPICAM_VFLIP=0         # Vertical flip
REARCAM_PIN=27         # GPIO trigger pin (connect to reverse signal)
```

**Using USB Camera:**
```bash
USBCAM_USE=1
USBCAM_ROTATION=0
```

### Day/Night Mode

Automatic brightness switching based on time:
```bash
RTC_DAYNIGHT=1
RTC_DAY_START=8        # Day mode starts at 8 AM
RTC_NIGHT_START=18     # Night mode starts at 6 PM
```

Or use a light sensor (TSL2561/TSL2591):
```bash
LIGHTSENSOR_TYPE='TSL2561'
TSL_I2C_BUS=1
TSL_ADDR=0x29
```

### Bluetooth Audio

```bash
ENABLE_BLUETOOTH=1
ENABLE_PAIRABLE=1      # Allow pairing
EXTERNAL_BLUETOOTH=0   # Use built-in Bluetooth (set to 1 for USB adapter)
```

### Custom Startup Script

Create `/boot/crankshaft/custom/startup.sh` for custom commands at boot:
```bash
#!/bin/bash
# Your custom startup commands here
echo "Custom startup running!"
```

### Standby Dashboard Customization

Customize the look and feel of the Crankshaft standby dashboard, including wallpapers, boot/shutdown screens, and display settings.

#### Wallpapers

Wallpaper images are stored in `/opt/crankshaft/wallpaper/`. The system includes several built-in wallpapers:

| File | Description |
|------|-------------|
| `wallpaper.png` | Default day mode wallpaper |
| `wallpaper-night.png` | Night mode wallpaper |
| `wallpaper-classic.png` | Classic day theme |
| `wallpaper-classic-night.png` | Classic night theme |
| `wallpaper-christmas.png` | Holiday theme |
| `wallpaper-firework.png` | Celebration theme |
| `wallpaper-eq.png` | Equalizer theme |

**To use a custom wallpaper:**

1. Create your wallpaper image (recommended resolution: 800x480 or match your display)
2. Copy to `/opt/crankshaft/wallpaper/`:
   ```bash
   # Day wallpaper
   sudo cp your-wallpaper.png /opt/crankshaft/wallpaper/wallpaper.png
   
   # Night wallpaper (optional)
   sudo cp your-night-wallpaper.png /opt/crankshaft/wallpaper/wallpaper-night.png
   ```

**Note:** Custom wallpapers should be backed up to `/boot/crankshaft/custom/` for persistence across updates.

#### Boot and Shutdown Screens

The boot/shutdown splash screens are controlled by Plymouth themes in `/usr/share/plymouth/themes/`.

**Default theme location:** `/usr/share/plymouth/themes/crankshaft/`

| File | Purpose |
|------|---------|
| `splash.png` | Boot splash screen image |
| `shutdown.png` | Shutdown screen image |
| `progress_bar.png` | Boot progress bar |
| `progress_box.png` | Progress bar container |

**Custom theme location:** `/usr/share/plymouth/themes/custom/`

To customize boot/shutdown screens:
```bash
# Unlock filesystem for editing
sudo crankshaft filesystem system unlock

# Replace splash images with your custom ones
sudo cp your-boot-splash.png /usr/share/plymouth/themes/crankshaft/splash.png
sudo cp your-shutdown.png /usr/share/plymouth/themes/crankshaft/shutdown.png

# Or use the custom theme directory for easier backup
sudo cp your-boot-splash.png /usr/share/plymouth/themes/custom/splash.png
sudo cp your-shutdown.png /usr/share/plymouth/themes/custom/shutdown.png

# Lock filesystem
sudo crankshaft filesystem system lock
```

**Alternative:** Place custom boot splash in `/boot/crankshaft/splash.png` for easy access from any computer.

#### OpenAuto Display Settings

Edit `/boot/crankshaft/openauto.ini` to control display behavior:

```ini
[General]
ShowClock=true         # Show clock on standby screen
ShowCursor=true        # Show mouse cursor

[Video]
FPS=1                  # Frame rate
OMXLayerIndex=2        # Video layer (EGL mode)

[Audio]
OutputBackendType=1    # 0=HDMI, 1=Analog
```

#### Standby Screen Button Customization

The large buttons displayed on the Crankshaft standby screen (the main UI that appears after boot while waiting for an Android device) are part of the OpenAuto application built with Qt5.

**Button Input Mapping:**

Button actions can be customized through the Crankshaft Settings interface:
1. Access Settings from the standby screen
2. Navigate to the **Input** tab
3. Configure button mappings for actions like:
   - Enter, Back, Home
   - Play/Pause, Next Track, Previous Track
   - Volume Up/Down
   - Left, Right, Up, Down navigation

**GPIO Button Configuration:**

To use physical GPIO buttons with the standby screen:

```bash
# Edit /boot/crankshaft/crankshaft_env.sh
ENABLE_GPIO=1          # Enable GPIO button support

# Configure GPIO-to-keyboard mappings in:
# /boot/crankshaft/gpio2kbd.cfg
```

The `gpio2kbd.cfg` file maps GPIO pins to keyboard actions:
```
# Format: KEY_NAME    GPIO_PIN  (whitespace separated)
# Example: Map GPIO 12 to Volume Down
VOLUMEDOWN      12
VOLUMEUP        13
```

**Button Visual Appearance:**

The visual styling of standby screen buttons (colors, fonts, sizes) is embedded in the OpenAuto application. To customize button appearance:

1. **For minor tweaks**: The standby screen uses the wallpaper images from `/opt/crankshaft/wallpaper/` as the background
2. **For advanced customization**: Requires modifying the OpenAuto source code from the [opencardev/openauto](https://github.com/opencardev/openauto) repository and rebuilding the application

⚠️ **Warning:** Modifying and rebuilding OpenAuto is an advanced operation that requires development experience. Incorrect modifications may cause system instability or boot failures. Always backup your system before attempting source-level changes.

**Triggerhappy Button Events:**

Additional button actions can be configured using triggerhappy:
```bash
# Edit /boot/crankshaft/triggerhappy.conf
# or /opt/crankshaft/triggerhappy.conf

# Format: KEY_NAME EVENT_TYPE COMMAND
# Example: Run a script when F1 is pressed
KEY_F1 1 /boot/crankshaft/custom/my_script.sh
```

#### Display Brightness Settings

Configure display brightness in `/boot/crankshaft/crankshaft_env.sh`:

```bash
# Brightness values (0-255)
BR_MIN=30              # Minimum brightness
BR_MAX=255             # Maximum brightness
BR_STEP=25             # Brightness adjustment step
BR_DAY=255             # Day mode brightness
BR_NIGHT=30            # Night mode brightness

# Screen timeout settings
DISCONNECTION_SCREEN_POWEROFF_SECS=120  # Seconds until screen off after disconnect
SCREEN_POWEROFF_OVERRIDE=0              # Use screensaver instead of display off (0/1)
```

#### Camera Overlay Customization

Customize the rear camera overlay image:
```bash
# The camera overlay is located at:
/opt/crankshaft/wallpaper/camera-overlay.png
/opt/crankshaft/wallpaper/usbcamera-overlay.png

# Replace with your custom overlay
sudo cp your-camera-overlay.png /opt/crankshaft/wallpaper/camera-overlay.png
```

#### Theme Files Summary

| Location | Purpose |
|----------|---------|
| `/boot/crankshaft/crankshaft_env.sh` | Main configuration (brightness, timeouts, etc.) |
| `/boot/crankshaft/openauto.ini` | OpenAuto display settings |
| `/boot/crankshaft/splash.png` | Custom boot splash (easy access) |
| `/opt/crankshaft/wallpaper/` | Standby wallpapers |
| `/usr/share/plymouth/themes/crankshaft/` | Boot/shutdown theme images |
| `/usr/share/plymouth/themes/custom/` | Custom theme directory |
| `/boot/crankshaft/custom/` | Persistent custom files (survives updates) |

---

## Building from Source

For developers who want to build Crankshaft from source or customize it.

### Requirements

- Linux system with Docker
- QEMU binfmt support for ARM64 emulation
- 20GB+ free disk space

### Build Steps

```bash
# Clone repository
git clone https://github.com/opencardev/crankshaft.git
cd crankshaft

# Initialize submodules
git submodule update --init

# Create config
cp config.example config

# Build with Docker
./build-docker.sh
```

### Building arm64 Prebuilts (Qt5 & OpenAuto)

The Qt5 and OpenAuto binaries need to be compiled for arm64:

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

**Note:** Building Qt5 from source takes several hours on a Raspberry Pi. Consider using a Pi 5 with adequate cooling.

### Recompiling OpenAuto for Customization

If you want to customize the OpenAuto UI (button appearance, fonts, colors, layout), you need to modify the source code and recompile. This guide explains how to do this directly on a running Crankshaft system.

#### Prerequisites

- Raspberry Pi 4 or 5 running Crankshaft
- SSH access enabled (Dev Mode)
- At least 4GB of free space
- Several hours for compilation

#### Step 1: Enable Dev Mode and SSH

```bash
# Edit the config file from a computer (SD card boot partition)
# In /boot/crankshaft/crankshaft_env.sh, set:
DEV_MODE=1
```

Or access via SSH if already enabled.

#### Step 2: Unlock the Filesystem

```bash
# Crankshaft runs in read-only mode by default
sudo crankshaft filesystem system unlock
```

#### Step 3: Install Build Dependencies

```bash
sudo apt-get update
sudo apt-get install -y \
    build-essential cmake git \
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
```

#### Step 4: Clone and Build aasdk (Android Auto SDK)

```bash
# Create build directory
mkdir -p ~/openauto-build && cd ~/openauto-build

# Clone aasdk
git clone -b newdev https://github.com/opencardev/aasdk.git

# Build aasdk
mkdir -p aasdk_build && cd aasdk_build
cmake -DCMAKE_BUILD_TYPE=Release ../aasdk
make -j$(nproc)
cd ~/openauto-build
```

#### Step 5: Clone and Customize OpenAuto

```bash
# Clone OpenAuto source
git clone -b crankshaft-ng https://github.com/opencardev/openauto.git
cd openauto
```

**Customization locations in the source code:**

| File/Directory | What to Customize |
|----------------|-------------------|
| `openauto/UI/` | Qt UI files (.ui) for layout |
| `openauto/UI/MainWindow.cpp` | Main window logic and button behavior |
| `openauto/UI/SettingsWindow.cpp` | Settings dialog |
| `resources/` | Images, icons, and QSS stylesheets |
| `openauto/Configuration/` | Default configuration values |

**Example: Changing button colors (Qt stylesheet)**

Look for `.qss` files or inline stylesheet definitions in the source. You can modify colors, fonts, and sizes using Qt CSS-like syntax:

```cpp
// Example in source code
button->setStyleSheet("QPushButton { background-color: #2196F3; color: white; font-size: 18px; }");
```

#### Step 6: Build OpenAuto

```bash
cd ~/openauto-build

# Set Qt5 path (already installed on Crankshaft)
export PATH=/usr/local/qt5/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/qt5/lib:$LD_LIBRARY_PATH

# Create build directory
mkdir -p openauto_build && cd openauto_build

# Configure with cmake
cmake -DCMAKE_BUILD_TYPE=Release \
    -DRPI3_BUILD=FALSE \
    -DAASDK_INCLUDE_DIRS="$HOME/openauto-build/aasdk/include" \
    -DAASDK_LIBRARIES="$HOME/openauto-build/aasdk_build/lib/libaasdk.so" \
    -DAASDK_PROTO_INCLUDE_DIRS="$HOME/openauto-build/aasdk_build" \
    -DAASDK_PROTO_LIBRARIES="$HOME/openauto-build/aasdk_build/lib/libaasdk_proto.so" \
    ../openauto

# Build (this takes 30-60 minutes on Pi 4/5)
make -j$(nproc)
```

#### Step 7: Install Your Custom OpenAuto

```bash
# Backup original binaries
sudo cp /usr/local/bin/autoapp /usr/local/bin/autoapp.backup
sudo cp /usr/local/lib/libaasdk.so /usr/local/lib/libaasdk.so.backup
sudo cp /usr/local/lib/libaasdk_proto.so /usr/local/lib/libaasdk_proto.so.backup

# Install new binaries
sudo cp ~/openauto-build/openauto_build/bin/autoapp /usr/local/bin/
sudo cp ~/openauto-build/aasdk_build/lib/libaasdk.so /usr/local/lib/
sudo cp ~/openauto-build/aasdk_build/lib/libaasdk_proto.so /usr/local/lib/

# Update library cache
sudo ldconfig
```

#### Step 8: Test and Lock Filesystem

```bash
# Reboot to test changes
sudo reboot

# If everything works, lock the filesystem again
sudo crankshaft filesystem system lock
```

#### Reverting to Original

If your custom build causes issues:

```bash
sudo crankshaft filesystem system unlock
sudo cp /usr/local/bin/autoapp.backup /usr/local/bin/autoapp
sudo cp /usr/local/lib/libaasdk.so.backup /usr/local/lib/libaasdk.so
sudo cp /usr/local/lib/libaasdk_proto.so.backup /usr/local/lib/libaasdk_proto.so
sudo ldconfig
sudo crankshaft filesystem system lock
sudo reboot
```

#### Tips for UI Customization

1. **Qt Designer**: Use Qt Designer on a desktop Linux to edit `.ui` files visually before transferring to Pi
2. **Colors**: Search for `setStyleSheet`, `QPalette`, or color hex codes in the source
3. **Fonts**: Look for `QFont` usage and modify font families/sizes
4. **Button sizes**: Modify `setFixedSize`, `setMinimumSize`, or layout constraints
5. **Icons**: Replace PNG/SVG files in the `resources/` directory

⚠️ **Important:** Keep your customizations minimal and well-documented. Complex changes may break compatibility with future Crankshaft updates.

### Creating Flashable Releases

Releases are automatically created when you push a version tag. To create a new release:

#### Automated Release (Recommended)

```bash
# Create and push a version tag
git tag v1.0.0
git push origin v1.0.0
```

This triggers the GitHub Actions release workflow which:
1. Builds flashable images for all supported architectures (arm64, arm64-pi3, armhf)
2. Generates checksums (MD5, SHA1, SHA256) for each image
3. Creates zip archives containing the image and checksums
4. Publishes a GitHub release with all artifacts

#### Manual Release via GitHub Actions

1. Go to **Actions** tab in the repository
2. Select **"Create Flashable Release"** workflow
3. Click **"Run workflow"**
4. Enter the version (e.g., `v1.0.0`)
5. Click **"Run workflow"** to start the build

#### Release Artifacts

Each release includes:
- `crankshaft-ng-vX.X.X.zip` - For Raspberry Pi 3, 4, 5 (arm64)
- `crankshaft-ng-vX.X.X-pi3.zip` - Pi 3 optimized (arm64)
- `crankshaft-ng-vX.X.X-armhf.zip` - For Pi Zero, Pi 2 (32-bit)

Each zip contains:
- The `.img` file ready to flash
- `.md5`, `.sha1`, `.sha256` checksum files

---

## Getting Help

- 📖 [Wiki](https://github.com/opencardev/crankshaft/wiki)
- 💬 [Discussions](https://github.com/opencardev/crankshaft/discussions)
- 🐛 [Report Issues](https://github.com/opencardev/crankshaft/issues)
- 🌐 [Website](https://getcrankshaft.com/)

---

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please read our [Code of Conduct](code_of_conduct.md) before contributing.

