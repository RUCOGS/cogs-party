extends PanelContainer
class_name LobbyPlayer


const X_BUTTON_COLOR = Color("#34a7f3")
const A_BUTTON_COLOR = Color("#7bcb62")
const UNTESTED_BUTTON_COLOR = Color("#95959585")

@export var player_name_label: Label
@export var points_label: Label
@export var x_button_test: Control
@export var a_button_test: Control

var player_number: int
var player_points: int : set = _set_player_points


func construct(_player_number: int, player_color: Color, points: int):
	player_number = _player_number
	player_name_label.text = "P%d" % player_number
	_set_player_points(points)
	
	var stylebox = get_theme_stylebox("panel").duplicate(true) as StyleBoxFlat
	stylebox.border_color = player_color
	add_theme_stylebox_override("panel", stylebox)


func _ready():
	x_button_test.add_theme_color_override("font_color", UNTESTED_BUTTON_COLOR)
	a_button_test.add_theme_color_override("font_color", UNTESTED_BUTTON_COLOR)


func _set_player_points(points: int):
	points_label.text = str(points)


func _get_player_device() -> int:
	var connected_joypads = Input.get_connected_joypads()
	if connected_joypads.size() >= player_number:
		return connected_joypads[player_number - 1]
	return -1


func _get_font_color(base_color: Color, pressed: bool) -> Color:
	base_color.a = 1 if pressed else 0.5
	return base_color


func _unhandled_input(event):
	if event is InputEventJoypadButton:
		if event.device == _get_player_device():
			if event.button_index == JOY_BUTTON_A:
				a_button_test.add_theme_color_override("font_color", _get_font_color(A_BUTTON_COLOR, event.pressed))
			elif event.button_index == JOY_BUTTON_X:
				x_button_test.add_theme_color_override("font_color", _get_font_color(X_BUTTON_COLOR, event.pressed))
