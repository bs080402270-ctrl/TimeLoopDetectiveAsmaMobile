using UnityEngine;

namespace TimeLoopDetective
{
    [RequireComponent(typeof(AudioSource))]
    public class AmbientAudio : MonoBehaviour
    {
        AudioSource source;
        AudioClip ambience;

        void Awake()
        {
            source = GetComponent<AudioSource>();
            source.loop = true;
            source.playOnAwake = false;
            source.volume = 0.055f;
            ambience = BuildNoirRain();
            source.clip = ambience;
        }

        void Start()
        {
            Apply();
        }

        void Update()
        {
            if (source.mute == SettingsManager.Sound)
                Apply();
        }

        public void Apply()
        {
            source.mute = !SettingsManager.Sound;
            if (SettingsManager.Sound && !source.isPlaying)
                source.Play();
            else if (!SettingsManager.Sound && source.isPlaying)
                source.Pause();
        }

        AudioClip BuildNoirRain()
        {
            const int sampleRate = 22050;
            const int seconds = 6;
            int length = sampleRate * seconds;
            var samples = new float[length];
            var random = new System.Random(847);
            float low = 0f;

            for (int i = 0; i < length; i++)
            {
                float white = (float)(random.NextDouble() * 2.0 - 1.0);
                low = low * 0.985f + white * 0.015f;
                float t = i / (float)sampleRate;
                float drone = Mathf.Sin(2f * Mathf.PI * 55f * t) * 0.035f
                            + Mathf.Sin(2f * Mathf.PI * 82.5f * t) * 0.018f;
                samples[i] = Mathf.Clamp(low * 0.16f + white * 0.025f + drone, -0.25f, 0.25f);
            }

            var clip = AudioClip.Create("NoirRainAmbience", length, 1, sampleRate, false);
            clip.SetData(samples, 0);
            return clip;
        }
    }
}
