# libnx API 迁移计划

## 概述

将代码从 libnx 旧版 HID API 迁移到 v4.0.0+ 新 API。

## 迁移映射表

### 按键常量映射

| 旧常量 | 新常量 | 使用位置 |
|--------|--------|----------|
| `KEY_RSTICK_RIGHT` | `HidNpadButton_StickRRight` | controller.c:53 |
| `KEY_RSTICK_LEFT` | `HidNpadButton_StickRLeft` | controller.c:54 |
| `KEY_RSTICK_UP` | `HidNpadButton_StickRUp` | controller.c:56 |
| `KEY_RSTICK_DOWN` | `HidNpadButton_StickRDown` | controller.c:57 |
| `KEY_PLUS` | `HidNpadButton_Plus` | controller.c:59, graphic.c:540,567 |
| `KEY_A` | `HidNpadButton_A` | controller.c:60, ebook.c:284 |
| `KEY_X` | `HidNpadButton_X` | controller.c:61 |
| `KEY_ZR` | `HidNpadButton_ZR` | controller.c:62 |

### 函数映射

| 旧 API | 新 API |
|--------|--------|
| `hidScanInput()` | `padUpdate(&pad)` |
| `hidKeysDown(CONTROLLER_P1_AUTO)` | `padGetButtonsDown(&pad)` |
| `hidTouchRead(&touch, 0)` | `hidGetTouchScreenStates(&state, 1)` |

### 类型映射

| 旧类型 | 新类型 |
|--------|--------|
| `touchPosition` | `HidTouchScreenState` |
| `touch.px` | `state.touches[0].x` |
| `touch.py` | `state.touches[0].y` |

---

## 修改步骤

### 阶段 1: 全局状态与初始化

#### 1.1 修改 `include/common.h`
- 添加 `#include <switch/runtime/pad.h>`（如果需要单独引入）

#### 1.2 修改 `include/controller.h`
- 添加新的全局 PadState 声明
- 将所有 `touchPosition` 参数改为新的触摸类型

```c
// 新增
extern PadState g_pad;

// 触摸相关函数签名更新
typedef struct {
    u32 x;
    u32 y;
} TouchPoint;

bool touch_button(TouchPoint touch, int button_id);
bool button_touch(TouchPoint touch, SDL_Rect rect);
// ... 其他触摸函数
```

#### 1.3 修改 `source/init.c`
在 `init_all()` 中添加新的初始化代码：

```c
// 在 romfsInit() 之后添加
padConfigureInput(1, HidNpadStyleSet_NpadStandard);
padInitializeDefault(&g_pad);
hidInitializeTouchScreen();
```

---

### 阶段 2: 控制器输入迁移

#### 2.1 修改 `source/controller.c`

**default_controller_layout() 函数：**
```c
// 旧
controller->next_page = KEY_RSTICK_RIGHT;
controller->prev_page = KEY_RSTICK_LEFT;
controller->next_multiple_page = KEY_RSTICK_UP;
controller->prev_multiple_page = KEY_RSTICK_DOWN;
controller->quit = KEY_PLUS;
controller->launch_book = KEY_A;
controller->help = KEY_X;
controller->layout = KEY_ZR;

// 新
controller->next_page = HidNpadButton_StickRRight;
controller->prev_page = HidNpadButton_StickRLeft;
controller->next_multiple_page = HidNpadButton_StickRUp;
controller->prev_multiple_page = HidNpadButton_StickRDown;
controller->quit = HidNpadButton_Plus;
controller->launch_book = HidNpadButton_A;
controller->help = HidNpadButton_X;
controller->layout = HidNpadButton_ZR;
```

---

### 阶段 3: 主循环迁移

#### 3.1 修改 `source/home.c` (home_page 函数)

```c
// 旧代码
hidScanInput();
u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
touchPosition touch = {0};
hidTouchRead(&touch, 0);

// 新代码
padUpdate(&g_pad);
u64 kDown = padGetButtonsDown(&g_pad);
HidTouchScreenState touch_state = {0};
hidGetTouchScreenStates(&touch_state, 1);
TouchPoint touch = {0, 0};
if (touch_state.count > 0) {
    touch.x = touch_state.touches[0].x;
    touch.y = touch_state.touches[0].y;
}
```

#### 3.2 修改 `source/ebook.c` (ebook_reader 函数)
同 home.c 的模式

#### 3.3 修改 `source/graphic.c` (draw_message_box, draw_error 函数)

```c
// 旧代码
hidScanInput();
u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
if (kDown & KEY_PLUS) {

// 新代码
padUpdate(&g_pad);
u64 kDown = padGetButtonsDown(&g_pad);
if (kDown & HidNpadButton_Plus) {
```

---

### 阶段 4: 触摸处理迁移

#### 4.1 修改 `source/controller.c`

**check_hitbox 函数：**
```c
// 旧
static bool check_hitbox(touchPosition touch, SDL_Rect button)
{
    if (touch.px >= (u32)button.x && ...)

// 新
static bool check_hitbox(TouchPoint touch, SDL_Rect button)
{
    if (touch.x >= (u32)button.x && ...)
```

**button_touch 函数（需要重写）：**
```c
bool button_touch(TouchPoint touch, SDL_Rect rect)
{
    HidTouchScreenState released = {0};
    static TouchPoint released_save = {0, 0};

    if (touch.x == 0 || touch.y == 0) {
        return false;
    }

    while (true) {
        padUpdate(&g_pad);
        hidGetTouchScreenStates(&released, 1);

        TouchPoint current = {0, 0};
        if (released.count > 0) {
            current.x = released.touches[0].x;
            current.y = released.touches[0].y;
        }

        // check if button is pressed and released not outside the hitbox
        if (current.x == 0 && current.y == 0) {
            if (check_hitbox(touch, rect) && check_hitbox(released_save, rect)) {
                return true;
            }
            break;
        }

        released_save = current;
    }

    return false;
}
```

---

## 文件修改清单

| 文件 | 修改类型 | 优先级 |
|------|----------|--------|
| `include/controller.h` | 类型定义 + 函数签名 | 1 |
| `source/init.c` | 添加初始化代码 | 2 |
| `source/controller.c` | 按键常量 + 触摸逻辑 | 3 |
| `source/home.c` | 主循环输入处理 | 4 |
| `source/ebook.c` | 阅读循环输入处理 | 5 |
| `source/graphic.c` | 消息框输入处理 | 6 |

---

## 测试计划

1. 编译通过
2. 按键输入测试（Plus 退出、A 选择、方向键导航）
3. 触摸屏测试（选书、翻页、按钮）
4. 横竖屏切换测试
5. 完整阅读流程测试

---

## 风险与注意事项

1. **触摸坐标类型变化**：旧 API 使用 `u32 px/py`，新 API 使用 `s32 x/y`，需注意类型转换
2. **全局 PadState**：需要确保在所有使用输入的地方都能访问到
3. **触摸释放检测逻辑**：`button_touch()` 的等待释放逻辑可能需要调整
