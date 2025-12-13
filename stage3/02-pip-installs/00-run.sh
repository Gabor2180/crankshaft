#!/bin/bash -e

on_chroot << EOF
# Create a virtual environment for Python packages
python3 -m venv /opt/crankshaft-venv --system-site-packages
source /opt/crankshaft-venv/bin/activate
pip3 install --upgrade pip
# Pin versions for reproducible builds
pip3 install smbus2==0.4.3
pip3 install python-tsl2591==0.2.0
deactivate

# Create symlinks for easy access
ln -sf /opt/crankshaft-venv/bin/python3 /usr/local/bin/crankshaft-python
EOF
