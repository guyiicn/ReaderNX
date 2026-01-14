# PC 构建说明

ReaderNX 可以在 Linux PC 上构建和运行用于测试。

## 安装依赖

```bash
cd ubuntu
./install-pc-dependencies.sh
```

这会安装：
- clang
- libsdl2-dev
- libsdl2-ttf-dev
- libsdl2-image-dev
- libmupdf-dev
- libarchive-dev

## 构建

```bash
./build-pc.sh
```

或者直接使用 make：
```bash
cd ..
make pc
```

## 运行

```bash
./run-pc.sh
```

或者：
```bash
./EbookViewerNX_pc
```

## 注意事项

1. PC 版本使用 `-D__PC_BUILD__` 编译标志
2. Switch 特有的 API (padUpdate, appletMainLoop 等) 在 PC 上是空实现
3. romfs 资源在 PC 上直接访问 romfs/ 目录
4. CBR/CBZ 支持在 PC 版本中可能有限制

## 修改的文件

为了支持 PC 构建，修改了以下文件：

- `Makefile`: 添加了 `-D__PC_BUILD__` 和必要的库链接
- `include/controller.h`: 添加了 PC 构建的类型定义和空函数
- `source/init.c`: 为 Switch 特有代码添加了条件编译
