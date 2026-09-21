using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace TimeLoopDetective
{
    // Converts the existing Godot JSON schema into typed Unity data while preserving dictionary keys.
    public static class JsonDictionaryParser
    {
        public static CaseData ParseCase(string json)
        {
            var root = MiniJson.Deserialize(json) as Dictionary<string, object>;
            if (root == null) return null;
            var c = new CaseData {
                id = S(root,"id"), title=S(root,"title"), subtitle=S(root,"subtitle"),
                start_location=S(root,"start_location"), max_actions=I(root,"max_actions",8),
                loop_reset_text=S(root,"loop_reset_text"), culprit=S(root,"culprit"),
                required_contradiction=S(root,"required_contradiction"),
                deduction_prompt=S(root,"deduction_prompt"), truth=S(root,"truth"),
                partial=S(root,"partial"), wrong=S(root,"wrong")
            };
            c.timeline = SL(root,"timeline");
            c.strong_clues = SL(root,"strong_clues");

            if (root.TryGetValue("locations", out var lo) && lo is Dictionary<string,object> ld)
                foreach (var kv in ld) if (kv.Value is Dictionary<string,object> x)
                    c.locations[kv.Key] = new LocationData { name=S(x,"name"), art=S(x,"art"), description=S(x,"description"), people=SL(x,"people") };

            if (root.TryGetValue("suspects", out var so) && so is Dictionary<string,object> sd)
                foreach (var kv in sd) if (kv.Value is Dictionary<string,object> x) {
                    var s = new SuspectData { name=S(x,"name"), role=S(x,"role"), art=S(x,"art"), dialogue=SL(x,"dialogue") };
                    if (x.TryGetValue("contradiction", out var co) && co is Dictionary<string,object> cd)
                        s.contradiction = new ContradictionData { id=S(cd,"id"), needs=SL(cd,"needs"), result=S(cd,"result") };
                    c.suspects[kv.Key] = s;
                }

            if (root.TryGetValue("clues", out var clo) && clo is Dictionary<string,object> cld)
                foreach (var kv in cld) if (kv.Value is Dictionary<string,object> x)
                    c.clues[kv.Key] = new ClueData { name=S(x,"name"), art=S(x,"art"), location=S(x,"location"), description=S(x,"description") };
            return c;
        }

        static string S(Dictionary<string,object> d,string k) => d.TryGetValue(k,out var v) ? Convert.ToString(v) ?? "" : "";
        static int I(Dictionary<string,object> d,string k,int def) => d.TryGetValue(k,out var v) ? Convert.ToInt32(v) : def;
        static List<string> SL(Dictionary<string,object> d,string k) {
            var r=new List<string>(); if (!d.TryGetValue(k,out var v) || v is not IList a) return r;
            foreach (var x in a) r.Add(Convert.ToString(x) ?? ""); return r;
        }
    }
}
