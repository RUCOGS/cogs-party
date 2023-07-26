extends Control
class_name GameManager
## GameManager manages the actual gameplay part of the minigame.
## 
## It connects to the MiniGameManager to detect when the game started,
## and to also end the game when the time runs out.


@export var countdown_label: Label
@export var countdown_overlay: Control
@export var time_label: Label
@export var player_panel_container: HBoxContainer
@export var player_panel_prefab: PackedScene
@export var mini_game_manager: MiniGameManager
@export var duration: float = 10

## The points awarded to each player
## 
## The order of the points specifies the "place" the points are awared to.
## ex: [4, 3, 1] means 
##   	4 points are awarded to first place, 
##		3 points are awarded to second place, 
##		and 1 point is awarded to third place .
@export var player_reward_points: PackedInt64Array

var game_started: bool = false
var time: float = 0

## Array of PlayerPanel nodes
var player_panels: Array


func _ready():
	mini_game_manager.game_started.connect(_on_game_started)
	time_label.text = str(duration)


func _on_game_started(players: Array):
	time = duration
	time_label.text = str(duration)
	for player in players:
		var panel_inst = player_panel_prefab.instantiate() as PlayerPanel;
		player_panel_container.add_child(panel_inst)
		panel_inst.construct(player)
		player_panels.append(panel_inst)
	
	countdown_overlay.visible = true
	for i in range(3, 0, -1):
		countdown_label.text = str(i)
		await get_tree().create_timer(1).timeout
	countdown_label.text = "START"
	await get_tree().create_timer(1).timeout
	countdown_overlay.visible = false
		
	game_started = true


func _process(delta):
	if not game_started:
		return
	time -= delta
	time_label.text = "%4.2f" % time
	if time <= 0:
		time_label.text = "0.00"
		_end_game()


func _sort_player_panel_descending(a: PlayerPanel, b: PlayerPanel):
	if a.score < b.score:
		return false
	return true


func _end_game():
	game_started = false

	var top_players = player_panels.duplicate();
	top_players.sort_custom(_sort_player_panel_descending)		
	
	var results = []
	var i = 0
	var prev_player = null
	for _player in top_players:
		var player: PlayerPanel = _player
		if prev_player != null:
			if prev_player.score != player.score:
				i += 1
			if i >= player_reward_points.size():
				break
		results.append(MiniGameManager.PlayerResultData.new(
			player.player_data.number, 
			player_reward_points[i]
		))
		prev_player = _player
		
	mini_game_manager.end_game(results)
