#!/bin/bash
# Clean ReaderNX build artifacts
# This script removes all compiled files and build directories

set -e

echo "========================================"
echo "Cleaning ReaderNX Build Artifacts"
echo "========================================"

# Get the project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo ""
echo "Cleaning project build files..."

# Clean main project
if [ -f "Makefile" ]; then
    make clean 2>/dev/null || true
fi

# Remove build artifacts
rm -rf build/
rm -f *.nro
rm -f *.elf
rm -f *.nacp
rm -f *.map

echo "✓ Project build files cleaned"

# Ask if user wants to clean MuPDF as well
echo ""
read -p "Do you want to clean MuPDF build files as well? (y/N): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Cleaning MuPDF build files..."

    if [ -d "libs/mupdf/build" ]; then
        rm -rf libs/mupdf/build/
        echo "✓ MuPDF build directory removed"
    fi

    if [ -d "libs/mupdf/lib" ]; then
        rm -rf libs/mupdf/lib/
        echo "✓ MuPDF lib directory removed"
    fi

    echo "✓ MuPDF build files cleaned"
    echo ""
    echo "Note: You'll need to run ./build-mupdf.sh again before building the project."
fi

echo ""
echo "========================================"
echo "✓ Cleanup completed!"
echo "========================================"
echo ""
