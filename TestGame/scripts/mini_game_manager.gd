extends Node
class_name MiniGameManager
## MiniGameManager is the main script that handles starting and ending a minigame.
##
## There are various signals you can connect to
## to detect when the game starts and ends.


signal game_started(player_data)
signal game_ended()


## Fake save data.
## 
## This is automatically loaded if no save_file_path is
## provided to this game through the command line.
const DUMMY_SAVE_DATA: Dictionary = {
	"players": [
		{
			"color": "#a83232",
			"points": 0,
		},
		{
			"color": "#63a832",
			"points": 0,
		},
		{
			"color": "#327ba8",
			"points": 2,
		},
		{
			"color": "#7932a8",
			"points": 0,
		},
	],
	"games": [
		{
			"name": "Test Game",
			"results": [
				{
					"player": 0,
					"points": 1
				},
				{
					"player": 1,
					"points": 3
				},
			]
		},
		{
			"name": "Other Game",
			"results": [
				{
					"player": 2,
					"points": 1
				},
			]
		},
	]
}


## The path of the save file.
var save_file_path: String = ""
## The data of the asve file
var save_file_data: Dictionary = {}

## Our minigame's name
@export var game_name: String = "Test Game"
@export var min_player_count: int = 2
@export var max_player_count: int = 4


## Holds information about a player 
class PlayerData:
	## Player's number
	var number: int
	## Player's color
	var color: String
	## Player's Current points
	var points: int
	
	func _init(_number: int, _color: String, _points: int):
		number = _number
		color = _color
		points = _points


## Holds information about the result of a match for a player
class PlayerResultData:
	## Player's number
	var player: int
	## The points a player has earned/lost
	var points: int
	
	func _init(_player: int, _points: int):
		player = _player
		points = _points
	
	func to_dict() -> Dictionary:
		return {
			"player": player - 1,
			"points": points
		}


# Returns an array of PlayerData
func get_players() -> Array:
	var players = [];
	var i = 1
	for dict in save_file_data["players"]:
		players.append(PlayerData.new(i, dict.color, dict.points))
		i += 1
	return players


## Ends the game with some results 
## 
## `results` is an array that stores an array of PlayerResultData.
## Each dictionary holds a player number, and the points they've 
## earned from this minigame. An example is shown below:
## 
## [
## 	  {
## 	  	  "player": 1,
## 	  	  "points": 1
## 	  },
## 	  {
## 	  	  "player": 1,
## 	  	  "points": 3
## 	  },
## ]
func end_game(results: Array):
	var final_results = []
	for result in results:
		if result is PlayerResultData:
			final_results.append(result.to_dict())
		else:
			final_results.append(result)
	
	save_file_data["games"].append({
		"name": game_name,
		"results": final_results
	})
	
	for result in final_results:
		save_file_data["players"][result.player].points += result.points
	
	if save_file_path != "":
		var file = FileAccess.open(save_file_path, FileAccess.WRITE)
		if file == null:
			printerr("Could not write to save file.")
			file.store_string(JSON.stringify(save_file_data, "  "))
	else:
		push_warning("No file saved because we're using a dummy data...")
		print("Ending game with save_file_data:\n%s" % JSON.stringify(save_file_data, "  "))
	get_tree().quit()


func _ready():
	await get_tree().process_frame
	_parse_cmd_args()
	
	if save_file_data.size() == 0:
		push_warning("Save file not found, loading dummy save data...")
		save_file_data = DUMMY_SAVE_DATA.duplicate(true)
	
	game_started.emit(get_players())


func _parse_cmd_args():
	var arguments = {}
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]
	if arguments.has("savefile"):
		save_file_path = arguments["savefile"]
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		if file == null:
			push_error("Could not read save file.")
			return
		file.close();
