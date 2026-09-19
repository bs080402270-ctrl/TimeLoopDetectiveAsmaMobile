using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class GameBootstrap : MonoBehaviour
{
    private Canvas canvas;
    private Text statusText;
    private Text dialogueText;
    private Text clueText;
    private GameObject dialoguePanel;
    private GameObject endingPanel;
    private Text endingText;
    private PlayerMover player;
    private readonly List<SuspectActor> suspects = new();
    private readonly HashSet<string> clues = new();
    private int loop = 1;
    private bool gameEnded;

    private readonly string[] clueNames =
    {
        "Broken Watch",
        "Coffee Receipt",
        "Wet Umbrella",
        "Red Thread",
        "Voicemail"
    };

    private void Awake()
    {
        Application.targetFrameRate = 60;
        EnsureEventSystem();
        BuildWorld();
        BuildUI();
        LoadProgress();
        RefreshStatus();
    }

    private void Update()
    {
        if (gameEnded) return;

        if (Input.GetKeyDown(KeyCode.E))
            TryInteract();

        if (Input.GetKeyDown(KeyCode.R))
            ResetLoop();

        if (Input.GetKeyDown(KeyCode.N))
            ToggleNotebook();
    }

    private void EnsureEventSystem()
    {
        if (FindObjectOfType<EventSystem>() != null) return;
        var es = new GameObject("EventSystem");
        es.AddComponent<EventSystem>();
        es.AddComponent<StandaloneInputModule>();
    }

    private void BuildWorld()
    {
        var camObj = new GameObject("Main Camera");
        camObj.tag = "MainCamera";
        var cam = camObj.AddComponent<Camera>();
        cam.transform.position = new Vector3(0, 8, -10);
        cam.transform.rotation = Quaternion.Euler(28, 0, 0);
        cam.clearFlags = CameraClearFlags.SolidColor;
        cam.backgroundColor = new Color(0.08f, 0.08f, 0.12f);

        var lightObj = new GameObject("Key Light");
        var light = lightObj.AddComponent<Light>();
        light.type = LightType.Directional;
        light.intensity = 1.1f;
        lightObj.transform.rotation = Quaternion.Euler(45, -30, 0);

        CreatePrimitive("Floor", PrimitiveType.Cube, new Vector3(0, -0.25f, 0), new Vector3(12, 0.5f, 10), new Color(0.35f, 0.24f, 0.18f));
        CreatePrimitive("BackWall", PrimitiveType.Cube, new Vector3(0, 2, 4.7f), new Vector3(12, 4, 0.5f), new Color(0.18f, 0.12f, 0.10f));
        CreatePrimitive("Counter", PrimitiveType.Cube, new Vector3(0, 0.7f, 2.7f), new Vector3(6, 1.4f, 1.1f), new Color(0.22f, 0.12f, 0.08f));

        var p = CreatePrimitive("Detective", PrimitiveType.Capsule, new Vector3(0, 1, -3), Vector3.one, new Color(0.2f, 0.55f, 0.9f));
        player = p.AddComponent<PlayerMover>();

        suspects.Add(CreateSuspect("Maya", new Vector3(-3, 1, 1), new Color(0.8f, 0.25f, 0.3f), 0));
        suspects.Add(CreateSuspect("Omar", new Vector3(0, 1, 1.2f), new Color(0.25f, 0.75f, 0.4f), 1));
        suspects.Add(CreateSuspect("Lina", new Vector3(3, 1, 1), new Color(0.75f, 0.45f, 0.9f), 2));

        CreateCluePickup("Broken Watch", new Vector3(-4.3f, 0.35f, -1.2f));
        CreateCluePickup("Coffee Receipt", new Vector3(1.6f, 0.35f, 2.0f));
        CreateCluePickup("Wet Umbrella", new Vector3(4.4f, 0.55f, 3.6f));
        CreateCluePickup("Red Thread", new Vector3(-2.2f, 0.35f, 3.7f));
        CreateCluePickup("Voicemail", new Vector3(3.7f, 0.35f, -2.5f));
    }

    private GameObject CreatePrimitive(string name, PrimitiveType type, Vector3 pos, Vector3 scale, Color color)
    {
        var go = GameObject.CreatePrimitive(type);
        go.name = name;
        go.transform.position = pos;
        go.transform.localScale = scale;
        var r = go.GetComponent<Renderer>();
        if (r != null)
        {
            r.material = new Material(Shader.Find("Standard"));
            r.material.color = color;
        }
        return go;
    }

    private SuspectActor CreateSuspect(string name, Vector3 pos, Color color, int index)
    {
        var go = CreatePrimitive(name, PrimitiveType.Capsule, pos, Vector3.one, color);
        var s = go.AddComponent<SuspectActor>();
        s.Setup(name, index);
        return s;
    }

    private void CreateCluePickup(string clue, Vector3 pos)
    {
        var go = CreatePrimitive(clue, PrimitiveType.Sphere, pos, Vector3.one * 0.55f, new Color(0.95f, 0.8f, 0.2f));
        var cp = go.AddComponent<CluePickup>();
        cp.Setup(clue, this);
    }

    private void BuildUI()
    {
        var canvasObj = new GameObject("Canvas");
        canvas = canvasObj.AddComponent<Canvas>();
        canvas.renderMode = RenderMode.ScreenSpaceOverlay;
        canvasObj.AddComponent<CanvasScaler>().uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
        canvasObj.AddComponent<GraphicRaycaster>();

        statusText = CreateText(canvas.transform, "Status", new Vector2(0.02f, 0.93f), new Vector2(0.75f, 0.995f), 26, TextAnchor.MiddleLeft);
        clueText = CreateText(canvas.transform, "Notebook", new Vector2(0.02f, 0.55f), new Vector2(0.42f, 0.91f), 22, TextAnchor.UpperLeft);
        clueText.gameObject.SetActive(false);

        CreateButton(canvas.transform, "Interact", new Vector2(0.78f, 0.04f), new Vector2(0.97f, 0.14f), TryInteract);
        CreateButton(canvas.transform, "Loop Reset", new Vector2(0.78f, 0.16f), new Vector2(0.97f, 0.26f), ResetLoop);
        CreateButton(canvas.transform, "Notebook", new Vector2(0.78f, 0.28f), new Vector2(0.97f, 0.38f), ToggleNotebook);

        dialoguePanel = CreatePanel(canvas.transform, new Vector2(0.10f, 0.05f), new Vector2(0.72f, 0.33f), new Color(0, 0, 0, 0.82f));
        dialogueText = CreateText(dialoguePanel.transform, "DialogueText", new Vector2(0.04f, 0.24f), new Vector2(0.96f, 0.95f), 24, TextAnchor.UpperLeft);
        CreateButton(dialoguePanel.transform, "Continue", new Vector2(0.64f, 0.04f), new Vector2(0.95f, 0.22f), () => dialoguePanel.SetActive(false));
        dialoguePanel.SetActive(false);

        endingPanel = CreatePanel(canvas.transform, new Vector2(0.16f, 0.2f), new Vector2(0.84f, 0.80f), new Color(0.03f, 0.03f, 0.05f, 0.95f));
        endingText = CreateText(endingPanel.transform, "EndingText", new Vector2(0.08f, 0.28f), new Vector2(0.92f, 0.92f), 34, TextAnchor.MiddleCenter);
        CreateButton(endingPanel.transform, "Restart Case", new Vector2(0.31f, 0.08f), new Vector2(0.69f, 0.22f), RestartCase);
        endingPanel.SetActive(false);

        var mobile = canvasObj.AddComponent<MobileControls>();
        mobile.Setup(player);
    }

    private Text CreateText(Transform parent, string name, Vector2 min, Vector2 max, int size, TextAnchor align)
    {
        var go = new GameObject(name);
        go.transform.SetParent(parent, false);
        var rt = go.AddComponent<RectTransform>();
        rt.anchorMin = min; rt.anchorMax = max; rt.offsetMin = Vector2.zero; rt.offsetMax = Vector2.zero;
        var t = go.AddComponent<Text>();
        t.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
        t.fontSize = size;
        t.color = Color.white;
        t.alignment = align;
        return t;
    }

    private GameObject CreatePanel(Transform parent, Vector2 min, Vector2 max, Color color)
    {
        var go = new GameObject("Panel");
        go.transform.SetParent(parent, false);
        var rt = go.AddComponent<RectTransform>();
        rt.anchorMin = min; rt.anchorMax = max; rt.offsetMin = Vector2.zero; rt.offsetMax = Vector2.zero;
        var img = go.AddComponent<Image>(); img.color = color;
        return go;
    }

    private void CreateButton(Transform parent, string label, Vector2 min, Vector2 max, UnityEngine.Events.UnityAction onClick)
    {
        var go = new GameObject(label + "Button");
        go.transform.SetParent(parent, false);
        var rt = go.AddComponent<RectTransform>();
        rt.anchorMin = min; rt.anchorMax = max; rt.offsetMin = Vector2.zero; rt.offsetMax = Vector2.zero;
        var img = go.AddComponent<Image>(); img.color = new Color(0.12f, 0.16f, 0.24f, 0.95f);
        var btn = go.AddComponent<Button>(); btn.onClick.AddListener(onClick);
        var t = CreateText(go.transform, "Label", Vector2.zero, Vector2.one, 22, TextAnchor.MiddleCenter);
        t.text = label;
    }

    public void CollectClue(string clue, GameObject pickup)
    {
        if (clues.Add(clue))
        {
            pickup.SetActive(false);
            SaveProgress();
            ShowDialogue("Clue found: " + clue + "\nThe loop remembers what you learn.");
            RefreshStatus();
        }
    }

    public void TryInteract()
    {
        SuspectActor nearest = null;
        float best = 2.4f;
        foreach (var s in suspects)
        {
            float d = Vector3.Distance(player.transform.position, s.transform.position);
            if (d < best) { best = d; nearest = s; }
        }
        if (nearest == null)
        {
            ShowDialogue("No one is close enough. Move nearer to a suspect or glowing clue.");
            return;
        }
        Talk(nearest);
    }

    private void Talk(SuspectActor s)
    {
        string line;
        if (s.Index == 0)
        {
            line = loop == 1 ? "Maya: I arrived at 8:40. Ask Omar; he was already here." :
                   clues.Contains("Coffee Receipt") ? "Maya: That receipt isn't mine. Lina ordered that exact drink." :
                   "Maya: You keep asking the same questions. How do you know what happens next?";
        }
        else if (s.Index == 1)
        {
            line = clues.Contains("Broken Watch") ? "Omar: The watch stopped at 8:47, exactly when the lights failed." :
                   "Omar: The power flickered before the crash. I heard someone near the back door.";
        }
        else
        {
            line = clues.Contains("Wet Umbrella") && clues.Contains("Red Thread")
                ? "Lina: Fine. I used the back door, but I was trying to stop Maya—not hurt anyone."
                : "Lina: I never left my table. Check the front entrance camera.";
        }

        ShowDialogue(line);

        if (clues.Count >= 3 && loop >= 2)
            CheckEnding();
    }

    private void CheckEnding()
    {
        if (clues.Contains("Broken Watch") && clues.Contains("Voicemail") && clues.Contains("Red Thread"))
            EndGame("TRUE ENDING\n\nYou reconstruct the 8:47 blackout and prove the incident was staged to hide a theft. The loop finally breaks.");
        else if (clues.Count >= 4)
            EndGame("ENDING: WRONG ACCUSATION\n\nYou force a conclusion too early. The loop ends, but the real motive remains hidden.");
    }

    private void EndGame(string text)
    {
        gameEnded = true;
        endingText.text = text;
        endingPanel.SetActive(true);
        SaveProgress();
    }

    public void ResetLoop()
    {
        if (gameEnded) return;
        loop = Mathf.Min(loop + 1, 3);
        player.transform.position = new Vector3(0, 1, -3);
        foreach (var s in suspects) s.ResetForLoop(loop);
        ShowDialogue("Loop " + loop + " begins. Your clues remain in memory.");
        RefreshStatus();
        SaveProgress();

        if (loop == 3 && clues.Count >= 5)
            EndGame("TRUE ENDING\n\nWith every clue connected before the third reset, you expose the staged crime and escape the café.");
    }

    private void ToggleNotebook()
    {
        clueText.gameObject.SetActive(!clueText.gameObject.activeSelf);
        RefreshNotebook();
    }

    private void RefreshNotebook()
    {
        var text = "CASE NOTEBOOK\n\n";
        foreach (var c in clueNames)
            text += (clues.Contains(c) ? "[FOUND] " : "[ ? ] ") + c + "\n";
        text += "\nGoal: connect the 8:47 blackout, the back door, and the voicemail before Loop 3 ends.";
        clueText.text = text;
    }

    private void RefreshStatus()
    {
        statusText.text = "TIME LOOP DETECTIVE    Loop " + loop + "/3    Clues " + clues.Count + "/5";
        RefreshNotebook();
    }

    private void ShowDialogue(string text)
    {
        dialogueText.text = text;
        dialoguePanel.SetActive(true);
    }

    private void SaveProgress()
    {
        PlayerPrefs.SetInt("tld_loop", loop);
        PlayerPrefs.SetString("tld_clues", string.Join("|", clues));
        PlayerPrefs.Save();
    }

    private void LoadProgress()
    {
        loop = Mathf.Clamp(PlayerPrefs.GetInt("tld_loop", 1), 1, 3);
        string raw = PlayerPrefs.GetString("tld_clues", "");
        if (!string.IsNullOrEmpty(raw))
            foreach (var c in raw.Split('|')) if (!string.IsNullOrWhiteSpace(c)) clues.Add(c);
    }

    private void RestartCase()
    {
        PlayerPrefs.DeleteKey("tld_loop");
        PlayerPrefs.DeleteKey("tld_clues");
        PlayerPrefs.Save();
        UnityEngine.SceneManagement.SceneManager.LoadScene(UnityEngine.SceneManagement.SceneManager.GetActiveScene().buildIndex);
    }
}

