using System;
using System.Collections.Generic;

namespace TimeLoopDetective
{
    [Serializable] public class CaseCatalog { public List<CaseData> cases = new List<CaseData>(); }
    [Serializable] public class CaseData
    {
        public string id;
        public string title;
        public string subtitle;
        public string start_location;
        public int max_actions;
        public string loop_reset_text;
        public SerializableDictionary<string, LocationData> locations = new SerializableDictionary<string, LocationData>();
        public SerializableDictionary<string, SuspectData> suspects = new SerializableDictionary<string, SuspectData>();
        public SerializableDictionary<string, ClueData> clues = new SerializableDictionary<string, ClueData>();
        public List<string> timeline = new List<string>();
        public string culprit;
        public List<string> strong_clues = new List<string>();
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
        public List<string> people = new List<string>();
    }

    [Serializable] public class SuspectData
    {
        public string name;
        public string role;
        public string art;
        public List<string> dialogue = new List<string>();
        public ContradictionData contradiction = new ContradictionData();
    }

    [Serializable] public class ContradictionData
    {
        public string id;
        public List<string> needs = new List<string>();
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
