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

            string[] requiredArt = {
                "Assets/Resources/Art/Generated/MainMenu.jpg",
                "Assets/Resources/Art/Generated/AppIcon.jpg",
                "Assets/Resources/Art/Generated/InvestigationDesk.jpg",
                "Assets/Resources/Art/Generated/EvidenceRoom.jpg",
                "Assets/Resources/Art/Generated/DetectiveOffice.jpg",
                "Assets/Resources/Art/Generated/FinalDeduction.jpg"
            };
            foreach (var path in requiredArt)
                if (AssetDatabase.LoadAssetAtPath<Texture2D>(path) == null)
                    Debug.LogError("Release QA: generated artwork is missing: " + path);

            Debug.Log("Release QA static checks finished. Continue with Play Mode, APK device test and AAB signing test.");
        }
    }
}
