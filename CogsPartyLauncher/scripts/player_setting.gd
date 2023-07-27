extends PanelContainer
class_name PlayerSetting


signal removed()
signal updated()

@export var player_name_label: Label
@export var color_left_button: Button
@export var color_right_button: Button
@export var remove_button: Button


var player_number: int = 1
var player_color: Color
var next_color_option
var prev_color_option


func construct(number: int, color: Color):
	player_number = number
	player_color = color
	_update_player_name()
	_update_color()


func update(number: int, _prev_color_option, _next_color_option):
	player_number = number
	_update_player_name()
	prev_color_option = _prev_color_option
	next_color_option = _next_color_option
	color_left_button.visible = prev_color_option != null
	color_right_button.visible = next_color_option != null


func _ready():
	remove_button.pressed.connect(func(): removed.emit())
	color_left_button.pressed.connect(_on_color_left_button_pressed)
	color_right_button.pressed.connect(_on_color_right_button_pressed)


func _update_color():
	var stylebox = get_theme_stylebox("panel").duplicate(true) as StyleBoxFlat
	stylebox.border_color = player_color
	add_theme_stylebox_override("panel", stylebox)


func _update_player_name():
	player_name_label.text = "P%d" % player_number


func _on_color_option_selected():
	updated.emit()


func _on_color_left_button_pressed():
	if prev_color_option != null:
		player_color = prev_color_option
		_update_color()
		updated.emit()


func _on_color_right_button_pressed():
	if next_color_option != null:
		player_color = next_color_option
		_update_color()
		updated.emit()
