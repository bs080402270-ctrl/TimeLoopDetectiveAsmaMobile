# Time Loop Detective - Unity scaffold

This folder is a separate Unity project scaffold for the Asma mobile game.

Current production game remains in Godot at the repository root. The Unity folder is isolated so migration can happen screen-by-screen without breaking the working Android build.

Planned migration order:
1. Main menu and navigation
2. Case select and investigator screens
3. Case data loader
4. Interrogation and evidence systems
5. Save/settings/credits/achievements
6. Android build and signing
7. Art migration after invalid JPG sources are replaced with clean originals

Do not copy the currently corrupted JPG files into Unity. Replace them with clean source artwork first.
