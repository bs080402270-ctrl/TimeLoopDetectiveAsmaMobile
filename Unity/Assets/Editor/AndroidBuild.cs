using System.IO;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace TimeLoopDetective.Editor
{
    public static class AndroidBuild
    {
        [MenuItem("Time Loop Detective/Build Android APK")]
        public static void BuildAndroid()
        {
            ArtInstaller.EnsureInstalled();
            AssetDatabase.Refresh();
            const string scenePath = "Assets/Scenes/Main.unity";
            Directory.CreateDirectory("Assets/Scenes");
            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            EditorSceneManager.SaveScene(scene, scenePath);

            PlayerSettings.productName = "Time Loop Detective";
            PlayerSettings.companyName = "ZetaRank";
            PlayerSettings.SetApplicationIdentifier(BuildTargetGroup.Android, "com.zetarank.timeloopdetective");
            PlayerSettings.defaultInterfaceOrientation = UIOrientation.Portrait;
            PlayerSettings.Android.bundleVersionCode = 13;
            PlayerSettings.bundleVersion = "1.2.2-unity";
            PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel26;
            PlayerSettings.Android.targetSdkVersion = AndroidSdkVersions.AndroidApiLevelAuto;
            PlayerSettings.Android.targetArchitectures = AndroidArchitecture.ARM64 | AndroidArchitecture.ARMv7;

            Directory.CreateDirectory("Builds/Android");
            var options = new BuildPlayerOptions {
                scenes = new[] { scenePath },
                locationPathName = "Builds/Android/TimeLoopDetective-Unity.apk",
                target = BuildTarget.Android,
                options = BuildOptions.None
            };
            var report = BuildPipeline.BuildPlayer(options);
            if (report.summary.result != BuildResult.Succeeded)
                throw new System.Exception("Android build failed: " + report.summary.result);
            Debug.Log("Android APK built: " + options.locationPathName);
        }

        public static void BuildAndroidFromCI() => BuildAndroid();
    }
}
