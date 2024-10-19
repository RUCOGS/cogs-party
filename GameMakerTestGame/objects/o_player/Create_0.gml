/// @param {Struct.PlayerData} player_data
/// @param {Real} player_count
// feather ignore GM2017
function _construct(player_data, player_count) {
	var gap = 64;
	var xscale = 2;
	var yscale = 4;
	var true_width = self.sprite_width * xscale;
	var true_height = self.sprite_height * yscale;
	var separation = true_width + gap;
	self.x = room_width / 2 + separation * (player_data.index - player_count / 2);
	self.y = room_height / 2 - true_height * 0.25;
	self.image_xscale = xscale;
	self.image_yscale = yscale;
	self.image_blend = hex_to_color(player_data.color)
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