extends VBoxContainer
class_name GameLibraryDisplay


@export var game_entry_prefab: PackedScene
@export var game_entry_container: VBoxContainer
@export var games_label: Label

@export var display_mode: bool = false : set = _set_display_mode

var games: Array[Dictionary]
var allowed_games	# Array[Dictionary] | Null


func update(_games: Array[Dictionary], _allowed_games = null,):
	games = _games
	allowed_games = _allowed_games
	
	for child in game_entry_container.get_children():
		child.queue_free()
		game_entry_container.remove_child(child)
	
	for entry in _games:
		var inst = game_entry_prefab.instantiate() as GameEntry
		game_entry_container.add_child(inst)
		inst.changed.connect(_update_games_label)
		inst.construct(entry)
		if allowed_games != null and not entry in allowed_games:
			inst.allowed = false
		if display_mode:
			inst.display_mode = true
	
	_sort_entries()
	_update_games_label()


func _set_display_mode(value: bool):
	display_mode = value


func _sort_entry(a: GameEntry, b: GameEntry):
	if b.allowed:
		if a.allowed:
			if b.game_data.enabled:
				if a.game_data.enabled:
					return true
				else:
					return false
			else:
				return true
		else:
			return false
	else:
		return true


func _sort_entries():
	var sorted_entries = game_entry_container.get_children()
	sorted_entries.sort_custom(_sort_entry)
	for entry in sorted_entries:
		game_entry_container.remove_child(entry)
	for entry in sorted_entries:
		game_entry_container.add_child(entry)


func _update_games_label():
	var allowed_game_count = 0
	var allowed_and_enabled_game_count = 0
	for game in games:
		if allowed_games == null or game in allowed_games:
			allowed_game_count += 1
			if game.enabled:
				allowed_and_enabled_game_count += 1
	if allowed_games:
		games_label.text = "G A M E S   ( %d / %d )" % [allowed_and_enabled_game_count, allowed_game_count]
	else:
		games_label.text = "G A M E S   ( %d )" % allowed_and_enabled_game_count
