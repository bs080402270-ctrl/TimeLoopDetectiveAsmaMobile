# Unity Port Working Branch

Branch: `unity-port`

This branch contains the isolated Unity conversion of Time Loop Detective. Keep it separate from `main` until the Unity Android build, gameplay flow, and visual polish are approved.

## Current Unity version
- App version: **1.2.4-unity**
- Android versionCode: **15**
- Package: `com.zetarank.timeloopdetective`
- Portrait mobile layout
- Minimum Android API: 26

## Gameplay included
- Five cases / 20 investigation locations
- Three-loop investigation structure
- Persistent case saves
- Clue collection and evidence inspection
- Suspect interrogation and contradictions
- Casebook and timeline
- Final deductions with true / partial / wrong endings
- Easy / Hard / Hardest difficulty
- First-run tutorial
- Settings, clear progress, Android back navigation and mobile safe-area support

## Integrated artwork
Optimized versions of the real noir game artwork are embedded as offline Unity Resources under:

`Unity/Assets/Resources/ArtBase64/`

The game decodes these local TextAssets into textures at runtime. No network connection or external art download is required.

Integrated assets include:
- Daily Bean cafe artwork
- detective/suspect key art
- rainy exterior artwork
- Maya portrait
- Lina portrait
- Omar portrait
- broken watch evidence
- coffee receipt evidence
- wet umbrella evidence
- red thread evidence
- voicemail evidence

Case 1 uses its dedicated character/evidence art. Cases 2–5 currently use matching noir background/key-art fallbacks where unique case-specific illustrations do not yet exist.

## Visual polish included
- Noir/gold interface
- Large artwork hero cards
- Character/evidence image cards
- Gold outlined controls
- Screen fade transitions
- UI click feedback
- Optional vibration
- Enhanced/Performance frame-rate modes
- Three text-size modes
- Safe-area handling for modern phones

## Open locally
1. Clone/pull the repository.
2. Check out `unity-port`.
3. In Unity Hub choose **Add project from disk**.
4. Select the repository's `Unity` folder.
5. Open with Unity 6.
6. Allow Unity to import packages/resources.
7. Check **Window > General > Console**.
8. Use **Time Loop Detective > Build Android APK**.

APK output:
`Unity/Builds/Android/TimeLoopDetective-Unity.apk`

There is intentionally no Unity GitHub Actions workflow.

## Merge rule
Do not merge into `main` until the Unity project opens, compiles, builds on Android, is device-tested, and the visuals are approved.


## Mobile compatibility audit (2026-09-21)
- Unity editor target: 6000.0.59f1.
- Android target API: 36 (Android 16).
- Minimum API: 26 (Android 8.0), so the same build is intended to cover Android 8 through current Android 16 phones.
- IL2CPP release backend.
- ARM64 plus ARMv7 architectures.
- Unity 6000.0.59f1 is new enough for Android API 36 and Unity's 16 KB memory-page support.
- Portrait safe-area layout handles notches, rounded corners and tall displays.
- APK build is available for direct device testing.
- AAB build is available for Google Play submission.

## Gameplay audit
- Action limits are now enforced; clues/interrogations cannot bypass the selected difficulty budget.
- Loops 1 and 2 can reset when the action budget is exhausted.
- Loop 3 cannot reset forever; when its budget is exhausted the game directs the player to the final deduction.
- All five cases have valid culprits, required contradictions, strong-clue references and location references.
- Each case remains solvable on Hardest: the minimum clue + culprit-interrogation path fits inside its Hardest action budget.


## Final production additions
- Generated noir main-menu artwork is now stored as a native Unity texture at `Assets/Resources/Art/Generated/MainMenu.jpg`.
- Generated Android app icon is stored at `Assets/Resources/Art/Generated/AppIcon.jpg` and is applied by the local Android build menu.
- Startup title splash is included.
- Procedural noir/rain ambience is included with a persistent SOUND on/off setting.
- One-click static QA: **Time Loop Detective > Run Release QA**.
- End-to-end logic self-test: **Time Loop Detective > Run Full Gameplay Self-Test**.
- Structural case validation: **Time Loop Detective > Validate Project**.

The final remaining verification is runtime-only: open the project in Unity, confirm there are no Console compile errors, run Play Mode, then install the APK on physical Android devices and build a signed AAB with your release keystore.


## Generated screen artwork integrated
The following generated native textures are now committed and used by the Unity UI:
- Main menu/startup splash: `Art/Generated/MainMenu`
- Tutorial/investigation presentation: `Art/Generated/InvestigationDesk`
- Case archive/settings office: `Art/Generated/DetectiveOffice`
- Casebook/evidence board: `Art/Generated/EvidenceRoom`
- Final deduction: `Art/Generated/FinalDeduction`
- Android app icon: `Art/Generated/AppIcon`

Release QA now verifies these assets are present before final device testing.
