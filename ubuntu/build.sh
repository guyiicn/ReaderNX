#!/bin/bash
# Build ReaderNX for Nintendo Switch
# This script compiles the complete ReaderNX application

set -e

echo "========================================"
echo "Building ReaderNX"
echo "========================================"

# Check if DEVKITPRO is set
if [ -z "$DEVKITPRO" ]; then
    echo "Error: DEVKITPRO environment variable is not set!"
    echo "Please run: source ~/.bashrc"
    echo ""
    echo "Quick fix: export DEVKITPRO=/opt/devkitpro"
    exit 1
fi

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo ""
echo "Project root: $PROJECT_ROOT"
echo "DEVKITPRO: $DEVKITPRO"

# Export required environment variables
export DEVKITARM=$DEVKITPRO/devkitARM
export DEVKITA64=$DEVKITPRO/devkitA64
export PATH=$DEVKITPRO/tools/bin:$PATH

# Check if MuPDF library exists
if [ ! -f "$PROJECT_ROOT/libs/mupdf/lib/libmupdf.a" ]; then
    echo ""
    echo "Error: MuPDF library not found!"
    echo "Please build MuPDF first by running: ./build-mupdf.sh"
    exit 1
fi

# Check if submodules are initialized
if [ ! -d "$PROJECT_ROOT/libs/log.c/src" ] || [ -z "$(ls -A "$PROJECT_ROOT/libs/log.c/src" 2>/dev/null)" ]; then
    echo ""
    echo "Submodules not initialized. Initializing..."
    cd "$PROJECT_ROOT"
    git submodule update --init --recursive
fi

# Build the project
echo ""
echo "Building ReaderNX..."
echo ""

cd "$PROJECT_ROOT"
make

# Check if build was successful
if [ -f "$PROJECT_ROOT/ReaderNX.nro" ]; then
    echo ""
    echo "========================================"
    echo "✓ Build completed successfully!"
    echo "========================================"
    echo ""
    echo "Output file: ReaderNX.nro"
    echo "Size: $(du -h ReaderNX.nro | cut -f1)"
    echo ""
    echo "To install on Switch:"
    echo "  1. Copy ReaderNX.nro to /switch/ on your SD card"
    echo "  2. Create /switch/ebookViewerNX/ directory for your ebooks"
    echo "  3. Launch from Homebrew Menu"
    echo ""
else
    echo ""
    echo "========================================"
    echo "✗ Build failed!"
    echo "========================================"
    echo ""
    echo "Please check the error messages above."
    exit 1
fi
