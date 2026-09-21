using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace TimeLoopDetective
{
    public class GameController : MonoBehaviour
    {
        public List<CaseData> Cases { get; private set; } = new List<CaseData>();
        public CaseData CurrentCase { get; private set; }
        public GameState State { get; private set; }

        public void Awake()
        {
            Cases = CaseJsonLoader.LoadAll();
        }

        public bool OpenCase(string caseId)
        {
            CurrentCase = Cases.FirstOrDefault(x => x.id == caseId);
            if (CurrentCase == null) return false;
            State = SaveManager.Load(CurrentCase.id, CurrentCase.start_location);
            return true;
        }

        public void StartNew()
        {
            if (CurrentCase == null) return;
            SaveManager.Clear(CurrentCase.id);
            State = new GameState
            {
                started = true,
                case_id = CurrentCase.id,
                loop = 1,
                action = 0,
                location = CurrentCase.start_location
            };
            Save();
        }

        public int EffectiveMaxActions()
        {
            var b = CurrentCase != null ? CurrentCase.max_actions : 8;
            switch (SettingsManager.Difficulty)
            {
                case DifficultyMode.Easy: return b + 2;
                case DifficultyMode.Hardest: return Mathf.Max(4, b - 2);
                default: return b;
            }
        }

        public int RequiredStrongClues()
        {
            var n = CurrentCase != null && CurrentCase.strong_clues != null ? CurrentCase.strong_clues.Count : 0;
            switch (SettingsManager.Difficulty)
            {
                case DifficultyMode.Easy: return Mathf.Min(3, n);
                case DifficultyMode.Hardest: return n;
                default: return Mathf.Min(4, n);
            }
        }

        public bool CanAct()
        {
            return State != null && State.action < EffectiveMaxActions();
        }

        public bool CanResetLoop()
        {
            return State != null && State.loop < 3;
        }

        public void Travel(string location)
        {
            if (State == null || CurrentCase == null || !CurrentCase.locations.ContainsKey(location)) return;
            State.location = location;
            Save();
        }

        public bool AddClue(string clue)
        {
            if (State == null || CurrentCase == null || !CurrentCase.clues.ContainsKey(clue)) return false;
            if (State.clues.Contains(clue)) return true;
            if (!CanAct()) return false;

            State.clues.Add(clue);
            SpendAction();
            return true;
        }

        public bool Talk(string suspect)
        {
            if (State == null || CurrentCase == null || !CurrentCase.suspects.ContainsKey(suspect)) return false;
            if (!CanAct() && !State.talked.Contains(suspect)) return false;

            if (!State.talked.Contains(suspect))
            {
                State.talked.Add(suspect);
                SpendAction();
            }
            return true;
        }

        public bool TryContradiction(string suspectId)
        {
            if (State == null || CurrentCase == null) return false;
            SuspectData suspect;
            if (!CurrentCase.suspects.TryGetValue(suspectId, out suspect)) return false;
            if (suspect.contradiction == null || suspect.contradiction.needs == null || suspect.contradiction.needs.Count == 0) return false;

            var ok = suspect.contradiction.needs.All(State.clues.Contains);
            if (ok && !State.contradictions.Contains(suspect.contradiction.id))
                State.contradictions.Add(suspect.contradiction.id);

            Save();
            return ok;
        }

        public bool ResetLoop()
        {
            if (State == null || CurrentCase == null || !CanResetLoop()) return false;
            State.loop++;
            State.action = 0;
            State.location = CurrentCase.start_location;
            Save();
            return true;
        }

        public string Accuse(string suspectId)
        {
            if (State == null || CurrentCase == null) return "wrong";

            int strong = CurrentCase.strong_clues.Count(State.clues.Contains);
            bool required = State.contradictions.Contains(CurrentCase.required_contradiction);

            string result =
                suspectId == CurrentCase.culprit && strong >= RequiredStrongClues() && required ? "true" :
                suspectId == CurrentCase.culprit && strong >= 2 ? "partial" :
                "wrong";

            State.ending = result;
            Save();
            return result;
        }

        public void SpendAction()
        {
            if (State == null) return;
            State.action = Mathf.Min(State.action + 1, EffectiveMaxActions());
            Save();
        }

        void Save()
        {
            if (CurrentCase != null && State != null)
                SaveManager.Save(CurrentCase.id, State);
        }
    }
}
