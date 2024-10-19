/// @description
// feather ignore GM2017

function _print(_message) {
	show_debug_message("[GameManager]: " + _message);
}

// Initialize minigame manager
init_minigame_manager("GameMaker Test Game");

countdown_screen = instance_create_depth(0, 0, -100, o_countdown_screen, { time_left: 3 })
ingame_screen = instance_create_depth(0, 0, -10, o_ingame_screen, { time_left: 10 })
results_screen = instance_create_depth(0, 0, -100, o_results_screen, { time_left: 5 })
player_reward_points = [4, 3, 1]
global.game_manager = self

enum GameState {
	CountDown,
	InGame,
	ResultsScreen
}

state = GameState.CountDown
countdown_screen.start()

_print("Got save: " + json_stringify(global.minigame_manager.save_data, true));

// Spawn players
var _player_data_array = global.minigame_manager.player_data_array;
_print("Spawning players: " + json_stringify(_player_data_array, true));

var player_count = array_length(_player_data_array)
for (var i = 0; i < player_count; i++) {
	with (instance_create_layer(0, 0, "Instances", o_player)) { 
		self._construct(_player_data_array[i], player_count); 
	}
}