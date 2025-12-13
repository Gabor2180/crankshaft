#!/bin/bash -e

on_chroot << EOF
# Create a virtual environment for Python packages
python3 -m venv /opt/crankshaft-venv --system-site-packages
source /opt/crankshaft-venv/bin/activate
pip3 install --upgrade pip
pip3 install smbus2
pip3 install python-tsl2591
deactivate

# Create symlinks for easy access
ln -sf /opt/crankshaft-venv/bin/python3 /usr/local/bin/crankshaft-python
EOF
