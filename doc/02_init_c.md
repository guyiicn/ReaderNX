# init.c 修改记录

## 文件路径
`source/init.c`

## 修改内容

### 1. 新增全局变量定义（第 10-11 行）

**新增代码：**
```c
// 全局 PadState 定义
PadState g_pad;
```

**说明：**
- 定义新版 libnx Pad API 所需的全局状态变量
- 对应 controller.h 中的 `extern PadState g_pad;` 声明

### 2. 在 init_all() 中添加输入系统初始化（第 47-50 行）

**新增代码：**
```c
// 初始化新版 libnx 输入系统
padConfigureInput(1, HidNpadStyleSet_NpadStandard);
padInitializeDefault(&g_pad);
hidInitializeTouchScreen();
```

**说明：**
- `padConfigureInput(1, HidNpadStyleSet_NpadStandard)` - 配置支持单玩家标准控制器
- `padInitializeDefault(&g_pad)` - 初始化默认手柄（包含掌机模式和 Player 1）
- `hidInitializeTouchScreen()` - 初始化触摸屏输入

**位置：**
- 在 `romfsInit()` 之后
- 在内存分配之前
