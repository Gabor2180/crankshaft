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
- [Building from Source](#building-from-source)

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

