var cx = self.x + true_width / 2
var cy = self.y + true_height * 0.175

draw_sprite_stretched_ext(s_square_corner_32, 1, self.x, self.y, true_width, true_height, c_black, 0.25);

draw_set_color(c_white)
draw_set_alpha(1)
draw_set_font(f_urbanist_semibold_20);
draw_set_halign(fa_middle)
draw_set_valign(fa_middle)
draw_text(cx, cy - 64, string("Player {0}", player_data.number));

draw_set_font(f_urbanist_semibold_64);
draw_text(cx, cy, string("{0}", points));

draw_set_font(f_urbanist_semibold_20);
draw_set_alpha(0.5)
draw_text(cx, cy + 64, string("Press {0}", input_key));
draw_set_alpha(1)

draw_self()
