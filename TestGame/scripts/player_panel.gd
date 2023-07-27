extends PanelContainer
class_name PlayerPanel
## PlayerPanel manages a UI panel for a single player
##
## A panel displays a point score as well as a button the player can click to increase their score.
## Each player also gets a special key on the keyboard they can click to increase their score. 


@export var player_label: Label
@export var points_label: Label
@export var click_button: Button

var player_data: MiniGameManager.PlayerData
var player_keybind: int
var points: int

const PLAYER_KEYBINDS = {
	1: KEY_Q,
	2: KEY_R,
	3: KEY_U,
	4: KEY_P,
	5: KEY_Z,
	6: KEY_V,
	7: KEY_M,
	8: KEY_QUESTION,
}


func construct(player_data: MiniGameManager.PlayerData):
	self.player_data = player_data
	
	player_label.text = "Player %d" % player_data.number
	player_keybind = PLAYER_KEYBINDS[player_data.number]
	click_button.text = "Click %s" % char(player_keybind).to_upper()
	
	var panel = get_theme_stylebox("panel").duplicate(true) as StyleBoxFlat;
	panel.border_color = Color(player_data.color)
	add_theme_stylebox_override("panel", panel)
	
	points = 0
	points_label.text = str(points)


func _ready():
	player_label.text = "asdf"
	click_button.button_up.connect(_on_button_click)


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == player_keybind:
			_on_button_click()


func _on_button_click():
	points += 1
	points_label.text = str(points)
