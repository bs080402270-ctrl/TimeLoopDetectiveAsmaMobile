using System.IO;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace TimeLoopDetective.Editor
{
    public static class AndroidBuild
    {
        const string ScenePath = "Assets/Scenes/Main.unity";
        const string BuildDir = "Builds/Android";

        [MenuItem("Time Loop Detective/Build Android APK")]
        public static void BuildAndroidApk()
        {
            ConfigureAndroid(false);
            Build("Builds/Android/TimeLoopDetective-Unity.apk");
        }

        [MenuItem("Time Loop Detective/Build Android AAB")]
        public static void BuildAndroidAab()
        {
            ConfigureAndroid(true);
            Build("Builds/Android/TimeLoopDetective-Unity.aab");
        }

        static void ConfigureAndroid(bool appBundle)
        {
            Directory.CreateDirectory("Assets/Scenes");
            var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
            EditorSceneManager.SaveScene(scene, ScenePath);

            PlayerSettings.productName = "Time Loop Detective";
            PlayerSettings.companyName = "ZetaRank";
            PlayerSettings.SetApplicationIdentifier(BuildTargetGroup.Android, "com.zetarank.timeloopdetective");
            PlayerSettings.defaultInterfaceOrientation = UIOrientation.Portrait;
            PlayerSettings.Android.bundleVersionCode = 15;
            PlayerSettings.bundleVersion = "1.2.4-unity";
            PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel26;
            PlayerSettings.Android.targetSdkVersion = AndroidSdkVersions.AndroidApiLevel36;
            PlayerSettings.SetScriptingBackend(BuildTargetGroup.Android, ScriptingImplementation.IL2CPP);
            PlayerSettings.Android.targetArchitectures = AndroidArchitecture.ARM64 | AndroidArchitecture.ARMv7;

            var icon = AssetDatabase.LoadAssetAtPath<Texture2D>("Assets/Resources/Art/Generated/AppIcon.jpg");
            if (icon != null)
            {
                var sizes = PlayerSettings.GetIconSizes(NamedBuildTarget.Android, IconKind.Application);
                var icons = new Texture2D[sizes.Length];
                for (int i = 0; i < icons.Length; i++) icons[i] = icon;
                PlayerSettings.SetIcons(NamedBuildTarget.Android, icons, IconKind.Application);
            }

            EditorUserBuildSettings.buildAppBundle = appBundle;
        }

        static void Build(string outputPath)
        {
            Directory.CreateDirectory(BuildDir);
            var options = new BuildPlayerOptions
            {
                scenes = new[] { ScenePath },
                locationPathName = outputPath,
                target = BuildTarget.Android,
                options = BuildOptions.None
            };

            var report = BuildPipeline.BuildPlayer(options);
            if (report.summary.result != BuildResult.Succeeded)
                throw new System.Exception("Android build failed: " + report.summary.result);

            Debug.Log("Android build created: " + outputPath);
        }

        public static void BuildAndroidFromCI()
        {
            BuildAndroidApk();
        }
    }
}
