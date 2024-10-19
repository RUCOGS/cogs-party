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

///@func draw_text_kern(tx, ty, text, kern)
///@param {Real} tx The X position to draw at
///@param {Real} ty The Y position to draw at
///@param {String} text The text to draw
///@param {Real} kern The amount to track (positive) or kern (negative)
///@desc Draw a string with kerning.
function draw_text_kern(tx, ty, text, kern, centered = true) {
    var n = string_length(text);
    if (centered) {
		tx -= (string_width(text) + (n - 1) * kern) / 2;
	}
	
	var tox = tx;
    var lh = string_height("|");
    for (var i = 1 ; i <= n; i++) {
        var ch = string_char_at(text, i);
        if (ch == "\n") {
            ty += lh;
            tx = tox;
        } else {
            draw_text(tx, ty, ch);
            tx += string_width(ch)+kern;
        }
    }
}