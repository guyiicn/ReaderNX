#!/bin/bash
# Build MuPDF library for Nintendo Switch
# This script compiles the MuPDF library needed by ReaderNX

set -e

echo "========================================"
echo "Building MuPDF for Nintendo Switch"
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

# Check if libs directory exists
if [ ! -d "$PROJECT_ROOT/libs" ]; then
    echo "Error: libs directory not found!"
    echo "Please ensure you're in the ReaderNX project directory."
    exit 1
fi

# Check if mupdf submodule is initialized
if [ ! -d "$PROJECT_ROOT/libs/mupdf" ] || [ -z "$(ls -A "$PROJECT_ROOT/libs/mupdf")" ]; then
    echo ""
    echo "MuPDF submodule not found. Initializing submodules..."
    cd "$PROJECT_ROOT"
    git submodule update --init --recursive
fi

# Build MuPDF
echo ""
echo "Building MuPDF library..."
echo "This will take several minutes..."
echo ""

cd "$PROJECT_ROOT/libs"

# Clean any previous build
if [ -d "mupdf/build" ]; then
    echo "Cleaning previous MuPDF build..."
    rm -rf mupdf/build
fi

# Apply MuPDF patches if not already applied
if ! grep -q "__SWITCH__" mupdf/source/pdf/pdf-annot.c; then
    echo "Applying MuPDF Switch patches..."
    cd mupdf
    patch -p1 < ../../patches/mupdf-switch-timegm.patch
    cd ..
    echo "✓ Patches applied"
else
    echo "✓ MuPDF patches already applied"
fi

# Build using the Switch-specific Makefile
make -f Makefile.mupdf

echo ""
echo "========================================"
echo "✓ MuPDF build completed!"
echo "========================================"
echo ""
echo "MuPDF libraries have been built and copied to libs/mupdf/lib/"
echo ""
echo "You can now build the main project with: ./build.sh"
echo ""
