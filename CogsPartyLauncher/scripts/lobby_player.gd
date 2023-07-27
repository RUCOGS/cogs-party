extends PanelContainer
class_name LobbyPlayer


@export var player_name_label: Label
@export var points_label: Label

var player_number: int
var player_points: int : set = _set_player_points

func construct(_player_number: int, player_color: Color, points: int):
	player_number = _player_number
	player_name_label.text = "P%d" % player_number
	_set_player_points(points)
	
	var stylebox = get_theme_stylebox("panel").duplicate(true) as StyleBoxFlat
	stylebox.border_color = player_color
	add_theme_stylebox_override("panel", stylebox)
	

func _set_player_points(points: int):
	points_label.text = str(points)
