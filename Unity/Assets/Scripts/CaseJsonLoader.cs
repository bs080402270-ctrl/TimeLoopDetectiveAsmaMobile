using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace TimeLoopDetective
{
    public static class CaseJsonLoader
    {
        public static List<CaseData> LoadAll()
        {
            var list = new List<CaseData>();
            var assets = Resources.LoadAll<TextAsset>("Cases");
            foreach (var asset in assets)
            {
                if (asset == null || !asset.name.StartsWith("case_")) continue;
                var parsed = JsonDictionaryParser.ParseCase(asset.text);
                if (parsed != null) list.Add(parsed);
            }
            return list.OrderBy(x => x.id).ToList();
        }
    }
}
