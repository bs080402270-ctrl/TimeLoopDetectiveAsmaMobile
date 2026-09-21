using System;
using System.IO;
using System.IO.Compression;
using UnityEditor;
using UnityEngine;

namespace TimeLoopDetective.Editor
{
    [InitializeOnLoad]
    public static class ArtInstaller
    {
        const string ZipPath = "Assets/ArtAssets.zip";
        const string OutputPath = "Assets/Resources/Art";
        const string MarkerPath = "Assets/Resources/Art/.installed";

        static ArtInstaller()
        {
            EditorApplication.delayCall += EnsureInstalled;
        }

        public static void EnsureInstalled()
        {
            if (!File.Exists(ZipPath)) return;
            if (File.Exists(MarkerPath)) return;

            Directory.CreateDirectory(OutputPath);
            using (var file = File.OpenRead(ZipPath))
            using (var archive = new ZipArchive(file, ZipArchiveMode.Read))
            {
                foreach (var entry in archive.Entries)
                {
                    if (string.IsNullOrEmpty(entry.Name)) continue;
                    var relative = entry.FullName.Replace('\\', '/');
                    if (relative.Contains("..")) continue;
                    var destination = Path.Combine(OutputPath, relative);
                    var directory = Path.GetDirectoryName(destination);
                    if (!string.IsNullOrEmpty(directory)) Directory.CreateDirectory(directory);
                    using (var input = entry.Open())
                    using (var output = File.Create(destination))
                        input.CopyTo(output);
                }
            }

            File.WriteAllText(MarkerPath, "Time Loop Detective optimized art installed.");
            AssetDatabase.Refresh();
            Debug.Log("Time Loop Detective: optimized game art installed.");
        }
    }
}
