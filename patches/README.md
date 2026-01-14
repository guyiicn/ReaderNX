# MuPDF Patches

This directory contains patches required for building ReaderNX.

## mupdf-switch-timegm.patch

**Purpose:** Add timegm() implementation for Nintendo Switch

**Why needed:**
- Nintendo Switch uses newlib C library
- newlib doesn't provide the GNU extension `timegm()`
- MuPDF's pdf-annot.c only handles Windows (`_mkgmtime`) but not Switch

**What it does:**
Adds a `timegm()` implementation using `mktime()` with timezone manipulation for Switch platform.

## Automatic Application

The Ubuntu build scripts (`ubuntu/build-mupdf.sh`) automatically apply this patch during the MuPDF build process.

## Manual Application

If building manually without Ubuntu scripts:

```bash
cd libs/mupdf
patch -p1 < ../../patches/mupdf-switch-timegm.patch
```

To check if patch is applied:
```bash
cd libs/mupdf
grep -A 5 "__SWITCH__" source/pdf/pdf-annot.c
```

You should see the timegm implementation code.
