using UnityEngine;

namespace TimeLoopDetective
{
    public static class SettingsManager
    {
        const string DifficultyKey = "difficulty";
        const string GraphicsKey = "graphics";
        const string TextSizeKey = "text_size";
        const string VibrationKey = "vibration";
        const string TutorialKey = "tutorial_seen";

        public static DifficultyMode Difficulty
        {
            get { return (DifficultyMode)PlayerPrefs.GetInt(DifficultyKey, (int)DifficultyMode.Hard); }
            set { PlayerPrefs.SetInt(DifficultyKey, (int)value); PlayerPrefs.Save(); }
        }

        public static bool EnhancedGraphics
        {
            get { return PlayerPrefs.GetInt(GraphicsKey, 1) == 1; }
            set { PlayerPrefs.SetInt(GraphicsKey, value ? 1 : 0); PlayerPrefs.Save(); ApplyRuntime(); }
        }

        public static int TextSize
        {
            get { return PlayerPrefs.GetInt(TextSizeKey, 0); }
            set { PlayerPrefs.SetInt(TextSizeKey, Mathf.Clamp(value, 0, 2)); PlayerPrefs.Save(); }
        }

        public static bool Vibration
        {
            get { return PlayerPrefs.GetInt(VibrationKey, 1) == 1; }
            set { PlayerPrefs.SetInt(VibrationKey, value ? 1 : 0); PlayerPrefs.Save(); }
        }

        public static bool TutorialSeen
        {
            get { return PlayerPrefs.GetInt(TutorialKey, 0) == 1; }
            set { PlayerPrefs.SetInt(TutorialKey, value ? 1 : 0); PlayerPrefs.Save(); }
        }

        public static void ApplyRuntime()
        {
            Application.targetFrameRate = EnhancedGraphics ? 60 : 30;
            QualitySettings.vSyncCount = 0;
        }

        public static void Haptic()
        {
#if UNITY_ANDROID || UNITY_IOS
            if (Vibration) Handheld.Vibrate();
#endif
        }
    }
}
