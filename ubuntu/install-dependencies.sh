#!/bin/bash
# Install Nintendo Switch development dependencies
# This script installs all required libraries for ReaderNX

set -e

echo "========================================"
echo "Installing Switch Development Dependencies"
echo "========================================"

# CRITICAL: Remove any devkitPro APT sources first!
echo ""
echo "[0/3] Cleaning up any devkitPro APT sources (if exist)..."
sudo rm -f /etc/apt/sources.list.d/devkitpro.list 2>/dev/null || true
sudo rm -f /etc/apt/apt.conf.d/99devkitpro 2>/dev/null || true
echo "✓ Cleanup done"

# Check if DEVKITPRO is set
if [ -z "$DEVKITPRO" ]; then
    echo ""
    echo "Error: DEVKITPRO environment variable is not set!"
    echo "Please run setup-devkitpro.sh first and source your ~/.bashrc"
    echo ""
    echo "Quick fix: export DEVKITPRO=/opt/devkitpro"
    exit 1
fi

# Ensure pacman is configured to skip signature verification
echo ""
echo "[1/3] Configuring pacman..."
for conf in /etc/pacman.conf /opt/devkitpro/pacman/etc/pacman.conf; do
    if [ -f "$conf" ]; then
        echo "Configuring $conf"
        sudo sed -i.bak 's/^SigLevel.*/SigLevel = Never/g' "$conf"
        sudo sed -i '/^\[/a SigLevel = Never' "$conf" 2>/dev/null || true
    fi
done

# Update package database
echo ""
echo "[2/3] Updating package database..."
echo "⚠️  This may show warnings about expired keys - that's expected"
sudo dkp-pacman -Syy --noconfirm --overwrite '*' 2>&1 || {
    echo "⚠️  Database update had issues, trying to continue anyway..."
}

# Install all required packages
echo ""
echo "[3/3] Installing Switch libraries..."
echo "This may take a while..."

PACKAGES=(
    "libnx"
    "switch-tools"
    "switch-sdl2"
    "switch-sdl2_image"
    "switch-sdl2_ttf"
    "switch-freetype"
    "switch-libpng"
    "switch-libjpeg-turbo"
    "switch-libwebp"
    "switch-zlib"
    "switch-bzip2"
    "switch-liblzma"
    "switch-libarchive"
    "switch-zstd"
    "switch-glad"
    "switch-glm"
    "switch-mesa"
)

FAILED_PACKAGES=()
INSTALLED_PACKAGES=()

for package in "${PACKAGES[@]}"; do
    echo ""
    echo "Installing $package..."
    if sudo dkp-pacman -S --noconfirm --overwrite '*' --needed "$package" 2>&1; then
        INSTALLED_PACKAGES+=("$package")
        echo "✓ $package installed successfully"
    else
        FAILED_PACKAGES+=("$package")
        echo "✗ Failed to install $package"
        # Try alternative package name (sometimes switch- prefix is different)
        ALT_PACKAGE="${package/switch-/}"
        if [ "$ALT_PACKAGE" != "$package" ]; then
            echo "Trying alternative name: $ALT_PACKAGE"
            if sudo dkp-pacman -S --noconfirm --overwrite '*' --needed "$ALT_PACKAGE" 2>&1; then
                INSTALLED_PACKAGES+=("$ALT_PACKAGE")
                echo "✓ $ALT_PACKAGE installed successfully"
            fi
        fi
    fi
done

# Install additional build tools
echo ""
echo "Installing additional build tools from Ubuntu repos..."
sudo apt-get update  # This updates Ubuntu repos only, NOT devkitpro
sudo apt-get install -y \
    build-essential \
    git \
    make \
    cmake \
    pkg-config \
    autoconf \
    automake \
    libtool \
    m4 \
    || true

echo ""
echo "========================================"
echo "Dependencies Installation Summary"
echo "========================================"
echo ""
echo "✓ Successfully installed (${#INSTALLED_PACKAGES[@]} packages):"
for package in "${INSTALLED_PACKAGES[@]}"; do
    echo "  ✓ $package"
done

if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
    echo ""
    echo "✗ Failed to install (${#FAILED_PACKAGES[@]} packages):"
    for package in "${FAILED_PACKAGES[@]}"; do
        echo "  ✗ $package"
    done
    echo ""
    echo "⚠️  Some packages failed to install."
    echo "This might be okay if the core packages (libnx, switch-sdl2) are installed."
    echo ""
fi

# Check critical packages
echo ""
echo "Checking critical packages..."
CRITICAL_OK=true
for critical in "libnx" "switch-sdl2" "switch-tools"; do
    if dkp-pacman -Q "$critical" &>/dev/null; then
        echo "  ✓ $critical is installed"
    else
        echo "  ✗ $critical is NOT installed"
        CRITICAL_OK=false
    fi
done

echo ""
if [ "$CRITICAL_OK" = true ]; then
    echo "✓ All critical packages are installed!"
    echo "You can now proceed to build MuPDF with: ./build-mupdf.sh"
else
    echo "⚠️  WARNING: Some critical packages are missing!"
    echo "Build may fail. Please review the errors above."
fi
echo ""
