/// @description

function start() {
	active = true
	
	show_debug_message("ending with save data: {0}", json_stringify(global.minigame_manager.save_data, true));
	
	// Get the latest game result's player results
	var player_results = array_last(global.minigame_manager.save_data.games).results;
	var player_data_array= global.minigame_manager.player_data_array;
	// Maps player index to the points they earned
	var player_to_points_map = {}
	for (var i = 0; i < array_length(player_results); i++) {
		variable_struct_set(player_to_points_map, player_results[i].player, player_results[i].points)
	}
	
	var player_count = array_length(player_data_array);
	for (var i = 0; i < player_count; i++) {
		var player_data = player_data_array[i];
		var earned_points = 0;
		if (variable_struct_exists(player_to_points_map, player_data.index)) {
			earned_points = variable_struct_get(player_to_points_map, player_data.index);
		}
		with (instance_create_depth(0, 0, -200, o_player_result)) {
			self._construct(player_data, earned_points, player_count);
		}
	}
}

active = false