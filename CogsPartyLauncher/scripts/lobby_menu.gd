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
var lobby_player_prev_scores: Array[int] = [] #Store previous player scores for equalization process

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
		lobby_player_prev_scores.clear()
		var player_number = 1
		for player in game_library.save_data.players:
			var inst = lobby_player_prefab.instantiate() as LobbyPlayer
			lobby_player_container.add_child(inst)
			lobby_players.append(inst)
			inst.construct(player_number, player.color, player.points)
			player_number += 1
			lobby_player_prev_scores.append(inst.player_points) #Run-time score storage for equalization
		
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
		var point_tally = 0
		var first_place = [-1,-1] #For awarding bonus point if uneven division | index, points
		
		for lobby_player in lobby_players: #Get total points received
			var player_data = game_library.save_data.players[lobby_player.player_number - 1]
			player_data.points -= lobby_player_prev_scores[lobby_player.player_number - 1] #for equalization
			point_tally += player_data.points
			if (player_data.points > first_place[1]):
				first_place[0] = lobby_player.player_number - 1
				first_place[1] = player_data.points
			else: if(player_data.points == first_place[1]): #tie for first, do not award bonus
				first_place[0] = -1
			
		if step_decimals(game_library.save_data.players[0].points/point_tally as float)==0:  #If even distribution, don't award point
			first_place[0] = -1
			
		for lobby_player in lobby_players: #Give players the equalized scores
			var index = lobby_player.player_number - 1
			var player_data = game_library.save_data.players[index]
			var rejusted_score = ((player_data.points * 12) / point_tally) + lobby_player_prev_scores[index] as int
			if (index == first_place[0]): #Award bonus point for best player
				rejusted_score += 1
			lobby_player.player_points = rejusted_score
			lobby_player_prev_scores[index] = rejusted_score
			player_data.points = rejusted_score
			
		var file = FileAccess.open(game_library.SAVE_FILE_PATH, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(game_library.save_data, "  ")) 		#Update save with equalized scores
			file.close()
		else:
			printerr("Could not write to save file.")
