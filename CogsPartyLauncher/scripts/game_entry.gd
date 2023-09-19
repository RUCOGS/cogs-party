@tool
extends Control
class_name GameEntry


signal changed()


@export var banner_rect: TextureRect
@export var title_label: Label
@export var description_label: Label
@export var error_panel: Control
@export var error_panel_label: Label
@export var content_container: Control
@export var enabled_checkbox: CheckBox
@export var player_count_label: Label
@export var crossout: Control


const SUPPORTED_BUILDS = [
	"windows",
	"macos",
	"linux"
]

@export var allowed: bool = true : set = _set_allowed
@export var display_mode: bool = false : set = _set_display_mode

var game_data: Dictionary
var errors = PackedStringArray([])


func _set_allowed(value: bool):
	allowed = value
	_update_ui()


func _set_display_mode(value: bool):
	display_mode = value
	_update_ui()


func construct(_game_data: Dictionary):
	game_data = _game_data
	
	enabled_checkbox.button_pressed = game_data.enabled
	
	if game_data.has("banner") and game_data.banner is String:
		var image = Image.new()
		if image.load(game_data.directory_path + "/" + game_data.banner) == OK:
			var texture = ImageTexture.create_from_image(image)
			banner_rect.texture = texture
		else:
			errors.append("Failed to load banner image.")
	
	if game_data.has("title") and game_data.title is String:
		title_label.text = game_data.title
	else:
		title_label.text = "N/A"
		errors.append("Missing title")
	if game_data.has("description") and game_data.description is String:
		description_label.text = game_data.description
	else:
		description_label.text = "N/A"
		errors.append("Missing description")
	
	if game_data.has("builds") and game_data.builds is Dictionary:
		for build in game_data.builds:
			var rel_build_location = game_data.builds[build]
			if rel_build_location is String:
				if build is String and build in SUPPORTED_BUILDS:
					var build_location = game_data.directory_path + "/" + rel_build_location
					if not FileAccess.file_exists(build_location):
						errors.append("No file found at location '%s'" % build_location)
				else:
					errors.append("Failed to parse build: '%s'" % build)
			else:
				errors.append("Expected string for build location")
	else:
		errors.append("Missing builds")
	
	var player_bounds_valid = true
	if not (game_data.has("min_players") and game_data.min_players is float):
		errors.append("Missing min players")
		player_bounds_valid = false
	elif game_data.min_players <= 1:
		player_bounds_valid = false
		errors.append("Cannot have singleplayer only games. min_players >= 2")
		
	if not (game_data.has("max_players") and game_data.max_players is float):
		player_bounds_valid = false
		errors.append("Missing max players")
	elif game_data.max_players <= 1:
		player_bounds_valid = false
		errors.append("Cannot have singleplayer only games. max_players >= 2")
	
	if player_bounds_valid and game_data.max_players < game_data.min_players:
		player_bounds_valid = false
		errors.append("max_players must be >= min_players")
	
	if player_bounds_valid and game_data.has("min_players") and game_data.has("max_players"):
		if game_data.min_players == game_data.max_players:
			player_count_label.text = "%d Players" % [game_data.min_players]
		else:
			player_count_label.text = "%d - %d Players" % [game_data.min_players, game_data.max_players]
	else:
		player_count_label.text = "N/A"
	_update_ui()


func _ready():
	enabled_checkbox.toggled.connect(_on_enabled_checbox_toggled)
	_update_ui()


func _update_ui():
	if game_data:
		if errors.size() != 0:
			error_panel.visible = true
			error_panel_label.text = ",\n".join(errors)
			game_data.enabled = false
			game_data.errors = true
		else:
			error_panel.visible = false
	
	crossout.visible = not allowed
	crossout.queue_redraw()
	if not allowed:
		content_container.modulate = Color("#b4b4b4")
		enabled_checkbox.disabled = true
	elif game_data and not game_data.enabled:
		content_container.modulate = Color("#b4b4b4")
	else:
		content_container.modulate = Color.WHITE
		enabled_checkbox.disabled = false
	
	if display_mode:
		enabled_checkbox.visible = false


func _on_enabled_checbox_toggled(toggled: bool):
	if game_data:
		game_data.enabled = toggled
	_update_ui()
	changed.emit()
