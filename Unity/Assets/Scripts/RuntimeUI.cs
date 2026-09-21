using System;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

namespace TimeLoopDetective
{
    public class RuntimeUI : MonoBehaviour
    {
        readonly Color Bg = new(0.025f,0.035f,0.05f,1f);
        readonly Color PanelColor = new(0.055f,0.06f,0.065f,0.96f);
        readonly Color Gold = new(0.90f,0.72f,0.36f,1f);
        readonly Color Muted = new(0.68f,0.64f,0.57f,1f);
        readonly Color Red = new(0.75f,0.11f,0.15f,1f);
        Font font;
        GameController game;
        Canvas canvas;
        RectTransform content;
        Text header;
        Text subheader;

        void Start()
        {
            font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
            game = GetComponent<GameController>();
            BuildShell();
            ShowMenu();
        }

        void BuildShell()
        {
            var canvasGo = new GameObject("Canvas", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            canvasGo.transform.SetParent(transform,false);
            canvas = canvasGo.GetComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            var scaler = canvasGo.GetComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(720,1280);
            scaler.matchWidthOrHeight = 0.5f;

            var bg = CreateImage("Background", canvas.transform, Bg);
            Stretch(bg.rectTransform);

            var root = CreateCreatePanel("Root", canvas.transform, new Color(0,0,0,0));
            Stretch(root);
            var layout = root.gameObject.AddComponent<VerticalLayoutGroup>();
            layout.padding = new RectOffset(26,26,28,22);
            layout.spacing = 12;
            layout.childForceExpandHeight = false;
            layout.childForceExpandWidth = true;

            header = Label("TIME LOOP DETECTIVE", root, 42, Color.white, TextAnchor.MiddleCenter);
            header.gameObject.AddComponent<LayoutElement>().preferredHeight = 64;
            subheader = Label("", root, 20, Muted, TextAnchor.MiddleCenter);
            subheader.gameObject.AddComponent<LayoutElement>().preferredHeight = 44;

            var divider = Image("Divider", root, new Color(Gold.r,Gold.g,Gold.b,.45f));
            divider.gameObject.AddComponent<LayoutElement>().preferredHeight = 2;

            var scrollGo = new GameObject("Scroll", typeof(RectTransform), typeof(ScrollRect), typeof(Image), typeof(Mask), typeof(LayoutElement));
            scrollGo.transform.SetParent(root,false);
            scrollGo.GetComponent<Image>().color = new Color(0,0,0,0);
            scrollGo.GetComponent<Mask>().showMaskGraphic = false;
            scrollGo.GetComponent<LayoutElement>().flexibleHeight = 1;
            var viewport = scrollGo.GetComponent<RectTransform>();
            Stretch(viewport);

            var contentGo = new GameObject("Content", typeof(RectTransform), typeof(VerticalLayoutGroup), typeof(ContentSizeFitter));
            contentGo.transform.SetParent(scrollGo.transform,false);
            content = contentGo.GetComponent<RectTransform>();
            content.anchorMin = new Vector2(0,1);
            content.anchorMax = new Vector2(1,1);
            content.pivot = new Vector2(.5f,1);
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

            var nav = new GameObject("BottomNav", typeof(RectTransform), typeof(HorizontalLayoutGroup), typeof(LayoutElement));
            nav.transform.SetParent(root,false);
            nav.GetComponent<LayoutElement>().preferredHeight = 82;
            var n = nav.GetComponent<HorizontalLayoutGroup>();
            n.spacing = 8; n.childForceExpandWidth = true; n.childForceExpandHeight = true;
            AddButton(nav.transform,"HOME",ShowMenu,false);
            AddButton(nav.transform,"CASES",ShowCases,false);
            AddButton(nav.transform,"HOW TO",ShowHowTo,false);
            AddButton(nav.transform,"SETTINGS",ShowSettings,false);
        }

        void ClearContent()
        {
            for(int i=content.childCount-1;i>=0;i--) Destroy(content.GetChild(i).gameObject);
            content.anchoredPosition = Vector2.zero;
        }

        void ShowMenu()
        {
            ClearContent();
            header.text="TIME LOOP DETECTIVE";
            subheader.text="SAME TIME. DIFFERENT TRUTHS. BREAK THE LOOP.";

            var hero=CreatePanel("Hero",content,PanelColor);
            hero.gameObject.AddComponent<LayoutElement>().preferredHeight=430;
            var v=hero.gameObject.AddComponent<VerticalLayoutGroup>();
            v.padding=new RectOffset(22,22,38,28); v.spacing=15; v.childAlignment=TextAnchor.MiddleCenter;
            Label("◷",hero,96,Gold,TextAnchor.MiddleCenter);
            Label("INVESTIGATE. UNCOVER.\nBREAK THE LOOP.",hero,34,Color.white,TextAnchor.MiddleCenter);
            Label("Five mysteries. Three loops each.\nYou are the only one who remembers.",hero,22,Muted,TextAnchor.MiddleCenter);
            AddButton(content,"START INVESTIGATION  →",ShowDifficulty,true);
            AddButton(content,"HOW TO PLAY",ShowHowTo,false);
        }

        void ShowHowTo()
        {
            ClearContent(); header.text="HOW THE LOOP WORKS"; subheader.text="Observe. Question. Remember. Deduce.";
            Step("01","INVESTIGATE LOCATIONS","Search every scene for useful clues.");
            Step("02","QUESTION SUSPECTS","Stories change. Contradictions reveal the truth.");
            Step("03","CARRY CLUES ACROSS LOOPS","The world resets. Your knowledge does not.");
            AddButton(content,"CHOOSE DIFFICULTY  →",ShowDifficulty,true);
        }

        void Step(string num,string title,string desc)
        {
            var p=CreatePanel("Step",content,PanelColor); p.gameObject.AddComponent<LayoutElement>().preferredHeight=145;
            var h=p.gameObject.AddComponent<HorizontalLayoutGroup>(); h.padding=new RectOffset(14,14,14,14); h.spacing=14;
            var n=Label(num,p,30,Gold,TextAnchor.MiddleCenter); n.gameObject.AddComponent<LayoutElement>().preferredWidth=72;
            var box=new GameObject("Text",typeof(RectTransform),typeof(VerticalLayoutGroup)); box.transform.SetParent(p,false);
            box.GetComponent<VerticalLayoutGroup>().spacing=5;
            Label(title,box.transform,25,Color.white,TextAnchor.MiddleLeft);
            Label(desc,box.transform,18,Muted,TextAnchor.MiddleLeft);
        }

        void ShowDifficulty()
        {
            ClearContent(); header.text="SELECT DIFFICULTY"; subheader.text="Choose how challenging the loop will be.";
            DifficultyCard(DifficultyMode.Easy,"EASY","More hints, two extra actions per loop, easier final deduction.");
            DifficultyCard(DifficultyMode.Hard,"HARD","Balanced investigation, standard actions and limited guidance.");
            DifficultyCard(DifficultyMode.Hardest,"HARDEST","No hints, two fewer actions and the strictest final deduction.");
            AddButton(content,"CONTINUE TO CASES  →",ShowCases,true);
        }

        void DifficultyCard(DifficultyMode mode,string title,string desc)
        {
            bool selected=SettingsManager.Difficulty==mode;
            var p=Panel(title,content,selected?new Color(.12f,.09f,.045f,1):PanelColor);
            p.gameObject.AddComponent<LayoutElement>().preferredHeight=165;
            var v=p.gameObject.AddComponent<VerticalLayoutGroup>(); v.padding=new RectOffset(18,18,14,14); v.spacing=6;
            Label((selected?"✓  ":"○  ")+title,p,30,selected?Gold:Color.white,TextAnchor.MiddleLeft);
            Label(desc,p,18,Muted,TextAnchor.MiddleLeft);
            var b=AddButton(p,"SELECT",()=>{SettingsManager.Difficulty=mode;ShowDifficulty();},selected);
            b.interactable=!selected; b.GetComponent<LayoutElement>().preferredHeight=58;
            b.GetComponentInChildren<Text>().text=selected?"SELECTED":"SELECT";
        }

        void ShowCases()
        {
            ClearContent(); header.text="SELECT A CASE"; subheader.text="Each case is a loop. Each truth changes everything.";
            if(game.Cases.Count==0){ Label("Case data could not be loaded.",content,24,Red,TextAnchor.MiddleCenter); return; }
            int i=1;
            foreach(var c in game.Cases)
            {
                var p=Panel(c.id,content,PanelColor); p.gameObject.AddComponent<LayoutElement>().preferredHeight=180;
                var v=p.gameObject.AddComponent<VerticalLayoutGroup>(); v.padding=new RectOffset(18,18,15,15); v.spacing=5;
                Label($"{i:00}  {c.title}",p,27,Gold,TextAnchor.MiddleLeft);
                Label(c.subtitle,p,18,Muted,TextAnchor.MiddleLeft);
                string id=c.id;
                var b=AddButton(p,SaveManager.HasSave(id)?"CONTINUE  →":"OPEN CASE  →",()=>OpenCase(id),false);
                b.GetComponent<LayoutElement>().preferredHeight=62;
                i++;
            }
        }

        void OpenCase(string id)
        {
            if(!game.OpenCase(id)) return;
            if(!game.State.started) game.StartNew();
            ShowGame();
        }

        void ShowGame()
        {
            ClearContent();
            var c=game.CurrentCase; var s=game.State;
            header.text=c.title;
            subheader.text=$"{SettingsManager.Difficulty.ToString().ToUpper()}  •  LOOP {s.loop}/3  •  ACTIONS {s.action}/{game.EffectiveMaxActions()}  •  CLUES {s.clues.Count}/{c.clues.Count}";
            if(c.locations.TryGetValue(s.location,out var loc))
            {
                var hero=CreatePanel("Location",content,new Color(.05f,.045f,.035f,.96f));
                var v=hero.gameObject.AddComponent<VerticalLayoutGroup>(); v.padding=new RectOffset(18,18,18,18); v.spacing=8;
                Label(loc.name,hero,32,Gold,TextAnchor.MiddleLeft);
                Label(loc.description,hero,20,Color.white,TextAnchor.MiddleLeft);
                foreach(var person in loc.people) if(c.suspects.ContainsKey(person)) SuspectCard(person);
                foreach(var clue in c.clues.Where(x=>x.Value.location==s.location)) ClueCard(clue.Key);
            }
            Label("TRAVEL",content,24,Gold,TextAnchor.MiddleLeft);
            foreach(var l in c.locations) { string id=l.Key; AddButton(content,l.Value.name.ToUpper(),()=>{game.Travel(id);ShowGame();},id==s.location); }
            AddButton(content,"CASEBOOK / EVIDENCE",ShowCasebook,false);
            if(s.action>=game.EffectiveMaxActions()) AddButton(content,"RESET THE TIMELINE  ↻",()=>{game.ResetLoop();ShowGame();},true);
        }

        void SuspectCard(string id)
        {
            var d=game.CurrentCase.suspects[id];
            var p=CreatePanel("Suspect",content,PanelColor); var v=p.gameObject.AddComponent<VerticalLayoutGroup>(); v.padding=new RectOffset(16,16,12,12); v.spacing=5;
            Label(d.name,p,27,Color.white,TextAnchor.MiddleLeft);
            Label(d.role,p,18,Muted,TextAnchor.MiddleLeft);
            AddButton(p,"INTERROGATE  →",()=>Interrogate(id),true);
        }

        void Interrogate(string id)
        {
            game.Talk(id);
            var d=game.CurrentCase.suspects[id];
            int idx=Mathf.Clamp(game.State.loop-1,0,Mathf.Max(0,d.dialogue.Count-1));
            ClearContent(); header.text=d.name+" • INTERROGATION"; subheader.text=d.role;
            var p=CreatePanel("Dialogue",content,PanelColor); var v=p.gameObject.AddComponent<VerticalLayoutGroup>(); v.padding=new RectOffset(20,20,25,25); v.spacing=15;
            Label(d.dialogue.Count>0?d.dialogue[idx]:"They watch you carefully.",p,24,Color.white,TextAnchor.UpperLeft);
            AddButton(p,"THIS DOESN'T ADD UP...  →",()=>Press(id),true);
            AddButton(content,"BACK TO SCENE",ShowGame,false);
        }

        void Press(string id)
        {
            bool ok=game.TryContradiction(id);
            ClearContent(); header.text=ok?"CONTRADICTION FOUND":"NEED MORE EVIDENCE";
            subheader.text=ok?game.CurrentCase.suspects[id].contradiction.result:"Return to the scene and keep investigating.";
            AddButton(content,"BACK TO SCENE",ShowGame,true);
        }

        void ClueCard(string id)
        {
            var d=game.CurrentCase.clues[id]; bool found=game.State.clues.Contains(id);
            var p=CreatePanel("Clue",content,found?new Color(.11f,.09f,.045f,1):PanelColor);
            var v=p.gameObject.AddComponent<VerticalLayoutGroup>(); v.padding=new RectOffset(16,16,12,12); v.spacing=5;
            Label((found?"RECORDED • ":"")+d.name,p,24,found?Gold:Color.white,TextAnchor.MiddleLeft);
            Label(found?d.description:HintText(),p,17,Muted,TextAnchor.MiddleLeft);
            var b=AddButton(p,found?"RECORDED":"INSPECT",()=>{game.AddClue(id);ShowGame();},false); b.interactable=!found;
        }

        string HintText()=>SettingsManager.Difficulty switch {
            DifficultyMode.Easy=>"Hint: evidence is hidden in this area.",
            DifficultyMode.Hardest=>"No hint available. Trust your observations.",
            _=>"Inspect this area for evidence."
        };

        void ShowCasebook()
        {
            ClearContent(); header.text="CASEBOOK / EVIDENCE"; subheader.text=$"COLLECTED {game.State.clues.Count}/{game.CurrentCase.clues.Count}";
            foreach(var kv in game.CurrentCase.clues)
                Label((game.State.clues.Contains(kv.Key)?"■ ":"□ ")+kv.Value.name,content,21,game.State.clues.Contains(kv.Key)?Gold:Muted,TextAnchor.MiddleLeft);
            Label("TIMELINE",content,25,Gold,TextAnchor.MiddleLeft);
            foreach(var line in game.CurrentCase.timeline) Label("• "+line,content,18,Muted,TextAnchor.MiddleLeft);
            AddButton(content,"MAKE A DEDUCTION  →",ShowDeduction,true);
            AddButton(content,"BACK TO SCENE",ShowGame,false);
        }

        void ShowDeduction()
        {
            ClearContent(); header.text="FINAL DEDUCTION"; subheader.text=game.CurrentCase.deduction_prompt;
            Label("WHO IS RESPONSIBLE?",content,31,Red,TextAnchor.MiddleCenter);
            foreach(var kv in game.CurrentCase.suspects){ string id=kv.Key; AddButton(content,kv.Value.name,()=>Finish(game.Accuse(id)),false); }
            AddButton(content,"NOT YET",ShowGame,false);
        }

        void Finish(string kind)
        {
            ClearContent(); header.text=kind=="true"?"CASE CLOSED":"THE LOOP RESISTS";
            string text=kind=="true"?game.CurrentCase.truth:kind=="partial"?game.CurrentCase.partial:game.CurrentCase.wrong;
            Label(kind=="true"?"TRUE ENDING":kind=="partial"?"PARTIAL TRUTH":"WRONG ACCUSATION",content,34,kind=="wrong"?Red:Gold,TextAnchor.MiddleCenter);
            Label(text,content,22,Color.white,TextAnchor.UpperLeft);
            AddButton(content,"CASE SELECT",ShowCases,true);
        }

        void ShowSettings()
        {
            ClearContent(); header.text="SETTINGS"; subheader.text="Tune readability, graphics and gameplay.";
            AddButton(content,"DIFFICULTY: "+SettingsManager.Difficulty.ToString().ToUpper(),ShowDifficulty,false);
            AddButton(content,"GRAPHICS: "+(SettingsManager.EnhancedGraphics?"ENHANCED":"PERFORMANCE"),()=>{SettingsManager.EnhancedGraphics=!SettingsManager.EnhancedGraphics;ShowSettings();},false);
            AddButton(content,"TEXT SIZE",()=>{SettingsManager.TextSize=(SettingsManager.TextSize+1)%3;ShowSettings();},false);
            AddButton(content,"VIBRATION: "+(SettingsManager.Vibration?"ON":"OFF"),()=>{SettingsManager.Vibration=!SettingsManager.Vibration;ShowSettings();},false);
            Label("UNITY PORT • WORKING BRANCH",content,18,Muted,TextAnchor.MiddleCenter);
        }

        Image CreatePanel(string name,Transform parent,Color color)
        {
            var go=new GameObject(name,typeof(RectTransform),typeof(Image)); go.transform.SetParent(parent,false);
            var img=go.GetComponent<Image>(); img.color=color; return img;
        }

        Image CreateImage(string name,Transform parent,Color color)=>CreatePanel(name,parent,color);

        Text Label(string text,Transform parent,int size,Color color,TextAnchor anchor)
        {
            var go=new GameObject("Text",typeof(RectTransform),typeof(Text)); go.transform.SetParent(parent,false);
            var t=go.GetComponent<Text>(); t.text=text; t.font=font; t.fontSize=size; t.color=color; t.alignment=anchor; t.horizontalOverflow=HorizontalWrapMode.Wrap; t.verticalOverflow=VerticalWrapMode.Overflow;
            var le=go.AddComponent<LayoutElement>(); le.minHeight=Mathf.Max(34,size+14); le.flexibleWidth=1;
            return t;
        }

        Button AddButton(Transform parent,string text,Action action,bool accent)
        {
            var go=new GameObject("Button",typeof(RectTransform),typeof(Image),typeof(Button),typeof(LayoutElement)); go.transform.SetParent(parent,false);
            go.GetComponent<Image>().color=accent?new Color(.23f,.15f,.055f,1):new Color(.085f,.075f,.06f,1);
            var b=go.GetComponent<Button>(); var cb=b.colors; cb.normalColor=Color.white; cb.highlightedColor=new Color(1f,.92f,.75f); cb.pressedColor=new Color(.8f,.68f,.45f); b.colors=cb;
            go.GetComponent<LayoutElement>().preferredHeight=78;
            var t=Label(text,go.transform,22,accent?Gold:Color.white,TextAnchor.MiddleCenter); Stretch(t.rectTransform);
            b.onClick.AddListener(()=>action());
            return b;
        }

        static void Stretch(RectTransform r){r.anchorMin=Vector2.zero;r.anchorMax=Vector2.one;r.offsetMin=Vector2.zero;r.offsetMax=Vector2.zero;}
    }
}
