# Time Loop Detective: Asma

A mobile-first, conversation-driven detective mystery built with **Godot 4.5.1**.

You are physically present as **Asma's detective partner**. Cases unfold through short conversations, investigation, clues, choices, suspense, action, and repeated time loops rather than long narration or early explanations.

## Implemented
- 10 Season 1 cases
- Asma + player partner framing
- persistent partner choices and trust
- suspect observation / body-language clues
- loop-gated clues and loop-specific reveals
- evidence, contradictions, casebook, deductions
- true / partial / wrong outcomes
- chase, confrontation and capture visual routing
- visual-event routing for locations, crime scenes, clues, interrogations, searches, pursuits, cover, captures and resets
- stable character portrait resources
- autosave / continue
- investigator selection, outfits, gear, hints, achievements and credits
- Android debug APK CI and full gameplay smoke tests
- Unity migration scaffold under `unity/`

## Visual system
Each case defines `visual_scenes`. Locations may define `visual`, suspects `scene_art`, and clues `visual`. The engine uses dedicated artwork when available and safe fallbacks when it is not, so important actions never show a blank scene.

## Android
CI uses Godot 4.5.1, Java 17, Android API 35, Build Tools 35.0.0 and NDK 29.

Package: `com.zetarank.timeloopdetective`

Current release line: **1.5.0 (version code 12)**.

The normal workflow builds a debug APK. The manual release workflow builds a signed AAB once your private keystore/alias/password are supplied securely as GitHub Actions secrets.

See:
- `docs/ANDROID_RELEASE.md`
- `docs/REAL_DEVICE_QA.md`
- `docs/STORE_LISTING.md`
