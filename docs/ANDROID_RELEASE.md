# Android Release Guide

## Package
`com.zetarank.timeloopdetective`

## Current version
- Version name: 1.6.0
- Version code: 16
- Minimum Android: API 24 (Android 7.0)
- Target Android: API 36 (Android 16)
- Architectures: ARMv7, ARM64, x86, x86_64
- Godot: 4.7.2 stable
- Android Build Tools: 36.1.0

## Debug APK
The main GitHub Actions workflow builds and tests a debug APK on every push to `main`.

Artifact name:
`TimeLoopDetective-Android-1.6.0`

## Signed Play Store AAB
A signed AAB is built from `main` when the Play signing secrets are configured. The manual workflow `.github/workflows/android-release.yml` can also be run when a fresh signed AAB is needed.

Required GitHub Actions secrets:
- `ANDROID_KEYSTORE_BASE64`
- `ANDROID_KEY_ALIAS`
- `ANDROID_KEY_PASSWORD`

Never commit the keystore or password to Git.

Expected artifact:
`TimeLoopDetective-Play-AAB-1.6.0`

## Google Play sequence
1. Build the signed AAB from `main`.
2. Upload to Play Console Internal testing.
3. Install from Play on real devices.
4. Complete the real-device checklist.
5. Review screenshots, privacy policy and store copy.
6. Promote the tested build to the desired release track.

## Versioning
Increase `version/code` for every Google Play upload. Keep `version/name` aligned with the public release version.
