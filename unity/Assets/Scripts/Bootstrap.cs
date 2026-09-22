using UnityEngine;

namespace TimeLoopDetective
{
    public sealed class Bootstrap : MonoBehaviour
    {
        private void Awake()
        {
            Application.targetFrameRate = 60;
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Debug.Log("Time Loop Detective Unity scaffold loaded.");
        }
    }
}
