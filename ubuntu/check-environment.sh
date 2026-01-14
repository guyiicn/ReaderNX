#!/bin/bash
# Check devkitPro environment and installation status
# Use this script to diagnose problems

echo "========================================"
echo "DevkitPro Environment Diagnostic"
echo "========================================"
echo ""

# Check environment variables
echo "[1] Environment Variables:"
echo "----------------------------"
if [ -z "$DEVKITPRO" ]; then
    echo "✗ DEVKITPRO is not set"
    echo "  Run: export DEVKITPRO=/opt/devkitpro"
else
    echo "✓ DEVKITPRO=$DEVKITPRO"
fi

if [ -z "$DEVKITA64" ]; then
    echo "✗ DEVKITA64 is not set"
else
    echo "✓ DEVKITA64=$DEVKITA64"
fi

# Check if dkp-pacman is installed
echo ""
echo "[2] DevkitPro Pacman:"
echo "----------------------------"
if command -v dkp-pacman &> /dev/null; then
    echo "✓ dkp-pacman is installed"
    echo "  Version: $(dkp-pacman --version | head -n1)"
else
    echo "✗ dkp-pacman is NOT installed"
    echo "  Run: ./setup-devkitpro.sh"
fi

# Check directories
echo ""
echo "[3] Installation Directories:"
echo "----------------------------"
for dir in "/opt/devkitpro" "/opt/devkitpro/devkitA64" "/opt/devkitpro/libnx" "/opt/devkitpro/portlibs/switch"; do
    if [ -d "$dir" ]; then
        echo "✓ $dir exists"
    else
        echo "✗ $dir NOT found"
    fi
done

# Check critical packages
echo ""
echo "[4] Critical Packages:"
echo "----------------------------"
if command -v dkp-pacman &> /dev/null; then
    CRITICAL_PACKAGES=(
        "devkitA64"
        "libnx"
        "switch-tools"
        "switch-sdl2"
        "switch-sdl2_ttf"
        "switch-sdl2_image"
        "switch-libarchive"
    )

    for pkg in "${CRITICAL_PACKAGES[@]}"; do
        if dkp-pacman -Q "$pkg" &>/dev/null; then
            VERSION=$(dkp-pacman -Q "$pkg" 2>/dev/null | awk '{print $2}')
            echo "✓ $pkg ($VERSION)"
        else
            echo "✗ $pkg NOT installed"
        fi
    done
else
    echo "Cannot check packages - dkp-pacman not available"
fi

# Check compiler
echo ""
echo "[5] Compiler Toolchain:"
echo "----------------------------"
if [ -f "/opt/devkitpro/devkitA64/bin/aarch64-none-elf-gcc" ]; then
    GCC_VERSION=$(/opt/devkitpro/devkitA64/bin/aarch64-none-elf-gcc --version | head -n1)
    echo "✓ aarch64-none-elf-gcc found"
    echo "  $GCC_VERSION"
else
    echo "✗ aarch64-none-elf-gcc NOT found"
fi

# Check MuPDF
echo ""
echo "[6] MuPDF Library:"
echo "----------------------------"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

if [ -f "$PROJECT_ROOT/libs/mupdf/lib/libmupdf.a" ]; then
    SIZE=$(du -h "$PROJECT_ROOT/libs/mupdf/lib/libmupdf.a" | cut -f1)
    echo "✓ MuPDF library built ($SIZE)"
else
    echo "✗ MuPDF library NOT found"
    echo "  Run: ./build-mupdf.sh"
fi

# Check pacman configuration
echo ""
echo "[7] Pacman Configuration:"
echo "----------------------------"
if [ -f "/opt/devkitpro/pacman/etc/pacman.conf" ]; then
    if grep -q "SigLevel.*Never" /opt/devkitpro/pacman/etc/pacman.conf; then
        echo "✓ Signature verification disabled"
    else
        echo "⚠️  Signature verification is enabled"
        echo "  This may cause issues with old packages"
    fi
else
    echo "⚠️  pacman.conf not found"
fi

# Summary
echo ""
echo "========================================"
echo "Summary"
echo "========================================"

ISSUES=0

if [ -z "$DEVKITPRO" ]; then
    echo "⚠️  Environment variables not set"
    echo "   Fix: source ~/.bashrc"
    ((ISSUES++))
fi

if ! command -v dkp-pacman &> /dev/null; then
    echo "⚠️  dkp-pacman not installed"
    echo "   Fix: ./setup-devkitpro.sh"
    ((ISSUES++))
fi

if [ ! -d "/opt/devkitpro/devkitA64" ]; then
    echo "⚠️  devkitA64 not installed"
    echo "   Fix: sudo dkp-pacman -S switch-dev"
    ((ISSUES++))
fi

if [ ! -f "$PROJECT_ROOT/libs/mupdf/lib/libmupdf.a" ]; then
    echo "⚠️  MuPDF not built"
    echo "   Fix: ./build-mupdf.sh"
    ((ISSUES++))
fi

echo ""
if [ $ISSUES -eq 0 ]; then
    echo "✓ Environment looks good!"
    echo "  You should be able to build with: ./build.sh"
else
    echo "Found $ISSUES issue(s) that need to be fixed."
fi

echo ""
