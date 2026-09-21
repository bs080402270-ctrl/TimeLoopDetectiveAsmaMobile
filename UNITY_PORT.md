# Unity Port Working Branch

Branch: `unity-port`

This branch contains the isolated Unity conversion of Time Loop Detective. Keep it separate from `main` until the Unity Android build, gameplay flow, and visual polish are approved.

## Ported
- Five case JSON files
- Android-safe case loading from Unity Resources
- Save/progress model
- Three-loop gameplay
- Clue collection
- Suspect interrogation
- Contradiction checks
- Final accusation/endings
- Easy / Hard / Hardest rules
- Noir/gold runtime mobile UI
- Settings
- Android local build menu

## Open locally
1. Clone or pull the repository.
2. Check out `unity-port`.
3. In Unity Hub choose **Add project from disk**.
4. Select the repository's `Unity` folder.
5. Open it with Unity 6.
6. Let Unity import packages and assets.
7. Use **Time Loop Detective > Build Android APK**.

The local APK output is:
`Unity/Builds/Android/TimeLoopDetective-Unity.apk`

There is intentionally no Unity GitHub Actions workflow. Android builds are local so no Unity CI license secret is required.

## Merge rule
Do not merge into `main` until the Unity version is opened, built, device-tested, and visually approved.
