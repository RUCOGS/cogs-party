using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace Game
{
    public class PlayerResultPanel : MonoBehaviour
    {
        [SerializeField]
        private Image _bgOutline;
        [SerializeField]
        private TextMeshProUGUI _playerText;
        [SerializeField]
        private TextMeshProUGUI _pointsChangeText;
        [SerializeField]
        private TextMeshProUGUI _pointsText;

        public void Construct(PlayerData playerData, int scoreChange)
        {
            _playerText.text = $"Player {playerData.Number}";
            if (scoreChange > 0)
                _pointsChangeText.text = $"+{scoreChange}";
            else if (scoreChange < 0)
                _pointsChangeText.text = scoreChange.ToString();
            else
                _pointsChangeText.text = "X";
            _pointsText.text = playerData.Points.ToString();
            _bgOutline.color = playerData.Color;
        }
    }
}