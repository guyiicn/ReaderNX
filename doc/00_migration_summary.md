# libnx API 迁移总结

## 项目信息

- **项目名称：** EbookViewerNX
- **迁移日期：** 2026-01-10
- **迁移原因：** libnx v4.0.0+ 移除了旧版 HID API

## 迁移结果

✅ **编译成功**
✅ **运行正常**

## 修改文件列表

### libnx API 迁移（6 个文件）

| 文件 | 修改内容 |
|------|----------|
| include/controller.h | 新增 TouchPoint 类型、PadState 声明、更新函数签名 |
| source/init.c | 新增 PadState 定义、添加 Pad/Touch 初始化 |
| source/controller.c | 更新触摸处理、按键常量迁移 |
| source/home.c | 更新输入循环 |
| source/ebook.c | 更新输入循环、按键常量 |
| source/graphic.c | 更新消息框/错误框输入处理 |

### 编译修复（4 个文件）

| 文件 | 修改内容 |
|------|----------|
| libs/Makefile.mupdf | 添加 freetype2 头文件路径 |
| libs/mupdf/source/pdf/pdf-annot.c | 添加 Switch 平台的 timegm 实现 |
| Makefile | 移除 twili、添加 zstd/harfbuzz、修复链接顺序 |
| source/stubs.c | 新建，提供 umask stub 函数 |

## API 映射表

### 按键常量

| 旧 API | 新 API |
|--------|--------|
| KEY_RSTICK_RIGHT | HidNpadButton_StickRRight |
| KEY_RSTICK_LEFT | HidNpadButton_StickRLeft |
| KEY_RSTICK_UP | HidNpadButton_StickRUp |
| KEY_RSTICK_DOWN | HidNpadButton_StickRDown |
| KEY_PLUS | HidNpadButton_Plus |
| KEY_A | HidNpadButton_A |
| KEY_X | HidNpadButton_X |
| KEY_ZR | HidNpadButton_ZR |

### 输入函数

| 旧 API | 新 API |
|--------|--------|
| hidScanInput() | padUpdate(&g_pad) |
| hidKeysDown(CONTROLLER_P1_AUTO) | padGetButtonsDown(&g_pad) |
| hidTouchRead(&touch, 0) | hidGetTouchScreenStates(&state, 1) |

### 类型

| 旧类型 | 新类型 |
|--------|--------|
| touchPosition | TouchPoint (自定义) + HidTouchScreenState |
| touch.px / touch.py | touch.x / touch.y |

## 初始化代码

```c
// 在 init_all() 中添加
padConfigureInput(1, HidNpadStyleSet_NpadStandard);
padInitializeDefault(&g_pad);
hidInitializeTouchScreen();
```

## 文档目录

```
doc/
├── 00_migration_summary.md  (本文件)
├── 01_controller_h.md
├── 02_init_c.md
├── 03_controller_c.md
├── 04_home_c.md
├── 05_ebook_c.md
├── 06_graphic_c.md
├── 07_build_result.md
└── 08_additional_fixes.md
```

## 编译命令

```bash
# 首次编译需要先编译 mupdf
cd libs && make -f Makefile.mupdf && cd ..

# 编译主程序
make

# 清理并重新编译
make clean && make
```

## 输出文件

- `ebookViewerNX.nro` (47 MB)
