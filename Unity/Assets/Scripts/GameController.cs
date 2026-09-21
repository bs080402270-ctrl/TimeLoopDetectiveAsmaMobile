using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace TimeLoopDetective
{
    public class GameController : MonoBehaviour
    {
        public List<CaseData> Cases { get; private set; } = new();
        public CaseData CurrentCase { get; private set; }
        public GameState State { get; private set; }

        public void Awake() => Cases = CaseJsonLoader.LoadAll();

        public bool OpenCase(string caseId)
        {
            CurrentCase = Cases.FirstOrDefault(x => x.id == caseId);
            if (CurrentCase == null) return false;
            State = SaveManager.Load(CurrentCase.id, CurrentCase.start_location);
            return true;
        }

        public void StartNew()
        {
            SaveManager.Clear(CurrentCase.id);
            State = new GameState { started=true, case_id=CurrentCase.id, loop=1, action=0, location=CurrentCase.start_location };
            Save();
        }

        public int EffectiveMaxActions()
        {
            var b=CurrentCase?.max_actions ?? 8;
            return SettingsManager.Difficulty switch {
                DifficultyMode.Easy => b+2,
                DifficultyMode.Hardest => Mathf.Max(4,b-2),
                _ => b
            };
        }

        public int RequiredStrongClues()
        {
            var n=CurrentCase?.strong_clues?.Count ?? 0;
            return SettingsManager.Difficulty switch {
                DifficultyMode.Easy => Mathf.Min(3,n),
                DifficultyMode.Hardest => n,
                _ => Mathf.Min(4,n)
            };
        }

        public void Travel(string location){ State.location=location; Save(); }
        public void AddClue(string clue){ if(!State.clues.Contains(clue)) State.clues.Add(clue); SpendAction(); }
        public void Talk(string suspect){ if(!State.talked.Contains(suspect)) State.talked.Add(suspect); SpendAction(); }

        public bool TryContradiction(string suspectId)
        {
            if(!CurrentCase.suspects.TryGetValue(suspectId,out var s)) return false;
            if(s.contradiction?.needs == null || s.contradiction.needs.Count==0) return false;
            var ok=s.contradiction.needs.All(State.clues.Contains);
            if(ok && !State.contradictions.Contains(s.contradiction.id)) State.contradictions.Add(s.contradiction.id);
            Save(); return ok;
        }

        public void ResetLoop()
        {
            if(State.loop<3) State.loop++;
            State.action=0; State.location=CurrentCase.start_location; Save();
        }

        public string Accuse(string suspectId)
        {
            int strong=CurrentCase.strong_clues.Count(State.clues.Contains);
            bool required=State.contradictions.Contains(CurrentCase.required_contradiction);
            string result = suspectId==CurrentCase.culprit && strong>=RequiredStrongClues() && required ? "true" :
                            suspectId==CurrentCase.culprit && strong>=2 ? "partial" : "wrong";
            State.ending=result; Save(); return result;
        }

        public void SpendAction(){ State.action=Mathf.Min(State.action+1,EffectiveMaxActions()); Save(); }
        void Save()=>SaveManager.Save(CurrentCase.id,State);
    }
}
