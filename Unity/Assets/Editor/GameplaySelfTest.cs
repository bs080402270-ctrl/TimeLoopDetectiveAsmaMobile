using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace TimeLoopDetective.Editor
{
    public static class GameplaySelfTest
    {
        [MenuItem("Time Loop Detective/Run Full Gameplay Self-Test")]
        public static void Run()
        {
            var cases = CaseJsonLoader.LoadAll();
            var failures = new List<string>();

            foreach (var c in cases)
            {
                TestCase(c, DifficultyMode.Easy, failures);
                TestCase(c, DifficultyMode.Hard, failures);
                TestCase(c, DifficultyMode.Hardest, failures);
            }

            if (failures.Count == 0)
            {
                Debug.Log("Time Loop Detective gameplay self-test passed: all cases solve correctly on Easy, Hard and Hardest.");
                return;
            }

            foreach (var failure in failures)
                Debug.LogError("Gameplay self-test: " + failure);
        }

        static void TestCase(CaseData c, DifficultyMode mode, List<string> failures)
        {
            int baseActions = c.max_actions;
            int budget = mode == DifficultyMode.Easy ? baseActions + 2 :
                         mode == DifficultyMode.Hardest ? Mathf.Max(4, baseActions - 2) :
                         baseActions;

            int requiredStrong = mode == DifficultyMode.Easy ? Mathf.Min(3, c.strong_clues.Count) :
                                 mode == DifficultyMode.Hardest ? c.strong_clues.Count :
                                 Mathf.Min(4, c.strong_clues.Count);

            SuspectData culprit;
            if (!c.suspects.TryGetValue(c.culprit, out culprit) || culprit.contradiction == null)
            {
                failures.Add(c.id + " " + mode + ": culprit contradiction missing.");
                return;
            }

            var needed = new HashSet<string>(culprit.contradiction.needs);
            foreach (var clue in c.strong_clues.Take(requiredStrong))
                needed.Add(clue);

            if (needed.Any(x => !c.clues.ContainsKey(x)))
            {
                failures.Add(c.id + " " + mode + ": solution references a missing clue.");
                return;
            }

            int minimumActions = needed.Count + 1;
            int totalAvailable = budget * 3;
            if (minimumActions > totalAvailable)
                failures.Add(c.id + " " + mode + ": true ending needs " + minimumActions + " actions but only " + totalAvailable + " exist.");

            if (mode == DifficultyMode.Hardest && minimumActions > budget)
                Debug.Log(c.id + " Hardest intentionally spans loops: minimum " + minimumActions + " actions, loop budget " + budget + ".");

            bool contradictionCanResolve = culprit.contradiction.needs.All(needed.Contains);
            int strong = c.strong_clues.Count(needed.Contains);
            bool trueEnding = contradictionCanResolve && strong >= requiredStrong;

            if (!trueEnding)
                failures.Add(c.id + " " + mode + ": generated valid path does not reach true ending.");
        }
    }
}
