# Playtest Checklist

## Functional
- New Case resets prior state.
- Continue restores loop, location, clues and contradictions.
- All four locations open.
- All four suspects can be interrogated.
- All eight evidence items can be collected.
- Evidence remains after loop reset.
- Each loop resets action count.
- Casebook displays evidence and timeline.
- Lina contradiction requires relevant evidence.
- True, partial and wrong endings all trigger.
- Restart Case clears save.

## Mobile UI
- Test 720x1280, 1080x1920 and taller devices.
- No controls overlap navigation bars.
- All text remains readable at default system scaling.
- Location and evidence lists scroll.
- Portrait orientation fills the screen.
- Tap targets are at least approximately 48dp.

## Performance
- Startup under five seconds on a mid-range device.
- No stutter when switching vector art.
- No memory growth after repeated location changes.
- App resumes after backgrounding.

## Android
- Install clean APK.
- Upgrade over previous debug build.
- Launch offline.
- Portrait lock remains correct.
- Save survives app restart.
- Back gesture does not corrupt state.
