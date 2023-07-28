extends Node
class_name GameLibrary


signal game_started(game: Dictionary)
signal game_ended(results)


const GAME_FILE_NAME = "game.json"
const SAVE_FILE_PATH = "user://save.json"

var games: Array[Dictionary]
var platform: String
var running_game_thread: Thread
var game_thread_poll_interval: float = 1
var game_thread_poll_time: float = 0
var save_data = null


func _ready():
	match OS.get_name():
		"Windows", "UWP":
			platform = "windows"
		"macOS":
			platform = "macos"
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			platform = "linux"
		_:
			platform = "unsupported"


func _process(delta):
	if running_game_thread == null:
		return
	game_thread_poll_time += delta
	if game_thread_poll_time >= game_thread_poll_interval:
		game_thread_poll_time = 0
		if not running_game_thread.is_alive():
			var code = running_game_thread.wait_to_finish()
			if code != 0:
				push_error("Game exited with unxpected code: %d." % code)
			var old_data = save_data
			reread_save_file()
			running_game_thread = null
			
			var latest_result = null
			# Make sure a new game result has been added before 
			# attempted to emit the last result
			if old_data.games.size() < save_data.games.size():
				var games: Array = save_data.games
				latest_result = games[games.size() - 1];
			game_ended.emit(latest_result)


func _exit_tree():
	if running_game_thread != null:
		running_game_thread.wait_to_finish()


func load_games(path: String):
	games.clear()
	
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not open directory '%s'." % dir)
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			var game_directory_path = path + "/" + file_name
			var game_file_path = game_directory_path + "/" + GAME_FILE_NAME
			var game_file = FileAccess.open(game_file_path, FileAccess.READ)
			if game_file:
				var res = JSON.parse_string(game_file.get_as_text())
				game_file.close()
				if res:
					res.directory_path = game_directory_path
					res.enabled = true
					res.errors = false
					games.append(res)
				else:
					push_error("Failed to parse game file at `%s`." % game_file_path)
			else:
				push_error("Could not read game file at path '%s'." % game_file_path)
		file_name = dir.get_next()
	
	print("Loaded games:\n%s" % JSON.stringify(games))


## Returns the playable games for a given `player_count`
##
## If `player_count` is not provided, then it defaults to the player count specified
## in teh currenrt save_data.
func get_playable_games(player_count: int = save_data.players.size()) -> Array[Dictionary]:
	var playable_games: Array[Dictionary] = []
	for game in games:
		if not game.errors and platform in game.builds and player_count >= game.min_players and player_count <= game.max_players:
			playable_games.append(game)
	return playable_games


func get_enabled_playable_games(player_count: int = save_data.players.size()) -> Array[Dictionary]:
	var playable_games: Array[Dictionary] = []
	for game in get_playable_games(player_count):
		if game.enabled:
			playable_games.append(game)
	return playable_games


## Returns a random enabled and playable game (represented as a Dictionary).
##
## if there are no games, then returns `null`.
func get_random_enabled_playable_game():
	var playable_games = get_enabled_playable_games()
	if playable_games.size() == 0:
		return null
	return playable_games[randi() % playable_games.size()]


func reread_save_file():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if save_file:
		var data = JSON.parse_string(save_file.get_as_text())
		if data:
			save_data = data
		else:
			push_error("Could not parse save file json.")
	else:
		push_error("Could not read save file at '%s'." % SAVE_FILE_PATH)


func new_save_file(players: Array[Dictionary]):
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file:
		save_data = {
			"players": players,
			"games": []
		}
		save_file.store_string(JSON.stringify(save_data, "  "))
		save_file.close()
	else:
		push_error("Could not create save file at '%s'." % SAVE_FILE_PATH)


func launch_game(game: Dictionary):
	if running_game_thread != null:
		push_error("Cannot launch game when a game is already running")
		return
	
	if not game.enabled:
		push_error("Cannot play disabled game:\n%s" % JSON.stringify(game, "  "))
		return
	if not (platform in game.builds):
		push_error("Game does not support our platform of '%s'." % platform)
		return
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		push_error("Save file does not exist, cannot start game.")
		return
	var game_executable_path = game.directory_path + "/" + game.builds[platform]
	var absolute_save_file_path = ProjectSettings.globalize_path(SAVE_FILE_PATH)
	
	running_game_thread = Thread.new()
	var err = running_game_thread.start(_run_game_executable.bind(game_executable_path, absolute_save_file_path))
	if err != OK:
		push_error("Could not start game monitoring thread.")
		return
	game_started.emit(game)

func _run_game_executable(executable_path: String, save_file_path: String) -> int:
	return OS.execute(executable_path, ["--savefile=" + save_file_path])
