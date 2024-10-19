using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using ColorUtility = UnityEngine.ColorUtility;

/// <summary>
/// MiniGameManager is the main script that handles starting and ending a minigame.
/// 
/// There are various events you can connect to 
/// to detect when the game starts and ends.
/// </summary>
public class MiniGameManager : MonoBehaviour
{
    /// <summary>
    /// Emitted when the game is started
    /// </summary>
    public event Action<PlayerData[]> GameStarted;
    /// <summary>
    /// Emitted when the game is ended
    /// </summary>
    public event Action GameEnded;

    /// <summary>
    /// Name of the game.
    /// </summary>
    /// <value></value>
    [field: Header("Settings")]
    [field: SerializeField]
    public string GameName { get; set; }
    /// <summary>
    /// Path to the save file.
    /// This is set when the game first runs.
    /// </summary>
    /// <value></value>
    [field: SerializeField]
    public string SaveFilePath { get; set; }
    public SaveData SaveFileData { get; private set; } = null;

    /// <summary>
    /// Applies the results to the save data.
    /// 
    /// This can only be done once during the entire game, and is
    /// usually done at the end.
    /// </summary>
    public bool AppliedResults { get; private set; } = false;

    /// <summary>
    /// Returns an array of PlayerData
    /// </summary>
    /// <returns></returns>
    public PlayerData[] GetPlayers()
    {
        var players = new List<PlayerData>();
        for (int i = 0; i < SaveFileData.Players.Count; i++)
        {
            var x = SaveFileData.Players[i];

            ColorUtility.TryParseHtmlString(x.Color, out Color color);
            players.Add(new PlayerData()
            {
                Index = i,
                Color = color,
                Points = x.Points,
            });
        }
        return players.ToArray();
    }

    /// <summary>
    /// Applies the results of this game to the save data.
    /// 
    /// This can only be done once during the entire game, and is
    /// usually done at the end.
    /// </summary>
    /// <param name="playerResults"></param>
    public void ApplyResults(IEnumerable<SaveData.GameResult.PlayerResult> playerResults)
    {
        if (AppliedResults)
        {
            Debug.LogError("Cannot add results twice!");
            return;
        }
        AppliedResults = true;

        SaveFileData.Games.Add(new SaveData.GameResult()
        {
            Name = GameName,
            Results = playerResults.ToList()
        });

        foreach (var result in playerResults)
            SaveFileData.Players[result.Player].Points += result.Points;
    }

    /// <summary>
    /// Ends the game with some results.
    /// 
    /// If you manually called <see cref="ApplyResults">ApplyResults</see> earlier, then you do not need to pass in a <paramref name="playerResults"/> parameter.
    /// </summary>
    /// <param name="playerResults"></param>
    public void EndGame(IEnumerable<SaveData.GameResult.PlayerResult> playerResults = null)
    {
        GameEnded?.Invoke();

        if (playerResults != null)
            ApplyResults(playerResults);

        if (SaveFilePath != "")
        {
            try
            {
                var data = JsonUtility.ToJson(SaveFileData);
                File.WriteAllText(SaveFilePath, data);
            }
            catch (Exception e)
            {
                Debug.LogError("Could not open save filee: " + e);
            }
        }
        else
        {
            Debug.LogWarning("No file saved because we're using dummy data...");
            Debug.Log("Ending game with SaveFileData:\n" + JsonUtility.ToJson(SaveFileData, true));
        }

        Application.Quit();
    }

    private void Start()
    {
        StartCoroutine(nameof(InitializeCoroutine));
    }

    private IEnumerator InitializeCoroutine()
    {
        Screen.fullScreen = true;

        yield return new WaitForEndOfFrame();

        ParseCmdArgs();

        if (SaveFileData == null)
        {
            Debug.LogWarning("Save file not found, loading dummy save data...");
            SaveFileData = SaveData.DummySaveData;
        }

        GameStarted?.Invoke(GetPlayers());
    }

    private void ParseCmdArgs()
    {
        var arguments = new Dictionary<string, string>();
        foreach (var argument in System.Environment.GetCommandLineArgs())
        {
            if (argument.StartsWith("--") && argument.Contains("="))
            {
                var keyValue = argument.Split("=");
                arguments[keyValue[0].Substring(2)] = keyValue[1];
            }
        }
        if (arguments.ContainsKey("savefile"))
        {
            SaveFilePath = arguments["savefile"];
            try
            {
                string fileText = File.ReadAllText(SaveFilePath);
                var jsonResult = JsonUtility.FromJson<SaveData>(fileText);
                SaveFileData = jsonResult;
            }
            catch (Exception e)
            {
                Debug.LogError("Could not read save file. " + e);
                return;
            }
        }
    }
}

/// <summary>
/// Information about a specific player
/// </summary>
public class PlayerData
{
    public int Index { get; set; }
    public int Number => Index + 1;
    public Color Color { get; set; }
    public int Points { get; set; }
}

/// <summary>
/// Raw JSON data stored in save_file.json
/// </summary>
[Serializable]
public class SaveData
{
    public static SaveData DummySaveData => new SaveData
    {
        Players = new List<Player>()
        {
            new Player()
            {
                Color = "#a83232",
                Points = 0
            },
            new Player()
            {
                Color = "#63a832",
                Points = 0,
            },
            new Player()
            {
                Color ="#327ba8",
                Points = 2,
            },
            new Player()
            {
                Color = "#7932a8",
                Points = 0,
            }
        },
        Games = new List<GameResult>()
        {
            new GameResult()
            {
                Name = "Text Game",
                Results = new List<GameResult.PlayerResult>()
                {
                    new GameResult.PlayerResult()
                    {
                        Player = 0,
                        Points = 1
                    },
                    new GameResult.PlayerResult()
                    {
                        Player = 1,
                        Points = 3
                    }
                }
            },
            new GameResult()
            {
                Name = "Other Game",
                Results = new List<GameResult.PlayerResult>()
                {
                    new GameResult.PlayerResult()
                    {
                        Player = 2,
                        Points = 1
                    }
                }
            }
        }
    };

    [Serializable]
    public class Player
    {
        [SerializeField] private string color;
        [SerializeField] private int points;

        public string Color { get => color; set => color = value; }
        public int Points { get => points; set => points = value; }
    }

    [Serializable]
    public class GameResult
    {
        [Serializable]
        public class PlayerResult
        {
            [SerializeField] private int player;
            [SerializeField] private int points;

            public int Player { get => player; set => player = value; }
            public int Points { get => points; set => points = value; }
        }

        [SerializeField] private string name;
        [SerializeField] private List<PlayerResult> results;

        public string Name { get => name; set => name = value; }
        public List<PlayerResult> Results { get => results; set => results = value; }
    }

    [SerializeField] private List<Player> players;
    [SerializeField] private List<GameResult> games;

    public List<Player> Players { get => players; set => players = value; }
    public List<GameResult> Games { get => games; set => games = value; }
}