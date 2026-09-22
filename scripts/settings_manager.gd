class_name SettingsManager
extends RefCounted

const PATH := "user://settings.cfg"

var graphics_quality := "enhanced"
var vibration_enabled := true
var text_size := "normal"
var difficulty := "hard"
var tutorial_seen := false
var selected_investigator := "asma"
var selected_outfit := "classic"
var detective_credits := 250
var unlocked_outfits: Array[String] = ["classic"]
var unlocked_gear: Array[String] = ["handcuffs"]
var rewarded_cases: Array[String] = []
var achievements: Array[String] = []
var season_fragments: Array[String] = []
var completed_cases: Array[String] = []

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
	selected_investigator = str(cfg.get_value("profile", "selected_investigator", selected_investigator))
	selected_outfit = str(cfg.get_value("profile", "selected_outfit", selected_outfit))
	detective_credits = int(cfg.get_value("economy", "detective_credits", detective_credits))
	unlocked_outfits = Array(cfg.get_value("economy", "unlocked_outfits", unlocked_outfits), TYPE_STRING, "", null)
	unlocked_gear = Array(cfg.get_value("economy", "unlocked_gear", unlocked_gear), TYPE_STRING, "", null)
	rewarded_cases = Array(cfg.get_value("economy", "rewarded_cases", rewarded_cases), TYPE_STRING, "", null)
	achievements = Array(cfg.get_value("profile", "achievements", achievements), TYPE_STRING, "", null)
	season_fragments = Array(cfg.get_value("story", "season_fragments", season_fragments), TYPE_STRING, "", null)
	completed_cases = Array(cfg.get_value("story", "completed_cases", completed_cases), TYPE_STRING, "", null)

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("display", "graphics_quality", graphics_quality)
	cfg.set_value("accessibility", "vibration_enabled", vibration_enabled)
	cfg.set_value("accessibility", "text_size", text_size)
	cfg.set_value("gameplay", "difficulty", difficulty)
	cfg.set_value("gameplay", "tutorial_seen", tutorial_seen)
	cfg.set_value("profile", "selected_investigator", selected_investigator)
	cfg.set_value("profile", "selected_outfit", selected_outfit)
	cfg.set_value("economy", "detective_credits", detective_credits)
	cfg.set_value("economy", "unlocked_outfits", unlocked_outfits)
	cfg.set_value("economy", "unlocked_gear", unlocked_gear)
	cfg.set_value("economy", "rewarded_cases", rewarded_cases)
	cfg.set_value("profile", "achievements", achievements)
	cfg.set_value("story", "season_fragments", season_fragments)
	cfg.set_value("story", "completed_cases", completed_cases)
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


func set_investigator(id: String) -> void:
	selected_investigator = id
	save_settings()

func set_outfit(id: String) -> void:
	if id in unlocked_outfits:
		selected_outfit = id
		save_settings()

func can_afford(cost: int) -> bool:
	return detective_credits >= cost

func spend_credits(cost: int) -> bool:
	if cost < 0 or detective_credits < cost:
		return false
	detective_credits -= cost
	save_settings()
	return true

func buy_outfit(id: String, cost: int) -> bool:
	if id in unlocked_outfits:
		return true
	if not spend_credits(cost):
		return false
	unlocked_outfits.append(id)
	save_settings()
	return true

func buy_gear(id: String, cost: int) -> bool:
	if id in unlocked_gear:
		return true
	if not spend_credits(cost):
		return false
	unlocked_gear.append(id)
	save_settings()
	return true

func add_credits(amount: int) -> void:
	detective_credits = maxi(0, detective_credits + amount)
	save_settings()


func reward_case_once(case_id: String, amount: int) -> int:
	if case_id in rewarded_cases:
		return 0
	rewarded_cases.append(case_id)
	detective_credits += maxi(0, amount)
	save_settings()
	return maxi(0, amount)

func unlock_achievement(id: String) -> bool:
	if id in achievements:
		return false
	achievements.append(id)
	save_settings()
	return true


func unlock_season_fragment(id: String) -> bool:
	if id == "" or id in season_fragments:
		return false
	season_fragments.append(id)
	save_settings()
	return true

func mark_case_completed(case_id: String) -> bool:
	if case_id == "" or case_id in completed_cases:
		return false
	completed_cases.append(case_id)
	save_settings()
	return true

func season_progress_text() -> String:
	return "%d/10 CASES • %d LOOP FRAGMENTS" % [completed_cases.size(),season_fragments.size()]
