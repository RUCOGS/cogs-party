# Unity Example

This folder contains a sample minigame written in Unity.

Last tested on Unity 6000.0.23f1

## Minigame Manager Library

### Installation

1. Download `Assets/Scripts/MiniGameManager.cs` and add it to your Unity project.
2. Attach the `MiniGameManager` component to a GameObject in your game's main scene.
3. Set the `GameName` field on the minigame manager component to your minigame's name.

### Usage

- Starting the game
  1. Get a reference to the `MiniGameManager`
  2. Attach a listener to the `GameStarted` event of `MiniGameManager`
  3. Spawn players in from your listener function
- Ending the game
  1. Call `EndGame` on the `MiniGamemanager` and pass in an array of player results

**Ex.**

```cs
// Inside GameManager.cs, which is attached to some GameObject in the main scene.
// This script handles the lifecycle of a game, including starting and stopping the game.
using UnityEngine;
using System.Collections;
using static SaveData.GameResult;

public class GameManager : MonoBehaviour
{
    // Get a reference to the MiniGameManager
    // Can drag-and-drop in the MiniGameManager from the inspector
    [SerializeField]
    private MiniGameManager _minigameManager;

    private void Start()
    {
        _minigameManager.GameStarted += OnGameStarted;
    }

    private async void OnGameStarted(PlayerData[] players)
    {
        foreach (PlayerData player in players) {
            // Spawn in the players
            Debug.Log("Spawn player " + player.Number);
        }
    }

    private float _timeLeft = 10;
    private void Update() {
        _timeLeft -= Time.DeltaTime;
        if (_timeLeft < 0) {
            // End the game after the time is up
            EndGame();
        }
    }

    private void EndGame() {
        // Assign points to each player
        // In the eaxmple below, we give 1 point to player 1 and 3 points to player 2
        _minigameManager.EndGame([
            new PlayerResult()
            {
                Player = 0,
                Points = 1
            },
            new PlayerResult()
            {
                Player = 1,
                Points = 3
            }
        ])
    }
}
```
