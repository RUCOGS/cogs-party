using System;
using System.Collections.Generic;
using UnityEngine;

namespace Game
{
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
}