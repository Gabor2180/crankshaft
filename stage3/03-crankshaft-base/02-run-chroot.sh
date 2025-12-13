#!/bin/bash -e

if [ -f $CONTINUE ]; then
  set +e
fi

# Set lang
SETLANG=en_GB

sed -i -e '/^#/! s/./# &/' /etc/locale.gen # disable all entries by adding # in line start
sed -i "s/^# $SETLANG.UTF-8 UTF-8/$SETLANG.UTF-8 UTF-8/" /etc/locale.gen # enable lang
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=$SETLANG.UTF-8

# we don't need to resize the root part
sed -i 's/ init\=.*$//' /boot/firmware/cmdline.txt || sed -i 's/ init\=.*$//' /boot/cmdline.txt || true

# config.txt - use /boot/firmware for modern Pi OS
BOOT_CONFIG="/boot/firmware/config.txt"
if [ ! -f "$BOOT_CONFIG" ]; then
    BOOT_CONFIG="/boot/config.txt"
fi

echo "" >> $BOOT_CONFIG
echo "# Custom power settings" >> $BOOT_CONFIG
echo "max_usb_current=1" >> $BOOT_CONFIG

echo "" >> $BOOT_CONFIG
echo "# Disable the PWR LED." >> $BOOT_CONFIG
echo "dtparam=pwr_led_trigger=none" >> $BOOT_CONFIG
echo "dtparam=pwr_led_activelow=off" >> $BOOT_CONFIG

echo "" >> $BOOT_CONFIG
echo "# Disable Rainbow splash" >> $BOOT_CONFIG
echo "disable_splash=1" >> $BOOT_CONFIG

echo "" >> $BOOT_CONFIG
echo "# Overscan fix" >> $BOOT_CONFIG
echo "overscan_scale=1" >> $BOOT_CONFIG

echo "" >> $BOOT_CONFIG
echo "# Enable watchdog" >> $BOOT_CONFIG
echo "dtparam=watchdog=on" >> $BOOT_CONFIG

echo "" >> $BOOT_CONFIG
echo "# Boot time improvements" >> $BOOT_CONFIG
echo "boot_delay=0" >> $BOOT_CONFIG
echo "initial_turbo=30" >> $BOOT_CONFIG
echo "#dtoverlay=sdtweak,overclock_50=100" >> $BOOT_CONFIG

# pulseaudio
if [ -f /etc/pulse/csng_daemon.conf ]; then
    cat /etc/pulse/csng_daemon.conf >> /etc/pulse/daemon.conf
    cat /etc/pulse/csng_default.pa > /etc/pulse/default.pa
    cat /etc/pulse/csng_system.pa > /etc/pulse/system.pa
    rm /etc/pulse/csng_daemon.conf
    rm /etc/pulse/csng_default.pa
    rm /etc/pulse/csng_system.pa
fi

# wallaper's
ln -sf /boot/crankshaft/wallpaper.png /home/pi/wallpaper.png
ln -sf /boot/crankshaft/wallpaper-night.png /home/pi/wallpaper-night.png
ln -sf /boot/crankshaft/wallpaper-classic.png /home/pi/wallpaper-classic.png
ln -sf /boot/crankshaft/wallpaper-classic-night.png /home/pi/wallpaper-classic-night.png
ln -sf /boot/crankshaft/wallpaper-eq.png /home/pi/wallpaper-eq.png

# custom plymouth
ln -sf /boot/crankshaft/splash.png /usr/share/plymouth/themes/custom/splash.png
ln -sf /boot/crankshaft/shutdown.png /usr/share/plymouth/themes/custom/shutdown.png

# custom usbcamera-overlay
ln -sf /boot/crankshaft/usbcamera-overlay.png /opt/crankshaft/cam_overlay/overlay.png

# triggerhappy
if [ -f /lib/systemd/system/triggerhappy.service ]; then
    sed -i 's/user nobody/user pi/' /lib/systemd/system/triggerhappy.service
fi
ln -sf /boot/crankshaft/triggerhappy.conf /etc/triggerhappy/triggers.d/crankshaft.conf

# set the hostname
echo "CRANKSHAFT-NG" > /etc/hostname
sed -i "s/raspberrypi/CRANKSHAFT-NG/" /etc/hosts
sed -i "s/localhost/CRANKSHAFT-NG localhost/" /etc/hosts

# Boost system performance - skip if file doesn't exist
if [ -f /lib/systemd/system/rpi-display-backlight.service ]; then
    sed -i 's/reboot.target/shutdown.target/g' /lib/systemd/system/rpi-display-backlight.service
fi

