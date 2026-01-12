# 额外修复记录

## 编译过程中发现的问题及修复

### 1. Makefile.mupdf - 添加 freetype 头文件路径

**文件：** `libs/Makefile.mupdf`

**修改：**
```makefile
# 旧
CFLAGS	+=	-D__SWITCH__ $(INCLUDE) `sdl2-config --cflags`

# 新
CFLAGS	+=	-D__SWITCH__ $(INCLUDE) `sdl2-config --cflags` -I$(DEVKITPRO)/portlibs/switch/include/freetype2
```

### 2. mupdf pdf-annot.c - 添加 timegm 实现

**文件：** `libs/mupdf/source/pdf/pdf-annot.c`

**修改：**
```c
#ifdef _WIN32
#define timegm _mkgmtime
#elif defined(__SWITCH__)
/* Simple timegm implementation for Switch */
static time_t timegm(struct tm *tm) {
	/* Simplified implementation - treat as UTC */
	return mktime(tm);
}
#endif
```

### 3. Makefile - 移除 twili 依赖

**文件：** `Makefile`

**修改：**
- 从 LIBS 中移除 `-ltwili`
- 从 LIBDIRS 中移除 `/opt/devkitpro/twili-libnx`

### 4. Makefile - 添加缺失的库依赖

**文件：** `Makefile`

**修改：**
```makefile
# 最终 LIBS 配置
LIBS := -lSDL2 -lSDL2_ttf -lSDL2_image -lwebp -lEGL -lglapi -ldrm_nouveau \
        `sdl2-config --libs` -larchive -lzstd -llzma -lz -lstdc++ -lnx \
        -lmupdf -Wl,--allow-multiple-definition -lharfbuzz -lmupdf-third \
        -lfreetype -lm -ljpeg -lpng -lbz2
```

**说明：**
- 添加 `-lzstd` - libarchive 依赖
- 添加 `-lharfbuzz` - freetype 依赖
- 添加 `-Wl,--allow-multiple-definition` - 解决 harfbuzz 和 mupdf-third 的符号冲突

### 5. 新建 stubs.c - 提供缺失的 POSIX 函数

**文件：** `source/stubs.c`（新建）

**内容：**
```c
/* Stub implementations for missing POSIX functions on Switch */

#include <sys/types.h>

/* umask is not available in newlib for Switch */
mode_t umask(mode_t mask) {
    (void)mask;
    return 0;
}
```

---

## 编译结果

**成功生成：** `ebookViewerNX.nro` (47 MB)
