using UnityEngine;

namespace Game
{
    public class PauseControl : MonoBehaviour
    {
        public bool IsPaused { get; private set; }
        private float _prevTimeScale;

        public void TogglePause() => SetPause(!IsPaused);

        public void SetPause(bool isPaused)
        {
            IsPaused = isPaused;
            if (IsPaused)
            {
                _prevTimeScale = Time.timeScale;
                Time.timeScale = 0;
                AudioListener.pause = true;
            }
            else
            {
                Time.timeScale = _prevTimeScale;
                AudioListener.pause = true;
            }
        }
    }
}