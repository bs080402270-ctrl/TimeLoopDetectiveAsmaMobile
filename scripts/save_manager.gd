class_name SaveManager
extends RefCounted

const SAVE_PATH := "user://case_01.save"

func load_state() -> Dictionary:
	var defaults := {
		"started": false,
		"loop": 1,
		"action": 0,
		"location": "cafe",
		"clues": [],
		"contradictions": [],
		"talked": [],
		"ending": ""
	}
	if not FileAccess.file_exists(SAVE_PATH):
		return defaults
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return defaults
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return defaults
	for key in defaults.keys():
		if not parsed.has(key):
			parsed[key] = defaults[key]
	return parsed

func save_state(state: Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(state))

func clear() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
