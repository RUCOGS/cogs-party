var cx = self.x + true_width / 2
var cy = self.y + true_height / 2 - 24

draw_sprite_stretched_ext(s_square_corner_32, 1, self.x, self.y, true_width, true_height, c_black, 0.25);
draw_set_font(f_urbanist_semibold_20);
draw_set_halign(fa_middle)
draw_set_valign(fa_middle)
draw_text(cx, cy - 64, string("Player {0}", player_data.number));

draw_set_font(f_urbanist_semibold_64);
var points_text = "X";
if (earned_points > 0) {
	points_text = string("+{0}", earned_points);
}
draw_text(cx, cy, string("{0}", points_text));

draw_set_font(f_urbanist_semibold_20);
draw_text(cx, cy + 64, string("{0}", player_data.points));

draw_self()