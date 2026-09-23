import express from "express";
import crypto from "node:crypto";

const app = express();
app.disable("x-powered-by");
app.use(express.json({ limit: "256kb" }));

const PORT = Number(process.env.PORT || 3000);
const OPENAI_API_KEY = process.env.OPENAI_API_KEY || "";
const GAME_API_TOKEN = process.env.GAME_API_TOKEN || "";
const IMAGE_MODEL = process.env.OPENAI_IMAGE_MODEL || "gpt-image-2.5-flare";
const IMAGE_QUALITY = process.env.OPENAI_IMAGE_QUALITY || "low";
const IMAGE_SIZE = process.env.OPENAI_IMAGE_SIZE || "1024x1536";
const MAX_PER_MINUTE = Math.max(1, Number(process.env.MAX_IMAGES_PER_MINUTE || 8));

const buckets = new Map();
const cache = new Map();

function cleanBuckets(now) {
  for (const [key, value] of buckets.entries()) {
    if (now - value.startedAt > 60_000) buckets.delete(key);
  }
}

function allowRequest(key) {
  const now = Date.now();
  cleanBuckets(now);
  const current = buckets.get(key);
  if (!current) {
    buckets.set(key, { startedAt: now, count: 1 });
    return true;
  }
  if (current.count >= MAX_PER_MINUTE) return false;
  current.count += 1;
  return true;
}

function cacheKey(prompt) {
  return crypto.createHash("sha256").update([
    IMAGE_MODEL,
    IMAGE_QUALITY,
    IMAGE_SIZE,
    prompt
  ].join("|")).digest("hex");
}

function authorized(req) {
  if (!GAME_API_TOKEN) return true;
  const token = req.get("x-game-token") || "";
  return crypto.timingSafeEqual(
    Buffer.from(token.padEnd(GAME_API_TOKEN.length, "\0")),
    Buffer.from(GAME_API_TOKEN)
  );
}

app.get("/health", (_req, res) => {
  res.json({
    ok: true,
    image_generation_configured: Boolean(OPENAI_API_KEY),
    model: IMAGE_MODEL
  });
});

app.post("/api/game-image", async (req, res) => {
  try {
    if (!authorized(req)) {
      return res.status(401).json({ ok: false, error: "unauthorized" });
    }
    if (!OPENAI_API_KEY) {
      return res.status(503).json({ ok: false, error: "image_generation_not_configured" });
    }

    const prompt = String(req.body?.prompt || "").trim();
    const sceneId = String(req.body?.scene_id || "").slice(0, 160);

    if (prompt.length < 10 || prompt.length > 20_000) {
      return res.status(400).json({ ok: false, error: "invalid_prompt" });
    }

    const rateKey = req.ip || "unknown";
    if (!allowRequest(rateKey)) {
      return res.status(429).json({ ok: false, error: "rate_limited" });
    }

    const key = cacheKey(prompt);
    const cached = cache.get(key);
    if (cached) {
      return res.json({
        ok: true,
        scene_id: sceneId,
        cached: true,
        mime_type: cached.mime_type,
        image_base64: cached.image_base64
      });
    }

    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 45_000);

    let response;
    try {
      response = await fetch("https://api.openai.com/v1/images/generations", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${OPENAI_API_KEY}`,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          model: IMAGE_MODEL,
          prompt,
          n: 1,
          size: IMAGE_SIZE,
          quality: IMAGE_QUALITY,
          output_format: "jpeg",
          output_compression: 70,
          background: "opaque"
        }),
        signal: controller.signal
      });
    } finally {
      clearTimeout(timeout);
    }

    const payload = await response.json().catch(() => ({}));
    if (!response.ok) {
      const message = String(payload?.error?.message || "image_provider_error").slice(0, 300);
      return res.status(response.status).json({ ok: false, error: message });
    }

    const imageBase64 = payload?.data?.[0]?.b64_json;
    if (!imageBase64) {
      return res.status(502).json({ ok: false, error: "missing_image_data" });
    }

    const result = {
      mime_type: "image/jpeg",
      image_base64: imageBase64
    };

    cache.set(key, result);
    if (cache.size > 40) {
      const first = cache.keys().next().value;
      cache.delete(first);
    }

    res.json({
      ok: true,
      scene_id: sceneId,
      cached: false,
      ...result
    });
  } catch (error) {
    const name = error?.name === "AbortError" ? "generation_timeout" : "server_error";
    res.status(name === "generation_timeout" ? 504 : 500).json({ ok: false, error: name });
  }
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Time Loop Detective image backend listening on port ${PORT}`);
});
