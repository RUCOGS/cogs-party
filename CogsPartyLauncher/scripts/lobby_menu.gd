extends Control


@export var menu_navigator: MenuNavigator
@export var game_library: GameLibrary
@export var game_library_display: GameLibraryDisplay
@export var quit_button: Button
@export var next_button: Button
@export var lobby_player_prefab: PackedScene
@export var lobby_player_container: Control
@export var lobby_view: Control
@export var running_game_playing_label: Label
@export var running_view: Control
@export var running_game_entry: GameEntry

var lobby_players: Array[LobbyPlayer] = []


func _ready():
	self.visibility_changed.connect(_on_visible_changed)
	_on_visible_changed()
	quit_button.pressed.connect(menu_navigator.load_menu.bind("PlayerSelectMenu"))
	next_button.pressed.connect(_on_next_button_pressed)
	game_library.game_ended.connect(_on_game_ended)


func _on_visible_changed():
	# We just loaded the menu
	if visible:
		lobby_view.visible = true
		running_view.visible = false
		
		if game_library.save_data == null:
			push_error("Expected game library save_data to be set before entering LobbyMenu.")
			return
		
		for child in lobby_player_container.get_children():
			lobby_player_container.remove_child(child)
			child.queue_free()
		
		lobby_players.clear()
		var player_number = 1
		for player in game_library.save_data.players:
			var inst = lobby_player_prefab.instantiate() as LobbyPlayer
			lobby_player_container.add_child(inst)
			lobby_players.append(inst)
			inst.construct(player_number, player.color, player.points)
			player_number += 1
		
		game_library_display.update(game_library.get_enabled_playable_games())


func _on_next_button_pressed():
	var game = game_library.get_random_enabled_playable_game()

	lobby_view.visible = false
	running_view.visible = true
	running_game_entry.construct(game)

	# Countdown to give people time to 
	# see what game was chosen
	for i in range(3, 0, -1):
		running_game_playing_label.text = "P L A Y I N G   I N   %d" % i
		await get_tree().create_timer(1).timeout

	running_game_playing_label.text = "P L A Y I N G"
	game_library.launch_game(game)


func _on_game_ended(results):
	lobby_view.visible = true
	running_view.visible = false
	
	if results != null and results is Dictionary:
		for lobby_player in lobby_players:
			var player_data = game_library.save_data.players[lobby_player.player_number - 1]
			lobby_player.player_points = player_data.points
