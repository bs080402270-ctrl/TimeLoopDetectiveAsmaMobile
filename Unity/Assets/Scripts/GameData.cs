using System;
using System.Collections.Generic;

namespace TimeLoopDetective
{
    [Serializable] public class CaseCatalog { public List<CaseData> cases = new(); }
    [Serializable] public class CaseData
    {
        public string id;
        public string title;
        public string subtitle;
        public string start_location;
        public int max_actions;
        public string loop_reset_text;
        public SerializableDictionary<string, LocationData> locations = new();
        public SerializableDictionary<string, SuspectData> suspects = new();
        public SerializableDictionary<string, ClueData> clues = new();
        public List<string> timeline = new();
        public string culprit;
        public List<string> strong_clues = new();
        public string required_contradiction;
        public string deduction_prompt;
        public string truth;
        public string partial;
        public string wrong;
    }

    [Serializable] public class LocationData
    {
        public string name;
        public string art;
        public string description;
        public List<string> people = new();
    }

    [Serializable] public class SuspectData
    {
        public string name;
        public string role;
        public string art;
        public List<string> dialogue = new();
        public ContradictionData contradiction = new();
    }

    [Serializable] public class ContradictionData
    {
        public string id;
        public List<string> needs = new();
        public string result;
    }

    [Serializable] public class ClueData
    {
        public string name;
        public string art;
        public string location;
        public string description;
    }

    [Serializable] public class SerializableDictionary<TKey,TValue> : Dictionary<TKey,TValue> { }
}
