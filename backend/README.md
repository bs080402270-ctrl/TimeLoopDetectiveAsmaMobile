# Dynamic Image Backend

This service keeps the OpenAI API key off the Android device.

## Request flow

Godot -> `POST /api/game-image` -> OpenAI Images API -> base64 JPEG -> Godot cache/display.

The game continues immediately with built-in artwork. Generated artwork replaces the fallback only if it arrives while the same scene is still active.

## Environment variables

Copy `.env.example` values into your hosting provider's environment-variable/secret settings. Do not upload a real `.env` file to GitHub.

Required:
- `OPENAI_API_KEY`
- `GAME_API_TOKEN`

Optional:
- `OPENAI_IMAGE_MODEL` (default `gpt-image-2.5-flare`)
- `OPENAI_IMAGE_QUALITY` (default `low`)
- `OPENAI_IMAGE_SIZE` (default `1024x1536`)
- `MAX_IMAGES_PER_MINUTE`
- `PORT`

## Install

```bash
npm install
npm start
```

Health check:
`GET /health`

Game endpoint:
`POST /api/game-image`

Body:
```json
{
  "scene_id": "case_02_face_to_face_talk_loop_2",
  "prompt": "current scene prompt"
}
```

Header:
`X-Game-Token: <GAME_API_TOKEN>`

## Important

Do not put the OpenAI API key inside Godot, an APK, a GitHub variable visible to clients, or any downloadable game asset.
