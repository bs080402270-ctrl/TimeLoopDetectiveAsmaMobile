class_name SettingsManager
extends RefCounted

const PATH := "user://settings.cfg"

var graphics_quality := "enhanced"
var vibration_enabled := true
var text_size := "normal"

func _init() -> void:
	load_settings()

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(PATH) != OK:
		return
	graphics_quality = str(cfg.get_value("display", "graphics_quality", graphics_quality))
	vibration_enabled = bool(cfg.get_value("accessibility", "vibration_enabled", vibration_enabled))
	text_size = str(cfg.get_value("accessibility", "text_size", text_size))

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("display", "graphics_quality", graphics_quality)
	cfg.set_value("accessibility", "vibration_enabled", vibration_enabled)
	cfg.set_value("accessibility", "text_size", text_size)
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
