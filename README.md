# Time Loop Detective

A mobile mystery game built with **Godot 4.7.2**.

## Current playable slice

The first case is designed around:

- The Daily Bean café
- Three suspects: Maya, Omar, and Lina
- Five collectible clues
- Three repeating time loops
- Dialogue that changes based on discovered evidence
- A persistent case notebook
- Two ending paths
- Local save progress
- Mobile-friendly point-and-click controls

## Project structure

- `project.godot` — Godot project configuration
- `scenes/main.tscn` — main scene
- `scripts/game.gd` — gameplay, dialogue, clues, loops, saves, and UI
- `art/` — phase 1 and phase 2 game art
- `export_presets.cfg` — Android export configuration
- `.github/workflows/android-build.yml` — automated Android APK build

## Art

The game automatically loads polished artwork when the PNG files listed in `art/ASSET_MANIFEST.md` are present. The UI remains functional if an optional art file is missing, which makes development and CI more robust.

## Android build

GitHub Actions uses Godot export templates and Android tooling. **No Unity license, Unity serial, UNITY_EMAIL, UNITY_PASSWORD, or UNITY_LICENSE secrets are required.**

You can also build locally with Godot:

```bash
godot --headless --path . --export-debug "Android" build/TimeLoopDetective.apk
```

For a signed Play Store release, configure an Android release keystore separately.

## Controls

On mobile, tap suspect and clue cards.

Desktop development shortcuts:

- `E` — interaction hint
- `N` — case notebook
- `R` — reset the current loop

## Next phase

Phase 2 expands beyond the café into the rainy street exterior, hidden back room, riverside walkway, and investigation desk scenes while keeping the same mystery progression and art direction.
