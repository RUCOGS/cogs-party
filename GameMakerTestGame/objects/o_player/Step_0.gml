if (global.game_manager.state != GameState.InGame) {
	exit;
}

if (keyboard_check_pressed(ord(input_key)) or 
	(gamepad_id >= 0 and gamepad_button_check_pressed(gamepad_id, gp_face1))
) {
	points += 1
}