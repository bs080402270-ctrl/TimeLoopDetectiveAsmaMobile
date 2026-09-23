class_name ImagePromptBuilder
extends RefCounted

const DEFAULT_STYLE := "cinematic dark blue-black noir manhwa/webtoon detective thriller, highly detailed rainy reflections, warm amber practical lighting, electric-blue accents, premium mobile visual novel, portrait 9:16"

func build(scene: Dictionary, rules: Dictionary) -> String:
	var parts: Array[String] = []
	var style := str(rules.get("visual_consistency",{}).get("style",DEFAULT_STYLE))
	parts.append(style)
	parts.append("Current gameplay moment only. Do not reveal future story information.")\n\tparts.append("Compose as a full-screen mobile gameplay background: cinematic characters and environment in the upper and middle frame, with darker uncluttered lower space reserved for dialogue and choice panels. No UI text inside the generated artwork.")
	parts.append("Scene type: %s." % str(scene.get("type","story")))
	parts.append("Location: %s." % str(scene.get("location_name","current location")))
	parts.append("Time loop: %d." % int(scene.get("loop",1)))
	var chars: Array = scene.get("characters",[])
	if chars.size() > 0:
		parts.append("Characters physically present: %s." % ", ".join(PackedStringArray(chars)))
	if bool(scene.get("face_to_face",false)):
		parts.append("Show Detective Asma and her detective partner physically together in the same location, clearly interacting face to face. Make the player feel present inside the scene.")
	var action := str(scene.get("action",""))
	if action != "":
		parts.append("Current action: %s." % action)
	var mood := str(scene.get("mood","tense investigative suspense"))
	parts.append("Mood: %s." % mood)
	var visible_clues: Array = scene.get("visible_clues",[])
	if visible_clues.size() > 0:
		parts.append("Only currently discovered visible clues: %s." % ", ".join(PackedStringArray(visible_clues)))
	var changes: Array = scene.get("loop_changes",[])
	if changes.size() > 0:
		parts.append("Clearly show these differences from the previous loop: %s." % ", ".join(PackedStringArray(changes)))
	if str(scene.get("type","")) == "time_loop_reset":
		parts.append("Visually represent the time reset itself: subtle temporal distortion, repeated environment, and one meaningful changed detail if known.")
	if str(scene.get("type","")) in ["chase","pursuit","cover","danger","confrontation","capture"]:
		parts.append("Use dynamic cinematic body language and environmental action appropriate to the current event.")
	parts.append("Do not add text captions, UI labels, hidden clues, future characters, or spoilers not present in the current game state.")
	return " ".join(parts)
