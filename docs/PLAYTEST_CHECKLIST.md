# Playtest Checklist

## Story / loop
- All 10 cases load.
- Every case has visual_scenes and loop_reveals.
- Player choices persist across resets.
- Asma remembers a previous investigation direction.
- Loop-gated evidence unlocks only on its configured loop.
- Observation reveals a suspect tell.
- Evidence persists after reset.
- True, partial and wrong endings work.

## Visuals
- No important scene displays blank.
- Location, clue, interrogation, loop, chase, confrontation and capture visuals resolve.
- Missing dedicated artwork falls back safely.
- Character appearances remain consistent.

## Android / UI
- Test 720x1280, 1080x1920 and taller screens.
- Dialogue stays short/readable.
- All buttons remain tappable.
- Back gesture, save/restore and resume work.
- Test image memory/performance on a mid-range device.

## Release
- Debug APK installs and upgrades.
- Signed AAB is built only after release signing secrets are configured.
- Test AAB in Play Console internal testing before production rollout.
