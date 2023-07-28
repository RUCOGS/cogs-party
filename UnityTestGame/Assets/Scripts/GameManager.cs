using Cysharp.Threading.Tasks;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using static Game.SaveData.GameResult;

namespace Game
{
    public class GameManager : MonoBehaviour
    {
        [Header("Settings")]
        [SerializeField]
        private float _duration = 10;
        [SerializeField]
        private int[] _playerRewardPoints;

        [Header("Dependencies")]
        [SerializeField]
        private GameObject _countdownOverlay;
        [SerializeField]
        private TextMeshProUGUI _countdownText;
        [SerializeField]
        private TextMeshProUGUI _timeText;
        [SerializeField]
        private Transform _playerPanelContainer;
        [SerializeField]
        private GameObject _playerPanelPrefab;
        [SerializeField]
        private GameObject _playerResultsOverlay;
        [SerializeField]
        private Transform _playerResultPanelContainer;
        [SerializeField]
        private GameObject _playerResultPanelPrefab;
        [SerializeField]
        private MiniGameManager _minigameManager;
        [SerializeField]
        private PauseControl _pauseControl;

        private bool _gameStarted = false;
        private float _time = 0;
        private List<PlayerPanel> _playerPanels = new List<PlayerPanel>();

        private void Start()
        {
            _minigameManager.GameStarted += OnGameStarted;
            _timeText.text = _duration.ToString();
            _countdownOverlay.SetActive(false);
            _playerResultsOverlay.SetActive(false);
        }

        private async void OnGameStarted(PlayerData[] players)
        {
            _pauseControl.SetPause(true);
            _time = _duration;
            _timeText.text = _duration.ToString();

            foreach (Transform panel in _playerPanelContainer.transform)
                Destroy(panel.gameObject);

            foreach (var player in players)
            {
                var panelInst = Instantiate(_playerPanelPrefab, _playerPanelContainer).GetComponent<PlayerPanel>();
                panelInst.Construct(player, _pauseControl);
                _playerPanels.Add(panelInst);
            }

            _countdownOverlay.SetActive(true);
            for (int i = 3; i > 0; i--)
            {
                _countdownText.text = i.ToString();
                await UniTask.WaitForSeconds(1f, true);
            }
            _countdownText.text = "START";
            await UniTask.WaitForSeconds(1f, true);
            _countdownOverlay.SetActive(false);
            _pauseControl.SetPause(false);
            _gameStarted = true;
        }

        private void Update()
        {
            if (!_gameStarted)
                return;
            _time -= Time.deltaTime;
            _timeText.text = _time.ToString("0.00");
            if (_time <= 0)
            {
                _timeText.text = "0.00";
                EndGame();
            }
        }

        private async void EndGame()
        {
            _gameStarted = false;
            _pauseControl.SetPause(true);

            _playerPanels.Sort((a, b) => a.Points - b.Points);

            var results = new List<PlayerResult>();
            PlayerPanel prevPlayerPanel = null;
            int i = 0;
            foreach (var panel in _playerPanels)
            {
                if (prevPlayerPanel != null)
                {
                    if (prevPlayerPanel.Points != panel.Points)
                        i++;
                    if (i >= _playerRewardPoints.Count())
                        break;
                }
                results.Add(new PlayerResult()
                {
                    Player = panel.PlayerData.Index,
                    Points = _playerRewardPoints[i]
                });
                prevPlayerPanel = panel;
            }

            _minigameManager.ApplyResults(results);

            foreach (Transform panel in _playerResultPanelContainer.transform)
                Destroy(panel.gameObject);

            foreach (var player in _minigameManager.GetPlayers())
            {
                var panelInst = Instantiate(_playerResultPanelPrefab, _playerResultPanelContainer).GetComponent<PlayerResultPanel>();
                int pointChange = 0;
                foreach (var result in results)
                    if (result.Player == player.Index)
                    {
                        pointChange = result.Points;
                        break;
                    }

                panelInst.Construct(player, pointChange);
            }
            _playerResultsOverlay.SetActive(true);

            await UniTask.WaitForSeconds(5f, true);

            _minigameManager.EndGame();
        }
    }
}