using System;
using System.Collections;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

namespace TimeLoopDetective
{
    public class RuntimeUI : MonoBehaviour
    {
        readonly Color Bg = new Color(0.018f, 0.024f, 0.034f, 1f);
        readonly Color PanelColor = new Color(0.045f, 0.050f, 0.060f, 0.97f);
        readonly Color Gold = new Color(0.90f, 0.72f, 0.36f, 1f);
        readonly Color Muted = new Color(0.72f, 0.68f, 0.61f, 1f);
        readonly Color Red = new Color(0.78f, 0.12f, 0.16f, 1f);

        Font font;
        GameController game;
        Canvas canvas;
        RectTransform content;
        CanvasGroup contentGroup;
        Text header;
        Text subheader;
        AudioSource uiAudio;
        AudioClip clickClip;
        string currentScreen = "menu";

        void Start()
        {
            font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            game = GetComponent<GameController>();
            SettingsManager.ApplyRuntime();
            BuildShell();
            ShowMenu();
        }

        void BuildShell()
        {
            var canvasGo = new GameObject("Canvas", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            canvasGo.transform.SetParent(transform, false);
            canvas = canvasGo.GetComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;

            var scaler = canvasGo.GetComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(720, 1280);
            scaler.matchWidthOrHeight = 0.5f;

            var bg = CreateImage("Background", canvas.transform, Bg);
            Stretch(bg.rectTransform);

            var root = CreatePanel("SafeAreaRoot", canvas.transform, new Color(0, 0, 0, 0));
            Stretch(root.rectTransform);
            root.gameObject.AddComponent<SafeAreaFitter>();

            var layout = root.gameObject.AddComponent<VerticalLayoutGroup>();
            layout.padding = new RectOffset(24, 24, 22, 18);
            layout.spacing = 10;
            layout.childForceExpandHeight = false;
            layout.childForceExpandWidth = true;

            header = Label("TIME LOOP DETECTIVE", root, 40, Color.white, TextAnchor.MiddleCenter);
            header.gameObject.AddComponent<LayoutElement>().preferredHeight = 62;
            subheader = Label("", root, 18, Muted, TextAnchor.MiddleCenter);
            subheader.gameObject.AddComponent<LayoutElement>().preferredHeight = 42;

            var divider = CreateImage("GoldDivider", root, new Color(Gold.r, Gold.g, Gold.b, .5f));
            divider.gameObject.AddComponent<LayoutElement>().preferredHeight = 2;

            var scrollGo = new GameObject("Scroll", typeof(RectTransform), typeof(ScrollRect), typeof(Image), typeof(Mask), typeof(LayoutElement));
            scrollGo.transform.SetParent(root.transform, false);
            scrollGo.GetComponent<Image>().color = new Color(0, 0, 0, 0);
            scrollGo.GetComponent<Mask>().showMaskGraphic = false;
            scrollGo.GetComponent<LayoutElement>().flexibleHeight = 1;

            var viewport = scrollGo.GetComponent<RectTransform>();
            Stretch(viewport);

            var contentGo = new GameObject("Content", typeof(RectTransform), typeof(VerticalLayoutGroup), typeof(ContentSizeFitter), typeof(CanvasGroup));
            contentGo.transform.SetParent(scrollGo.transform, false);
            content = contentGo.GetComponent<RectTransform>();
            contentGroup = contentGo.GetComponent<CanvasGroup>();
            content.anchorMin = new Vector2(0, 1);
            content.anchorMax = new Vector2(1, 1);
            content.pivot = new Vector2(.5f, 1);
            content.offsetMin = Vector2.zero;
            content.offsetMax = Vector2.zero;

            var v = contentGo.GetComponent<VerticalLayoutGroup>();
            v.spacing = 14;
            v.childForceExpandWidth = true;
            v.childForceExpandHeight = false;
            contentGo.GetComponent<ContentSizeFitter>().verticalFit = ContentSizeFitter.FitMode.PreferredSize;

            var sr = scrollGo.GetComponent<ScrollRect>();
            sr.content = content;
            sr.viewport = viewport;
            sr.horizontal = false;
            sr.movementType = ScrollRect.MovementType.Clamped;
            sr.scrollSensitivity = 34f;

            var nav = new GameObject("BottomNav", typeof(RectTransform), typeof(HorizontalLayoutGroup), typeof(LayoutElement), typeof(Image));
            nav.transform.SetParent(root.transform, false);
            nav.GetComponent<Image>().color = new Color(.025f, .028f, .032f, .98f);
            nav.GetComponent<LayoutElement>().preferredHeight = 82;
            var n = nav.GetComponent<HorizontalLayoutGroup>();
            n.padding = new RectOffset(4, 4, 4, 4);
            n.spacing = 7;
            n.childForceExpandWidth = true;
            n.childForceExpandHeight = true;
            AddButton(nav.transform, "HOME", ShowMenu, false);
            AddButton(nav.transform, "CASES", ShowCases, false);
            AddButton(nav.transform, "HOW TO", ShowHowTo, false);
            AddButton(nav.transform, "SETTINGS", ShowSettings, false);

            uiAudio = root.gameObject.AddComponent<AudioSource>();
            uiAudio.playOnAwake = false;
            uiAudio.volume = .18f;
            clickClip = BuildClickClip();
        }

        AudioClip BuildClickClip()
        {
            const int sampleRate = 44100;
            const int length = 2205;
            var data = new float[length];
            for (int i = 0; i < length; i++)
            {
                var t = i / (float)sampleRate;
                var envelope = 1f - i / (float)length;
                data[i] = Mathf.Sin(2f * Mathf.PI * 620f * t) * envelope * .22f;
            }
            var clip = AudioClip.Create("NoirUIClick", length, 1, sampleRate, false);
            clip.SetData(data, 0);
            return clip;
        }

        void ClearContent()
        {
            StopAllCoroutines();
            for (int i = content.childCount - 1; i >= 0; i--) Destroy(content.GetChild(i).gameObject);
            content.anchoredPosition = Vector2.zero;
            contentGroup.alpha = 0f;
            StartCoroutine(FadeContent());
        }

        IEnumerator FadeContent()
        {
            float t = 0f;
            while (t < .2f)
            {
                t += Time.unscaledDeltaTime;
                contentGroup.alpha = Mathf.Clamp01(t / .2f);
                yield return null;
            }
            contentGroup.alpha = 1f;
        }

        void ShowMenu()
        {
            currentScreen = "menu";
            ClearContent();
            header.text = "TIME LOOP DETECTIVE";
            subheader.text = "SAME TIME. DIFFERENT TRUTHS. BREAK THE LOOP.";

            ArtworkCard("Art/Phase1/Backgrounds/SuspectKeyArt", 500,
                "INVESTIGATE. UNCOVER.\nBREAK THE LOOP.",
                "Five mysteries. Three loops each.\nYou are the only one who remembers.");

            AddButton(content, "START INVESTIGATION  →", () =>
            {
                if (SettingsManager.TutorialSeen) ShowDifficulty();
                else ShowHowTo();
            }, true);
            AddButton(content, "HOW TO PLAY", ShowHowTo, false);
        }

        void ShowHowTo()
        {
            currentScreen = "howto";
            ClearContent();
            header.text = "HOW THE LOOP WORKS";
            subheader.text = "Observe. Question. Remember. Deduce.";

            ArtworkCard("Art/Phase2/Backgrounds/InvestigationDesk", 270, "THE LOOP REMEMBERS", "Every reset changes what you can prove.");
            Step("01", "INVESTIGATE LOCATIONS", "Search every scene for useful clues.");
            Step("02", "QUESTION SUSPECTS", "Stories change. Contradictions reveal the truth.");
            Step("03", "CARRY CLUES ACROSS LOOPS", "The world resets. Your knowledge does not.");
            AddButton(content, "CHOOSE DIFFICULTY  →", () =>
            {
                SettingsManager.TutorialSeen = true;
                ShowDifficulty();
            }, true);
        }

        void Step(string num, string title, string desc)
        {
            var p = CreatePanel("Step", content, PanelColor);
            p.gameObject.AddComponent<LayoutElement>().preferredHeight = 145;
            var h = p.gameObject.AddComponent<HorizontalLayoutGroup>();
            h.padding = new RectOffset(14, 14, 14, 14);
            h.spacing = 14;
            var n = Label(num, p, 30, Gold, TextAnchor.MiddleCenter);
            n.gameObject.AddComponent<LayoutElement>().preferredWidth = 72;
            var box = new GameObject("Text", typeof(RectTransform), typeof(VerticalLayoutGroup));
            box.transform.SetParent(p.transform, false);
            box.GetComponent<VerticalLayoutGroup>().spacing = 5;
            Label(title, box.transform, 25, Color.white, TextAnchor.MiddleLeft);
            Label(desc, box.transform, 18, Muted, TextAnchor.MiddleLeft);
        }

        void ShowDifficulty()
        {
            currentScreen = "difficulty";
            ClearContent();
            header.text = "SELECT DIFFICULTY";
            subheader.text = "Choose how challenging the loop will be.";
            ArtworkCard("Art/Phase2/Backgrounds/RiversideWalkway", 230, "CHOOSE YOUR PRESSURE", "Hints, actions, and deduction requirements change by mode.");
            DifficultyCard(DifficultyMode.Easy, "EASY", "More hints, two extra actions per loop, easier final deduction.");
            DifficultyCard(DifficultyMode.Hard, "HARD", "Balanced investigation, standard actions and limited guidance.");
            DifficultyCard(DifficultyMode.Hardest, "HARDEST", "No hints, two fewer actions and the strictest final deduction.");
            AddButton(content, "CONTINUE TO CASES  →", ShowCases, true);
        }

        void DifficultyCard(DifficultyMode mode, string title, string desc)
        {
            bool selected = SettingsManager.Difficulty == mode;
            var p = CreatePanel(title, content, selected ? new Color(.12f, .09f, .045f, 1) : PanelColor);
            p.gameObject.AddComponent<LayoutElement>().preferredHeight = 165;
            var v = p.gameObject.AddComponent<VerticalLayoutGroup>();
            v.padding = new RectOffset(18, 18, 14, 14);
            v.spacing = 6;
            Label((selected ? "✓  " : "○  ") + title, p, 30, selected ? Gold : Color.white, TextAnchor.MiddleLeft);
            Label(desc, p, 18, Muted, TextAnchor.MiddleLeft);
            var b = AddButton(p, "SELECT", () =>
            {
                SettingsManager.Difficulty = mode;
                ShowDifficulty();
            }, selected);
            b.interactable = !selected;
            b.GetComponent<LayoutElement>().preferredHeight = 58;
            b.GetComponentInChildren<Text>().text = selected ? "SELECTED" : "SELECT";
        }

        void ShowCases()
        {
            currentScreen = "cases";
            ClearContent();
            header.text = "SELECT A CASE";
            subheader.text = "Each case is a loop. Each truth changes everything.";

            ArtworkCard("Art/Phase1/Backgrounds/DailyBeanCafe", 290, "CASE ARCHIVE", "Five investigations are ready.");

            if (game.Cases.Count == 0)
            {
                Label("Case data could not be loaded.", content, 24, Red, TextAnchor.MiddleCenter);
                return;
            }

            int i = 1;
            foreach (var c in game.Cases)
            {
                var p = CreatePanel(c.id, content, PanelColor);
                p.gameObject.AddComponent<LayoutElement>().preferredHeight = 180;
                var v = p.gameObject.AddComponent<VerticalLayoutGroup>();
                v.padding = new RectOffset(18, 18, 15, 15);
                v.spacing = 5;
                Label(string.Format("{0:00}  {1}", i, c.title), p, 27, Gold, TextAnchor.MiddleLeft);
                Label(c.subtitle, p, 18, Muted, TextAnchor.MiddleLeft);
                string id = c.id;
                var b = AddButton(p, SaveManager.HasSave(id) ? "CONTINUE  →" : "OPEN CASE  →", () => OpenCase(id), false);
                b.GetComponent<LayoutElement>().preferredHeight = 62;
                i++;
            }
        }

        void OpenCase(string id)
        {
            if (!game.OpenCase(id)) return;
            if (!game.State.started) game.StartNew();
            ShowGame();
        }

        void ShowGame()
        {
            currentScreen = "game";
            ClearContent();
            var c = game.CurrentCase;
            var s = game.State;
            if (c == null || s == null)
            {
                ShowCases();
                return;
            }

            header.text = c.title;
            subheader.text = string.Format("{0}  •  LOOP {1}/3  •  ACTIONS {2}/{3}  •  CLUES {4}/{5}",
                SettingsManager.Difficulty.ToString().ToUpper(), s.loop, s.action, game.EffectiveMaxActions(), s.clues.Count, c.clues.Count);

            LocationData loc;
            if (c.locations.TryGetValue(s.location, out loc))
            {
                ArtworkCard(ArtManager.Location(s.location), 390, loc.name, loc.description);
                foreach (var person in loc.people)
                    if (c.suspects.ContainsKey(person)) SuspectCard(person);
                foreach (var clue in c.clues.Where(x => x.Value.location == s.location))
                    ClueCard(clue.Key);
            }

            Label("TRAVEL", content, 24, Gold, TextAnchor.MiddleLeft);
            foreach (var l in c.locations)
            {
                string id = l.Key;
                AddButton(content, l.Value.name.ToUpper(), () =>
                {
                    game.Travel(id);
                    ShowGame();
                }, id == s.location);
            }

            AddButton(content, "CASEBOOK / EVIDENCE", ShowCasebook, false);
            if (s.action >= game.EffectiveMaxActions())
                AddButton(content, "RESET THE TIMELINE  ↻", () =>
                {
                    game.ResetLoop();
                    ShowGame();
                }, true);
        }

        void SuspectCard(string id)
        {
            var d = game.CurrentCase.suspects[id];
            var p = CreatePanel("Suspect", content, PanelColor);
            var v = p.gameObject.AddComponent<VerticalLayoutGroup>();
            v.padding = new RectOffset(14, 14, 12, 12);
            v.spacing = 7;
            AddArtStrip(p, ArtManager.Suspect(id), id == "maya" || id == "lina" || id == "omar" ? 210 : 145);
            Label(d.name, p, 27, Color.white, TextAnchor.MiddleLeft);
            Label(d.role, p, 18, Muted, TextAnchor.MiddleLeft);
            AddButton(p, "INTERROGATE  →", () => Interrogate(id), true);
        }

        void Interrogate(string id)
        {
            currentScreen = "interrogate";
            game.Talk(id);
            var d = game.CurrentCase.suspects[id];
            int idx = Mathf.Clamp(game.State.loop - 1, 0, Mathf.Max(0, d.dialogue.Count - 1));
            ClearContent();
            header.text = d.name + " • INTERROGATION";
            subheader.text = d.role;

            ArtworkCard(ArtManager.Suspect(id), 370, d.name, d.role);

            var p = CreatePanel("Dialogue", content, PanelColor);
            var v = p.gameObject.AddComponent<VerticalLayoutGroup>();
            v.padding = new RectOffset(20, 20, 25, 25);
            v.spacing = 15;
            Label(d.dialogue.Count > 0 ? d.dialogue[idx] : "They watch you carefully.", p, 24, Color.white, TextAnchor.UpperLeft);
            AddButton(p, "THIS DOESN'T ADD UP...  →", () => Press(id), true);
            AddButton(content, "BACK TO SCENE", ShowGame, false);
        }

        void Press(string id)
        {
            currentScreen = "result";
            bool ok = game.TryContradiction(id);
            ClearContent();
            header.text = ok ? "CONTRADICTION FOUND" : "NEED MORE EVIDENCE";
            subheader.text = ok ? game.CurrentCase.suspects[id].contradiction.result : "Return to the scene and keep investigating.";
            ArtworkCard(ok ? "Art/Phase1/Clues/RedThread" : "Art/Phase2/Backgrounds/InvestigationDesk",
                300, ok ? "STORY BROKEN" : "NOT ENOUGH YET", subheader.text);
            AddButton(content, "BACK TO SCENE", ShowGame, true);
        }

        void ClueCard(string id)
        {
            var d = game.CurrentCase.clues[id];
            bool found = game.State.clues.Contains(id);
            var p = CreatePanel("Clue", content, found ? new Color(.11f, .09f, .045f, 1) : PanelColor);
            var v = p.gameObject.AddComponent<VerticalLayoutGroup>();
            v.padding = new RectOffset(14, 14, 12, 12);
            v.spacing = 7;
            AddArtStrip(p, ArtManager.Clue(id), 170);
            Label((found ? "RECORDED • " : "") + d.name, p, 24, found ? Gold : Color.white, TextAnchor.MiddleLeft);
            Label(found ? d.description : HintText(), p, 17, Muted, TextAnchor.MiddleLeft);
            var b = AddButton(p, found ? "RECORDED" : "INSPECT", () =>
            {
                game.AddClue(id);
                ShowGame();
            }, false);
            b.interactable = !found;
        }

        string HintText()
        {
            switch (SettingsManager.Difficulty)
            {
                case DifficultyMode.Easy: return "Hint: evidence is hidden in this area.";
                case DifficultyMode.Hardest: return "No hint available. Trust your observations.";
                default: return "Inspect this area for evidence.";
            }
        }

        void ShowCasebook()
        {
            currentScreen = "casebook";
            ClearContent();
            header.text = "CASEBOOK / EVIDENCE";
            subheader.text = string.Format("COLLECTED {0}/{1}", game.State.clues.Count, game.CurrentCase.clues.Count);

            ArtworkCard("Art/Phase2/Backgrounds/InvestigationDesk", 320, "INVESTIGATION BOARD", "Everything you remember survives the reset.");

            foreach (var kv in game.CurrentCase.clues)
                Label((game.State.clues.Contains(kv.Key) ? "■ " : "□ ") + kv.Value.name,
                    content, 21, game.State.clues.Contains(kv.Key) ? Gold : Muted, TextAnchor.MiddleLeft);

            Label("TIMELINE", content, 25, Gold, TextAnchor.MiddleLeft);
            foreach (var line in game.CurrentCase.timeline)
                Label("• " + line, content, 18, Muted, TextAnchor.MiddleLeft);

            AddButton(content, "MAKE A DEDUCTION  →", ShowDeduction, true);
            AddButton(content, "BACK TO SCENE", ShowGame, false);
        }

        void ShowDeduction()
        {
            currentScreen = "deduction";
            ClearContent();
            header.text = "FINAL DEDUCTION";
            subheader.text = game.CurrentCase.deduction_prompt;
            ArtworkCard("Art/Phase1/Backgrounds/SuspectKeyArt", 330, "BREAK THE LOOP", "Your evidence must support the accusation.");
            Label("WHO IS RESPONSIBLE?", content, 31, Red, TextAnchor.MiddleCenter);
            foreach (var kv in game.CurrentCase.suspects)
            {
                string id = kv.Key;
                AddButton(content, kv.Value.name, () => Finish(game.Accuse(id)), false);
            }
            AddButton(content, "NOT YET", ShowGame, false);
        }

        void Finish(string kind)
        {
            currentScreen = "ending";
            SettingsManager.Haptic();
            ClearContent();
            header.text = kind == "true" ? "CASE CLOSED" : "THE LOOP RESISTS";
            string text = kind == "true" ? game.CurrentCase.truth : kind == "partial" ? game.CurrentCase.partial : game.CurrentCase.wrong;
            ArtworkCard(kind == "true" ? "Art/Phase1/Backgrounds/DailyBeanCafe" : "Art/Phase2/Backgrounds/CafeExteriorRain",
                340, kind == "true" ? "TRUE ENDING" : kind == "partial" ? "PARTIAL TRUTH" : "WRONG ACCUSATION", text);
            Label(text, content, 22, Color.white, TextAnchor.UpperLeft);
            AddButton(content, "CASE SELECT", ShowCases, true);
        }

        void ShowSettings()
        {
            currentScreen = "settings";
            ClearContent();
            header.text = "SETTINGS";
            subheader.text = "Tune readability, graphics and gameplay.";

            ArtworkCard("Art/Phase2/Backgrounds/CafeExteriorRain", 260, "NOIR DISPLAY", "Optimized for portrait mobile play.");
            AddButton(content, "DIFFICULTY: " + SettingsManager.Difficulty.ToString().ToUpper(), ShowDifficulty, false);
            AddButton(content, "GRAPHICS: " + (SettingsManager.EnhancedGraphics ? "ENHANCED" : "PERFORMANCE"), () =>
            {
                SettingsManager.EnhancedGraphics = !SettingsManager.EnhancedGraphics;
                ShowSettings();
            }, false);
            string textLabel = SettingsManager.TextSize == 0 ? "NORMAL" : SettingsManager.TextSize == 1 ? "LARGE" : "EXTRA LARGE";
            AddButton(content, "TEXT SIZE: " + textLabel, () =>
            {
                SettingsManager.TextSize = (SettingsManager.TextSize + 1) % 3;
                ShowSettings();
            }, false);
            AddButton(content, "VIBRATION: " + (SettingsManager.Vibration ? "ON" : "OFF"), () =>
            {
                SettingsManager.Vibration = !SettingsManager.Vibration;
                ShowSettings();
            }, false);
            AddButton(content, "CLEAR ALL CASE PROGRESS", ClearProgress, false);
            Label("VERSION 1.2.1 UNITY", content, 18, Muted, TextAnchor.MiddleCenter);
            Label("ZetaRank • Offline detective adventure", content, 16, Muted, TextAnchor.MiddleCenter);
        }

        void Update()
        {
            if (!Input.GetKeyDown(KeyCode.Escape)) return;
            if (currentScreen == "game" || currentScreen == "interrogate" || currentScreen == "casebook" ||
                currentScreen == "deduction" || currentScreen == "result") ShowGame();
            else if (currentScreen == "cases" || currentScreen == "difficulty" || currentScreen == "howto" ||
                     currentScreen == "settings") ShowMenu();
            else if (currentScreen == "ending") ShowCases();
            else Application.Quit();
        }

        void ClearProgress()
        {
            if (game != null && game.Cases != null)
                foreach (var c in game.Cases) SaveManager.Clear(c.id);
            SettingsManager.Haptic();
            ShowSettings();
        }

        void ArtworkCard(string resourcePath, float height, string title, string description)
        {
            var card = CreatePanel("ArtworkCard", content, PanelColor);
            card.gameObject.AddComponent<LayoutElement>().preferredHeight = height;

            var art = CreateImage("Art", card, Color.black);
            Stretch(art.rectTransform);
            ArtManager.Apply(art, resourcePath, false);
            var artLayout = art.gameObject.AddComponent<LayoutElement>();
            artLayout.ignoreLayout = true;

            var shade = CreateImage("Shade", card, new Color(0f, 0f, 0f, .48f));
            Stretch(shade.rectTransform);
            shade.gameObject.AddComponent<LayoutElement>().ignoreLayout = true;

            var textBox = new GameObject("Caption", typeof(RectTransform), typeof(VerticalLayoutGroup), typeof(LayoutElement));
            textBox.transform.SetParent(card.transform, false);
            var rt = textBox.GetComponent<RectTransform>();
            rt.anchorMin = new Vector2(.045f, .05f);
            rt.anchorMax = new Vector2(.955f, .48f);
            rt.offsetMin = Vector2.zero;
            rt.offsetMax = Vector2.zero;
            textBox.GetComponent<LayoutElement>().ignoreLayout = true;

            var layout = textBox.GetComponent<VerticalLayoutGroup>();
            layout.childAlignment = TextAnchor.LowerLeft;
            layout.spacing = 7;
            layout.childForceExpandHeight = false;
            Label(title, textBox.transform, 30, Gold, TextAnchor.LowerLeft);
            Label(description, textBox.transform, 18, Color.white, TextAnchor.UpperLeft);
        }

        void AddArtStrip(Component parent, string resourcePath, float height)
        {
            var img = CreateImage("Artwork", parent, new Color(.02f, .02f, .02f, 1f));
            img.gameObject.AddComponent<LayoutElement>().preferredHeight = height;
            ArtManager.Apply(img, resourcePath, true);
        }

        Image CreatePanel(string name, Component parent, Color color)
        {
            var go = new GameObject(name, typeof(RectTransform), typeof(Image));
            go.transform.SetParent(parent.transform, false);
            var img = go.GetComponent<Image>();
            img.color = color;
            return img;
        }

        Image CreateImage(string name, Component parent, Color color)
        {
            return CreatePanel(name, parent, color);
        }

        Text Label(string text, Component parent, int size, Color color, TextAnchor anchor)
        {
            var go = new GameObject("Text", typeof(RectTransform), typeof(Text));
            go.transform.SetParent(parent.transform, false);
            var t = go.GetComponent<Text>();
            t.text = text;
            t.font = font;
            t.fontSize = size + SettingsManager.TextSize * 3;
            t.color = color;
            t.alignment = anchor;
            t.horizontalOverflow = HorizontalWrapMode.Wrap;
            t.verticalOverflow = VerticalWrapMode.Overflow;
            var le = go.AddComponent<LayoutElement>();
            le.minHeight = Mathf.Max(34, size + 14);
            le.flexibleWidth = 1;
            return t;
        }

        Button AddButton(Component parent, string text, Action action, bool accent)
        {
            var go = new GameObject("Button", typeof(RectTransform), typeof(Image), typeof(Button), typeof(LayoutElement), typeof(Outline));
            go.transform.SetParent(parent.transform, false);
            var img = go.GetComponent<Image>();
            img.color = accent ? new Color(.23f, .15f, .055f, 1) : new Color(.075f, .068f, .058f, 1);
            var outline = go.GetComponent<Outline>();
            outline.effectColor = accent ? new Color(Gold.r, Gold.g, Gold.b, .55f) : new Color(Gold.r, Gold.g, Gold.b, .16f);
            outline.effectDistance = new Vector2(1f, -1f);

            var b = go.GetComponent<Button>();
            var cb = b.colors;
            cb.normalColor = Color.white;
            cb.highlightedColor = new Color(1f, .92f, .75f);
            cb.pressedColor = new Color(.78f, .66f, .43f);
            cb.disabledColor = new Color(.45f, .45f, .45f, .6f);
            b.colors = cb;

            go.GetComponent<LayoutElement>().preferredHeight = 78;
            var t = Label(text, go.transform, 21, accent ? Gold : Color.white, TextAnchor.MiddleCenter);
            Stretch(t.rectTransform);

            b.onClick.AddListener(() =>
            {
                if (uiAudio != null && clickClip != null) uiAudio.PlayOneShot(clickClip);
                SettingsManager.Haptic();
                action();
            });
            return b;
        }

        static void Stretch(RectTransform r)
        {
            r.anchorMin = Vector2.zero;
            r.anchorMax = Vector2.one;
            r.offsetMin = Vector2.zero;
            r.offsetMax = Vector2.zero;
        }
    }
}
