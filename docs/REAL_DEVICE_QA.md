# Real Device QA Matrix

Automated CI verifies case data, asset references, Godot import, runtime startup, gameplay flow and APK export. These checks still require a physical Android device before production.

## Required devices
Test at minimum:
- one mid-range Android phone around 720×1600
- one 1080×2400-class phone
- one device with Android gesture navigation
- ideally one older/slower supported device

## Install / upgrade
- clean install APK/AAB
- upgrade over previous version
- launch offline
- reopen after force close
- confirm save survives restart

## Gameplay
For at least Case 01, Case 02 and Case 10:
- start new case
- interrogate multiple suspects
- use Stay Silent & Observe
- use previous-loop challenge in Loop 2
- shadow a suspect
- trigger a field action
- collect loop-gated evidence
- reset loop and verify evidence remains
- open casebook
- make wrong, partial and true deductions
- trigger final chase/confrontation

## Visuals
- no blank scene backgrounds
- no stretched/garbled artwork
- character identity remains stable within a case
- clue images appear immediately
- loop-reset and confrontation scenes switch correctly
- no visible hitch when moving between scenes repeatedly

## UI
- all text readable at normal, large and extra-large settings
- buttons fit without clipping
- navigation bar does not cover controls
- back gesture closes overlay first
- scroll works on long evidence/location lists

## Performance
- startup feels responsive
- no crash after repeated case/location switching
- no progressive slowdown after 15+ minutes
- background/resume does not lose state
- battery/heat remains reasonable during normal play

## Release gate
Do not promote from Internal testing until all required items above pass.
