/// @desc

/// @param {Struct.PlayerData} _player_data
/// @param {Real} _player_count
// feather ignore GM2017
function _construct(_player_data, _player_count) {
	player_data = _player_data
	player_count = _player_count
	points = int64(0)
	input_key = ["Q", "R", "U", "P"][player_data.index]
	// feather ignore once GM1041
	gamepad_id = get_player_gamepad(player_data.number)
	var gap = 16;
	var xscale = 2.5;
	var yscale = 5.25;
	true_width = self.sprite_width * xscale;
	true_height = self.sprite_height * yscale;
	var separation = true_width + gap;
	self.x = room_width / 2 + separation * (player_data.index - player_count / 2);
	self.y = room_height / 2 - true_height * 0.3;
	self.image_xscale = xscale;
	self.image_yscale = yscale;
	// feather ignore once GM1041
	self.image_blend = hex_to_color(player_data.color)
}