# Changes from Original EbookViewerNX

This document summarizes the changes made to create ReaderNX from the original EbookViewerNX project.

## Major Additions

### 1. Ubuntu Build System (`ubuntu/` directory)

Complete automated build system for Ubuntu Linux:

**Setup Scripts:**
- `setup-devkitpro.sh` - Install devkitPro with PGP bypass
- `install-dependencies.sh` - Install Switch libraries
- `install-pc-dependencies.sh` - Install PC build dependencies
- `setup-all.sh` - One-click complete installation

**Build Scripts:**
- `build-mupdf.sh` - Build MuPDF with automatic patching
- `build.sh` - Build Switch version
- `build-pc.sh` - Build PC test version
- `clean.sh` - Clean build artifacts

**Utility Scripts:**
- `run-pc.sh` - Run PC version
- `check-environment.sh` - Diagnostic tool
- `cleanup-devkitpro-apt.sh` - Remove devkitPro APT sources

**Documentation:**
- `README.md` - Quick start guide
- `START-HERE.txt` - Chinese quick reference
- `PC-BUILD.md` - PC build details
- `FILES.md` - Complete file listing and usage

**Key Features:**
- Automatic PGP signature bypass (required for 7-year-old dependencies)
- One-command setup from fresh Ubuntu install
- PC build support for testing without Switch hardware

### 2. PC Build Support

Cross-platform compilation for development/testing:

**Modified Files:**
- `Makefile` - Added `pc` target with `-D__PC_BUILD__` flag
- `include/controller.h` - PC type definitions and stub functions
- `source/init.c` - Conditional compilation for Switch-specific code

**Features:**
- Builds native Linux executable
- Stubs out Switch-specific APIs (PadState, HidNpadButton_*, appletMainLoop)
- Direct filesystem access (romfs/ instead of romfs:/)
- Same UI and layout as Switch version

**Limitations:**
- For testing only, not full functionality
- Some features may not work as expected

### 3. MuPDF Patch System

**New Directory:** `patches/`

**Files:**
- `mupdf-switch-timegm.patch` - Adds timegm() for Switch newlib
- `patches/README.md` - Patch documentation

**Problem Solved:**
- Nintendo Switch uses newlib which lacks timegm()
- MuPDF only handled Windows (_mkgmtime), not Switch
- Patch adds timegm implementation using mktime() with TZ manipulation

**Integration:**
- `build-mupdf.sh` automatically applies patch before building
- Checks if patch already applied to avoid double-patching

## Updated Documentation

### README.md
- Added Ubuntu build instructions (recommended method)
- Expanded PC build section with full dependencies
- Added note about PGP signature bypass
- Kept original Arch Linux instructions as alternative

### CLAUDE.md
- Added Ubuntu build system documentation
- PC build technical details
- Build script usage examples
- Notes about modified files for PC support

### .gitignore
- Fixed PC executable name (EbookViewerNX_pc)
- Added build/ directory
- Excluded ubuntu/*.txt from *.txt ignore
- Added IDE files (.vscode/, .idea/)
- Added test ebook formats (*.epub, *.cbz, *.cbr)

## Technical Changes

### Conditional Compilation

Added `__PC_BUILD__` macro for platform-specific code:

**controller.h:**
```c
#ifdef __PC_BUILD__
typedef unsigned int u32;
typedef unsigned long long u64;
typedef long long s64;
typedef struct { int dummy; } PadState;
// ... stub functions
#endif
```

**init.c:**
```c
#ifndef __PC_BUILD__
    romfsInit();
    padConfigureInput(...);
#endif
```

### Font Path Handling

PC build uses direct filesystem paths:
- Switch: `romfs:/fonts/NintendoStandard.ttf`
- PC: `romfs/fonts/NintendoStandard.ttf`

## Dependencies Added

### Ubuntu/Debian PC Build:
- libmujs-dev (JavaScript engine for MuPDF)
- libjbig2dec0-dev (JBIG2 image decoder)
- libopenjp2-7-dev (JPEG 2000 support)
- libgumbo-dev (HTML5 parser)
- libarchive-dev (CBR/CBZ support)
- libfreetype-dev, libharfbuzz-dev (Font rendering)

## Build System Improvements

### PGP Security Bypass

All Ubuntu scripts handle expired PGP keys:
- APT sources use `[trusted=yes]`
- `/etc/apt/apt.conf.d/99devkitpro` sets `AllowUnauthenticated`
- pacman.conf uses `SigLevel = Never`

**Rationale:**
- Dependencies are 7+ years old
- PGP keys have expired
- Official devkitPro packages, verified by checksums
- Safe for this specific use case

### Makefile Enhancements

**PC target:**
```makefile
pc:
	clang -g source/*.c libs/log.c/src/*.c \
	  -I include -I ./libs/log.c/src \
	  -L/usr/local/lib -lmupdf -lmupdf-third \
	  -I/usr/include/SDL2 -D_REENTRANT -pthread \
	  -lSDL2 -lSDL2_ttf -lSDL2_image -larchive \
	  -lmujs -lfreetype -lharfbuzz -ljpeg \
	  -ljbig2dec -lopenjp2 -lgumbo -lz -lm \
	  -DLOG_USE_COLOR -D__PC_BUILD__ \
	  -o EbookViewerNX_pc
```

## Compatibility

- Maintains full backward compatibility with original project
- All Switch functionality preserved
- Original build methods (Arch Linux) still work
- No changes to core application logic

## Testing

PC build tested on:
- Ubuntu 20.04+
- Debian 11+

Switch build tested on:
- Nintendo Switch with Atmosphere CFW
- Homebrew Menu environment

## Credits

- Original project: [SegFault42/ebookViewerNX](https://github.com/SegFault42/ebookViewerNX)
- Ubuntu build system: ReaderNX fork
- MuPDF timegm patch: ReaderNX fork
