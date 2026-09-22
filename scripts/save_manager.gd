class_name SaveManager
extends RefCounted

func path_for(case_id: String) -> String:
	return "user://%s.save" % case_id

func load_state(case_id: String, start_location: String) -> Dictionary:
	var defaults := {
		"started": false,
		"case_id": case_id,
		"loop": 1,
		"action": 0,
		"location": start_location,
		"clues": [],
		"contradictions": [],
		"talked": [],
		"ending": "",
		"partner_choices": {},
		"loop_memories": [],
		"observations": [],
		"action_history": [],
		"partner_trust": 50
	}
	var path := path_for(case_id)
	if not FileAccess.file_exists(path):
		return defaults
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return defaults
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return defaults
	for key in defaults.keys():
		if not parsed.has(key):
			parsed[key] = defaults[key]
	return parsed

func save_state(case_id: String, state: Dictionary) -> void:
	var file := FileAccess.open(path_for(case_id), FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(state))

func clear(case_id: String) -> void:
	var path := path_for(case_id)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

func has_save(case_id: String) -> bool:
	return FileAccess.file_exists(path_for(case_id))
