# Time Loop Detective

A mobile-first detective mystery built with **Godot 4.7.2**.

## Five playable cases

1. **The Last Cup** — café murder and blackout.
2. **The Missing Passenger** — a passenger vanishes inside a tunnel.
3. **Room 417** — an impossible locked-room hotel death.
4. **The Midnight Train** — a judge disappears and the wrong passenger is killed.
5. **The Vanishing Witness** — a protected witness escapes a compromised safe house.

Each case has its own suspects, locations, clues, timeline, contradiction rules, three-loop progression, autosave, and endings.

## Case 01 — The Last Cup

At 8:47 PM the lights fail inside The Daily Bean. At 8:49 PM Daniel Rowan collapses. At 8:52 PM the night resets.

Everyone forgets.

You do not.

The first case is built around a three-loop investigation where evidence, contradictions and player knowledge persist across resets.

## What is implemented

- Complete first-case story
- Four locations
- Four suspects
- Eight evidence items
- Three time loops
- Suspect interrogation
- Contradiction system
- Evidence casebook
- Timeline review
- Final deduction
- True, partial and wrong endings
- Local autosave / continue
- Mobile-first portrait interface
- Built-in vector artwork
- Built-in procedural UI / evidence sounds
- Offline gameplay
- Android APK CI build
- Runtime smoke testing

## Locations

- The Daily Bean
- Manager's Office
- Rear Alley
- Riverside Walk

## Suspects

- Maya Cole — cafe manager
- Omar Hale — investigative journalist
- Lina Vale — business partner
- Theo Marsh — barista

## Technical structure

```text
project.godot
export_presets.cfg
scenes/
  main.tscn
scripts/
  main.gd
  save_manager.gd
  audio_manager.gd
data/
  case_01.json
art/
  backgrounds/
  characters/
  evidence/
  ui/
docs/
  GAME_DESIGN.md
  PLAYTEST_CHECKLIST.md
  STORE_LISTING.md
.github/workflows/
  android-build.yml
```

## Android

The GitHub workflow builds a debug APK using:

- Godot 4.7.2
- Android API 36
- Build Tools 36.1.0
- NDK 29
- Java 17

No Unity license or Unity account is required.

The APK is uploaded as the GitHub Actions artifact:

`TimeLoopDetective-Android`

## Local development

Open the repository folder in Godot 4.7.2 and run `scenes/main.tscn`.

## Release

The current CI produces a debug APK for testing. A Google Play production release should use a private Android signing keystore and an AAB export preset.

See:

- `docs/GAME_DESIGN.md`
- `docs/PLAYTEST_CHECKLIST.md`
- `docs/STORE_LISTING.md`
- `PRIVACY.md`

## Next content milestone

After Case 01 is tested on real Android devices, the reusable case/data structure can be expanded into Case 02 without replacing the core game systems.
