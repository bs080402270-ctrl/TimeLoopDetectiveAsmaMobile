# Unity Port Working Branch

Branch: `unity-port`

This branch is the isolated Unity conversion of Time Loop Detective. Do not merge to `main` until the Unity Android build, gameplay flow and visual polish are approved.

## Ported
- Five case JSON files
- Save/progress model
- Three-loop gameplay
- Clue collection
- Suspect interrogation
- Contradiction checks
- Final accusation/endings
- Easy / Hard / Hardest rules
- Noir/gold runtime mobile UI
- Settings
- Android build method

## Android CI
The Unity workflow uses GameCI. Add repository secrets:
- `UNITY_LICENSE`
- `UNITY_EMAIL`
- `UNITY_PASSWORD`

Then run **Build Unity Android Port**. The APK artifact will be named `TimeLoopDetective-Unity-Android`.

## Merge rule
Keep all Unity conversion work on `unity-port`. Merge into `main` only after device testing and final approval.
