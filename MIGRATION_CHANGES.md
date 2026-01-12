# libnx API 迁移 - 详细修改清单

## 1. include/controller.h

### 1.1 添加头部声明（第 3 行后）
```c
// 新增：触摸点结构体（替代 touchPosition）
typedef struct {
    u32 x;
    u32 y;
} TouchPoint;

// 新增：全局 PadState 声明
extern PadState g_pad;
```

### 1.2 修改函数签名（第 34-45 行）
```c
// 旧代码
bool			touch_next_page_home(touchPosition touch);
bool			touch_prev_page_home(touchPosition touch);
bool			touch_launch_book_home(touchPosition touch);
bool			touch_exit_home(touchPosition touch);
bool			touch_next_page_read(touchPosition touch);
bool			touch_prev_page_read(touchPosition touch);
bool			touch_button(touchPosition touch, int button_id);
bool			button_touch(touchPosition touch, SDL_Rect rect);

// 新代码
bool			touch_next_page_home(TouchPoint touch);
bool			touch_prev_page_home(TouchPoint touch);
bool			touch_launch_book_home(TouchPoint touch);
bool			touch_exit_home(TouchPoint touch);
bool			touch_next_page_read(TouchPoint touch);
bool			touch_prev_page_read(TouchPoint touch);
bool			touch_button(TouchPoint touch, int button_id);
bool			button_touch(TouchPoint touch, SDL_Rect rect);
```

---

## 2. source/init.c

### 2.1 添加全局变量定义（第 8 行后）
```c
// 新增
PadState g_pad;
```

### 2.2 在 init_all() 函数中添加初始化（第 42 行后，romfsInit 之后）
```c
// 新增：初始化输入系统
padConfigureInput(1, HidNpadStyleSet_NpadStandard);
padInitializeDefault(&g_pad);
hidInitializeTouchScreen();
```

---

## 3. source/controller.c

### 3.1 添加全局变量引用（第 6 行后）
```c
// 新增
extern PadState g_pad;
```

### 3.2 修改 check_hitbox 函数（第 8-18 行）
```c
// 旧代码
static bool	check_hitbox(touchPosition touch, SDL_Rect button)
{
	if (touch.px >= (u32)button.x &&
		touch.py >= (u32)button.y &&
		touch.px <= (u32)(button.x + button.w) &&
		touch.py <= (u32)(button.y + button.h)) {
		return (true);
	}
	return (false);
}

// 新代码
static bool	check_hitbox(TouchPoint touch, SDL_Rect button)
{
	if (touch.x >= (u32)button.x &&
		touch.y >= (u32)button.y &&
		touch.x <= (u32)(button.x + button.w) &&
		touch.y <= (u32)(button.y + button.h)) {
		return (true);
	}
	return (false);
}
```

### 3.3 修改 button_touch 函数（第 20-49 行）
```c
// 旧代码
bool	button_touch(touchPosition touch, SDL_Rect rect)
{
	touchPosition			released = {0};
	static touchPosition	released_save = {0};

	if (touch.px == 0 || touch.py == 0) {
		return (false);
	}

	while (true) {
		hidScanInput();
		hidTouchRead(&released, 0);

		// check if button is pressed and released not outside de hitbox
		if (released.px == 0 && released.py == 0) {
			if (check_hitbox(touch, rect) == true && check_hitbox(released_save, rect) == true) {
				return (true);
			}
		}

		if (released.px != 0 && released.py != 0) {
			memcpy(&released_save, &released, sizeof(touchPosition));
		}
		if (released.px == 0 && released.py == 0) {
			break ;
		}
	}

	return (false);
}

// 新代码
bool	button_touch(TouchPoint touch, SDL_Rect rect)
{
	HidTouchScreenState		state = {0};
	static TouchPoint		released_save = {0};

	if (touch.x == 0 || touch.y == 0) {
		return (false);
	}

	while (true) {
		padUpdate(&g_pad);
		hidGetTouchScreenStates(&state, 1);

		TouchPoint current = {0, 0};
		if (state.count > 0) {
			current.x = state.touches[0].x;
			current.y = state.touches[0].y;
		}

		// check if button is pressed and released not outside the hitbox
		if (current.x == 0 && current.y == 0) {
			if (check_hitbox(touch, rect) == true && check_hitbox(released_save, rect) == true) {
				return (true);
			}
			break;
		}

		released_save = current;
	}

	return (false);
}
```

