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

### Prerequisites (Arch Linux with devkitPro)

```bash
sudo pacman -S libnx switch-tools switch-sdl2 switch-sdl2_image switch-sdl2_ttf switch-liblzma
```

### Build

```bash
git clone --recursive https://github.com/guyiicn/ReaderNX
cd ReaderNX/libs
make -f Makefile.mupdf
cd ..
make
```

### PC Build (for testing)

```bash
make pc
```

Note: PC build requires mupdf and SDL2 installed. CBR/CBZ not supported on PC.

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
