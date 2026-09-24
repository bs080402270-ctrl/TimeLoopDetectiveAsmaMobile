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
var detective_points := 0
var recovery_case_id := ""
var case_variation_counts: Dictionary = {}
var case_mastery: Dictionary = {}

func _init() -> void:
	load_settings()

func _safe_string_array(value, fallback: Array[String]) -> Array[String]:
	var result: Array[String] = []
	if typeof(value) == TYPE_ARRAY:
		for item in value:
			result.append(str(item))
		return result
	if typeof(value) == TYPE_PACKED_STRING_ARRAY:
		for item in value:
			result.append(str(item))
		return result
	return fallback.duplicate()

func _safe_bool(value, fallback: bool) -> bool:
	match typeof(value):
		TYPE_BOOL:
			return bool(value)
		TYPE_INT, TYPE_FLOAT:
			return int(value) != 0
		TYPE_STRING:
			var s := str(value).to_lower()
			if s in ["true","1","yes","on"]:
				return true
			if s in ["false","0","no","off"]:
				return false
	return fallback

func _safe_int(value, fallback: int) -> int:
	if typeof(value) in [TYPE_INT,TYPE_FLOAT]:
		return int(value)
	if typeof(value) == TYPE_STRING and str(value).is_valid_int():
		return int(str(value))
	return fallback

func load_settings() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(PATH)
	if err != OK:
		return

	graphics_quality = str(cfg.get_value("display","graphics_quality",graphics_quality))
	if graphics_quality not in ["enhanced","performance"]:
		graphics_quality = "enhanced"

	vibration_enabled = _safe_bool(cfg.get_value("accessibility","vibration_enabled",vibration_enabled),vibration_enabled)

	text_size = str(cfg.get_value("accessibility","text_size",text_size))
	if text_size not in ["normal","large","extra_large"]:
		text_size = "normal"

	difficulty = str(cfg.get_value("gameplay","difficulty",difficulty))
	if difficulty not in ["easy","hard","hardest"]:
		difficulty = "hard"

	tutorial_seen = _safe_bool(cfg.get_value("gameplay","tutorial_seen",tutorial_seen),tutorial_seen)
	selected_investigator = str(cfg.get_value("profile","selected_investigator",selected_investigator))
	selected_outfit = str(cfg.get_value("profile","selected_outfit",selected_outfit))
	detective_credits = maxi(0,_safe_int(cfg.get_value("economy","detective_credits",detective_credits),detective_credits))

	unlocked_outfits = _safe_string_array(cfg.get_value("economy","unlocked_outfits",unlocked_outfits),["classic"])
	if "classic" not in unlocked_outfits:
		unlocked_outfits.append("classic")
	unlocked_gear = _safe_string_array(cfg.get_value("economy","unlocked_gear",unlocked_gear),["handcuffs"])
	if "handcuffs" not in unlocked_gear:
		unlocked_gear.append("handcuffs")
	rewarded_cases = _safe_string_array(cfg.get_value("economy","rewarded_cases",rewarded_cases),[])
	achievements = _safe_string_array(cfg.get_value("profile","achievements",achievements),[])
	season_fragments = _safe_string_array(cfg.get_value("story","season_fragments",season_fragments),[])
	completed_cases = _safe_string_array(cfg.get_value("story","completed_cases",completed_cases),[])
	detective_points = maxi(0,_safe_int(cfg.get_value("progression","detective_points",-1),-1))
	if detective_points < 0:
		detective_points = completed_cases.size() * 100
	recovery_case_id = str(cfg.get_value("progression","recovery_case_id",recovery_case_id))
	var saved_variations = cfg.get_value("progression","case_variation_counts",{})
	case_variation_counts = saved_variations if typeof(saved_variations) == TYPE_DICTIONARY else {}
	var saved_mastery = cfg.get_value("progression","case_mastery",{})
	case_mastery = saved_mastery if typeof(saved_mastery) == TYPE_DICTIONARY else {}

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("display","graphics_quality",graphics_quality)
	cfg.set_value("accessibility","vibration_enabled",vibration_enabled)
	cfg.set_value("accessibility","text_size",text_size)
	cfg.set_value("gameplay","difficulty",difficulty)
	cfg.set_value("gameplay","tutorial_seen",tutorial_seen)
	cfg.set_value("profile","selected_investigator",selected_investigator)
	cfg.set_value("profile","selected_outfit",selected_outfit)
	cfg.set_value("economy","detective_credits",detective_credits)
	cfg.set_value("economy","unlocked_outfits",unlocked_outfits)
	cfg.set_value("economy","unlocked_gear",unlocked_gear)
	cfg.set_value("economy","rewarded_cases",rewarded_cases)
	cfg.set_value("profile","achievements",achievements)
	cfg.set_value("story","season_fragments",season_fragments)
	cfg.set_value("story","completed_cases",completed_cases)
	cfg.set_value("progression","detective_points",detective_points)
	cfg.set_value("progression","recovery_case_id",recovery_case_id)
	cfg.set_value("progression","case_variation_counts",case_variation_counts)
	cfg.set_value("progression","case_mastery",case_mastery)
	cfg.save(PATH)

func toggle_graphics() -> void:
	graphics_quality = "performance" if graphics_quality == "enhanced" else "enhanced"
	save_settings()

func toggle_vibration() -> void:
	vibration_enabled = not vibration_enabled
	save_settings()

