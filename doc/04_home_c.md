# home.c 修改记录

## 文件路径
`source/home.c`

## 修改内容

### 1. 添加全局变量引用（第 7 行）

**新增代码：**
```c
extern PadState		g_pad;
```

### 2. 修改 home_page 函数中的输入处理（第 132-142 行）

**旧代码：**
```c
while (appletMainLoop()) {
    hidScanInput();

    u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
    touchPosition touch = {0};

    hidTouchRead(&touch, 0);

    /*Draw the cover and book informations*/
    if (kDown & controller->quit || touch_button(touch, e_exit) == true) {
```

**新代码：**
```c
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

    /*Draw the cover and book informations*/
    if (kDown & controller->quit || touch_button(touch, e_exit) == true) {
```

**说明：**
- `hidScanInput()` → `padUpdate(&g_pad)`
- `hidKeysDown(CONTROLLER_P1_AUTO)` → `padGetButtonsDown(&g_pad)`
- `touchPosition` → `TouchPoint` + `HidTouchScreenState`
- `hidTouchRead()` → `hidGetTouchScreenStates()`

### 3. 修改触摸坐标重置（第 182-183 行）

**旧代码：**
```c
touch.px = 0;
touch.py = 0;
```

**新代码：**
```c
touch.x = 0;
touch.y = 0;
```
