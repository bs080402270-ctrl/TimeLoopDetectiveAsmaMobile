using UnityEngine;

namespace TimeLoopDetective
{
    public static class Bootstrap
    {
        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
        static void Start()
        {
            if(Object.FindFirstObjectByType<GameController>()!=null) return;
            var root=new GameObject("TimeLoopDetective");
            Object.DontDestroyOnLoad(root);
            root.AddComponent<GameController>();
            root.AddComponent<RuntimeUI>();
        }
    }
}
