using System.IO;
using UnityEngine;

namespace TimeLoopDetective
{
    public static class SaveManager
    {
        static string PathFor(string caseId) => Path.Combine(Application.persistentDataPath, caseId + ".json");

        public static GameState Load(string caseId, string startLocation)
        {
            var path = PathFor(caseId);
            if (File.Exists(path))
            {
                try
                {
                    var loaded = JsonUtility.FromJson<GameState>(File.ReadAllText(path));
                    if (loaded != null) return loaded;
                }
                catch { }
            }
            return new GameState { case_id = caseId, location = startLocation };
        }

        public static void Save(string caseId, GameState state)
        {
            File.WriteAllText(PathFor(caseId), JsonUtility.ToJson(state, true));
        }

        public static void Clear(string caseId)
        {
            var path = PathFor(caseId);
            if (File.Exists(path)) File.Delete(path);
        }

        public static bool HasSave(string caseId) => File.Exists(PathFor(caseId));
    }
}
