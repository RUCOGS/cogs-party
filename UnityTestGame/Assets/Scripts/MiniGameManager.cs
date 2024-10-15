using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using ColorUtility = UnityEngine.ColorUtility;

namespace Game
{
    public class PlayerData
    {
        public int Index { get; set; }
        public int Number => Index + 1;
        public Color Color { get; set; }
        public int Points { get; set; }
    }

    /// <summary>
    /// MiniGameManager is the main scrip that handles starting and ending a minigame.
    /// 
    /// There are various events you can connect to 
    /// to detect when the game starts and ends.
    /// </summary>
    public class MiniGameManager : MonoBehaviour
    {
        public event Action<PlayerData[]> GameStarted;
        public event Action GameEnded;

        [field: Header("Settings")]
        [field: SerializeField]
        public string GameName { get; set; }
        [field: SerializeField]
        public Vector2Int PlayerCount { get; set; } = new Vector2Int(2, 4);
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
                Debug.LogWarning("No file asved because we're using dummy data...");
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
}