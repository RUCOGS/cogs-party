if (not active) {
	exit
}

draw_set_color(c_black)
draw_set_alpha(0.8)
draw_rectangle(0, 0, room_width, room_height, 0)

draw_set_color(c_white)
draw_set_alpha(1)
draw_set_font(f_urbanist_black_20);
draw_text_kern(room_width / 2, room_height * 0.35, "RESULTS", 16);