using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace TimeLoopDetective
{
    public static class CaseJsonLoader
    {
        [Serializable] class CaseWrapper { public CaseData data; }

        public static List<CaseData> LoadAll()
        {
            var list = new List<CaseData>();
            var dir = Path.Combine(Application.streamingAssetsPath, "Cases");
            if (!Directory.Exists(dir)) return list;
            foreach (var path in Directory.GetFiles(dir, "case_*.json"))
            {
                var json = File.ReadAllText(path);
                var parsed = JsonDictionaryParser.ParseCase(json);
                if (parsed != null) list.Add(parsed);
            }
            list.Sort((a,b) => string.CompareOrdinal(a.id,b.id));
            return list;
        }
    }
}