### 3.4 修改 default_controller_layout 函数（第 51-63 行）
```c
// 旧代码
void	default_controller_layout(void)
{
	controller->next_page = KEY_RSTICK_RIGHT;
	controller->prev_page = KEY_RSTICK_LEFT;

	controller->next_multiple_page = KEY_RSTICK_UP;
	controller->prev_multiple_page = KEY_RSTICK_DOWN;

	controller->quit = KEY_PLUS;
	controller->launch_book = KEY_A;
	controller->help = KEY_X;
	controller->layout = KEY_ZR;
}

// 新代码
void	default_controller_layout(void)
{
	controller->next_page = HidNpadButton_StickRRight;
	controller->prev_page = HidNpadButton_StickRLeft;

	controller->next_multiple_page = HidNpadButton_StickRUp;
	controller->prev_multiple_page = HidNpadButton_StickRDown;

	controller->quit = HidNpadButton_Plus;
	controller->launch_book = HidNpadButton_A;
	controller->help = HidNpadButton_X;
	controller->layout = HidNpadButton_ZR;
}
```

### 3.5 修改 touch_button 函数签名（第 65 行）
```c
// 旧代码
bool	touch_button(touchPosition touch, int button_id)

// 新代码
bool	touch_button(TouchPoint touch, int button_id)
```

---

## 4. source/home.c

### 4.1 添加全局变量引用（第 6 行后）
```c
// 新增
extern PadState g_pad;
```

### 4.2 修改 home_page 函数中的输入处理（第 131-137 行）
```c
// 旧代码
while (appletMainLoop()) {
    hidScanInput();

    u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
    touchPosition touch = {0};

    hidTouchRead(&touch, 0);

// 新代码
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
```

---

## 5. source/ebook.c

### 5.1 添加全局变量引用（第 8 行后）
```c
// 新增
extern PadState g_pad;
```

### 5.2 修改 ebook_reader 函数中的输入处理（第 266-272 行）
```c
// 旧代码
while (appletMainLoop()) {
    hidScanInput();

    u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);
    touchPosition touch = {0};

    hidTouchRead(&touch, 0);

// 新代码
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
```

### 5.3 修改按键常量（第 284 行）
```c
// 旧代码
} else if (kDown & KEY_A || (touch_button(touch, e_bar) == true)) {

// 新代码
} else if (kDown & HidNpadButton_A || (touch_button(touch, e_bar) == true)) {
```

---

## 6. source/graphic.c

### 6.1 添加全局变量引用（文件头部）
```c
// 新增
extern PadState g_pad;
```

### 6.2 修改 draw_message_box 函数（第 535-545 行）
```c
// 旧代码
while (appletMainLoop()) {
    hidScanInput();

    u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);

    if (kDown & KEY_PLUS) {
        break ;
    }

    SDL_RenderPresent(graphic->renderer);
}

// 新代码
while (appletMainLoop()) {
    padUpdate(&g_pad);

    u64 kDown = padGetButtonsDown(&g_pad);

    if (kDown & HidNpadButton_Plus) {
        break ;
    }

    SDL_RenderPresent(graphic->renderer);
}
```

### 6.3 修改 draw_error 函数（第 562-572 行）
```c
// 旧代码
while (appletMainLoop()) {
    hidScanInput();

    u64 kDown = hidKeysDown(CONTROLLER_P1_AUTO);

    if (kDown & KEY_PLUS) {
        break ;
    }

    SDL_RenderPresent(graphic->renderer);
}

// 新代码
while (appletMainLoop()) {
    padUpdate(&g_pad);

    u64 kDown = padGetButtonsDown(&g_pad);

    if (kDown & HidNpadButton_Plus) {
        break ;
    }

    SDL_RenderPresent(graphic->renderer);
}
```

---

## 修改统计

| 文件 | 修改处数 | 类型 |
|------|----------|------|
| include/controller.h | 9 | 类型定义 + 函数签名 |
| source/init.c | 2 | 全局变量 + 初始化调用 |
| source/controller.c | 5 | 函数重写 + 常量替换 |
| source/home.c | 2 | 输入循环 |
| source/ebook.c | 3 | 输入循环 + 常量 |
| source/graphic.c | 3 | 输入循环 x2 |
| **总计** | **24** | |

---

## 按键常量对照表

| 旧常量 | 新常量 |
|--------|--------|
| `KEY_RSTICK_RIGHT` | `HidNpadButton_StickRRight` |
| `KEY_RSTICK_LEFT` | `HidNpadButton_StickRLeft` |
| `KEY_RSTICK_UP` | `HidNpadButton_StickRUp` |
| `KEY_RSTICK_DOWN` | `HidNpadButton_StickRDown` |
| `KEY_PLUS` | `HidNpadButton_Plus` |
| `KEY_A` | `HidNpadButton_A` |
| `KEY_X` | `HidNpadButton_X` |
| `KEY_ZR` | `HidNpadButton_ZR` |

## 类型对照表

| 旧类型/字段 | 新类型/字段 |
|-------------|-------------|
| `touchPosition` | `TouchPoint` (自定义) 或 `HidTouchScreenState` |
| `touch.px` | `touch.x` |
| `touch.py` | `touch.y` |
| `CONTROLLER_P1_AUTO` | (不再需要，使用 PadState) |