func cycle_text_size() -> void:
	match text_size:
		"normal": text_size = "large"
		"large": text_size = "extra_large"
		_: text_size = "normal"
	save_settings()

func font_scale() -> float:
	match text_size:
		"large": return 1.12
		"extra_large": return 1.24
		_: return 1.0

func graphics_label() -> String:
	return "ENHANCED" if graphics_quality == "enhanced" else "PERFORMANCE"

func text_size_label() -> String:
	match text_size:
		"large": return "LARGE"
		"extra_large": return "EXTRA LARGE"
		_: return "NORMAL"

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

func buy_outfit(id: String,cost: int) -> bool:
	if id in unlocked_outfits:
		return true
	if not spend_credits(cost):
		return false
	unlocked_outfits.append(id)
	save_settings()
	return true

func buy_gear(id: String,cost: int) -> bool:
	if id in unlocked_gear:
		return true
	if not spend_credits(cost):
		return false
	unlocked_gear.append(id)
	save_settings()
	return true

func add_credits(amount: int) -> void:
	detective_credits = maxi(0,detective_credits + amount)
	save_settings()

func reward_case_once(case_id: String,amount: int) -> int:
	if case_id in rewarded_cases:
		return 0
	rewarded_cases.append(case_id)
	detective_credits += maxi(0,amount)
	save_settings()
	return maxi(0,amount)

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
	completed_cases.sort()
	if recovery_case_id == case_id:
		recovery_case_id = ""
	save_settings()
	return true

func _career_ranks() -> Array[String]:
	return [
		"CADET INVESTIGATOR",
		"ROOKIE DETECTIVE",
		"JUNIOR INVESTIGATOR",
		"DETECTIVE",
		"SENIOR DETECTIVE",
		"LEAD INVESTIGATOR",
		"SPECIAL INVESTIGATOR",
		"ELITE DETECTIVE",
		"MASTER INVESTIGATOR",
		"CHIEF DETECTIVE",
		"LEGENDARY TIME DETECTIVE"
	]

func career_level() -> int:
	return clampi(int(floor(float(detective_points) / 100.0)),0,10)

func detective_career_rank() -> String:
	return str(_career_ranks()[career_level()])

func next_detective_career_rank() -> String:
	var level := career_level()
	if level >= 10:
		return "MAXIMUM RANK"
	return str(_career_ranks()[level + 1])

func detective_rank_progress_text() -> String:
	var level := career_level()
	if level >= 10:
		return "%s • %d RP • ALL PROMOTIONS EARNED" % [detective_career_rank(),detective_points]
	return "%s • %d RP • NEXT: %s AT %d RP" % [detective_career_rank(),detective_points,next_detective_career_rank(),(level + 1) * 100]

func case_variation_count(case_id: String) -> int:
	return maxi(0,int(case_variation_counts.get(case_id,0)))

func is_recovery_case(case_id: String) -> bool:
	return recovery_case_id != "" and recovery_case_id == case_id

func _case_number(case_id: String) -> int:
	var parts := case_id.split("_")
	if parts.size() < 2:
		return 0
	return int(parts[parts.size()-1])

func _highest_completed_case() -> String:
	var best := ""
	var best_num := 0
	for case_id in completed_cases:
		var n := _case_number(case_id)
		if n > best_num:
			best_num = n
			best = case_id
	return best

func apply_case_result(kind: String, case_id: String) -> Dictionary:
	var before_points := detective_points
	var before_rank := detective_career_rank()
	var delta := 0
	var demoted := false
	var recovery := recovery_case_id

	match kind:
		"true":
			delta = 100
		"partial":
			delta = -25
		_:
			delta = -50

	if kind == "true":
		detective_points = mini(1000,detective_points + delta)
	else:
		var old_level := career_level()
		detective_points = maxi(0,detective_points + delta)
		var new_level := career_level()
		if new_level < old_level and completed_cases.size() > 0:
			# A single failed case can demote at most one career level.
			detective_points = maxi(new_level * 100,detective_points)
			var lost_case := _highest_completed_case()
			if lost_case != "":
				completed_cases.erase(lost_case)
				recovery_case_id = lost_case
				case_variation_counts[lost_case] = case_variation_count(lost_case) + 1
				recovery = lost_case
				demoted = true

	save_settings()
	return {
		"delta": detective_points - before_points,
		"before_points": before_points,
		"after_points": detective_points,
		"before_rank": before_rank,
		"after_rank": detective_career_rank(),
		"demoted": demoted,
		"recovery_case_id": recovery
	}

func mastery_value(case_id: String) -> int:
	return clampi(int(case_mastery.get(case_id,0)),0,3)

func mastery_label(case_id: String) -> String:
	match mastery_value(case_id):
		3: return "GOLD"
		2: return "SILVER"
		1: return "BRONZE"
		_: return "UNRANKED"

func mastery_symbol(case_id: String) -> String:
	match mastery_value(case_id):
		3: return "★★★"
		2: return "★★"
		1: return "★"
		_: return "—"

func record_case_mastery(case_id: String,medal: int) -> bool:
	var value := clampi(medal,0,3)
	if value <= mastery_value(case_id):
		return false
	case_mastery[case_id] = value
	save_settings()
	return true

func total_mastery_stars() -> int:
	var total := 0
	for value in case_mastery.values():
		total += clampi(int(value),0,3)
	return total

func season_progress_text() -> String:
	return "%d/10 CASES • %d LOOP FRAGMENTS" % [completed_cases.size(),season_fragments.size()]
