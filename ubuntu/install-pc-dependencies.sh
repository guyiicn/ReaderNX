#!/bin/bash
# Install PC build dependencies

set -e

echo "Installing PC build dependencies..."
echo ""

sudo apt-get update
sudo apt-get install -y \
    clang \
    libsdl2-dev \
    libsdl2-ttf-dev \
    libsdl2-image-dev \
    libmupdf-dev \
    libarchive-dev \
    libmujs-dev \
    libjbig2dec0-dev \
    libopenjp2-7-dev \
    libgumbo-dev

echo ""
echo "✓ PC dependencies installed!"
