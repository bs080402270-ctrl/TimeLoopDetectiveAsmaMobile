# Unity Port Working Branch

Branch: `unity-port`

This branch contains the isolated Unity conversion of Time Loop Detective. Keep it separate from `main` until the Unity Android build, gameplay flow, and visual polish are approved.

## Current Unity version
- App version: **1.2.2-unity**
- Android versionCode: **13**
- Package: `com.zetarank.timeloopdetective`
- Orientation: portrait
- Minimum Android API: 26

## Complete gameplay
- Five cases with 20 investigation locations
- Three-loop investigation structure
- Persistent case saves
- Clue/evidence collection
- Suspect interrogation
- Contradiction checks
- Casebook and timeline
- Final accusations
- True / partial / wrong endings
- Easy / Hard / Hardest difficulty
- First-run tutorial
- Settings and clear-progress controls
- Android back navigation
- Mobile safe-area handling

## Integrated visual package
The optimized real game artwork is stored in:
`Unity/Assets/ArtAssets.zip`

Unity automatically extracts the package into:
`Unity/Assets/Resources/Art/`

The visual package includes:
- Daily Bean cafe background
- suspect key art
- investigation desk
- riverside walkway
- back room
- rainy cafe exterior
- Maya, Lina and Omar portraits
- broken watch
- coffee receipt
- wet umbrella
- red thread
- voicemail evidence art

The runtime UI uses these assets for the title screen, onboarding, difficulty, case archive, investigation locations, interrogations, clue cards, casebook, deduction, results and settings. Other cases use themed artwork fallbacks until case-specific future art is added.

## Polish included
- Noir/gold visual system
- Artwork hero cards
- Evidence thumbnails
- Suspect portraits/key art
- Gold button outlines
- Screen fade transitions
- Mobile click sound feedback
- Optional vibration
- Performance/Enhanced frame-rate setting
- Text size modes

## Open locally
1. Clone or pull the repository.
2. Check out `unity-port`.
3. In Unity Hub choose **Add project from disk**.
4. Select the repository's `Unity` folder.
5. Open it with Unity 6.
6. Allow Unity to import the project. The editor automatically extracts the optimized artwork.
7. Check the Console for errors.
8. Use **Time Loop Detective > Build Android APK**.

Local APK output:
`Unity/Builds/Android/TimeLoopDetective-Unity.apk`

There is intentionally no Unity GitHub Actions workflow. Android builds are local so no Unity CI license secret is required.

## Merge rule
Do not merge into `main` until the Unity version is opened, built, device-tested, and visually approved.
