/// @desc

/// @param {Struct.PlayerData} _player_data
/// @param {Real} _earned_points
// feather ignore GM2017
function _construct(_player_data, _earned_points, _player_count) {
	player_data = _player_data
	earned_points = _earned_points
	player_count = _player_count
	
	var gap = 16;
	var xscale = 1.75;
	var yscale = 2.25;
	true_width = self.sprite_width * xscale;
	true_height = self.sprite_height * yscale;
	var separation = true_width + gap;
	self.x = room_width / 2 + separation * (player_data.index - player_count / 2);
	self.y = room_height / 2 - true_height * 0.4;
	self.image_xscale = xscale;
	self.image_yscale = yscale;
	// feather ignore once GM1041
	self.image_blend = hex_to_color(player_data.color)
}