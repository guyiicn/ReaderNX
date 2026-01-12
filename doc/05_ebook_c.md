# ebook.c 修改记录

## 文件路径
`source/ebook.c`

## 修改内容

### 1. 添加全局变量引用（第 9 行）

**新增代码：**
```c
extern PadState		g_pad;
```

### 2. 修改 ebook_reader 函数中的输入处理（第 267-277 行）

**旧代码：**
```c
ebook->read_mode = true;
while (appletMainLoop()) {
    hidScanInput();

    u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
    touchPosition touch = {0};

    hidTouchRead(&touch, 0);

    if (kDown & controller->quit || (layout->show_bar == true && touch_button(touch, e_exit) == true)) {
```

**新代码：**
```c
ebook->read_mode = true;
while (appletMainLoop()) {
    padUpdate(&g_pad);

    u64 kDown = padGetButtonsDown(&g_pad);
    HidTouchScreenState touch_state = {0};
    hidGetTouchScreenStates(&touch_state, 1);
    TouchPoint touch = {0, 0};
    if (touch_state.count > 0) {
        touch.x = touch_state.touches[0].x;
        touch.y = touch_state.touches[0].y;
    }

    if (kDown & controller->quit || (layout->show_bar == true && touch_button(touch, e_exit) == true)) {
```

**说明：**
- `hidScanInput()` → `padUpdate(&g_pad)`
- `hidKeysDown(CONTROLLER_P1_AUTO)` → `padGetButtonsDown(&g_pad)`
- `touchPosition` → `TouchPoint` + `HidTouchScreenState`
- `hidTouchRead()` → `hidGetTouchScreenStates()`

### 3. 修改按键常量（第 289 行）

**旧代码：**
```c
} else if (kDown & KEY_A || (touch_button(touch, e_bar) == true)) {
```

**新代码：**
```c
} else if (kDown & HidNpadButton_A || (touch_button(touch, e_bar) == true)) {
```

**说明：**
- `KEY_A` → `HidNpadButton_A`
