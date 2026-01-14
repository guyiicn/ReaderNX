#!/bin/bash
# Build PC version for testing (Linux)
# Note: CBR/CBZ support is not available on PC build

set -e

echo "========================================"
echo "Building ReaderNX PC Version"
echo "========================================"

# Get project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Check dependencies
echo ""
echo "Checking PC dependencies..."

MISSING=""

if ! command -v clang &> /dev/null; then
    echo "✗ clang not found"
    MISSING="$MISSING clang"
else
    echo "✓ clang found"
fi

if ! pkg-config --exists sdl2; then
    echo "✗ SDL2 not found"
    MISSING="$MISSING libsdl2-dev"
else
    echo "✓ SDL2 found"
fi

if ! pkg-config --exists SDL2_ttf; then
    echo "✗ SDL2_ttf not found"
    MISSING="$MISSING libsdl2-ttf-dev"
else
    echo "✓ SDL2_ttf found"
fi

if ! pkg-config --exists SDL2_image; then
    echo "✗ SDL2_image not found"
    MISSING="$MISSING libsdl2-image-dev"
else
    echo "✓ SDL2_image found"
fi

if ! pkg-config --exists libarchive; then
    echo "✗ libarchive not found"
    MISSING="$MISSING libarchive-dev"
else
    echo "✓ libarchive found"
fi

if [ ! -f /usr/local/lib/libmupdf.a ] && [ ! -f /usr/lib/libmupdf.a ] && [ ! -f /usr/lib/x86_64-linux-gnu/libmupdf.a ]; then
    echo "⚠️  MuPDF not found (will try anyway)"
else
    echo "✓ MuPDF found"
fi

if [ -n "$MISSING" ]; then
    echo ""
    echo "Missing dependencies:$MISSING"
    echo ""
    echo "Install with:"
    echo "  cd ubuntu && ./install-pc-dependencies.sh"
    echo ""
    echo "Or manually:"
    echo "  sudo apt-get install -y$MISSING libmupdf-dev libmujs-dev libjbig2dec0-dev libopenjp2-7-dev libgumbo-dev"
    echo ""
    read -p "Try to install them now? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get update
        sudo apt-get install -y$MISSING libmupdf-dev
    else
        echo "Aborting."
        exit 1
    fi
fi

# Build
echo ""
echo "Building PC version..."
make pc

if [ -f "EbookViewerNX_pc" ]; then
    echo ""
    echo "========================================"
    echo "✓ Build successful!"
    echo "========================================"
    echo ""
    echo "Executable: EbookViewerNX_pc"
    echo "Size: $(du -h EbookViewerNX_pc | cut -f1)"
    echo ""
    echo "Run with:"
    echo "  ./EbookViewerNX_pc"
    echo ""
    echo "Note: CBR/CBZ support is not available in PC build"
    echo ""
else
    echo ""
    echo "✗ Build failed!"
    exit 1
fi
