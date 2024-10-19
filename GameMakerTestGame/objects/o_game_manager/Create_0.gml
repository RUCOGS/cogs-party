/// @description
// feather ignore GM2017

function _print(_message) {
	show_debug_message("[GameManager]: " + _message);
}

// Initialize minigame manager
init_minigame_manager("GameMaker Test Game");

_print("Got save: " + json_stringify(global.minigame_manager.save_data, true));

var _player_data_array = global.minigame_manager.player_data_array;
_print("Spawning players: " + json_stringify(_player_data_array, true));

var player_count = array_length(_player_data_array)
for (var i = 0; i < player_count; i++) {
	with (instance_create_layer(0, 0, "Instances", o_player)) { 
		self._construct(_player_data_array[i], player_count); 
	}
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

function end_game() {
	global.minigame_manager.end_game()
}