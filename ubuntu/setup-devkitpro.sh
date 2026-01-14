#!/bin/bash
# DevkitPro installer for Ubuntu - GPG bypassed

set -e

echo "DevkitPro Setup (No GPG)"
echo "========================"

# Clean old sources
sudo rm -f /etc/apt/sources.list.d/devkitpro.list /etc/apt/apt.conf.d/99devkitpro /usr/share/keyrings/devkitpro-pub.gpg

# Add trusted source
echo "deb [trusted=yes] https://apt.devkitpro.org stable main" | sudo tee /etc/apt/sources.list.d/devkitpro.list

# Configure APT to allow unauthenticated
sudo tee /etc/apt/apt.conf.d/99devkitpro > /dev/null << 'EOF'
APT::Get::AllowUnauthenticated "true";
Acquire::AllowInsecureRepositories "true";
EOF

# Install
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated devkitpro-pacman

# Configure pacman
sudo mkdir -p /opt/devkitpro/pacman/etc
sudo tee /opt/devkitpro/pacman/etc/pacman.conf > /dev/null << 'EOF'
[options]
Architecture = auto
SigLevel = Never

[dkp-libs]
Server = https://downloads.devkitpro.org/packages
SigLevel = Never

[dkp-linux]
Server = https://downloads.devkitpro.org/packages/linux/$arch/
SigLevel = Never
EOF

# Install switch-dev
if command -v dkp-pacman &> /dev/null; then
    sudo dkp-pacman -Syy --noconfirm --overwrite '*'
    sudo dkp-pacman -S --noconfirm --overwrite '*' switch-dev
fi

# Environment
if ! grep -q "DEVKITPRO" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

export DEVKITPRO=/opt/devkitpro
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITPRO/tools/bin:$PATH
EOF
fi

echo ""
echo "✓ Done! Run: source ~/.bashrc"
