using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace TimeLoopDetective.Editor
{
    [InitializeOnLoad]
    public static class ProjectValidator
    {
        static ProjectValidator()
        {
            EditorApplication.delayCall += ValidateQuietly;
        }

        [MenuItem("Time Loop Detective/Validate Project")]
        public static void ValidateFromMenu()
        {
            Validate(true);
        }

        static void ValidateQuietly()
        {
            Validate(false);
        }

        static void Validate(bool verbose)
        {
            var cases = CaseJsonLoader.LoadAll();
            var errors = new List<string>();

            if (cases.Count != 5)
                errors.Add("Expected 5 cases but found " + cases.Count + ".");

            foreach (var c in cases)
            {
                if (string.IsNullOrEmpty(c.id)) errors.Add("A case is missing an id.");
                if (string.IsNullOrEmpty(c.title)) errors.Add(c.id + ": missing title.");
                if (string.IsNullOrEmpty(c.start_location) || !c.locations.ContainsKey(c.start_location))
                    errors.Add(c.id + ": invalid start location.");
                if (string.IsNullOrEmpty(c.culprit) || !c.suspects.ContainsKey(c.culprit))
                    errors.Add(c.id + ": culprit is missing from suspects.");
                if (c.locations.Count < 1) errors.Add(c.id + ": no locations.");
                if (c.suspects.Count < 1) errors.Add(c.id + ": no suspects.");
                if (c.clues.Count < 1) errors.Add(c.id + ": no clues.");
                if (c.strong_clues == null || c.strong_clues.Count < 1)
                    errors.Add(c.id + ": no strong clues.");

                if (c.strong_clues != null)
                    foreach (var clue in c.strong_clues.Where(x => !c.clues.ContainsKey(x)))
                        errors.Add(c.id + ": strong clue '" + clue + "' does not exist.");

                if (!string.IsNullOrEmpty(c.required_contradiction))
                {
                    bool exists = c.suspects.Values.Any(s => s.contradiction != null && s.contradiction.id == c.required_contradiction);
                    if (!exists) errors.Add(c.id + ": required contradiction does not exist.");
                }

                foreach (var loc in c.locations)
                    foreach (var person in loc.Value.people.Where(x => !c.suspects.ContainsKey(x)))
                        errors.Add(c.id + ": location '" + loc.Key + "' references missing suspect '" + person + "'.");

                foreach (var clue in c.clues)
                    if (!c.locations.ContainsKey(clue.Value.location))
                        errors.Add(c.id + ": clue '" + clue.Key + "' references missing location '" + clue.Value.location + "'.");

                foreach (var suspect in c.suspects)
                {
                    if (suspect.Value.contradiction == null) continue;
                    foreach (var need in suspect.Value.contradiction.needs.Where(x => !c.clues.ContainsKey(x)))
                        errors.Add(c.id + ": suspect '" + suspect.Key + "' contradiction references missing clue '" + need + "'.");
                }
            }

            if (errors.Count == 0)
            {
                if (verbose) Debug.Log("Time Loop Detective validation passed: 5 cases and all core references are valid.");
                return;
            }

            foreach (var error in errors) Debug.LogError("Time Loop Detective validation: " + error);
        }
    }
}
