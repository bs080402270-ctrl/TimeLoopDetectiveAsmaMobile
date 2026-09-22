# Android Release Guide

## Package
`com.zetarank.timeloopdetective`

## Current version
- Version name: 1.5.0
- Version code: 12

## Debug APK
The normal GitHub Actions workflow builds and tests a debug APK on every push to `main`.

Artifact name:
`TimeLoopDetective-Android`

## Signed Play Store AAB
The manual workflow `.github/workflows/android-release.yml` builds a release AAB.

Before running it, add these GitHub Actions secrets:

- `ANDROID_KEYSTORE_BASE64` — base64 of the private Android keystore file
- `ANDROID_KEY_ALIAS` — signing key alias
- `ANDROID_KEY_PASSWORD` — signing password

Never commit the keystore or password to Git.

Run:
Actions → Build Signed Android AAB → Run workflow.

Expected artifact:
`TimeLoopDetective-Android-AAB`

## Google Play sequence
1. Build the signed AAB.
2. Upload to Play Console Internal testing.
3. Install from Play on at least one real phone.
4. Complete the real-device checklist.
5. Review screenshots, privacy policy and store copy.
6. Promote the tested build to the desired release track.

## Versioning
Increase `version/code` for every new Play upload. Keep `version/name` aligned with the public release version.
