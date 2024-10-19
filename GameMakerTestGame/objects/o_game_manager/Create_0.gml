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
	with (instance_create_depth(0, 0, 0, o_player)) { 
		self._construct(_player_data_array[i], player_count); 
	}
}