# set gpsd settings
if [ -f /etc/default/gpsd ]; then
    sed -i 's/GPSD_OPTIONS=\"\"/GPSD_OPTIONS=\"-n\"/g' /etc/default/gpsd
fi

# Use chrony instead of ntp for modern systems
if [ -f /etc/chrony/chrony.conf ]; then
    echo "" >> /etc/chrony/chrony.conf
    echo "# GPS as time source" >> /etc/chrony/chrony.conf
    echo "refclock SHM 0 offset 0.5 delay 0.2 refid GPS" >> /etc/chrony/chrony.conf
fi

# Set default startup services state
systemctl enable gpio2kbd.service || true
systemctl enable crankshaft.service || true
systemctl enable btservice.service || true
systemctl enable user_startup.service || true
systemctl enable devmode.service || true
systemctl enable debugmode.service || true
systemctl enable display.service || true
systemctl enable update.timer || true
systemctl enable usbrestore.service || true
systemctl enable usbdetect.service || true
systemctl enable usbunmount.service || true
systemctl enable daymode.timer || true
systemctl enable nightmode.timer || true
systemctl enable tap2wake.service || true
systemctl enable openauto.service || true
systemctl enable gpiotrigger.service || true
systemctl enable timerstart.service || true
systemctl enable regensshkeys.service || true
systemctl enable ssh.service || true
systemctl enable pulseaudio.service || true
systemctl enable pacheck.service || true
systemctl disable rpi-display-backlight.service || true
systemctl enable rpi-display-backlight.service || true
systemctl enable hotspot.service || true
systemctl enable alsastaterestore.service || true
systemctl enable systemd-timesyncd.service || true
systemctl enable networking.service || true
systemctl enable dhcpcd.service || true
systemctl enable lightsensor.service || true
systemctl enable i2ccheck.service || true
systemctl enable wpa-monitor.service || true
systemctl enable custombrightness.service || true
systemctl enable gpsd.service || true
systemctl enable watchdog.service || true
systemctl disable hotspot-monitor.service || true
systemctl disable wpa_supplicant.service || true
systemctl disable hwclock-load.service || true
systemctl disable rpicamserver.service || true
systemctl disable systemd-rfkill.service || true
systemctl disable systemd-rfkill.socket || true
systemctl disable resize2fs_once.service || true
systemctl disable bluetooth.service || true
systemctl disable hciuart.service || true
systemctl disable hostapd.service || true
systemctl disable dnsmasq.service || true
systemctl disable alsa-state.service || true
systemctl disable apply_noobs_os_config.service || true
systemctl disable wifi-country.service || true
systemctl disable alsa-restore.service || true
systemctl disable raspi-config.service || true
systemctl disable systemd-fsck@.service || true
systemctl disable smbd.service || true
systemctl disable nmbd.service || true
systemctl disable gldriver-test.service || true
systemctl disable dphys-swapfile.service || true
systemctl disable systemd-timesyncd.service || true
systemctl disable systemd-fsck@dev-mmcblk0p1.service || true

# Remove systemd units if they exist (use mask instead of rm for safety)
systemctl mask systemd-rfkill.service || true
systemctl mask systemd-rfkill.socket || true
systemctl mask apt-daily.timer || true
systemctl mask apt-daily.service || true
systemctl mask apt-daily-upgrade.timer || true
systemctl mask apt-daily-upgrade.service || true

# set custom boot splash
plymouth-set-default-theme csnganimation || true

# create lib cache
ldconfig

# add gettys
systemctl enable getty@tty3.service || true
# Don't kill still running getty - fixes restart in x11 mode during boot
if [ -f /lib/systemd/system/getty@.service ]; then
    sed -i 's/^TTYVHangup=.*/TTYVHangup=no/' /lib/systemd/system/getty@.service
fi

# enable splash and set default console
BOOT_CMDLINE="/boot/firmware/cmdline.txt"
if [ ! -f "$BOOT_CMDLINE" ]; then
    BOOT_CMDLINE="/boot/cmdline.txt"
fi

sed -i 's/console=tty1/console=tty3/' $BOOT_CMDLINE
sed -i 's/console=serial0,115200 //' $BOOT_CMDLINE

# add special settings
sed -i 's/$/ logo.nologo loglevel=0 vt.global_cursor_default=0 noswap splash plymouth.ignore-serial-consoles consoleblank=0/' $BOOT_CMDLINE

# Banner for ssh
sed -i 's/#Banner none/Banner \/etc\/issue.net/' /etc/ssh/sshd_config

# Listen on all interfaces ssh
sed -i 's/^#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config

