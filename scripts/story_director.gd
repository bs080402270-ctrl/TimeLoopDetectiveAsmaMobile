class_name StoryDirector
extends RefCounted

var rules: Dictionary = {}
var prompt_builder := ImagePromptBuilder.new()
var image_generation_available := false
var last_request: Dictionary = {}

func initialize(path := "res://data/story_rules.json") -> bool:
	var file := FileAccess.open(path,FileAccess.READ)
	if file == null:
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	rules = parsed
	return true

func set_image_generation_available(value: bool) -> void:
	image_generation_available = value

func make_scene(scene_type: String, context: Dictionary) -> Dictionary:
	var scene := context.duplicate(true)
	scene["type"] = scene_type
	var should_request := should_generate(scene_type,scene)
	var prompt := ""
	if should_request:
		prompt = prompt_builder.build(scene,rules)
	last_request = {
		"scene_type": scene_type,
		"should_generate": should_request,
		"image_generation_available": image_generation_available,
		"prompt": prompt,
		"fallback_art": str(scene.get("fallback_art","")),
		"scene_id": str(scene.get("scene_id",""))
	}
	return last_request

func should_generate(scene_type: String, context: Dictionary) -> bool:
	if not bool(rules.get("dynamic_images",{}).get("enabled",true)):
		return false
	if bool(context.get("force_visual",false)):
		return true
	var triggers: Dictionary = rules.get("triggers",{})
	if triggers.has(scene_type):
		return bool(triggers[scene_type].get("enabled",false))
	return bool(context.get("significant_change",false))

func current_prompt() -> String:
	return str(last_request.get("prompt",""))

func use_generated_image() -> bool:
	return bool(last_request.get("should_generate",false)) and image_generation_available

func fallback_art() -> String:
	return str(last_request.get("fallback_art",""))
