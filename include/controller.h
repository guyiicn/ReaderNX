#ifndef CONTROLLER_H
#define CONTROLLER_H

#ifdef __PC_BUILD__
// PC 构建的类型定义
typedef unsigned int u32;
typedef unsigned long long u64;
typedef long long s64;

typedef struct {
	int dummy;  // 占位成员
} PadState;

typedef struct {
	u32 x;
	u32 y;
} HidTouchState;

typedef struct {
	u32 count;  // 触摸点数量
	HidTouchState touches[16];  // 最多16个触摸点
} HidTouchScreenState;

// Switch 按钮常量定义（PC构建时用不到，定义为0）
#define HidNpadButton_A              (1ULL << 0)
#define HidNpadButton_X              (1ULL << 2)
#define HidNpadButton_Plus           (1ULL << 10)
#define HidNpadButton_ZR             (1ULL << 8)
#define HidNpadButton_StickRLeft     (1ULL << 20)
#define HidNpadButton_StickRRight    (1ULL << 21)
#define HidNpadButton_StickRUp       (1ULL << 22)
#define HidNpadButton_StickRDown     (1ULL << 23)

// PC 构建的空函数（内联避免链接错误）
static inline void padUpdate(PadState *pad) { (void)pad; }
static inline u64 padGetButtonsDown(PadState *pad) { (void)pad; return 0; }
static inline int appletMainLoop(void) { return 1; }  // 总是返回1保持循环
static inline void hidGetTouchScreenStates(HidTouchScreenState *state, int count) {
	(void)count;
	if (state) {
		state->count = 0;
		// 初始化触摸点数组
		for (int i = 0; i < 16; i++) {
			state->touches[i].x = 0;
			state->touches[i].y = 0;
		}
	}
}
#endif

// 触摸点结构体（替代旧版 touchPosition）
typedef struct {
	u32 x;
	u32 y;
} TouchPoint;

// 全局 PadState 声明
extern PadState g_pad;

typedef struct	s_controller
{
	// common
	int			next_page;
	int			prev_page;
	int			quit;

	// menu mode
	int			launch_book;
	int			help;

	// reading mode
	int			layout;
	int			next_multiple_page;
	int			prev_multiple_page;
}				t_controller;

enum button_id
{
	e_exit = 0,
	e_help = 1,
	e_cover = 2,
	e_bar = 3,
	e_rotate = 4,
	e_next_page = 5,
	e_prev_page = 6
};

void			default_controller_layout(void);

bool			touch_next_page_home(TouchPoint touch);
bool			touch_prev_page_home(TouchPoint touch);

bool			touch_launch_book_home(TouchPoint touch);

bool			touch_exit_home(TouchPoint touch);

bool			touch_next_page_read(TouchPoint touch);
bool			touch_prev_page_read(TouchPoint touch);

bool			touch_button(TouchPoint touch, int button_id);
bool			button_touch(TouchPoint touch, SDL_Rect rect);

#endif
