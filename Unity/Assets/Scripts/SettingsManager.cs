using UnityEngine;

namespace TimeLoopDetective
{
    public static class SettingsManager
    {
        const string DifficultyKey = "difficulty";
        const string GraphicsKey = "graphics";
        const string TextSizeKey = "text_size";
        const string VibrationKey = "vibration";

        public static DifficultyMode Difficulty
        {
            get => (DifficultyMode)PlayerPrefs.GetInt(DifficultyKey, (int)DifficultyMode.Hard);
            set { PlayerPrefs.SetInt(DifficultyKey, (int)value); PlayerPrefs.Save(); }
        }

        public static bool EnhancedGraphics
        {
            get => PlayerPrefs.GetInt(GraphicsKey, 1) == 1;
            set { PlayerPrefs.SetInt(GraphicsKey, value ? 1 : 0); PlayerPrefs.Save(); }
        }

        public static int TextSize
        {
            get => PlayerPrefs.GetInt(TextSizeKey, 0);
            set { PlayerPrefs.SetInt(TextSizeKey, Mathf.Clamp(value,0,2)); PlayerPrefs.Save(); }
        }

        public static bool Vibration
        {
            get => PlayerPrefs.GetInt(VibrationKey, 1) == 1;
            set { PlayerPrefs.SetInt(VibrationKey, value ? 1 : 0); PlayerPrefs.Save(); }
        }
    }
}