public class PlayerMover : MonoBehaviour
{
    public float speed = 4.5f;
    private Vector2 mobile;

    public void SetMobile(Vector2 value) => mobile = value;

    private void Update()
    {
        float h = Input.GetAxisRaw("Horizontal") + mobile.x;
        float v = Input.GetAxisRaw("Vertical") + mobile.y;
        var move = new Vector3(h, 0, v);
        if (move.sqrMagnitude > 1) move.Normalize();
        transform.position += move * speed * Time.deltaTime;
        transform.position = new Vector3(Mathf.Clamp(transform.position.x, -5.3f, 5.3f), 1, Mathf.Clamp(transform.position.z, -4.0f, 4.0f));
    }
}

public class SuspectActor : MonoBehaviour
{
    public string SuspectName { get; private set; }
    public int Index { get; private set; }
    public void Setup(string n, int i) { SuspectName = n; Index = i; }
    public void ResetForLoop(int loop) { transform.localScale = Vector3.one * (1f + 0.03f * loop); }
}

public class CluePickup : MonoBehaviour
{
    private string clue;
    private GameBootstrap game;
    public void Setup(string c, GameBootstrap g) { clue = c; game = g; }

    private void Update()
    {
        transform.Rotate(0, 80f * Time.deltaTime, 0, Space.World);
        var p = FindObjectOfType<PlayerMover>();
        if (p != null && Vector3.Distance(transform.position, p.transform.position) < 1.2f)
            game.CollectClue(clue, gameObject);
    }
}

