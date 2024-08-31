#!/bin/bash

# Ensure script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Install live-build
echo "Installing live-build..."
apt update
apt install -y live-build

# Set up the live-build configuration
[ -d "live-default" ] && rm -rf live-default
echo "Setting up live-build configuration with correct repositories..."
mkdir live-default
cd live-default || exit
lb config --distribution bookworm --archive-areas "main contrib non-free non-free-firmware" --iso-volume "GNUstep Live"

# Customize package lists to include all GNUstep packages, WindowMaker, and Calamares
echo "Adding all GNUstep packages and Calamares Installer..."
WORKDIR="$PWD"
cp ${WORKDIR}/config/package-lists/gershwin.list.chroot config/package-lists/gershwin.list.chroot

# Build the live ISO
echo "Building the live ISO..."
lb build