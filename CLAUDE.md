# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ReaderNX is an ebook reader homebrew application for the Nintendo Switch, forked from EbookViewerNX. It uses MuPDF for PDF/EPUB rendering and libarchive for CBR/CBZ comic book support, with SDL2 for graphics and input handling. Key features include portrait/landscape orientation, dual page view, touchscreen support, and web upload functionality.

## Build Commands

### Ubuntu Build (Recommended)

Ubuntu users should use the automated scripts in the `ubuntu/` directory:

```bash
# One-click setup (installs everything and builds)
cd ubuntu
./setup-all.sh

# Or step-by-step:
./setup-devkitpro.sh       # Install devkitPro toolchain
source ~/.bashrc            # Reload environment
./install-dependencies.sh   # Install Switch libraries
./build-mupdf.sh            # Build MuPDF (5-10 minutes)
./build.sh                  # Build ReaderNX.nro

# Diagnostics
./check-environment.sh      # Check if everything is installed correctly
```

**Important Notes:**
- Scripts use `--allow-unauthenticated` for APT because dependencies are 7+ years old with expired PGP keys
- All scripts handle PGP signature bypassing automatically
- See `ubuntu/README.md` and `ubuntu/FILES.md` for detailed documentation

### Arch Linux (Manual Setup)
```bash
# Install devkitPro toolchain and dependencies
sudo pacman -S libnx switch-tools switch-sdl2 switch-sdl2_image switch-sdl2_ttf switch-liblzma
yay ltwili

# Clone with submodules
git clone --recursive https://github.com/guyiicn/ReaderNX
cd ReaderNX

# Build MuPDF library (first time only)
cd libs
make -f Makefile.mupdf
cd ..

# Build the application (outputs ReaderNX.nro)
make

# Clean build artifacts
make clean
```

### PC Build (for testing without Switch hardware)

Build a PC version for development/testing:

**Ubuntu:**
```bash
cd ubuntu
./install-pc-dependencies.sh  # Install all PC dependencies
./build-pc.sh                  # Build PC version
./run-pc.sh                    # Run PC version
```

**Manual PC build:**
```bash
# Install dependencies
sudo apt-get install clang libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev \
    libmupdf-dev libarchive-dev libmujs-dev libjbig2dec0-dev \
    libopenjp2-7-dev libgumbo-dev

# Build
make pc

# Run
./EbookViewerNX_pc
```

**PC Build Technical Details:**
- Uses `-D__PC_BUILD__` compile flag
- Switch-specific types (PadState, u32, u64, HidNpadButton_*) are stubbed in `include/controller.h`
- romfs paths changed from `romfs:/` to `romfs/` (direct filesystem access)
- Fonts: Uses `romfs/fonts/NintendoStandard.ttf` instead of `romfs:/fonts/`
- Modified files: `Makefile`, `include/controller.h`, `source/init.c`
- See `ubuntu/PC-BUILD.md` for full details

## Architecture

### Global State Pattern
The application uses global struct pointers defined in `main.c` and accessed via `extern` in other files:
- `t_graphic *graphic` - SDL window, renderer, and fonts
- `t_ebook *ebook` - MuPDF context, document, and page state
- `t_layout *layout` - UI element positions and dimensions
- `t_controller *controller` - Button mappings
- `t_transform *trans` - MuPDF transformation matrix for rendering
- `t_cbr *cbr` - libarchive handles for comic book formats

### Main Components

- **init.c** - Initialization/deinitialization of all subsystems (SDL, TTF, MuPDF, romfs)
- **home.c** - Home menu loop: lists ebooks from `/switch/ebookViewerNX/`, handles navigation
- **ebook.c** - PDF/EPUB reading via MuPDF: opens documents, converts pages to pixmaps
- **cbr.c** - CBR/CBZ comic reading via libarchive extraction
- **graphic.c** - SDL rendering functions: drawing pixmaps, UI elements, text
- **layout.c** - UI positioning logic for portrait/landscape orientations
- **controller.c** - Button and touchscreen input handling

### Application Flow
1. `main()` calls `init_all()` then `home_page()`
2. Home page scans `/switch/ebookViewerNX/` for supported files (.pdf, .epub, .cbz, .cbr)
3. User can press `-` button to toggle web server for uploading ebooks via browser at `http://<Switch IP>:8080`
4. User selects a book → `ebook_reader()` or CBR reader is invoked
5. Reading loop handles page navigation, dual page mode (landscape), and orientation changes
6. Page progress is saved to `/switch/ebookViewerNX/config` and books are sorted by last read

### Libraries
- **libs/mupdf** - PDF/EPUB rendering engine (git submodule, build with `make -f Makefile.mupdf`)
- **libs/log.c** - Logging library (git submodule)
- **libs/archive** - libarchive for CBR/CBZ extraction
- **Mongoose** - Embedded web server for Wi-Fi upload feature (mentioned in README)

### Key Constants
- Window: 1280x720 (Switch docked resolution)
- Cover display: 350x500 pixels
- Ebook path: `/switch/ebookViewerNX/`
- Config path: `/switch/ebookViewerNX/config`

## Development Notes

- The `__NXLINK__` define enables socket debugging via nxlink
- The `__TWILI__` define enables Twili debugger support (currently commented out in Makefile)
- RomFS (`romfs/`) contains bundled assets like fonts
- The application uses MuPDF's `fz_try`/`fz_catch` exception handling pattern for document operations
- Config file format: `filename=page_number` (one entry per line)
- Touchscreen uses `TouchPoint` struct (replaces old `touchPosition`) with x/y coordinates
- The `PadState g_pad` is a global variable for gamepad input handling
