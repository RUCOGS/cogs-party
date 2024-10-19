// feather ignore GM2017
// feather ignore GM1041

// Transition between the game states and overlays
// as the game progresses.
if (state == GameState.CountDown and not countdown_screen.active) {
	// Turn on ingame UI and countdown
	state = GameState.InGame;
	ingame_screen.start();
} else if (state == GameState.InGame and not ingame_screen.active) {
	// Fetch scores
	var players = [];
	for (var i = 0; i < instance_number(o_player); i++) {
	    players[i] = instance_find(o_player, i);
	}
	// Sort scores by descending order
	array_sort(players, function(a, b) {
		return b.points - a.points;
	});
	// Award points to top X players from reward_points array
	var reward_i = 0;
	var results = [];
	for (var i = 0; i < array_length(players); i++) {
		if (i > 0 and players[i].points != players[i - 1].points) {
			reward_i += 1;
		}
	    if (reward_i >= array_length(player_reward_points)) {
			break;
		}
		var player = players[i];
		results[i] = new PlayerResult(player.player_data.index, player_reward_points[reward_i]);
	}
	global.minigame_manager.apply_results(results);
	
	// Show results overlay
	state = GameState.ResultsScreen;
	results_screen.start();
} else if (state == GameState.ResultsScreen and not results_screen.active) {
	global.minigame_manager.end_game()
}