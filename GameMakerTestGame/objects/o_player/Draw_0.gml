var cx = self.x + true_width / 2
var cy = self.y + true_height * 0.175

draw_set_font(f_urbanist_semibold_24);
draw_set_halign(fa_middle)
draw_set_valign(fa_middle)
draw_text(cx, cy - 64, string("Player {0}", player_data.number));

draw_set_font(f_urbanist_semibold_42);
draw_text(cx, cy, string("{0}", points));

draw_set_font(f_urbanist_semibold_24);
var c = c_white
draw_text_color(cx, cy + 64, string("Press {0}", input_key),c,c,c,c,0.25);

draw_self()
