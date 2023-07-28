using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Game
{
    public class PlayerPanel : MonoBehaviour
    {
        static readonly Dictionary<int, KeyCode> PlayerKeybinds = new Dictionary<int, KeyCode>()
        {
            { 1, KeyCode.Q},
            { 2, KeyCode.R},
            { 3, KeyCode.U},
            { 4, KeyCode.P},
            { 5, KeyCode.Z},
            { 6, KeyCode.V},
            { 7, KeyCode.M},
            { 8, KeyCode.Question},
        };

        public PlayerData PlayerData { get; private set; }
        public int Points { get; private set; } = 0;

        [Header("Dependencies")]
        [SerializeField]
        private Image _bgOutline;
        [SerializeField]
        private TextMeshProUGUI _playerText;
        [SerializeField]
        private TextMeshProUGUI _pointsText;
        [SerializeField]
        private Button _clickButton;
        [SerializeField]
        private TextMeshProUGUI _clickButtonText;

        private KeyCode _keybind;
        private PauseControl _pauseControl;

        public void Construct(PlayerData playerData, PauseControl pauseControl)
        {
            PlayerData = playerData;
            _keybind = PlayerKeybinds[playerData.Number];
            _bgOutline.color = playerData.Color;
            _clickButton.onClick.AddListener(OnClick);
            _clickButtonText.text = $"Click {char.ToUpper((char)_keybind)}";
            _pauseControl = pauseControl;
            _playerText.text = $"Player {playerData.Number}";
            _pointsText.text = Points.ToString();
        }

        private void Update()
        {
            if (_pauseControl != null && !_pauseControl.IsPaused && Input.GetKeyUp(_keybind))
                OnClick();
        }

        private void OnClick()
        {
            Points++;
            _pointsText.text = Points.ToString();
        }
    }
}