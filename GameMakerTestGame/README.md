# GameMaker Example

This folder contains a sample minigame written in GameMaker.

Last tested on GameMaker 2024.8.1.171

## Minigame Manager Library

### Installation

1. Download the `scripts/c_minigame_manager` and `objects/o_minigame_manager` folders and add them to your GameMaker project.

### Usage

- Starting the game
  1. Call `init_minigame_manager()` and pass in your minigame name
  2. Spawn players using the `global.minigame_manager.player_data_array`
- Ending the game
  1. Call `end_game` on the `global.minigame_manager` and pass in an array of player results

**Ex.**

```gml
// Inside Create event of a object that's in charge
// of handling the lifecycle of the game

// Initialize minigame manager
init_minigame_manager("GameMaker Test Game");

// Spawn players
var player_count = array_length(_player_data_array)
for (var i = 0; i < player_count; i++) {
	show_debug_message("Spawning player: {0} with data: {1}", i, _player_data_array[i]);
}

// End the game and assign points to each player
//
// In the example below, we give 1 point to
// player 1 and 3 points to player 2
global.minigame_manager.end_game([
    new PlayerResult(0, 1),
    new PlayerResult(1, 3),
]);
```
