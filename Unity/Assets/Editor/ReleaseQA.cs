using UnityEditor;
using UnityEngine;

namespace TimeLoopDetective.Editor
{
    public static class ReleaseQA
    {
        [MenuItem("Time Loop Detective/Run Release QA")]
        public static void Run()
        {
            Debug.Log("Time Loop Detective release QA started.");
            ProjectValidator.ValidateFromMenu();
            GameplaySelfTest.Run();

            if (PlayerSettings.Android.minSdkVersion != AndroidSdkVersions.AndroidApiLevel26)
                Debug.LogWarning("Release QA: minimum Android API is not 26.");

            if (PlayerSettings.Android.targetSdkVersion != AndroidSdkVersions.AndroidApiLevel36)
                Debug.LogWarning("Release QA: target Android API is not 36.");

            var icon = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Resources/Art/Generated/AppIcon.jpg");
            if (icon == null)
                Debug.LogError("Release QA: Android app icon asset is missing.");

            var menu = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Resources/Art/Generated/MainMenu.jpg");
            if (menu == null)
                Debug.LogError("Release QA: generated main-menu artwork is missing.");

            Debug.Log("Release QA static checks finished. Continue with Play Mode, APK device test and AAB signing test.");
        }
    }
}
