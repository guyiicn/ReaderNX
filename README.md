# ReaderNX

Ebook reader for Nintendo Switch, forked from [EbookViewerNX](https://github.com/SegFault42/ebookViewerNX).

## Features

- Read PDF, EPUB, CBR, CBZ files
- Portrait/Landscape orientation
- Dual page view (landscape mode)
- Touchscreen support
- Progress bar and page indicator
- Sort by last read (recent books first)
- **Web Upload** - Upload ebooks from your browser via Wi-Fi

## Usage

1. Copy `ReaderNX.nro` to `/switch/` folder on your SD card
2. Create folder `/switch/ebookViewerNX/` and put your ebooks there
3. Launch from Homebrew Menu

### Web Upload

1. Press `-` button in home menu to start web server
2. Connect your PC/phone to the same Wi-Fi network
3. Open browser and go to `http://<Switch IP>:8080`
4. Upload PDF, EPUB, CBR, or CBZ files directly

## Controls

### Home Menu (List View)
| Button | Action |
|--------|--------|
| Up/Down, Left Stick | Navigate books |
| L / R | Page up/down |
| A | Open book |
| - (Minus) | Toggle Web Server |
| + (Plus) | Quit |

### Reading
| Button | Action |
|--------|--------|
| Right Stick Left/Right | Previous/Next page |
| Right Stick Up/Down | -10/+10 pages |
| ZR | Toggle Portrait/Landscape |
| Y | Toggle Dual Page mode |
| X | Toggle floating bar |
| A | Toggle help |
| + (Plus) | Return to home |
| Touch | Tap screen edges to turn pages |

## Building

### Ubuntu (Recommended - One-Click Setup)

Ubuntu users can use automated build scripts that handle all dependencies:

```bash
git clone --recursive https://github.com/guyiicn/ReaderNX
cd ReaderNX/ubuntu
./setup-all.sh
```

This will:
- Install devkitPro toolchain
- Install all Switch libraries
- Build MuPDF (takes 5-10 minutes)
- Build ReaderNX

Output: `ReaderNX.nro` in project root.

**Alternative - Step by step:**
```bash
cd ubuntu
./setup-devkitpro.sh       # Install devkitPro
source ~/.bashrc            # Load environment
./install-dependencies.sh   # Install Switch libraries
./build-mupdf.sh            # Build MuPDF
./build.sh                  # Build ReaderNX
```

See [`ubuntu/README.md`](ubuntu/README.md) for detailed documentation.

**Note:** This build uses `--allow-unauthenticated` for APT packages because the dependencies are 7 years old with expired PGP keys. This is safe for this specific use case.

### Arch Linux (Manual Setup)

If you're on Arch with devkitPro already configured:

```bash
sudo pacman -S libnx switch-tools switch-sdl2 switch-sdl2_image switch-sdl2_ttf switch-liblzma
git clone --recursive https://github.com/guyiicn/ReaderNX
cd ReaderNX/libs
make -f Makefile.mupdf
cd ..
make
```

### PC Build (for testing on Linux)

Build a PC version to test without Switch hardware:

**Ubuntu:**
```bash
cd ubuntu
./install-pc-dependencies.sh  # Install SDL2, mupdf, etc.
./build-pc.sh                  # Build
./run-pc.sh                    # Run
```

**Manual:**
```bash
# Install dependencies first
sudo apt-get install clang libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev \
    libmupdf-dev libarchive-dev libmujs-dev libjbig2dec0-dev \
    libopenjp2-7-dev libgumbo-dev

# Build
make pc

# Run
./EbookViewerNX_pc
```

**Limitations:**
- PC build is for testing UI/layout only
- Some features may not work as expected
- Put test ebooks in `/switch/ebookViewerNX/` (same as Switch)

## Roadmap

- [x] Read PDF/EPUB
- [x] Portrait/Landscape mode
- [x] Touchscreen support
- [x] CBR/CBZ support
- [x] Progress bar
- [x] Dual page view
- [x] Sort by last read
- [x] Web upload via Wi-Fi
- [ ] Night mode
- [ ] Page cache for faster loading

## Credits

- Original project: [SegFault42/ebookViewerNX](https://github.com/SegFault42/ebookViewerNX)
- PDF/EPUB rendering: [MuPDF](https://mupdf.com/)
- Web server: [Mongoose](https://github.com/cesanta/mongoose)
