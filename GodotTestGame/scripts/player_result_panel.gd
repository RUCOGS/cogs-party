extends PanelContainer
class_name PlayerResultPanel

@export var player_label: Label
@export var points_change_label: Label
@export var points_label: Label

# Called when the node enters the scene tree for the first time.
func construct(player_data: MiniGameManager.PlayerData, score_change: int):
	player_label.text = "Player %d" % (player_data.number + 1)
	if score_change > 0:
		points_change_label.text = "+%d" % score_change
	elif score_change < 0:
		points_change_label.text = str(score_change)
	else:
		points_change_label.text = "X"
	points_label.text = str(player_data.points)
	
	var panel = get_theme_stylebox("panel").duplicate(true) as StyleBoxFlat;
	panel.border_color = player_data.color
	add_theme_stylebox_override("panel", panel)
	
