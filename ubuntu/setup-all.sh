#!/bin/bash
# Complete setup and build script for ReaderNX on Ubuntu
# Uses ONLY the official devkitPro installation method (modified for GPG)

set -e

echo "========================================"
echo "ReaderNX - Complete Setup for Ubuntu"
echo "========================================"
echo ""
echo "This script will:"
echo "  1. Install devkitPro toolchain (official method, GPG bypassed)"
echo "  2. Install Nintendo Switch libraries"
echo "  3. Build MuPDF library"
echo "  4. Build ReaderNX application"
echo ""
echo "⚠️  SECURITY WARNING ⚠️"
echo "This script will disable GPG signature verification"
echo "for devkitPro packages due to expired signing keys."
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Step 1: Setup devkitPro using official method
echo ""
echo "========================================"
echo "Step 1/4: Installing devkitPro Toolchain"
echo "========================================"
echo ""
./setup-devkitpro.sh

# Reload environment for current shell
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=$DEVKITPRO/devkitARM
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITPRO/tools/bin:$PATH

echo ""
echo "Environment variables loaded for current session."
read -p "Press Enter to continue to Step 2..."

# Step 2: Install dependencies
echo ""
echo "========================================"
echo "Step 2/4: Installing Dependencies"
echo "========================================"
echo ""
./install-dependencies.sh

echo ""
read -p "Press Enter to continue to Step 3..."

# Step 3: Build MuPDF
echo ""
echo "========================================"
echo "Step 3/4: Building MuPDF Library"
echo "========================================"
echo ""
echo "This step will take 5-10 minutes..."
echo ""
./build-mupdf.sh

echo ""
read -p "Press Enter to continue to Step 4..."

# Step 4: Build ReaderNX
echo ""
echo "========================================"
echo "Step 4/4: Building ReaderNX"
echo "========================================"
echo ""
./build.sh

# Done!
echo ""
echo "========================================"
echo "🎉 Setup Complete! 🎉"
echo "========================================"
echo ""
echo "ReaderNX has been successfully built!"
echo ""
echo "Next steps:"
echo "  1. Find ReaderNX.nro in the project root directory"
echo "  2. Copy it to /switch/ on your Nintendo Switch SD card"
echo "  3. Create /switch/ebookViewerNX/ directory"
echo "  4. Add your PDF, EPUB, CBR, or CBZ files there"
echo "  5. Launch from Homebrew Menu"
echo ""
echo "For future builds, you only need to run: ./build.sh"
echo ""
echo "To clean build files, run: ./clean.sh"
echo ""
