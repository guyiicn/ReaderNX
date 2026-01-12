# graphic.c 修改记录

## 文件路径
`source/graphic.c`

## 修改内容

### 1. 添加全局变量引用（第 8 行）

**新增代码：**
```c
extern PadState		g_pad;
```

### 2. 修改 draw_message_box 函数中的输入处理（第 536-546 行）

**旧代码：**
```c
while (appletMainLoop()) {
    hidScanInput();

    u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);

    if (kDown & KEY_PLUS) {
        break ;
    }

    SDL_RenderPresent(graphic->renderer);
}
```

**新代码：**
```c
while (appletMainLoop()) {
    padUpdate(&g_pad);

    u64 kDown = padGetButtonsDown(&g_pad);

    if (kDown & HidNpadButton_Plus) {
        break ;
    }

    SDL_RenderPresent(graphic->renderer);
}
```

**说明：**
- `hidScanInput()` → `padUpdate(&g_pad)`
- `hidKeysDown(CONTROLLER_P1_AUTO)` → `padGetButtonsDown(&g_pad)`
- `KEY_PLUS` → `HidNpadButton_Plus`

### 3. 修改 draw_error 函数中的输入处理（第 563-573 行）

**旧代码：**
```c
while (appletMainLoop()) {
    hidScanInput();

    u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);

    if (kDown & KEY_PLUS) {
        break ;
    }

    SDL_RenderPresent(graphic->renderer);
}
```

**新代码：**
```c
while (appletMainLoop()) {
    padUpdate(&g_pad);

    u64 kDown = padGetButtonsDown(&g_pad);

    if (kDown & HidNpadButton_Plus) {
        break ;
    }

    SDL_RenderPresent(graphic->renderer);
}
```

**说明：**
- 与 draw_message_box 相同的修改
