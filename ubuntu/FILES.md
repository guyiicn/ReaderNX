# Ubuntu 构建脚本文件列表

## 安装脚本

### setup-devkitpro.sh
安装 devkitPro 工具链（绕过 PGP 签名验证）
- 清理旧的 APT 配置
- 添加 devkitPro APT 源（带 trusted=yes）
- 安装 devkitpro-pacman
- 配置 pacman.conf（SigLevel = Never）

### install-dependencies.sh
安装 Switch 开发所需的库
- switch-sdl2
- switch-sdl2_ttf
- switch-sdl2_image
- switch-liblzma
- switch-libarchive
- switch-tools
- libnx

### install-pc-dependencies.sh
安装 PC 版本构建所需的库
- clang
- libsdl2-dev
- libsdl2-ttf-dev
- libsdl2-image-dev
- libmupdf-dev
- libarchive-dev
- libmujs-dev
- libjbig2dec0-dev
- libopenjp2-7-dev
- libgumbo-dev

### setup-all.sh
一键完整安装脚本
- 调用 setup-devkitpro.sh
- 调用 install-dependencies.sh
- 调用 build-mupdf.sh
- 调用 build.sh

## 构建脚本

### build-mupdf.sh
编译 MuPDF 库（Switch 版本）
- 检查 DEVKITPRO 环境变量
- 自动应用 MuPDF Switch 补丁（timegm 实现）
- 编译 libs/mupdf
- 大约需要 5-10 分钟

### build.sh
编译 ReaderNX Switch 版本
- 检查依赖和环境
- 运行 `make`
- 生成 ReaderNX.nro

### build-pc.sh
编译 ReaderNX PC 版本（用于测试）
- 检查 PC 依赖（clang, SDL2, MuPDF 等）
- 运行 `make pc`
- 生成 EbookViewerNX_pc
- 注意：PC 版本不支持 CBR/CBZ

## 运行和清理脚本

### run-pc.sh
运行 PC 版本
- 检查 EbookViewerNX_pc 是否存在
- 运行程序

### clean.sh
清理构建文件
- 运行 `make clean`
- 删除 build 目录和生成的二进制文件

### cleanup-devkitpro-apt.sh
清理 devkitPro APT 配置
- 删除 APT 源配置
- 删除 APT 配置文件
- 删除 GPG 密钥环

## 诊断工具

### check-environment.sh
检查开发环境
- 验证 DEVKITPRO 环境变量
- 检查 Switch 库是否安装
- 检查 MuPDF 是否编译
- 显示系统信息

## 辅助文件

### install-devkitpro-pacman
devkitPro pacman 安装脚本
- 由 setup-devkitpro.sh 使用
- 官方安装脚本

## 文档

### README.md
简明构建指南
- 快速开始步骤
- 脚本列表说明
- PC 版本构建说明

### START-HERE.txt
中文快速开始指南
- 一键安装命令
- 分步执行步骤
- PC 版本命令

### PC-BUILD.md
PC 构建详细说明
- 依赖安装
- 构建步骤
- 注意事项
- 修改的文件列表

## 文件使用顺序

### 首次完整安装（Switch）
1. `./setup-all.sh` （一键完整安装）

或分步执行：
1. `./setup-devkitpro.sh`
2. `source ~/.bashrc`
3. `./install-dependencies.sh`
4. `./build-mupdf.sh`
5. `./build.sh`

### PC 版本构建
1. `./install-pc-dependencies.sh`
2. `./build-pc.sh`
3. `./run-pc.sh`

### 诊断问题
1. `./check-environment.sh`

### 清理
1. `./clean.sh` - 清理构建文件
2. `./cleanup-devkitpro-apt.sh` - 完全移除 devkitPro APT 源

## 注意事项

- 所有 `.sh` 文件都是可执行的
- PGP 签名验证已被绕过（依赖包太旧，密钥已过期）
- PC 构建不支持 CBR/CBZ 格式
- MuPDF 编译需要 5-10 分钟
