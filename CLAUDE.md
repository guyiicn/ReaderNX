# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

EbookViewerNX is an ebook reader homebrew application for the Nintendo Switch. It uses MuPDF for PDF/EPUB rendering and libarchive for CBR/CBZ comic book support, with SDL2 for graphics and input handling.

## Build Commands

### Prerequisites
```bash
# Install devkitPro toolchain and dependencies (Arch Linux)
sudo pacman -S libnx switch-tools switch-sdl2 switch-sdl2_image switch-sdl2_ttf switch-liblzma
yay ltwili
```

### Building
```bash
# First time: build MuPDF library
cd libs
make -f Makefile.mupdf
cd ..

# Build the application (outputs ebookViewerNX.nro)
make

# Clean build artifacts
make clean
```

### Linux PC Build (for testing)
```bash
make pc
# or directly:
clang -g source/*.c libs/log.c/src/*.c -I include -I ./libs/log.c/src -L/usr/local/lib -lmupdf -lmupdf-third -I/usr/include/SDL2 -D_REENTRANT -pthread -lSDL2 -lm -DLOG_USE_COLOR -o EbookViewerNX_pc
```

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
3. User selects a book → `ebook_reader()` or CBR reader is invoked
4. Reading loop handles page navigation and orientation changes
5. Page progress is saved to `/switch/ebookViewerNX/config`

### Libraries
- **libs/mupdf** - PDF/EPUB rendering engine (git submodule)
- **libs/log.c** - Logging library (git submodule)
- **libs/archive** - libarchive for CBR/CBZ extraction

### Key Constants
- Window: 1280x720 (Switch docked resolution)
- Cover display: 350x500 pixels
- Ebook path: `/switch/ebookViewerNX/`
- Config path: `/switch/ebookViewerNX/config`

## Development Notes

- The `__NXLINK__` define enables socket debugging via nxlink
- The `__TWILI__` define enables Twili debugger support (currently commented out)
- RomFS (`romfs/`) contains bundled assets like fonts
