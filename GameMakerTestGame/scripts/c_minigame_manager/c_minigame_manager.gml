// feather ignore GM2017

/// @description Initializes the minigame manager and returns it.
/// @param {String} _game_name Name of the minigame. 
/// @returns {Id.Instance<o_minigame_manager>} Initialized minigame manager.
function init_minigame_manager(_game_name) {
	return instance_create_depth(0, 0, 0, o_minigame_manager, {
		game_name: _game_name
	});
}

/// @description Information about a player
function PlayerData(_index, _points, _color) constructor {
	index = _index;
	number = _index + 1;
	points = _points;
	color = _color;
}

/// @description A player's result from a minigame
/// @param {Real} _player Index of the player
/// @param {Real} _points Amount of points earned
function PlayerResult(_player, _points) constructor {
	player = int64(_player);
	points = int64(_points);
}

/// @description The result from playing a minigame
/// @param {String} _name Name of the minigame
/// @param {Array<Struct.PlayerResult>} _results Array of PlayerResults 
function GameResult(_name, _results) constructor {
	name = _name;
	results = _results;
}

/// @description Save data for a player
/// @param {String} _color Hexadecimal color
/// @param {Real} _points Points earned 
function PlayerSaveData(_color, _points) constructor {
	color = _color;
	points = _points;
}

/// @description Save data of the current run
/// @param {Array<Struct.PlayerSaveData>} _players Aray of PlayerSaveData
/// @param {Array<Struct.GameResult>} _games Array of GameResults
function SaveData(_players, _games) constructor {
	players = _players;
	games = _games;
}