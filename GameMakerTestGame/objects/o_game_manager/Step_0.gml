time_left -= delta_time / 1_000_000;
if (time_left < 0) {
	end_game();
}