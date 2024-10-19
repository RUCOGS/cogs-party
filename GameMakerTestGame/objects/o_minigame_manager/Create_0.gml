/// @description

// feather ignore GM2017

/// @description Prints a message as the minigame manager
/// @param {Any} _message 
function _print(_message) {
	show_debug_message("[MinigameManager]: " + _message);
}

/// @description Returns dummy save file data
/// @returns {Struct.SaveData} Dummy save data 
function dummy_save_data() {
	// feather disable once GM1045
	return {
		players: [
			{
				color: "#a83232",
				points: int64(0),
			},
			{
				color: "#63a832",
				points: int64(0),
			},
			{
				color: "#327ba8",
				points: int64(2),
			},
			{
				color: "#7932a8",
				points: int64(0),
			},
		],
		games: [
			{
				name: "Test Game",
				results: [
					{
						player: int64(0),
						points: int64(1)
					},
					{
						player: int64(1),
						points: int64(3)
					},
				]
			},
			{
				name: "Other Game",
				results: [
					{
						player: int64(2),
						points: int64(1)
					},
				]
			},
		]
	};
}

/// Struct represented JSON save data
save_data = dummy_save_data()
/// Array of player data
player_data_array = [];
/// Path to save file
save_file_path = ""

/// @description Ends the game with some results.
/// @param {Array<Struct.PlayerResult>} _results Optional array of PlayerResult 
function end_game(_results = noone) {
	if(_results != noone) {
		apply_results(_results);
	}
	game_end();
}

/// @description Saves results to the launcher.
/// @param {Array<Struct.PlayerResult>} _results Array of PlayerResult
function apply_results(_results) {
	try {
		// Apply results to player save data
		for (var i = 0; i < array_length(_results); i++) {
			var player_result = _results[i];
			save_data.players[player_result.player].points += player_result.points;
		}
		// Add result to save_data games
		var game_result = {
			name: game_name,
			results: _results
		};
		array_push(save_data.games, game_result);
		if (save_file_path != "") {
			var file = file_text_open_write(save_file_path);
			file_text_write_string(file, json_stringify(save_data, true));
			file_text_close(file);
			_print("Saved to file");
		} else {
			_print("Using dummy data, not saving");
		}
	} catch (_exception) {
		_print("Error applying results, is results in correct format?\n" + json_stringify(_results, true));
	}
}

var _init = function() {
	// Parse cmd paramters for save file path
	var p_num = parameter_count();
	var file_path = "";
	if (p_num > 0)
	{
		for (var i = 0; i < p_num; i += 1)
		{
			var p_string = parameter_string(i + 1);
			if (string_starts_with(p_string, "--savefile=")) {
				file_path = string_split(p_string, "=")[1];
			}
		}
	}

	// Update save_data and save_file_path
	save_data = dummy_save_data();
	save_file_path = "";
	try {
		if (file_path != "") {
			// String exists
			var file = file_text_open_read(file_path);
			var load_data = file_text_read_string(file);
			file_text_close(file);
			save_file_path = file_path;
			save_data = json_parse(load_data);
			_print("Loaded save file data");
		} else {
			_print("Loaded dummy data");
		}
	} catch(_exception)
	{
		_print("Error reading savefile:")
		show_debug_message(_exception.message);
		show_debug_message(_exception.longMessage); 
		show_debug_message(_exception.script);
		show_debug_message(_exception.stacktrace);
		game_end();
	}

	// Set player_data_array14qrup
	player_data_array = [];
	var save_data_players = save_data.players;
	for (var i = int64(0); i < array_length(save_data_players); i++) {
		var save_player = save_data_players[i];
		player_data_array[i] = {
			index: i,
			number: i + 1,
			points: save_player.points,
			color: save_player.color
		};
	}

	// Fullscreen + debug print
	_print("Using save_data:\n" + json_stringify(save_data, true))
	window_set_fullscreen(true);
	_print("Initialized");
}
_init();

global.minigame_manager = self