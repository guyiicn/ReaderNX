#!/bin/bash
# Run the PC version of ReaderNX

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

if [ ! -f "EbookViewerNX_pc" ]; then
    echo "✗ EbookViewerNX_pc not found!"
    echo ""
    echo "Build it first:"
    echo "  cd ubuntu"
    echo "  ./build-pc.sh"
    exit 1
fi

echo "Running ReaderNX PC version..."
echo ""
echo "Note: Put your ebooks in /switch/ebookViewerNX/"
echo "      (Same path as Switch version)"
echo ""

./EbookViewerNX_pc
