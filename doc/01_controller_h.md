# controller.h 修改记录

## 文件路径
`include/controller.h`

## 修改内容

### 1. 新增类型定义和全局变量声明（第 4-11 行）

**新增代码：**
```c
// 触摸点结构体（替代旧版 touchPosition）
typedef struct {
	u32 x;
	u32 y;
} TouchPoint;

// 全局 PadState 声明
extern PadState g_pad;
```

**说明：**
- `TouchPoint` 替代旧版 libnx 的 `touchPosition` 类型
- `g_pad` 是新版 libnx Pad API 所需的全局状态变量

### 2. 修改函数签名（第 43-54 行）

**旧代码：**
```c
bool			touch_next_page_home(touchPosition touch);
bool			touch_prev_page_home(touchPosition touch);
bool			touch_launch_book_home(touchPosition touch);
bool			touch_exit_home(touchPosition touch);
bool			touch_next_page_read(touchPosition touch);
bool			touch_prev_page_read(touchPosition touch);
bool			touch_button(touchPosition touch, int button_id);
bool			button_touch(touchPosition touch, SDL_Rect rect);
```

**新代码：**
```c
bool			touch_next_page_home(TouchPoint touch);
bool			touch_prev_page_home(TouchPoint touch);
bool			touch_launch_book_home(TouchPoint touch);
bool			touch_exit_home(TouchPoint touch);
bool			touch_next_page_read(TouchPoint touch);
bool			touch_prev_page_read(TouchPoint touch);
bool			touch_button(TouchPoint touch, int button_id);
bool			button_touch(TouchPoint touch, SDL_Rect rect);
```

**说明：**
- 将所有 `touchPosition` 参数类型替换为 `TouchPoint`
