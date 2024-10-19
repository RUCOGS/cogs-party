draw_set_font(f_urbanist_black);
draw_text_kern(room_width / 2, room_height * 0.1, "GAMEMAKER TEST GAME", 32);

draw_set_font(f_urbanist_medium);
draw_text_kern(room_width / 2, room_height * 0.1 + 100, string_format(time_left, 2, 2), 32);
