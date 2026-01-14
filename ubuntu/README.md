# ReaderNX Ubuntu Build Scripts

## Quick Start

```bash
./setup-devkitpro.sh
source ~/.bashrc
./install-dependencies.sh
./build-mupdf.sh
./build.sh
```

Done! `ReaderNX.nro` will be in project root.

## Scripts

- `setup-devkitpro.sh` - Install devkitPro (GPG bypassed)
- `install-dependencies.sh` - Install Switch libraries
- `build-mupdf.sh` - Build MuPDF library
- `build.sh` - Build ReaderNX for Switch
- `build-pc.sh` - Build PC version for testing
- `run-pc.sh` - Run PC version
- `clean.sh` - Clean build files
- `check-environment.sh` - Diagnostic tool

## One-Click

```bash
./setup-all.sh
```

## PC Version (for testing)

Build and test on Linux PC without Switch hardware:

```bash
./build-pc.sh  # Build PC version
./run-pc.sh    # Run it
```

Note: PC version doesn't support CBR/CBZ files.

## Troubleshooting

```bash
./check-environment.sh
```
