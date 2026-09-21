using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace TimeLoopDetective
{
    public static class ArtManager
    {
        static readonly Dictionary<string, Sprite> Cache = new Dictionary<string, Sprite>();

        public static Sprite Load(string resourcePath)
        {
            Sprite cached;
            if (Cache.TryGetValue(resourcePath, out cached)) return cached;

            var directTexture = Resources.Load<Texture2D>(resourcePath);
            if (directTexture != null)
            {
                var directSprite = Sprite.Create(directTexture,
                    new Rect(0, 0, directTexture.width, directTexture.height),
                    new Vector2(.5f, .5f), 100f);
                Cache[resourcePath] = directSprite;
                return directSprite;
            }

            var textPath = resourcePath.Replace("Art/", "ArtBase64/");
            var encoded = Resources.Load<TextAsset>(textPath);
            if (encoded == null)
            {
                Debug.LogWarning("Missing artwork resource: " + resourcePath);
                return null;
            }

            try
            {
                var bytes = Convert.FromBase64String(encoded.text.Trim());
                var texture = new Texture2D(2, 2, TextureFormat.RGB24, false);
                texture.name = textPath;
                texture.wrapMode = TextureWrapMode.Clamp;
                texture.filterMode = FilterMode.Bilinear;
                if (!texture.LoadImage(bytes, false))
                {
                    UnityEngine.Object.Destroy(texture);
                    return null;
                }

                var sprite = Sprite.Create(texture,
                    new Rect(0, 0, texture.width, texture.height),
                    new Vector2(.5f, .5f), 100f);
                Cache[resourcePath] = sprite;
                return sprite;
            }
            catch (Exception ex)
            {
                Debug.LogWarning("Could not decode artwork " + textPath + ": " + ex.Message);
                return null;
            }
        }

        public static string Location(string id)
        {
            switch (id)
            {
                case "cafe":
                case "office":
                case "room":
                case "conference":
                case "court":
                case "sleeper":
                    return "Art/Phase1/Backgrounds/DailyBeanCafe";

                case "alley":
                case "riverside":
                case "tunnel":
                case "hall":
                case "safehouse":
                case "service":
                case "maintenance":
                    return "Art/Phase2/Backgrounds/CafeExteriorRain";

                default:
                    return "Art/Phase1/Backgrounds/SuspectKeyArt";
            }
        }

        public static string Suspect(string id)
        {
            switch (id)
            {
                case "maya": return "Art/Phase1/Characters/Maya";
                case "lina": return "Art/Phase1/Characters/Lina";
                case "omar": return "Art/Phase1/Characters/Omar";
                default: return "Art/Phase1/Backgrounds/SuspectKeyArt";
            }
        }

        public static string Clue(string id)
        {
            switch (id)
            {
                case "watch": return "Art/Phase1/Clues/BrokenWatch";
                case "receipt": return "Art/Phase1/Clues/CoffeeReceipt";
                case "umbrella": return "Art/Phase1/Clues/WetUmbrella";
                case "thread": return "Art/Phase1/Clues/RedThread";
                case "voicemail":
                case "burner":
                case "message":
                case "note":
                    return "Art/Phase1/Clues/Voicemail";
                default:
                    return "Art/Phase1/Backgrounds/SuspectKeyArt";
            }
        }

        public static void Apply(Image image, string resourcePath, bool preserveAspect)
        {
            var sprite = Load(resourcePath);
            if (sprite == null) return;
            image.sprite = sprite;
            image.color = Color.white;
            image.preserveAspect = preserveAspect;
            image.type = Image.Type.Simple;
        }
    }
}