public class MobileControls : MonoBehaviour
{
    private PlayerMover player;
    private Vector2 held;

    public void Setup(PlayerMover p)
    {
        player = p;
        AddHoldButton("Left", new Vector2(0.03f, 0.04f), new Vector2(0.12f, 0.14f), new Vector2(-1, 0));
        AddHoldButton("Right", new Vector2(0.23f, 0.04f), new Vector2(0.32f, 0.14f), new Vector2(1, 0));
        AddHoldButton("Up", new Vector2(0.13f, 0.15f), new Vector2(0.22f, 0.25f), new Vector2(0, 1));
        AddHoldButton("Down", new Vector2(0.13f, 0.02f), new Vector2(0.22f, 0.12f), new Vector2(0, -1));
    }

    private void AddHoldButton(string label, Vector2 min, Vector2 max, Vector2 dir)
    {
        var go = new GameObject(label + "MobileButton");
        go.transform.SetParent(transform, false);
        var rt = go.AddComponent<RectTransform>();
        rt.anchorMin = min; rt.anchorMax = max; rt.offsetMin = Vector2.zero; rt.offsetMax = Vector2.zero;
        var img = go.AddComponent<Image>(); img.color = new Color(1,1,1,0.15f);
        var trigger = go.AddComponent<EventTrigger>();
        AddTrigger(trigger, EventTriggerType.PointerDown, _ => { held = dir; player.SetMobile(held); });
        AddTrigger(trigger, EventTriggerType.PointerUp, _ => { held = Vector2.zero; player.SetMobile(held); });
        var text = go.AddComponent<Text>();
        text.font = Resources.GetBuiltinResource<Font>("Arial.ttf");
        text.text = label;
        text.alignment = TextAnchor.MiddleCenter;
        text.fontSize = 20;
        text.color = Color.white;
    }

    private static void AddTrigger(EventTrigger trigger, EventTriggerType type, Action<BaseEventData> action)
    {
        var entry = new EventTrigger.Entry { eventID = type };
        entry.callback.AddListener(data => action(data));
        trigger.triggers.Add(entry);
    }
}