# OS Name
STRING="Welcome to Crankshaft CarOS (${IMG_DATE} / Build ${GIT_HASH})"
cp /usr/lib/os-release /usr/lib/os-release.bak
sed -i '/PRETTY_NAME=/d' /usr/lib/os-release.bak
echo "PRETTY_NAME=\"$STRING\"" > /usr/lib/os-release
cat /usr/lib/os-release.bak >> /usr/lib/os-release
rm /usr/lib/os-release.bak
echo "$STRING" > /etc/issue
echo "" >> /etc/issue
echo "$STRING" > /etc/issue.net
echo "" >> /etc/issue.net

# wifi
rm -f /etc/wpa_supplicant/wpa_supplicant.conf
ln -sf /tmp/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

# Enable systemd timesync
sed -i 's/#NTP=.*/NTP=0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org/g' /etc/systemd/timesyncd.conf
sed -i 's/#FallbackNTP=.*/FallbackNTP=0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org/g' /etc/systemd/timesyncd.conf

# add alias for mc to stay inside folder after exit mc
echo "" >> /etc/bash.bashrc
echo "alias mc='. /usr/share/mc/bin/mc-wrapper.sh'" >> /etc/bash.bashrc

# Setup watchdog
if [ -f /etc/watchdog.conf ]; then
    sed -i 's/.*max-load-1	.*/max-load-1		= 2/' /etc/watchdog.conf
    sed -i 's/.*watchdog-device.*/watchdog-device		= \/dev\/watchdog/' /etc/watchdog.conf
    sed -i 's/.*temperatur-sensor.*/temperatur-sensor		= \/sys\/class\/thermal\/thermal_zone0\/temp/' /etc/watchdog.conf
    sed -i 's/.*max-temperature.*/max-temperature		= 75/' /etc/watchdog.conf
    sed -i 's/#retry-timeout.*/retry-timeout		= 30/' /etc/watchdog.conf
    echo "watchdog-timeout	= 10" >> /etc/watchdog.conf
fi

# Setup kernel panic behaviour
sed -i 's/.*kernel-panic.*//g' /etc/sysctl.conf
echo "kernel.panic = 10" >> /etc/sysctl.conf

# optimize wifi
echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
echo "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 16384 16777216" >> /etc/sysctl.conf

# Later start cpufrequtils
if [ -f /etc/init.d/cpufrequtils ]; then
    sed -i 's/# Required-Start: $remote_fs loadcpufreq.*/# Required-Start: $remote_fs loadcpufreq rc.local/' /etc/init.d/cpufrequtils
    # Boost system performance
    sed -i 's/^GOVERNOR=.*/GOVERNOR="performance"/' /etc/init.d/cpufrequtils
fi

# Don't kill processes after exit session
sed -i 's/#KillUserProcesses=.*/KillUserProcesses=no/' /etc/systemd/logind.conf

# Grant access to system wide pulseaudio
usermod -G pulse,pulse-access -a root || true
usermod -G pulse,pulse-access -a pi || true
usermod -G pulse,pulse-access -a pulse || true

# Grant disk access for pi user
usermod -G disk -a pi || true

# Grant pulse access to input for keyboard control
usermod -G input -a pulse || true

# Set client conf for system wide usage
if [ -f /etc/pulse/client.conf ]; then
    sed -i 's/.*Make sure client is correct configured for system wide usage.*//g' /etc/pulse/client.conf
    sed -i 's/.*default-server =.*//g' /etc/pulse/client.conf
    sed -i 's/.*autospawn =.*//g' /etc/pulse/client.conf
    sed -i '$!N; /^\(.*\)\n\1$/!P; D' /etc/pulse/client.conf
    echo "# Make sure client is correct configured for system wide usage" >> /etc/pulse/client.conf
    echo "default-server = unix:/var/run/pulse/native" >> /etc/pulse/client.conf
    echo "autospawn = no" >> /etc/pulse/client.conf
fi

# Make udev mountpoints shared
if [ -f /lib/systemd/system/systemd-udevd.service ]; then
    sed -i 's/^MountFlags=.*/MountFlags=shared/' /lib/systemd/system/systemd-udevd.service
fi

# link csmt
ln -sf /usr/local/bin/crankshaft /usr/local/bin/csmt

# Set path for rsyslogd
if [ -f /etc/rsyslog.conf ]; then
    sed -i 's/\$WorkDirectory \/var\/spool\/rsyslog/\$WorkDirectory \/var\/spool/' /etc/rsyslog.conf
fi

# exfat is now built into the kernel in modern kernels, no DKMS needed
# Skip exfat-nofuse for Trixie as exfat is built-in

exit 0
