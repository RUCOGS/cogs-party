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
	var yscale = 5;
	true_width = self.sprite_width * xscale;
	true_height = self.sprite_height * yscale;
	var separation = true_width + gap;
	self.x = room_width / 2 + separation * (player_data.index - player_count / 2);
	self.y = room_height / 2 - true_height * 0.25;
	self.image_xscale = xscale;
	self.image_yscale = yscale;
	// feather ignore once GM1041
	self.image_blend = hex_to_color(player_data.color)
}

/// @desc Fetches the gamepad device ID for a given player
/// @param {Real} Player's number
function get_player_gamepad(_number) {
	var gamepads = get_gamepads();
	if (array_length(gamepads) >= _number) {
		return gamepads[_number - 1];
	}
	return -1;
}

/// @desc Fetches the Device IDs of connected gamepads
/// @return {Array<Real>} Device IDs of connected gamepads
function get_gamepads() {
	var _maxpads = gamepad_get_device_count();
	var _connected_gamepads = []
	for (var i = 0; i < _maxpads; i++) {
	    if (gamepad_is_connected(i)) {
	        array_push(_connected_gamepads, i)
	    }
	}
	return _connected_gamepads
}

/// @desc   Returns an integer converted from an hexadecimal string.
/// @param  {string}    hex         hexadecimal digits
/// @return {real}      positive integer
function hex_to_dec(hex) 
{
    var dig = "0123456789ABCDEF";
    var dec = 0;
	var base = 1;
	hex = string_upper(hex)  
	var len = string_length(hex);
    for (var i = len; i >= 1; i--) {
		dec += (string_pos(string_char_at(hex, i), dig) - 1) * base;
		base = base << 4 // same as base *= 16
    }

    return dec;
}

/// @param {String} Hexadecimal color
function hex_to_color(hex)
{
	hex = string_replace(hex, "#", "")
    var dec = hex_to_dec(hex);
    return make_color_rgb((dec >> 16) & 0xFF, (dec >> 8) & 0xFF, dec & 0xFF);
} 