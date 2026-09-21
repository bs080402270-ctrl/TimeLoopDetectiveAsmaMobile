class_name SettingsManager
extends RefCounted

const PATH := "user://settings.cfg"

var graphics_quality := "enhanced"
var vibration_enabled := true
var text_size := "normal"
var difficulty := "hard"
var tutorial_seen := false

func _init() -> void:
	load_settings()

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return
	graphics_quality = str(cfg.get_value("display", "graphics_quality", graphics_quality))
	vibration_enabled = bool(cfg.get_value("accessibility", "vibration_enabled", vibration_enabled))
	text_size = str(cfg.get_value("accessibility", "text_size", text_size))
	difficulty = str(cfg.get_value("gameplay", "difficulty", difficulty))
	tutorial_seen = bool(cfg.get_value("gameplay", "tutorial_seen", tutorial_seen))

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("display", "graphics_quality", graphics_quality)
	cfg.set_value("accessibility", "vibration_enabled", vibration_enabled)
	cfg.set_value("accessibility", "text_size", text_size)
	cfg.set_value("gameplay", "difficulty", difficulty)
	cfg.set_value("gameplay", "tutorial_seen", tutorial_seen)
	cfg.save(PATH)

func toggle_graphics() -> void:
	graphics_quality = "performance" if graphics_quality == "enhanced" else "enhanced"
	save_settings()

func toggle_vibration() -> void:
	vibration_enabled = not vibration_enabled
	save_settings()

func cycle_text_size() -> void:
	match text_size:
		"normal":
			text_size = "large"
		"large":
			text_size = "extra_large"
		_:
			text_size = "normal"
	save_settings()

func font_scale() -> float:
	match text_size:
		"large":
			return 1.12
		"extra_large":
			return 1.24
		_:
			return 1.0

func graphics_label() -> String:
	return "ENHANCED" if graphics_quality == "enhanced" else "PERFORMANCE"

func text_size_label() -> String:
	match text_size:
		"large":
			return "LARGE"
		"extra_large":
			return "EXTRA LARGE"
		_:
			return "NORMAL"

func set_difficulty(value: String) -> void:
	if value not in ["easy","hard","hardest"]:
		return
	difficulty = value
	save_settings()

func difficulty_label() -> String:
	return difficulty.to_upper()

func mark_tutorial_seen() -> void:
	tutorial_seen = true
	save_settings()
