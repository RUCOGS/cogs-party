extends HBoxContainer


@export var play_button: Button
@export var quit_game_button: Button
@export var games_folder_select_button: Button
@export var games_folder_select_file_dialog: FileDialog 
@export var games_folder_label: Label
@export var game_library: GameLibrary
@export var menu_navigator: MenuNavigator
@export var game_library_display: GameLibraryDisplay
@export var refresh_games_button: Button

const PREFERENCES_FILE_PATH = "user://preferences.json"

var preferences: Dictionary = {
	"games_folder": "user://"
}


func _ready():
	play_button.pressed.connect(menu_navigator.load_menu.bind("PlayerSelectMenu"))
	games_folder_select_button.pressed.connect(_on_games_folder_select_pressed)
	games_folder_select_file_dialog.dir_selected.connect(_on_games_folder_selected)
	refresh_games_button.pressed.connect(_on_refresh_games_button_pressed)
	quit_game_button.pressed.connect(func(): get_tree().quit())
	self.visibility_changed.connect(_on_visible_changed)
	
	_on_visible_changed()
	_load_preferences()	
	_on_games_folder_selected(preferences.games_folder)


func _save_preferences_file():
	var preferences_file = FileAccess.open(PREFERENCES_FILE_PATH, FileAccess.WRITE)
	if preferences_file:
		preferences_file.store_string(JSON.stringify(preferences, "  "))
	else:
		push_error("Could not create preferences file at '%s'.", PREFERENCES_FILE_PATH)
	preferences_file.close()
	

func _load_preferences():
	var preferences_file = FileAccess.open(PREFERENCES_FILE_PATH, FileAccess.READ)
	if preferences_file:
		var res = JSON.parse_string(preferences_file.get_as_text())
		if res == null:
			push_error("Could not read preferences file")
			preferences_file.close()
			_save_preferences_file()
		else: 
			preferences = res
			preferences_file.close()
	else:
		preferences_file.close()
		_save_preferences_file()


func _on_visible_changed():
	if self.visible:
		play_button.grab_focus()


func _on_refresh_games_button_pressed():
	_on_games_folder_selected(preferences.games_folder)


func _on_games_folder_select_pressed():
	games_folder_select_file_dialog.popup_centered_ratio()
	

func _on_games_folder_selected(folder: String):
	preferences.games_folder = folder
	game_library.load_games(folder)
	games_folder_label.text = folder
	_save_preferences_file()
	game_library_display.update(game_library.games)
