extends VBoxContainer
class_name PlayerSelectMenu


@export var player_setting_prefab: PackedScene
@export var player_cursor_prefab: PackedScene
@export var player_setting_container: Control
@export var add_player_button: Button
@export var player_colors: Array[Color]
@export var play_button: Button
@export var back_button: Button
@export var game_library: GameLibrary
@export var menu_navigator: MenuNavigator
@export var game_library_display: GameLibraryDisplay


var player_settings: Array[PlayerSetting]
var player_cursors: Array[CharacterBody2D]
var cursor_controls: Array[String]
var taken_colors: Dictionary = {}
var taken_ids: Dictionary = {}


func _ready():
	add_player_button.pressed.connect(_on_add_player_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	back_button.pressed.connect(menu_navigator.load_menu.bind("MainMenu"))
	game_library_display.changed.connect(_on_game_library_display_changed)
	self.visibility_changed.connect(_on_visible_changed)
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	_update_add_player_button()
	
	# all non-ui controls get added to cursor controls
	for control in InputMap.get_actions():
		if !control.begins_with("ui"):
			cursor_controls.append(control)
	
	for device in Input.get_connected_joypads():
		_add_controls(device)
		_on_add_player_button_pressed()


# if an id is not found, the controllers id will be -1
func _get_next_id() -> int:
	var found_id = -1
	var devices = Input.get_connected_joypads()
	devices.sort()
	
	for device_id in devices:
		if not taken_ids.has(device_id):
			found_id = device_id
			break
	return found_id


func _add_taken_id(device_id: int):
	taken_ids[device_id] = null


func _remove_taken_id(device_id: int):
	taken_ids.erase(device_id)


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


func _get_enabled_playable_games() -> Array[Dictionary]:
	return game_library.get_enabled_playable_games(player_settings.size())


func _get_playable_games() -> Array[Dictionary]:
	return game_library.get_playable_games(player_settings.size())


func _update_play_button():
	play_button.disabled = _get_enabled_playable_games().size() == 0


func _update_player_settings():
	_update_taken_colors_set()
	# Update color options and numbers
	var i = 1
	for player_setting in player_settings:
		player_setting.update(i, _get_prev_available_color(player_setting.player_color), _get_next_available_color(player_setting.player_color))
		i += 1


func _update_game_library_display():
	game_library_display.update(game_library.games, _get_playable_games())


func _on_visible_changed():
	if self.visible:
		back_button.grab_focus()
		_update_game_library_display()


func _on_player_setting_updated():
	_update_player_settings()


func _on_player_count_changed():
	_update_player_settings()
	_update_game_library_display()
	_update_add_player_button()
	_update_play_button()
	


func _on_add_player_button_pressed():
	var player_cursor = player_cursor_prefab.instantiate() as CharacterBody2D
	var id = _get_next_id()
	_add_taken_id(id)
	player_cursor.controller_id = id
	player_cursors.append(player_cursor)
	add_child(player_cursor)
	
	var inst = player_setting_prefab.instantiate() as PlayerSetting
	player_setting_container.add_child(inst)
	player_setting_container.move_child(inst, player_setting_container.get_child_count() - 2)
	inst.updated.connect(_on_player_setting_updated)
	inst.removed.connect(_on_player_setting_removed.bind(inst))
	inst.construct(
		player_settings.size() + 1,
		player_cursor, 
		_get_next_available_color_or_self()
	)
	player_settings.append(inst)
	_on_player_count_changed()


func _on_player_setting_removed(player_setting: PlayerSetting):
	var next_focus_idx = player_setting.get_index() - 1;
	if next_focus_idx < 0:
		next_focus_idx = player_setting_container.get_child_count() - 1
	var next_focus_control = player_setting_container.get_child(next_focus_idx) as Control
	if next_focus_control is PlayerSetting:
		next_focus_control.remove_button.grab_focus()
	else:
		next_focus_control.grab_focus()

	_remove_taken_id(player_setting.player_cursor.controller_id)
	player_cursors.erase(player_setting.player_cursor)
	player_setting.player_cursor.queue_free()

	player_setting_container.remove_child(player_setting)
	player_setting.queue_free()
	player_settings.erase(player_setting)
	_on_player_count_changed()


func _on_joy_connection_changed(device_id: int, connected: bool):
	if connected:
		# adds InputMap for the new device if needed
		_add_controls(device_id)
		
		# check if there is an unlinked cursor
		for cursor in player_cursors:
			if cursor.controller_id == -1:
				_add_taken_id(device_id)
				cursor.controller_id = device_id
				break
		# if we need to make a new cursor
		if not taken_ids.has(device_id):
			_on_add_player_button_pressed()
	else:
		for cursor in player_cursors:
			if cursor.controller_id == device_id:
				_remove_taken_id(device_id)
				cursor.controller_id = -1
			break


func _add_controls(device_id: int):
	for control in cursor_controls:
		var action_name = control + str(device_id)
			
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
				
			for event in InputMap.action_get_events(control):
				var new_event = event.duplicate()
					
				if new_event is InputEventJoypadButton or new_event is InputEventJoypadMotion:
					new_event.device = device_id
					InputMap.action_add_event(action_name, new_event)
			
	

func _on_game_library_display_changed():
	_update_play_button()


func _on_play_button_pressed():
	var players: Array[Dictionary] = []
	for player_setting in player_settings:
		players.append({
			"color": "#" + player_setting.player_color.to_html(false),
			"points": 0
		})
	
	game_library.new_save_file(players)
	menu_navigator.load_menu("LobbyMenu")
