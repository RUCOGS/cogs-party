# Godot Example

This folder contains a sample minigame written in Godot.

Last tested on Godot 4.3

## Minigame Manager Library

### Installation

1. Download `scripts/mini_game_manager.gd` and add it to your Godot project.
2. Create a `Node` in your game's main scene and attach the `mini_game_manager.gd` script.
3. Set the `game_name` property on the minigame manager node to your minigame's name.

### Usage

- Starting the game
  1. Get a reference to the `mini_game_manager`
  2. Attach a listener to the `started` signal of `mini_game_manager`
  3. Spawn players in from your listener function
- Ending the game
  1. Call `end_game` on the `mini_game_manager` and pass in an array of player results

**Ex.**

```python
# A game_manager.gd script attached to a node in the main scene.
# This script handles the lifecycle of a game, including starting and stopping the game.
extends Node

# Export a MiniGameManager variable so we can assign it in the inspector to the
# MiniGameManager node in our main scene.
@export var mini_game_manager: MiniGameManager

func _ready():
	mini_game_manager.started.connect(_on_started)

func _on_started(player_data_array: Array[MiniGameManager]):
	for player_data in player_data_array:
		# Spawn players using player_data from player_data_array
		print("Spawning player " + player_data.number)


var time_left = 10
func _process(delta: float):
	time_left -= delta
	if time_left < 0:
		# End the game after the time is up
		end_game()


func end_game():
	# Assign points to each player
	# In the eaxmple below, we give 1 point to player 1 and 3 points to player 2
	mini_game_manager.end_game([
		{
			"player": 0,
			"points": 1
		},
		{
			"player": 1,
			"points": 3
		}
	])
```
