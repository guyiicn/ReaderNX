#ifndef CONTROLLER_H
#define CONTROLLER_H

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
