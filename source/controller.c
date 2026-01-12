#include "common.h"

extern t_controller	*controller;
extern t_ebook		*ebook;
extern t_graphic	*graphic;
extern t_layout		*layout;
extern PadState		g_pad;

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

bool	touch_button(TouchPoint touch, int button_id)
{
	if (button_id == e_exit && button_touch(touch, layout->exit_button) == true) {
		return (true);
	} else if (button_id == e_cover && button_touch(touch, layout->cover) == true) {
		return (true);
	} else if (button_id == e_help && button_touch(touch, layout->help_button) == true) {
		return (true);
	} else if (button_id == e_rotate && button_touch(touch, layout->rotate_button) == true) {
		return (true);
	} else if (button_id == e_bar && button_touch(touch, layout->bar.back_bar) == true) {
		return (true);
	} else if (button_id == e_next_page && button_touch(touch, layout->next_page_button) == true) {
		return (true);
	} else if (button_id == e_prev_page && button_touch(touch, layout->prev_page_button) == true) {
		return (true);
	}

	return (false);
}
