# TimeLoopDetectiveAsmaMobile

A Unity Android starter for **Time Loop Detective**.

## What is included

- Unity 2022.3 LTS project scaffold
- Android build workflow using GitHub Actions
- Manual workflow dispatch for on-demand APK builds
- A minimal playable bootstrap scene placeholder

## Getting started

1. Install Unity Hub and Unity 2022.3 LTS with Android Build Support.
2. Clone this repository and open it in Unity.
3. Open `Assets/Scenes/Main.unity`.
4. Press Play to run the starter scene.

## Android build automation

The workflow at `.github/workflows/android-build.yml` builds a debug APK on pushes to `main` and can also be started manually.

For a real Unity build, add these repository secrets:

- `UNITY_EMAIL`
- `UNITY_PASSWORD`
- `UNITY_LICENSE` (recommended for a serial-less activation setup)

Then use **Actions > Build Android APK > Run workflow**. The APK is uploaded as a workflow artifact.

## Next milestone

Build the first 15-minute vertical slice: one cafe, three suspects, three loops, five clues, and two endings.
