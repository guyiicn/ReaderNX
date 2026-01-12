# controller.c 修改记录

## 文件路径
`source/controller.c`

## 修改内容

### 1. 添加全局变量引用（第 7 行）

**新增代码：**
```c
extern PadState		g_pad;
```

### 2. 修改 check_hitbox 函数（第 9-19 行）

**旧代码：**
```c
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
```

**新代码：**
```c
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

**说明：**
- 参数类型 `touchPosition` → `TouchPoint`
- 字段名 `touch.px` → `touch.x`，`touch.py` → `touch.y`

### 3. 修改 button_touch 函数（第 21-52 行）

**旧代码：**
```c
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
```

**新代码：**
```c
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

**说明：**
- 参数类型改为 `TouchPoint`
- `hidScanInput()` → `padUpdate(&g_pad)`
- `hidTouchRead()` → `hidGetTouchScreenStates()`
- 使用新的触摸状态结构体 `HidTouchScreenState`
- 通过 `state.count` 和 `state.touches[0]` 获取触摸坐标

### 4. 修改 default_controller_layout 函数（第 54-66 行）

**旧代码：**
```c
controller->next_page = KEY_RSTICK_RIGHT;
controller->prev_page = KEY_RSTICK_LEFT;
controller->next_multiple_page = KEY_RSTICK_UP;
controller->prev_multiple_page = KEY_RSTICK_DOWN;
controller->quit = KEY_PLUS;
controller->launch_book = KEY_A;
controller->help = KEY_X;
controller->layout = KEY_ZR;
```

**新代码：**
```c
controller->next_page = HidNpadButton_StickRRight;
controller->prev_page = HidNpadButton_StickRLeft;
controller->next_multiple_page = HidNpadButton_StickRUp;
controller->prev_multiple_page = HidNpadButton_StickRDown;
controller->quit = HidNpadButton_Plus;
controller->launch_book = HidNpadButton_A;
controller->help = HidNpadButton_X;
controller->layout = HidNpadButton_ZR;
```

**说明：**
- 所有按键常量从 `KEY_*` 改为 `HidNpadButton_*`

### 5. 修改 touch_button 函数签名（第 68 行）

**旧代码：**
```c
bool	touch_button(touchPosition touch, int button_id)
```

**新代码：**
```c
bool	touch_button(TouchPoint touch, int button_id)
```
