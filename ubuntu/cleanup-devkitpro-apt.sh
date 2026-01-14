#!/bin/bash
# Clean up devkitPro APT sources and configurations
# Run this first if you have APT repository errors

echo "========================================"
echo "Cleaning DevkitPro APT Sources"
echo "========================================"
echo ""

# Remove APT source
if [ -f /etc/apt/sources.list.d/devkitpro.list ]; then
    echo "Removing /etc/apt/sources.list.d/devkitpro.list"
    sudo rm -f /etc/apt/sources.list.d/devkitpro.list
fi

# Remove APT configuration
if [ -f /etc/apt/apt.conf.d/99devkitpro ]; then
    echo "Removing /etc/apt/apt.conf.d/99devkitpro"
    sudo rm -f /etc/apt/apt.conf.d/99devkitpro
fi

# Remove GPG keyring
if [ -f /usr/share/keyrings/devkitpro-pub.gpg ]; then
    echo "Removing /usr/share/keyrings/devkitpro-pub.gpg"
    sudo rm -f /usr/share/keyrings/devkitpro-pub.gpg
fi

# Clean apt cache
echo "Cleaning APT cache..."
sudo apt-get clean

echo ""
echo "✓ DevkitPro APT sources cleaned"
echo ""
echo "You can now run: ./setup-devkitpro-direct.sh"
echo ""
