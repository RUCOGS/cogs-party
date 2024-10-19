if (not active) {
	exit
}

draw_set_color(c_black)
draw_set_alpha(0.8)
draw_rectangle(0, 0, room_width, room_height, 0)

draw_set_color(c_white)
draw_set_alpha(1)
draw_set_font(f_urbanist_medium_128);
draw_set_halign(fa_middle)
draw_set_valign(fa_middle)
draw_text(room_width / 2, room_height / 2, string(int64(ceil(time_left))))