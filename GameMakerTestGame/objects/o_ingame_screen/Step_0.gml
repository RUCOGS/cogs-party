if (not active) {
	exit;
}

if (time_left > 0) {
	time_left -= delta_time / 1_000_000;
	if (time_left <= 0) {
		time_left = 0;
	}
} else {
	active = false;
}