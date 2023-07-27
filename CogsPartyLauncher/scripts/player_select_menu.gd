extends VBoxContainer
class_name PlayerSelectMenu


@export var player_setting_prefab: PackedScene
@export var player_setting_container: Control
@export var add_player_button: Button
@export var player_colors: Array[Color]
@export var play_button: Button
@export var back_button: Button
@export var game_library: GameLibrary
@export var menu_navigator: MenuNavigator
@export var game_library_display: GameLibraryDisplay

var player_settings: Array[PlayerSetting]
var taken_colors: Dictionary = {}


func _ready():
	add_player_button.pressed.connect(_on_add_player_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	back_button.pressed.connect(menu_navigator.load_menu.bind("MainMenu"))
	self.visibility_changed.connect(_on_visible_changed)
	_update_add_player_button()


func _get_available_colors() -> Array[Color]:
	var available_colors = player_colors.duplicate()
	for setting in player_settings:
		available_colors.erase(setting.player_color)
	return available_colors


func _update_taken_colors_set():
	taken_colors.clear()
	for player_setting in player_settings:
		taken_colors[player_setting.player_color] = null


func _get_prev_available_color(start_color: Color):
	var curr_color_idx = player_colors.find(start_color)
	var found_color = null
	
	for i in range(1, player_colors.size()):
		var curr_idx = (curr_color_idx - i) % player_colors.size()
		var curr_color = player_colors[curr_idx]
		if not taken_colors.has(curr_color):
			found_color = curr_color
			break
	return found_color


func _get_next_available_color_or_self():
	return _get_next_available_color(player_colors[player_colors.size() - 1], true)


func _get_next_available_color(start_color: Color, include_self: bool = false):
	var curr_color_idx = player_colors.find(start_color)
	var found_color = null
	if include_self:
		found_color = start_color
	
	for i in range(1, player_colors.size()):
		var curr_idx = (curr_color_idx + i) % player_colors.size()
		var curr_color = player_colors[curr_idx]
		if not taken_colors.has(curr_color):
			found_color = curr_color
			break
	return found_color


func _update_add_player_button():
	# We can only add players as long as we have enough colors to differentiate them
	add_player_button.visible = taken_colors.size() < player_colors.size()


func _update_player_settings():
	_update_taken_colors_set()
	# Update color options and numbers
	var i = 1
	for player_setting in player_settings:
		player_setting.update(i, _get_prev_available_color(player_setting.player_color), _get_next_available_color(player_setting.player_color))
		i += 1


func _update_game_library_display():
	game_library_display.update(game_library.games, game_library.get_playable_games(player_settings.size()))


func _on_visible_changed():
	if self.visible:
		back_button.grab_focus()
		_update_game_library_display()


func _on_add_player_button_pressed():
	var inst = player_setting_prefab.instantiate() as PlayerSetting
	player_setting_container.add_child(inst)
	player_setting_container.move_child(inst, player_setting_container.get_child_count() - 2)
	inst.updated.connect(_on_player_setting_updated)
	inst.removed.connect(_on_player_setting_removed.bind(inst))
	inst.construct(
		player_settings.size() + 1, 
		_get_next_available_color_or_self()
	)
	player_settings.append(inst)
	_update_player_settings()
	_update_game_library_display()
	_update_add_player_button()


func _on_player_setting_updated():
	_update_player_settings()


func _on_player_setting_removed(player_setting: PlayerSetting):
	var next_focus_idx = player_setting.get_index() - 1;
	if next_focus_idx < 0:
		next_focus_idx = player_setting_container.get_child_count() - 1
	var next_focus_control = player_setting_container.get_child(next_focus_idx) as Control
	if next_focus_control is PlayerSetting:
		next_focus_control.remove_button.grab_focus()
	else:
		next_focus_control.grab_focus()

	player_setting_container.remove_child(player_setting)
	player_setting.queue_free()
	player_settings.erase(player_setting)
	_update_player_settings()
	_update_game_library_display()
	_update_add_player_button()


func _on_play_button_pressed():
	var players: Array[Dictionary] = []
	for player_setting in player_settings:
		players.append({
			"color": player_setting.player_color.to_html(false),
			"points": 0
		})
	
	game_library.new_save_file(players)
	menu_navigator.load_menu("LobbyMenu")
