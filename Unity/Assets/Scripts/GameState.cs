using System;
using System.Collections.Generic;

namespace TimeLoopDetective
{
    [Serializable]
    public class GameState
    {
        public bool started;
        public string case_id;
        public int loop = 1;
        public int action;
        public string location;
        public List<string> clues = new();
        public List<string> contradictions = new();
        public List<string> talked = new();
        public string ending = "";
    }

    public enum DifficultyMode { Easy, Hard, Hardest }
}
