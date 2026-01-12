# 编译结果

## 编译状态

**API 迁移成功** - 所有源文件编译通过，无 libnx API 相关错误。

## 编译输出

```
array.c     ✓
cbr.c       ✓ (有 warning)
controller.c ✓
debug.c     ✓
ebook.c     ✓ (有 warning)
file.c      ✓
get_next_line.c ✓ (有 warning)
graphic.c   ✓ (有 warning)
home.c      ✓ (有 warning)
init.c      ✓ (有 warning)
layout.c    ✓
main.c      ✓
log.c       ✓
linking     ✗ (缺少库文件)
```

## 链接错误（与迁移无关）

```
cannot find -lmupdf: No such file or directory
cannot find -lmupdf-third: No such file or directory
cannot find -ltwili: No such file or directory
```

**原因：** 需要先编译 mupdf 库，参考 README.md：
```bash
cd libs
make -f Makefile.mupdf
cd ..
```

twili 库是可选的调试库，如果不需要可以在 Makefile 中移除。

## 原有代码 Warnings（与迁移无关）

这些是原有代码的问题，不是本次迁移引入的：

1. **calloc 参数顺序警告** - 多个文件存在此问题
   - 正确用法：`calloc(count, size)`
   - 当前用法：`calloc(sizeof(type), count)`

2. **use-after-free 警告** - init.c:60-61
   - `free(graphic)` 后又访问 `graphic->ttf`

3. **类型不匹配警告** - graphic.c:167
   - `strlen()` 传入了 `unsigned char *`

## 结论

libnx API 迁移已完成。原有的 `touchPosition` 和 `hidScanInput` 等 API 错误已全部解决。

剩余工作：
1. 编译 mupdf 库
2. 处理 twili 库依赖（移除或安装）
3. （可选）修复原有代码的 warnings
