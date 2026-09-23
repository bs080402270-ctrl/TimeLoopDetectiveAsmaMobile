extends Control

const CASE_FILES := [
	"res://data/case_01.json",
	"res://data/case_02.json",
	"res://data/case_03.json",
	"res://data/case_04.json",
	"res://data/case_05.json",
	"res://data/case_06.json",
	"res://data/case_07.json",
	"res://data/case_08.json",
	"res://data/case_09.json",
	"res://data/case_10.json"
]

const C_BG := Color("#07111f")
const C_PANEL := Color("#0a1119")
const C_PANEL_2 := Color("#15130f")
const C_LINE := Color("#1a5f96")
const C_TEXT := Color("#f4f7fb")
const C_MUTED := Color("#9db1c7")
const C_RED := Color("#26a7ff")
const C_RED_DARK := Color("#0b4d80")
const C_GOLD := Color("#8fd3ff")
const C_BLUE := Color("#36aef5")
const ART_MENU := "res://art/noir_generated/season_conspiracy_noir.jpg"
const ART_CASES := "res://art/noir_generated/neon_alley_chase.jpg"
const ART_INTERROGATION := "res://art/noir_generated/interrogation_evidence_noir.jpg"
const ART_CASEBOOK := "res://art/actual/evidence_room.jpg"
const ART_RESET := "res://art/noir_latest/shattered_time_detective_in_the_rain.jpg"
const ART_DEDUCTION := "res://art/noir_latest/rainlit_warehouse_standoff.jpg"
const ART_SETTINGS := "res://art/noir_latest/rainy_noir_detective_office.jpg"
const ART_INTRO := "res://art/noir_generated/case01_vanishing_witness.jpg"
const ART_DIFFICULTY := "res://art/noir_latest/noir_evidence_room_investigation.jpg"
const ART_CHARACTER_ATLAS := "res://art/noir_latest/generated_character_atlas.png"
const ART_SEASON2_TEASER := "res://art/noir_generated/season_conspiracy_noir.jpg"
const ART_GENERATED_STORY_BOARD := "res://art/noir_latest/noir_interrogation_under_harsh_light.jpg"
const ART_MANHWA_MAIN := "res://art/noir_generated/case01_vanishing_witness.jpg"

const CHARACTER_REAL_ART := {
	"maya": "res://art/actual/optimized/maya.jpg",
	"omar": "res://art/actual/optimized/omar.jpg",
	"lina": "res://art/actual/optimized/lina.jpg",
	"asma": "res://art/actual/optimized/maya.jpg",
	"chief_farid": "res://art/actual/optimized/omar.jpg",
	"ryan_khan": "res://art/actual/optimized/lina.jpg",
	"dr_leila": "res://art/actual/optimized/maya.jpg",
	"samira": "res://art/actual/optimized/lina.jpg",
	"farid": "res://art/actual/optimized/omar.jpg",
	"leila": "res://art/actual/optimized/maya.jpg",
	"viktor": "res://art/actual/optimized/omar.jpg",
	"hassan": "res://art/actual/optimized/omar.jpg",
	"stranger": "res://art/actual/optimized/lina.jpg"
}

const CHARACTER_ATLAS_MAP := {
	"maya": 0, "omar": 19, "lina": 16, "theo": 2,
	"hassan": 15, "meera": 5, "elias": 6, "juno": 9, "rafi": 10,
	"sofia": 3, "marcus": 4, "ivy": 7, "noah": 13, "elena": 1,
	"clara": 8, "anton": 18, "gabriel": 12, "rowan": 17, "selene": 11, "nikolai": 14,
	"morgan": 2, "iris": 16, "leo": 13, "calvin": 1, "mara": 5, "tate": 6,
	"nadia": 5, "felix": 6, "lena": 9, "victor": 4,
	"samira": 11, "ethan": 2, "tariq": 12, "julia": 7, "kenji": 10,
	"nora": 5, "adrian": 4, "milo": 6, "evelyn": 14,
	"celeste": 7, "amir": 12, "daniel": 15, "mira": 9, "julian": 4,
	"farid": 1, "stranger": 18, "viktor": 4, "leila": 3
}

const CHARACTER_GALLERY := [
	{"id":"asma","name":"Asma","role":"Detective trapped in the time loop","index":0},
	{"id":"chief_farid","name":"Chief Farid","role":"Police chief and mentor","index":1},
	{"id":"ryan_khan","name":"Ryan Khan","role":"Detective with secrets","index":2},
	{"id":"dr_leila","name":"Dr. Leila","role":"Forensic analyst","index":3},
	{"id":"viktor_malik","name":"Viktor Malik","role":"Influential businessman","index":4},
	{"id":"nora_said","name":"Nora Said","role":"Socialite with hidden motives","index":5},
	{"id":"imran","name":"Imran","role":"Street informant","index":6},
	{"id":"mrs_zahra","name":"Mrs. Zahra","role":"Hotel owner","index":7},
	{"id":"marco","name":"Marco","role":"Bartender and observer","index":8},
	{"id":"ayumi","name":"Ayumi","role":"Independent journalist","index":9},
	{"id":"the_fixer","name":"The Fixer","role":"Underground contact","index":10},
	{"id":"samira","name":"Samira","role":"Hacker","index":11},
	{"id":"colonel_rashid","name":"Colonel Rashid","role":"Retired military officer","index":12},
	{"id":"kareem","name":"Kareem","role":"Street vendor and witness","index":13},
	{"id":"ayesha","name":"Ayesha","role":"Hotel staff","index":14},
	{"id":"dr_hassan","name":"Dr. Hassan","role":"Historian","index":15},
	{"id":"officer_lina","name":"Officer Lina","role":"Police officer","index":16},
	{"id":"the_mayor","name":"The Mayor","role":"Public official with secrets","index":17},
	{"id":"the_stranger","name":"The Stranger","role":"Unknown figure in every loop","index":18},
	{"id":"young_omar","name":"Young Omar","role":"Witness","index":19}
]

const INVESTIGATION_TEAM := [
	{"id":"asma","name":"Asma","role":"Lead Detective","specialty":"Interrogation • deduction • loop memory"},
	{"id":"chief_farid","name":"Chief Farid","role":"Field Commander","specialty":"Operations • warrants • case strategy"},
	{"id":"ryan_khan","name":"Ryan Khan","role":"Tactical Investigator","specialty":"Surveillance • pursuit • field reconstruction"},
	{"id":"dr_leila","name":"Dr. Leila","role":"Forensic Specialist","specialty":"Forensics • pathology • physical evidence"},
	{"id":"samira","name":"Samira","role":"Digital Analyst","specialty":"CCTV • devices • data recovery"}
]


const OUTFIT_STORE := [
	{"id":"classic","name":"Classic Detective","cost":0,"desc":"Default investigator coat and badge."},
	{"id":"noir","name":"Noir Investigator","cost":120,"desc":"Dark trench-coat style for interrogation scenes."},
	{"id":"field","name":"Field Operations","cost":150,"desc":"Practical field-investigator outfit."},
	{"id":"formal","name":"Formal Casewear","cost":180,"desc":"Premium formal investigator style."}
]

const GEAR_STORE := [
	{"id":"handcuffs","name":"Handcuffs","cost":0,"desc":"Standard arrest equipment."},
	{"id":"flashlight","name":"Tactical Flashlight","cost":60,"desc":"Improves confrontation options."},
	{"id":"vest","name":"Protective Vest","cost":100,"desc":"Helps in risky final confrontations."},
	{"id":"sidearm","name":"Service Sidearm","cost":160,"desc":"Virtual game equipment for high-risk confrontation scenes."}
]


var case_catalog: Array[Dictionary] = []
var case_data: Dictionary = {}
var state: Dictionary = {}
var save_manager := SaveManager.new()
var settings_manager := SettingsManager.new()
var audio: AudioManager
var story_director := StoryDirector.new()
var dynamic_image_client: DynamicImageClient
var current_case_id := ""

var background: TextureRect
var title_label: Label
var status_label: Label
var body: VBoxContainer
var main_scroll: ScrollContainer
var overlay_scroll: ScrollContainer
var nav: GridContainer
var texture_cache: Dictionary = {}
var overlay: PanelContainer
var overlay_title: Label
var overlay_body: RichTextLabel
var overlay_actions: VBoxContainer
var overlay_content: VBoxContainer
var touch_scroll: ScrollContainer
var touch_scroll_last_position := Vector2.ZERO
var touch_scroll_dragging := false

func _ready() -> void:
	# Build the essential UI first. Optional online/story systems must never
	# prevent the menu from appearing on a real Android device.
	_build_shell()
	_load_catalog()
	_show_main_menu()
	story_director.initialize()
	_setup_dynamic_image_client()
	var boot := get_node_or_null("BootSafe")
	if boot != null:
		boot.visible = false

func _setup_dynamic_image_client() -> void:
	dynamic_image_client = DynamicImageClient.new()
	add_child(dynamic_image_client)
	dynamic_image_client.image_ready.connect(_on_dynamic_image_ready)
	dynamic_image_client.image_failed.connect(_on_dynamic_image_failed)

	var file := FileAccess.open("res://data/image_service.json",FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	if not bool(parsed.get("enabled",false)):
		return
	dynamic_image_client.configure(str(parsed.get("endpoint","")),str(parsed.get("game_token","")))
	story_director.set_image_generation_available(dynamic_image_client.enabled)

func _on_dynamic_image_ready(scene_id: String,texture: Texture2D) -> void:
	if str(state.get("last_visual_scene","")) != scene_id:
		return
	background.texture = texture
	background.modulate = Color(0.90,0.94,1.0,0.72 if settings_manager.graphics_quality == "enhanced" else 0.52)

func _on_dynamic_image_failed(_scene_id: String,_reason: String) -> void:
	# Intentional no-op: gameplay already continues with the local fallback art.
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_scroll = _scroll_container_at(event.position)
			touch_scroll_last_position = event.position
			touch_scroll_dragging = touch_scroll != null
		else:
			touch_scroll = null
			touch_scroll_dragging = false
		return
	if event is InputEventScreenDrag and touch_scroll_dragging and touch_scroll != null:
		touch_scroll.scroll_vertical = maxi(0,touch_scroll.scroll_vertical - roundi(event.relative.y))
		touch_scroll_last_position = event.position
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("back"):
		get_viewport().set_input_as_handled()
		if overlay != null and overlay.visible:
			overlay.visible = false
			if current_case_id != "":
				_show_game()
			else:
				_show_main_menu()
		elif current_case_id != "":
			_show_case_select()
		else:
			_show_main_menu()

func _load_catalog() -> void:
	case_catalog.clear()
	for path in CASE_FILES:
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			continue
		var parsed = JSON.parse_string(file.get_as_text())
		if typeof(parsed) == TYPE_DICTIONARY:
			case_catalog.append(parsed)

func _load_case(case_id: String) -> bool:
	for item in case_catalog:
		if str(item.get("id","")) == case_id:
			case_data = item
			current_case_id = case_id
			var start_location := str(case_data.get("start_location",""))
			state = save_manager.load_state(case_id, start_location)
			return true
	return false

func _build_shell() -> void:
	background = TextureRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	background.modulate = Color(0.70,0.78,0.88,1.0)
	add_child(background)

	var base := ColorRect.new()
	base.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	base.color = C_BG
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(base)
	move_child(base,0)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.01,0.03,0.07,0.42)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left",20)
	margin.add_theme_constant_override("margin_right",20)
	margin.add_theme_constant_override("margin_top",24)
	margin.add_theme_constant_override("margin_bottom",80)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation",14)
	margin.add_child(root)

	title_label = Label.new()
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size",_fs(42))
	title_label.add_theme_color_override("font_color",C_TEXT)
	root.add_child(title_label)

	status_label = Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size",_fs(20))
	status_label.add_theme_color_override("font_color",C_MUTED)
	root.add_child(status_label)

	var divider := ColorRect.new()
	divider.custom_minimum_size = Vector2(0,2)
	divider.color = Color(0.10,0.31,0.49,0.65)
	root.add_child(divider)

	main_scroll = ScrollContainer.new()
	main_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_scroll.scroll_deadzone = 8
	main_scroll.get_v_scroll_bar().custom_minimum_size = Vector2(12,0)
	root.add_child(main_scroll)

	body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation",14)
	main_scroll.add_child(body)

	nav = GridContainer.new()
	nav.columns = 4
	nav.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	nav.add_theme_constant_override("h_separation",8)
	nav.add_theme_constant_override("v_separation",8)
	root.add_child(nav)

	overlay = PanelContainer.new()
	overlay.anchor_left = 0.045
	overlay.anchor_top = 0.10
	overlay.anchor_right = 0.955
	overlay.anchor_bottom = 0.92
	overlay.add_theme_stylebox_override("panel",_panel_style(C_PANEL,20,C_LINE,2,22))
	add_child(overlay)

	var ov := VBoxContainer.new()
	ov.add_theme_constant_override("separation",14)
	overlay.add_child(ov)

	overlay_title = Label.new()
	overlay_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	overlay_title.add_theme_font_size_override("font_size",_fs(38))
	overlay_title.add_theme_color_override("font_color",C_TEXT)
	ov.add_child(overlay_title)

	overlay_scroll = ScrollContainer.new()
	overlay_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	overlay_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	overlay_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	overlay_scroll.scroll_deadzone = 8
	overlay_scroll.get_v_scroll_bar().custom_minimum_size = Vector2(12,0)
	ov.add_child(overlay_scroll)

	overlay_content = VBoxContainer.new()
	overlay_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay_content.add_theme_constant_override("separation",10)
	overlay_scroll.add_child(overlay_content)

	overlay_body = RichTextLabel.new()
	overlay_body.bbcode_enabled = true
	overlay_body.fit_content = true
	overlay_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overlay_body.add_theme_font_size_override("normal_font_size",_fs(25))
	overlay_body.add_theme_color_override("default_color",C_TEXT)
	overlay_content.add_child(overlay_body)

	overlay_actions = VBoxContainer.new()
	overlay_actions.add_theme_constant_override("separation",10)
	overlay_content.add_child(overlay_actions)
	overlay.visible = false

func _show_main_menu() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_MENU,0.46)
	title_label.text = "TIME LOOP DETECTIVE"
	title_label.add_theme_color_override("font_color",C_TEXT)
	status_label.text = "SAME TIME. DIFFERENT TRUTHS. BREAK THE LOOP.  •  " + settings_manager.season_progress_text()

	var hero := PanelContainer.new()
	hero.custom_minimum_size = Vector2(0,470)
	hero.add_theme_stylebox_override("panel",_panel_style(Color("#09182a"),24,Color("#163f65"),2,24))
	var hv := VBoxContainer.new()
	hv.alignment = BoxContainer.ALIGNMENT_CENTER
	hv.add_theme_constant_override("separation",16)
	hero.add_child(hv)

	var mark := Label.new()
	mark.text = "∞"
	mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mark.add_theme_font_size_override("font_size",_fs(104))
	mark.add_theme_color_override("font_color",C_RED)
	hv.add_child(mark)

	var big := Label.new()
	big.text = "INVESTIGATE. UNCOVER.\nBREAK THE LOOP."
	big.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	big.add_theme_font_size_override("font_size",_fs(34))
	big.add_theme_color_override("font_color",C_TEXT)
	hv.add_child(big)

	var sub := Label.new()
	sub.text = "Ten mysteries. Three loops each.\nYou are the only one who remembers."
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sub.add_theme_font_size_override("font_size",_fs(23))
	sub.add_theme_color_override("font_color",C_MUTED)
	hv.add_child(sub)
	body.add_child(hero)

	var profile := Label.new()
	profile.text = "PLAYING AS: %s  •  OUTFIT: %s  •  CREDITS: %d" % [_selected_investigator_name(), settings_manager.selected_outfit.to_upper(), settings_manager.detective_credits]
	profile.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	profile.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	profile.add_theme_font_size_override("font_size",_fs(17))
	profile.add_theme_color_override("font_color",C_GOLD)
	body.add_child(profile)

	# HOME CASE PREVIEW: real packaged content is visible immediately on mobile.
	_add_section_title("CASES")
	if case_catalog.is_empty():
		var missing := Label.new()
		missing.text = "CASE DATA COULD NOT BE LOADED. Please install the latest complete APK."
		missing.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		missing.add_theme_font_size_override("font_size",_fs(20))
		missing.add_theme_color_override("font_color",C_RED)
		body.add_child(missing)
	else:
		var preview_count: int = mini(3,case_catalog.size())
		for i in range(preview_count):
			body.add_child(_case_card(case_catalog[i],i+1))
		var loaded := Label.new()
		loaded.text = "%d CASES LOADED • artwork ready" % case_catalog.size()
		loaded.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		loaded.add_theme_font_size_override("font_size",_fs(15))
		loaded.add_theme_color_override("font_color",C_GOLD)
		body.add_child(loaded)

	body.add_child(_button("PLAY CASES NOW  →",func(): _show_case_select(),true))
	body.add_child(_button("HOW THE LOOP WORKS",func(): _show_intro(),false))
	body.add_child(_button("CHOOSE INVESTIGATOR",func(): _show_investigator_select(),false))
	body.add_child(_button("DETECTIVE STORE",func(): _show_store(),false))
	body.add_child(_button("ACHIEVEMENTS",func(): _show_achievements(),false))
	body.add_child(_button("INVESTIGATION TEAM",func(): _show_investigation_team(),false))
	body.add_child(_button("CHARACTERS",func(): _show_character_gallery(),false))
	body.add_child(_button("HOW TO PLAY",func(): _show_help(),false))
	body.add_child(_button("STORY ART / MANGA UI",func(): _show_story_art(),false))
	body.add_child(_button("SEASON 2 TEASER",func(): _show_season2_teaser(),false))
	_build_home_nav("HOME")

func _selected_investigator_name() -> String:
	for member in INVESTIGATION_TEAM:
		if str(member.get("id","")) == settings_manager.selected_investigator:
			return str(member.get("name","Asma"))
	return "Asma"

func _show_investigator_select() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_INTERROGATION,0.40)
	title_label.text = "CHOOSE INVESTIGATOR"
	status_label.text = "Play the case as one of the five investigation-team members."

	for member in INVESTIGATION_TEAM:
		var id := str(member.get("id","asma"))
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel",_panel_style(C_PANEL,16,C_GOLD if id == settings_manager.selected_investigator else C_LINE,2,14))
		var row: BoxContainer = _responsive_box()
		row.add_theme_constant_override("separation",12)
		card.add_child(row)

		var portrait := TextureRect.new()
		portrait.texture = _character_portrait(id,"")
		portrait.custom_minimum_size = Vector2(110,145)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		row.add_child(portrait)

		var vb := VBoxContainer.new()
		vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(vb)
		var n := Label.new()
		n.text = str(member.get("name","Investigator"))
		n.add_theme_font_size_override("font_size",_fs(23))
		n.add_theme_color_override("font_color",C_TEXT)
		vb.add_child(n)
		var r := Label.new()
		r.text = str(member.get("role",""))
		r.add_theme_font_size_override("font_size",_fs(17))
		r.add_theme_color_override("font_color",C_MUTED)
		vb.add_child(r)
		var mid := id
		vb.add_child(_button("SELECTED" if id == settings_manager.selected_investigator else "SELECT",func():
			settings_manager.set_investigator(mid)
			_show_investigator_select()
		,false))
		body.add_child(card)

	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("TEAM")

func _show_store() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_SETTINGS,0.38)
	title_label.text = "DETECTIVE STORE"
	status_label.text = "Credits: %d  •  Cosmetic outfits, gear and extra hints." % settings_manager.detective_credits

	_add_section_title("OUTFITS")
	for item in OUTFIT_STORE:
		var iid := str(item.get("id","classic"))
		var owned := iid in settings_manager.unlocked_outfits
		var label := "%s%s" % [str(item.get("name","Outfit")), "  •  OWNED" if owned else "  •  %d CREDITS" % int(item.get("cost",0))]
		var action_id := iid
		var cost := int(item.get("cost",0))
		body.add_child(_button(label,func():
			if action_id in settings_manager.unlocked_outfits:
				settings_manager.set_outfit(action_id)
			elif settings_manager.buy_outfit(action_id,cost):
				settings_manager.set_outfit(action_id)
			_show_store()
		,owned and action_id == settings_manager.selected_outfit))

	_add_section_title("EQUIPMENT")
	for gear in GEAR_STORE:
		var gid := str(gear.get("id","handcuffs"))
		var owned_gear := gid in settings_manager.unlocked_gear
		var gtext := "%s%s" % [str(gear.get("name","Gear")), "  •  OWNED" if owned_gear else "  •  %d CREDITS" % int(gear.get("cost",0))]
		var buy_id := gid
		var buy_cost := int(gear.get("cost",0))
		body.add_child(_button(gtext,func():
			if not owned_gear:
				settings_manager.buy_gear(buy_id,buy_cost)
			_show_store()
		,false))

	var hint_info := Label.new()
	hint_info.text = "HINTS: The first hint in every case is free. Additional hints cost 25 credits."
	hint_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint_info.add_theme_font_size_override("font_size",_fs(17))
	hint_info.add_theme_color_override("font_color",C_MUTED)
	body.add_child(hint_info)

	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("STORE")

func _show_achievements() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_CASEBOOK,0.34)
	title_label.text = "ACHIEVEMENTS"
	status_label.text = "Milestones from your investigation career."

	var all := [
		["first_clue","FIRST CLUE","Collect your first piece of evidence."],
		["first_contradiction","STORY BREAKER","Expose your first contradiction."],
		["first_case","CASE CLOSED","Reach your first true ending."],
		["no_hint_case","SHARP MIND","Close a case without using a hint."],
		["perfect_loop","LOOP MASTER","Close a case before the third loop."],
		["season_one","SEASON 1 DETECTIVE","Close Case 10 with the true ending."]
	]
	for item in all:
		var unlocked := str(item[0]) in settings_manager.achievements
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel",_panel_style(C_PANEL,14,C_GOLD if unlocked else C_LINE,2,12))
		var vb := VBoxContainer.new()
		card.add_child(vb)
		var n := Label.new()
		n.text = ("✓ " if unlocked else "○ ") + str(item[1])
		n.add_theme_font_size_override("font_size",_fs(22))
		n.add_theme_color_override("font_color",C_GOLD if unlocked else C_TEXT)
		vb.add_child(n)
		var d := Label.new()
		d.text = str(item[2])
		d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		d.add_theme_font_size_override("font_size",_fs(16))
		d.add_theme_color_override("font_color",C_MUTED)
		vb.add_child(d)
		body.add_child(card)

	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("ACHIEVEMENTS")

func _show_story_art() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_GENERATED_STORY_BOARD,0.24)
	title_label.text = "STORY ART / MANGA UI"
	status_label.text = "Dialogue • clues • locations • investigators • case UI"

	var art := TextureRect.new()
	art.texture = _load_tex(ART_GENERATED_STORY_BOARD)
	art.custom_minimum_size = Vector2(0,680)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	body.add_child(art)

	var note := Label.new()
	note.text = "The generated visual concepts are now part of the game direction. Interrogations use manga-style two-character dialogue, cases display investigation types, and the five-person team is available from the main menu."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.add_theme_font_size_override("font_size",_fs(18))
	note.add_theme_color_override("font_color",C_MUTED)
	body.add_child(note)

	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("ART")

func _show_season2_teaser() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_SEASON2_TEASER,0.30)
	title_label.text = "SEASON 2"
	status_label.text = "A NEW LOOP BEGINS."

	var teaser := TextureRect.new()
	teaser.texture = _load_tex(ART_SEASON2_TEASER)
	teaser.custom_minimum_size = Vector2(0,760)
	teaser.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	teaser.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	body.add_child(teaser)

	var copy := Label.new()
	copy.text = "Different people. Deeper questions. Same city. New truths.\nCOMING SOON"
	copy.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	copy.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	copy.add_theme_font_size_override("font_size",_fs(24))
	copy.add_theme_color_override("font_color",C_GOLD)
	body.add_child(copy)

	body.add_child(_button("BACK TO SEASON 1",func(): _show_main_menu(),true))
	_build_home_nav("")

func _show_intro() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_INTRO,0.48)
	title_label.text = "HOW THE LOOP WORKS"
	status_label.text = "Observe. Question. Remember. Deduce."

	var steps := [
		["01","INVESTIGATE LOCATIONS","Search every scene for useful clues."],
		["02","QUESTION SUSPECTS","Stories change. Contradictions reveal the truth."],
		["03","CARRY CLUES ACROSS LOOPS","The world resets. Your knowledge does not."]
	]
	for step in steps:
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel",_panel_style(Color("#0d131a"),18,C_GOLD,2,18))
		var row: BoxContainer = _responsive_box()
		row.add_theme_constant_override("separation",16)
		card.add_child(row)
		var badge := Label.new()
		badge.text = str(step[0])
		badge.custom_minimum_size = Vector2(86,86)
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		badge.add_theme_font_size_override("font_size",_fs(30))
		badge.add_theme_color_override("font_color",C_GOLD)
		row.add_child(badge)
		var vb := VBoxContainer.new()
		vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(vb)
		var h := Label.new()
		h.text = str(step[1])
		h.add_theme_font_size_override("font_size",_fs(25))
		h.add_theme_color_override("font_color",C_TEXT)
		vb.add_child(h)
		var d := Label.new()
		d.text = str(step[2])
		d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		d.add_theme_font_size_override("font_size",_fs(19))
		d.add_theme_color_override("font_color",C_MUTED)
		vb.add_child(d)
		body.add_child(card)

	body.add_child(_button("CHOOSE DIFFICULTY  →",func():
		settings_manager.mark_tutorial_seen()
		_show_difficulty()
	,true))
	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("HOW TO")

func _show_difficulty() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_DIFFICULTY,0.48)
	title_label.text = "SELECT DIFFICULTY"
	status_label.text = "Choose how challenging the loop will be."

	body.add_child(_difficulty_card("easy","EASY","More hints, two extra actions per loop, easier final deduction."))
	body.add_child(_difficulty_card("hard","HARD","Balanced investigation, standard actions and limited guidance."))
	body.add_child(_difficulty_card("hardest","HARDEST","No hints, two fewer actions and the strictest final deduction."))
	body.add_child(_button("CONTINUE TO CASES  →",func(): _show_case_select(),true))
	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("")

func _difficulty_card(id: String,label_text: String,description: String) -> Control:
	var selected := settings_manager.difficulty == id
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel",_panel_style(Color("#17140f") if selected else Color("#0d131a"),18,C_GOLD if selected else Color("#765a3a"),3 if selected else 2,16))
	var row: BoxContainer = _responsive_box()
	row.add_theme_constant_override("separation",14)
	card.add_child(row)
	var icon := Label.new()
	icon.text = "✓" if selected else "○"
	icon.custom_minimum_size = Vector2(72,72)
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon.add_theme_font_size_override("font_size",_fs(34))
	icon.add_theme_color_override("font_color",C_GOLD)
	row.add_child(icon)
	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(vb)
	var title := Label.new()
	title.text = label_text
	title.add_theme_font_size_override("font_size",_fs(30))
	title.add_theme_color_override("font_color",C_TEXT)
	vb.add_child(title)
	var desc := Label.new()
	desc.text = description
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_size_override("font_size",_fs(18))
	desc.add_theme_color_override("font_color",C_MUTED)
	vb.add_child(desc)
	var did := id
	var choose := _button("SELECTED" if selected else "SELECT",func():
		settings_manager.set_difficulty(did)
		_show_difficulty()
	,false)
	choose.custom_minimum_size = Vector2(150,72)
	choose.disabled = selected
	row.add_child(choose)
	return card


func _show_investigation_team() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_INTERROGATION,0.42)
	title_label.text = "INVESTIGATION TEAM"
	status_label.text = "Five specialists. Different skills. One truth."

	for member in INVESTIGATION_TEAM:
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel",_panel_style(C_PANEL,16,C_GOLD,2,14))
		var row: BoxContainer = _responsive_box()
		row.add_theme_constant_override("separation",14)
		card.add_child(row)

		var portrait := TextureRect.new()
		portrait.texture = _character_portrait(str(member.get("id","")), "")
		portrait.custom_minimum_size = Vector2(124,168)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		row.add_child(portrait)

		var vb := VBoxContainer.new()
		vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(vb)

		var n := Label.new()
		n.text = str(member.get("name","Investigator"))
		n.add_theme_font_size_override("font_size",_fs(26))
		n.add_theme_color_override("font_color",C_TEXT)
		vb.add_child(n)

		var role := Label.new()
		role.text = str(member.get("role","Investigator"))
		role.add_theme_font_size_override("font_size",_fs(19))
		role.add_theme_color_override("font_color",C_GOLD)
		vb.add_child(role)

		var specialty := Label.new()
		specialty.text = str(member.get("specialty",""))
		specialty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		specialty.add_theme_font_size_override("font_size",_fs(16))
		specialty.add_theme_color_override("font_color",C_MUTED)
		vb.add_child(specialty)

		body.add_child(card)

	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("TEAM")

func _show_character_gallery() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_SETTINGS,0.44)
	title_label.text = "CHARACTERS"
	status_label.text = "People. Secrets. Consequences. Every loop reveals more."

	for item in CHARACTER_GALLERY:
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel",_panel_style(C_PANEL,16,C_GOLD,2,14))
		var row: BoxContainer = _responsive_box()
		row.add_theme_constant_override("separation",14)
		card.add_child(row)

		var portrait := TextureRect.new()
		portrait.texture = _character_portrait(str(item.id), "")
		portrait.custom_minimum_size = Vector2(150,210)
		portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		row.add_child(portrait)

		var vb := VBoxContainer.new()
		vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(vb)

		var n := Label.new()
		n.text = str(item.name)
		n.add_theme_font_size_override("font_size",_fs(28))
		n.add_theme_color_override("font_color",C_TEXT)
		vb.add_child(n)

		var r := Label.new()
		r.text = str(item.role)
		r.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		r.add_theme_font_size_override("font_size",_fs(19))
		r.add_theme_color_override("font_color",C_MUTED)
		vb.add_child(r)

	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("CHARACTERS")

func _show_case_select() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_CASES,0.40)
	title_label.text = "SELECT A CASE"
	status_label.text = "Each case is a loop. Each truth changes everything."

	var ready := PanelContainer.new()
	ready.add_theme_stylebox_override("panel",_panel_style(Color("#0b1828"),14,C_GOLD,2,12))
	var ready_text := Label.new()
	ready_text.text = "PACKAGED GAME CONTENT • %d CASES • OFFLINE ART ENABLED" % case_catalog.size()
	ready_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ready_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ready_text.add_theme_font_size_override("font_size",_fs(16))
	ready_text.add_theme_color_override("font_color",C_GOLD)
	ready.add_child(ready_text)
	body.add_child(ready)

	var index := 1
	for data in case_catalog:
		var case_id := str(data.get("id",""))
		body.add_child(_case_card(data,index))
		index += 1

	body.add_child(_button("BACK",func(): _show_main_menu(),false))
	_build_home_nav("CASES")

func _case_card(data: Dictionary,index: int) -> Control:
	var case_id := str(data.get("id",""))
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel",_panel_style(C_PANEL,16,Color("#174b78"),2,14))

	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation",10)
	card.add_child(stack)

	var top: BoxContainer = _responsive_box()
	top.add_theme_constant_override("separation",12)
	stack.add_child(top)

	var start_id := str(data.get("start_location",""))
	var thumb_path := str(data.get("locations",{}).get(start_id,{}).get("art",""))
	if thumb_path == "":
		thumb_path = ART_CASES
	var thumb := TextureRect.new()
	thumb.texture = _load_tex(thumb_path)
	thumb.custom_minimum_size = Vector2(116,92)
	thumb.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	thumb.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	top.add_child(thumb)

	var badge := PanelContainer.new()
	badge.custom_minimum_size = Vector2(78,92)
	badge.add_theme_stylebox_override("panel",_panel_style(Color("#122943"),12,C_GOLD,2,8))
	var num := Label.new()
	num.text = "%02d" % index
	num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	num.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	num.add_theme_font_size_override("font_size",_fs(30))
	num.add_theme_color_override("font_color",C_GOLD)
	badge.add_child(num)
	top.add_child(badge)

	var head := VBoxContainer.new()
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_theme_constant_override("separation",3)
	top.add_child(head)

	var t := Label.new()
	t.text = str(data.get("title","Untitled Case"))
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	t.add_theme_font_size_override("font_size",_fs(24))
	t.add_theme_color_override("font_color",C_TEXT)
	head.add_child(t)

	var case_type := Label.new()
	case_type.text = str(data.get("case_type","INVESTIGATION")).to_upper()
	case_type.add_theme_font_size_override("font_size",_fs(14))
	case_type.add_theme_color_override("font_color",C_GOLD)
	head.add_child(case_type)

	var state_text := Label.new()
	state_text.text = "CONTINUE INVESTIGATION" if save_manager.has_save(case_id) else "NEW INVESTIGATION"
	state_text.add_theme_font_size_override("font_size",_fs(15))
	state_text.add_theme_color_override("font_color",C_RED if save_manager.has_save(case_id) else C_GOLD)
	head.add_child(state_text)

	var d := Label.new()
	d.text = str(data.get("subtitle",""))
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	d.add_theme_font_size_override("font_size",_fs(17))
	d.add_theme_color_override("font_color",C_MUTED)
	stack.add_child(d)

	var team_line := Label.new()
	var assigned: Array = data.get("investigators",[])
	team_line.text = "TEAM: " + ", ".join(assigned) if assigned.size() > 0 else "TEAM: Asma"
	team_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	team_line.add_theme_font_size_override("font_size",_fs(14))
	team_line.add_theme_color_override("font_color",C_MUTED)
	stack.add_child(team_line)

	var cid: String = case_id
	var open := _button("OPEN CASE  →",func(): _open_case(cid),true)
	open.custom_minimum_size = Vector2(0,64)
	open.add_theme_font_size_override("font_size",_fs(19))
	stack.add_child(open)
	return card

func _open_case(case_id: String) -> void:
	if not _load_case(case_id):
		return
	if not bool(state.get("started",false)):
		_start_new()
	else:
		_show_game()

func _start_new() -> void:
	save_manager.clear(current_case_id)
	state = save_manager.load_state(current_case_id,str(case_data.get("start_location","")))
	state.started = true
	state.loop = 1
	state.action = 0
	state.location = str(case_data.get("start_location",""))
	state.clues = []
	state.contradictions = []
	state.talked = []
	state.hints_used = 0
	state.ending = ""
	state.partner_choices = {}
	state.loop_memories = []
	state.observations = []
	state.action_history = []
	state.partner_trust = 50
	state.suspect_pressure = {}
	state.branch_flags = []
	_save()
	_show_game()

func _show_game() -> void:
	overlay.visible = false
	_clear(body)
	_build_nav()

	var loc_key := str(state.location)
	var loc: Dictionary = case_data.get("locations",{}).get(loc_key,{})
	title_label.text = str(case_data.get("title","Investigation"))
	var total_clues: int = case_data.get("clues",{}).size()
	var max_actions: int = _effective_max_actions()
	status_label.text = "%s   •   LOOP %d/3   •   ACTIONS %d/%d   •   CLUES %d/%d   •   TRUST %d" % [settings_manager.difficulty_label(),int(state.loop),int(state.action),max_actions,state.clues.size(),total_clues,int(state.get("partner_trust",50))]
	_apply_scene_visual("location",str(loc.get("visual",loc.get("art",""))))
	_show_location(loc_key)

func _show_location(loc_key: String) -> void:
	var loc: Dictionary = case_data.get("locations",{}).get(loc_key,{})

	var hero := TextureRect.new()
	hero.texture = _load_tex(_resolve_scene_art("location",str(loc.get("visual",loc.get("art","")))))
	hero.custom_minimum_size = Vector2(0,250)
	hero.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hero.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	body.add_child(hero)

	var location_card := PanelContainer.new()
	location_card.add_theme_stylebox_override("panel",_panel_style(Color(0.02,0.07,0.12,0.86),18,Color("#245f91"),2,18))
	var lv := VBoxContainer.new()
	lv.add_theme_constant_override("separation",8)
	location_card.add_child(lv)

	var place := Label.new()
	place.text = str(loc.get("name","Investigation"))
	place.add_theme_font_size_override("font_size",_fs(34))
	place.add_theme_color_override("font_color",C_GOLD)
	lv.add_child(place)

	var intro := Label.new()
	intro.text = str(loc.get("description","Search carefully."))
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.add_theme_font_size_override("font_size",_fs(23))
	intro.add_theme_color_override("font_color",C_TEXT)
	lv.add_child(intro)
	body.add_child(location_card)

	var people: Array = loc.get("people",[])
	if people.size() > 0:
		_add_section_title("PEOPLE OF INTEREST")
		for person in people:
			body.add_child(_person_card(str(person)))

	_add_section_title("SEARCH FOR EVIDENCE")
	for clue_id in case_data.get("clues",{}).keys():
		var clue: Dictionary = case_data.clues[clue_id]
		if str(clue.get("location","")) == loc_key:
			body.add_child(_clue_card(str(clue_id)))

	var action_beats: Array = case_data.get("action_beats",[])
	var local_actions: Array = []
	for beat in action_beats:
		if str(beat.get("location","")) == loc_key and int(state.loop) >= int(beat.get("loop_min",1)):
			local_actions.append(beat)
	if local_actions.size() > 0:
		_add_section_title("FIELD ACTIONS")
		for beat in local_actions:
			var beat_copy: Dictionary = beat
			body.add_child(_button(str(beat_copy.get("label","TAKE ACTION")),func(): _field_action(beat_copy),false))

	if int(state.action) >= _effective_max_actions():
		var warning := PanelContainer.new()
		warning.add_theme_stylebox_override("panel",_panel_style(Color("#31111a"),16,C_RED,2,16))
		var wv := VBoxContainer.new()
		warning.add_child(wv)
		var w := Label.new()
		w.text = "THE LOOP IS COLLAPSING"
		w.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		w.add_theme_font_size_override("font_size",_fs(27))
		w.add_theme_color_override("font_color",C_RED)
		wv.add_child(w)
		wv.add_child(_button("RESET THE TIMELINE  ↻",func(): _reset_loop(),true))
		body.add_child(warning)

func _field_action(beat: Dictionary) -> void:
	var id := str(beat.get("id","field_action"))
	var flags: Array = state.get("branch_flags",[])
	if id in flags:
		overlay_title.text = "ACTION COMPLETE"
		overlay_body.text = "You already changed this part of the loop."
		_clear(overlay_actions)
		overlay_actions.add_child(_button("BACK",func(): _close_and_refresh(),true))
		overlay.visible = true
		return
	flags.append(id)
	state.branch_flags = flags
	var kind := str(beat.get("kind","search"))
	var field_request := _request_dynamic_visual(kind,str(beat.get("visual","")),{
		"action":str(beat.get("text","")),
		"force_visual":true
	})
	_set_polished_background(str(field_request.get("fallback_art",ART_CASES)),0.52)
	overlay_title.text = str(beat.get("title",kind.replace("_"," ").to_upper()))
	overlay_body.text = str(beat.get("text","You and Asma move before the moment can repeat."))
	var reveal_clue := str(beat.get("reveal_clue",""))
	if reveal_clue != "" and reveal_clue in case_data.get("clues",{}):
		var clue: Dictionary = case_data.clues[reveal_clue]
		if int(state.loop) >= int(clue.get("loop_min",1)) and reveal_clue not in state.clues:
			_add_unique(state.clues,reveal_clue)
			overlay_body.text += "\n\n[color=#e6b85c][b]NEW CLUE[/b][/color]\n" + str(clue.get("name",reveal_clue)) + " — " + str(clue.get("description",""))
	state.partner_trust = mini(100,int(state.get("partner_trust",50))+int(beat.get("trust",1)))
	_remember_action(id)
	_clear(overlay_actions)
	overlay_actions.add_child(_button("CONTINUE  →",func(): _close_and_refresh(),true))
	overlay.visible = true
	_spend_action(false)

func _challenge_previous_loop(id: String) -> void:
	var data: Dictionary = case_data.suspects.get(id,{})
	var pressure: Dictionary = state.get("suspect_pressure",{})
	pressure[id] = int(pressure.get(id,0)) + 1
	state.suspect_pressure = pressure
	var needed: Array = data.get("contradiction",{}).get("needs",[])
	var have := 0
	for clue in needed:
		if str(clue) in state.clues:
			have += 1
	if have >= maxi(1,needed.size()-1):
		state.partner_trust = mini(100,int(state.get("partner_trust",50))+3)
		overlay_body.text = "[color=#e6b85c][b]ASMA[/b][/color]\nYes. That is the part that changed. Push there.\n\n[color=#9db1c7][b]%s[/b][/color]\n%s" % [str(data.get("name",id)),str(data.get("pressure_line","You should not know that."))]
	else:
		state.partner_trust = maxi(0,int(state.get("partner_trust",50))-1)
		overlay_body.text = "[color=#e6b85c][b]ASMA[/b][/color]\nNot yet. I know what you remember, but the evidence does not support that jump. Give me something concrete."
	_remember_action("challenge_" + id)

func _shadow_suspect(id: String) -> void:
	var data: Dictionary = case_data.suspects.get(id,{})
	_apply_scene_visual("pursuit",str(data.get("pursuit_art","")),0.52)
	var flags: Array = state.get("branch_flags",[])
	var flag := "shadow_" + id + "_loop_" + str(state.loop)
	if flag not in flags:
		flags.append(flag)
	state.branch_flags = flags
	var reveal := str(data.get("shadow_reveal","They change direction twice, then check whether you are still behind them."))
	overlay_body.text = "[color=#e6b85c][b]ASMA[/b][/color]\nStay close. Do not let them see us.\n\n[color=#9db1c7]" + reveal + "[/color]"
	var clue_id := str(data.get("shadow_clue",""))
	if clue_id != "" and clue_id in case_data.get("clues",{}):
		var clue: Dictionary = case_data.clues[clue_id]
		if int(state.loop) >= int(clue.get("loop_min",1)) and clue_id not in state.clues:
			_add_unique(state.clues,clue_id)
			overlay_body.text += "\n\n[color=#e6b85c][b]CLUE UNLOCKED[/b][/color]\n" + str(clue.get("name",clue_id))
	_remember_action("shadow_" + id)
	_save()

func _dynamic_scene_context(kind: String,preferred: String = "",extra: Dictionary = {}) -> Dictionary:
	var loc_id := str(state.get("location",""))
	var loc: Dictionary = case_data.get("locations",{}).get(loc_id,{})
	var visible: Array[String] = []
	for clue_id in state.get("clues",[]):
		var clue: Dictionary = case_data.get("clues",{}).get(str(clue_id),{})
		if str(clue.get("location","")) == loc_id:
			visible.append(str(clue.get("name",clue_id)))
	var changes: Array[String] = []
	if int(state.get("loop",1)) > 1:
		var reveal_map: Dictionary = case_data.get("loop_reveals",{})
		var reveal := str(reveal_map.get(str(state.get("loop",1)),""))
		if reveal != "":
			changes.append(reveal)
	var context := {
		"scene_id": "%s_%s_loop_%d" % [current_case_id,kind,int(state.get("loop",1))],
		"location_name": str(loc.get("name","Unknown location")),
		"loop": int(state.get("loop",1)),
		"characters": ["Detective Asma","the player detective partner"],
		"visible_clues": visible,
		"loop_changes": changes,
		"fallback_art": _resolve_scene_art(kind,preferred),
		"significant_change": kind in ["time_loop_reset","important_clue_found","chase","pursuit","cover","danger","confrontation","capture"]
	}
	for key in extra.keys():
		context[key] = extra[key]
	return context

func _request_dynamic_visual(kind: String,preferred: String = "",extra: Dictionary = {}) -> Dictionary:
	var context := _dynamic_scene_context(kind,preferred,extra)
	var request := story_director.make_scene(kind,context)
	var scene_id := str(request.get("scene_id",""))
	var prompt := str(request.get("prompt",""))
	state["last_visual_scene"] = scene_id
	state["last_visual_prompt"] = prompt
	state["last_visual_requested"] = bool(request.get("should_generate",false))
	_save()

	# Never block gameplay. Fallback art is displayed immediately; an online
	# generated image can replace it later only while this scene is still active.
	if bool(request.get("should_generate",false)) and dynamic_image_client != null and dynamic_image_client.enabled:
		dynamic_image_client.request_scene(scene_id,prompt)

	return request

func _resolve_scene_art(kind: String,preferred: String = "") -> String:
	if preferred != "" and ResourceLoader.exists(preferred):
		return preferred
	var visuals: Dictionary = case_data.get("visual_scenes",{})
	var configured := str(visuals.get(kind,""))
	if configured != "" and ResourceLoader.exists(configured):
		return configured
	match kind:
		"crime_scene", "clue", "search":
			return ART_CASEBOOK
		"interrogation", "suspect":
			return ART_INTERROGATION
		"chase", "pursuit", "escape", "cover":
			return ART_CASES
		"confrontation", "capture":
			return ART_DEDUCTION
		"loop":
			return ART_RESET
		_:
			return ART_MENU

func _apply_scene_visual(kind: String,preferred: String = "",alpha := 0.40) -> void:
	var scene_type := kind
	if kind == "loop":
		scene_type = "time_loop_reset"
	elif kind == "clue":
		scene_type = "important_clue_found"
	var request := _request_dynamic_visual(scene_type,preferred)
	var fallback := str(request.get("fallback_art",_resolve_scene_art(kind,preferred)))
	_set_polished_background(fallback,alpha)

func _remember_action(action_id: String) -> void:
	var history: Array = state.get("action_history",[])
	history.append({"loop":int(state.get("loop",1)),"action":action_id})
	if history.size() > 24:
		history.pop_front()
	state.action_history = history
	_save()

func _observe_suspect(id: String) -> void:
	var data: Dictionary = case_data.suspects.get(id,{})
	var observations: Array = state.get("observations",[])
	var key := "%s_loop_%d" % [id,int(state.loop)]
	if key not in observations:
		observations.append(key)
	state.observations = observations
	state.partner_trust = mini(100,int(state.get("partner_trust",50))+2)
	_remember_action("observe_" + id)
	var tells: Array = data.get("tells",[])
	var tell := "They pause before answering and watch which clue you reach for."
	if tells.size() > 0:
		tell = str(tells[clampi(int(state.loop)-1,0,tells.size()-1)])
	overlay_body.text = "[color=#e6b85c][b]ASMA[/b][/color]\nGood. Do not rush them.\n\n[color=#9db1c7][b]YOU NOTICE[/b][/color]\n" + tell

func _person_card(id: String) -> Control:
	var data: Dictionary = case_data.suspects[id]
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel",_panel_style(Color(0.035,0.095,0.155,0.94),16,Color("#194d78"),2,12))

	var row: BoxContainer = _responsive_box()
	row.add_theme_constant_override("separation",14)
	card.add_child(row)

	var portrait := TextureRect.new()
	portrait.texture = _character_portrait(id,str(data.get("art","")))
	portrait.custom_minimum_size = Vector2(180,220)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(portrait)

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_theme_constant_override("separation",5)
	row.add_child(vb)

	var n := Label.new()
	n.text = str(data.get("name",id))
	n.add_theme_font_size_override("font_size",_fs(30))
	n.add_theme_color_override("font_color",C_TEXT)
	vb.add_child(n)

	var role := Label.new()
	role.text = str(data.get("role",""))
	role.add_theme_font_size_override("font_size",_fs(20))
	role.add_theme_color_override("font_color",C_MUTED)
	role.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(role)

	var suspicion := Label.new()
	var suspicion_value := 30
	if id in state.talked:
		suspicion_value += 15
	var rule: Dictionary = data.get("contradiction",{})
	if str(rule.get("id","")) in state.contradictions:
		suspicion_value += 40
	suspicion_value = mini(100,suspicion_value)
	suspicion.text = "SUSPICION  %d%%" % suspicion_value
	suspicion.add_theme_font_size_override("font_size",_fs(15))
	suspicion.add_theme_color_override("font_color",C_RED if suspicion_value >= 70 else C_GOLD)
	vb.add_child(suspicion)

	var memory := Label.new()
	memory.text = "INTERVIEWED" if id in state.talked else "NOT YET INTERVIEWED"
	memory.add_theme_font_size_override("font_size",_fs(16))
	memory.add_theme_color_override("font_color",C_GOLD if id in state.talked else C_MUTED)
	vb.add_child(memory)

	var sid: String = id
	vb.add_child(_button("INTERROGATE  →",func(): _interrogate(sid),true))
	return card

func _clue_card(id: String) -> Control:
	var data: Dictionary = case_data.clues[id]
	var found: bool = id in state.clues
	var loop_min := int(data.get("loop_min",1))
	var locked_by_loop := int(state.loop) < loop_min
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel",_panel_style(C_PANEL,14,C_GOLD if found else Color("#174b78"),2,12))

	var row: BoxContainer = _responsive_box()
	row.add_theme_constant_override("separation",12)
	card.add_child(row)

	var icon := TextureRect.new()
	icon.texture = _load_tex(str(data.get("art","")))
	icon.custom_minimum_size = Vector2(110,110)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)

	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(vb)

	var n := Label.new()
	n.text = ("RECORDED • " if found else "") + str(data.get("name",id))
	n.add_theme_font_size_override("font_size",_fs(25))
	n.add_theme_color_override("font_color",C_GOLD if found else C_TEXT)
	vb.add_child(n)

	var d := Label.new()
	if found:
		d.text = str(data.get("description",""))
	elif locked_by_loop:
		d.text = str(data.get("locked_hint","Something about this clue does not make sense yet."))
	else:
		d.text = _clue_hint_text(data)
	d.add_theme_font_size_override("font_size",_fs(19))
	d.add_theme_color_override("font_color",C_MUTED)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(d)

	var cid: String = id
	var b := _button("RECORDED" if found else ("LOCKED UNTIL NEXT LOOP" if locked_by_loop else "INSPECT"),func(): _collect_clue(cid),false)
	b.disabled = found or locked_by_loop
	b.custom_minimum_size = Vector2(145,72)
	row.add_child(b)
	return card

func _interrogate(id: String) -> void:
	var data: Dictionary = case_data.suspects[id]
	var lines: Array = data.get("dialogue",[])
	var idx := clampi(int(state.loop)-1,0,maxi(0,lines.size()-1))
	var suspect_line := str(lines[idx]) if lines.size() > 0 else "They watch you carefully."
	var remembered_topic := str(state.get("partner_choices",{}).get(id,""))
	var asma_open := str(data.get("asma_open","Look at me. Something is wrong here."))
	if remembered_topic != "" and int(state.loop) > 1:
		asma_open = "Last loop you pushed on %s. I remember. Let's see what changes this time." % remembered_topic.replace("_"," ")

	# Dynamic visual request for the current conversation only.
	var talk_request := _request_dynamic_visual("face_to_face_talk",str(data.get("scene_art","")),{
		"characters":["Detective Asma","the player detective partner",str(data.get("name",id))],
		"face_to_face":true,
		"action":"questioning %s together" % str(data.get("name",id)),
		"mood":"close, tense, observant detective conversation"
	})
	_set_polished_background(str(talk_request.get("fallback_art",ART_INTERROGATION)),0.44)
	overlay_title.text = str(data.get("name",id)) + " • INTERROGATION"
	overlay_body.text = "[color=#e6b85c][b]ASMA[/b][/color]\n%s\n\n[color=#9db1c7][b]%s[/b][/color]\n%s" % [asma_open,str(data.get("name",id)),suspect_line]
	_clear(overlay_actions)
	overlay_actions.add_child(_manga_portrait_strip(id))

	var sid: String = id
	overlay_actions.add_child(_button("ASK ABOUT THE TIMELINE",func(): _manga_followup(sid,"timeline"),false))
	overlay_actions.add_child(_button("ASK ABOUT THEIR MOTIVE",func(): _manga_followup(sid,"motive"),false))
	overlay_actions.add_child(_button("STAY SILENT & OBSERVE",func(): _observe_suspect(sid),false))
	if int(state.loop) > 1:
		overlay_actions.add_child(_button("CHALLENGE WITH PREVIOUS-LOOP KNOWLEDGE",func(): _challenge_previous_loop(sid),false))
	overlay_actions.add_child(_button("SHADOW THEM AFTER THE INTERVIEW",func(): _shadow_suspect(sid),false))
	overlay_actions.add_child(_button("PRESS WITH EVIDENCE  →",func(): _press_suspect(sid),true))
	overlay_actions.add_child(_button("END INTERVIEW",func(): _close_and_refresh(),false))
	overlay.visible = true
	_add_unique(state.talked,id)
	_spend_action(false)

func _manga_portrait_strip(id: String) -> Control:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel",_panel_style(Color("#07111f"),14,C_GOLD,2,10))
	var row: BoxContainer = _responsive_box()
	row.add_theme_constant_override("separation",10)
	panel.add_child(row)

	var asma := TextureRect.new()
	asma.texture = _character_portrait("asma","")
	asma.custom_minimum_size = Vector2(96,126)
	asma.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	asma.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	row.add_child(asma)

	var center := VBoxContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_child(center)
	var versus := Label.new()
	versus.text = "QUESTION • OBSERVE • REMEMBER"
	versus.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	versus.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	versus.add_theme_font_size_override("font_size",_fs(14))
	versus.add_theme_color_override("font_color",C_GOLD)
	center.add_child(versus)

	var suspect := TextureRect.new()
	suspect.texture = _character_portrait(id,str(case_data.suspects[id].get("art","")))
	suspect.custom_minimum_size = Vector2(96,126)
	suspect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	suspect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	row.add_child(suspect)
	return panel

func _manga_followup(id: String,topic: String) -> void:
	var data: Dictionary = case_data.suspects[id]
	var choices: Dictionary = state.get("partner_choices",{})
	choices[id] = topic
	state.partner_choices = choices
	state.partner_trust = mini(100,int(state.get("partner_trust",50))+1)
	_remember_action("ask_" + topic + "_" + id)
	var lines: Array = data.get("dialogue",[])
	var base_idx := clampi(int(state.loop)-1,0,maxi(0,lines.size()-1))
	var response := str(lines[base_idx]) if lines.size() > 0 else "I have already told you what I know."
	if lines.size() > 1 and topic == "motive":
		response = str(lines[(base_idx + 1) % lines.size()])

	var question := "Walk me through the exact timeline again." if topic == "timeline" else "What did you have to gain from what happened?"
	var partner_reaction := "Good catch. Let's test that." if topic == "timeline" else "I see why you think motive matters. I am not convinced yet."
	overlay_body.text = "[color=#e6b85c][b]ASMA[/b][/color]\n%s\n%s\n\n[color=#9db1c7][b]%s[/b][/color]\n%s" % [partner_reaction,question,str(data.get("name",id)),response]

func _press_suspect(id: String) -> void:
	var data: Dictionary = case_data.suspects[id]
	var rule: Dictionary = data.get("contradiction",{})
	var needs: Array = rule.get("needs",[])
	var complete: bool = true
	for clue in needs:
		if str(clue) not in state.clues:
			complete = false
	if complete and needs.size() > 0:
		_add_unique(state.contradictions,str(rule.get("id","")))
		settings_manager.unlock_achievement("first_contradiction")
		overlay_body.text = "[center][color=#e6b85c][font_size=30][b]CONTRADICTION FOUND[/b][/font_size][/color][/center]\n\n" + str(rule.get("result",""))
		_play_evidence()
	else:
		if settings_manager.difficulty == "easy":
			var missing: Array[String] = []
			for clue in needs:
				if str(clue) not in state.clues:
					missing.append(str(case_data.clues.get(str(clue),{}).get("name",clue)))
			overlay_body.text = "[color=#9db1c7]You need more evidence. Look for: %s[/color]" % ", ".join(missing)
		else:
			overlay_body.text = "[color=#9db1c7]You need more evidence before this story can be broken.[/color]"
	_spend_action(false)

func _collect_clue(id: String) -> void:
	if id in state.clues:
		return
	_add_unique(state.clues,id)
	settings_manager.unlock_achievement("first_clue")
	var data: Dictionary = case_data.clues[id]
	var fragment_id := str(data.get("season_fragment",""))
	var new_fragment := settings_manager.unlock_season_fragment(fragment_id)
	_apply_scene_visual("clue",str(data.get("visual",data.get("art",""))),0.48)
	overlay_title.text = "EVIDENCE FOUND"
	var loop_note := ""
	if int(state.loop) > 1:
		loop_note = "\n\n[color=#e6b85c][b]ASMA[/b][/color]\nWe missed this before. The loop gave us another angle."
	overlay_body.text = "[center][color=#e6b85c][font_size=30][b]%s[/b][/font_size][/color][/center]\n\n%s%s" % [str(data.get("name",id)),str(data.get("description","")),loop_note]
	if new_fragment:
		overlay_body.text += "\n\n[color=#2c8cff][b]LOOP ANOMALY RECORDED[/b][/color]\nThis detail matches something outside this case."
	_clear(overlay_actions)
	overlay_actions.add_child(_button("ADD TO CASEBOOK  →",func(): _close_and_refresh(),true))
	overlay.visible = true
	_play_evidence()
	_spend_action(false)

func _reset_loop() -> void:
	_play_loop_reset()
	var next_loop := mini(3,int(state.get("loop",1))+1)
	var reset_reveal := str(case_data.get("loop_reveals",{}).get(str(next_loop),""))
	var reset_request := _request_dynamic_visual("time_loop_reset","",{
		"force_visual":true,
		"loop":next_loop,
		"loop_changes":[reset_reveal] if reset_reveal != "" else []
	})
	_set_polished_background(str(reset_request.get("fallback_art",ART_RESET)),0.48)
	if int(state.loop) >= 3:
		_show_deduction()
		return
	state.loop = int(state.loop)+1
	state.action = 0
	state.location = str(case_data.get("start_location",""))
	var memories: Array = state.get("loop_memories",[])
	memories.append("Loop %d ended with %d clues and %d contradictions." % [int(state.loop)-1,state.clues.size(),state.contradictions.size()])
	state.loop_memories = memories
	_save()
	overlay_title.text = "↻  TIME LOOP RESET"
	var reveal_map: Dictionary = case_data.get("loop_reveals",{})
	var reveal := str(reveal_map.get(str(state.loop),""))
	overlay_body.text = "[center][font_size=28][color=#2c8cff]YOU KEEP THE KNOWLEDGE.\nTHE WORLD RESETS.[/color][/font_size][/center]\n\n" + str(case_data.get("loop_reset_text","Time folds backward. You remember."))
	if reveal != "":
		overlay_body.text += "\n\n[color=#e6b85c][b]ASMA[/b][/color]\n" + reveal
	_clear(overlay_actions)
	overlay_actions.add_child(_button("START LOOP %d  →" % int(state.loop),func(): _close_and_refresh(),true))
	overlay.visible = true

func _build_nav() -> void:
	_clear(nav)
	nav.columns = 3
	var locs: Array = case_data.get("locations",{}).keys()
	for loc_id in locs:
		var lid: String = str(loc_id)
		var name := str(case_data.locations[loc_id].get("name",lid))
		var label := name.substr(0,min(12,name.length())).to_upper()
		nav.add_child(_nav_button(label,func(): _travel(lid),lid == str(state.location)))
	nav.add_child(_nav_button("CASEBOOK",func(): _show_casebook(),false))

func _build_home_nav(active: String) -> void:
	_clear(nav)
	# Three columns keeps every control readable on narrow Android screens.
	nav.columns = 3
	nav.add_child(_nav_button("HOME",func(): _show_main_menu(),active=="HOME"))
	nav.add_child(_nav_button("CASES",func(): _show_case_select(),active=="CASES"))
	nav.add_child(_nav_button("SETTINGS",func(): _show_settings(),active=="SETTINGS"))
	nav.add_child(_nav_button("STORE",func(): _show_store(),active=="STORE"))
	nav.add_child(_nav_button("BADGES",func(): _show_achievements(),active=="ACHIEVEMENTS"))
	nav.add_child(_nav_button("TEAM",func(): _show_investigation_team(),active=="TEAM"))
	nav.add_child(_nav_button("CHARACTERS",func(): _show_character_gallery(),active=="CHARACTERS"))
	nav.add_child(_nav_button("HOW TO",func(): _show_help(),active=="HOW TO"))
	nav.add_child(_nav_button("ART",func(): _show_story_art(),active=="ART"))

func _show_settings() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_SETTINGS,0.44)
	title_label.text = "SETTINGS"
	status_label.text = "Tune readability, graphics and mobile feedback."

	var info := PanelContainer.new()
	info.add_theme_stylebox_override("panel",_panel_style(C_PANEL,16,C_GOLD,2,16))
	var iv := VBoxContainer.new()
	iv.add_theme_constant_override("separation",8)
	info.add_child(iv)
	var heading := Label.new()
	heading.text = "MOBILE EXPERIENCE"
	heading.add_theme_font_size_override("font_size",_fs(26))
	heading.add_theme_color_override("font_color",C_GOLD)
	iv.add_child(heading)
	var desc := Label.new()
	desc.text = "These settings are saved on this device."
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.add_theme_font_size_override("font_size",_fs(19))
	desc.add_theme_color_override("font_color",C_MUTED)
	iv.add_child(desc)
	body.add_child(info)

	body.add_child(_settings_row("DIFFICULTY",settings_manager.difficulty_label(),"Easy adds guidance. Hard is balanced. Hardest removes hints and reduces actions.",func():
		_show_difficulty()
	))
	body.add_child(_settings_row("GRAPHICS",settings_manager.graphics_label(),"Enhanced keeps richer artwork. Performance reduces background intensity.",func():
		settings_manager.toggle_graphics()
		_show_settings()
	))
	body.add_child(_settings_row("TEXT SIZE",settings_manager.text_size_label(),"Changes interface and story text sizing.",func():
		settings_manager.cycle_text_size()
		get_tree().reload_current_scene()
	))
	body.add_child(_settings_row("VIBRATION","ON" if settings_manager.vibration_enabled else "OFF","Short haptic feedback for clues, resets and deductions.",func():
		settings_manager.toggle_vibration()
		_vibrate(25)
		_show_settings()
	))
	body.add_child(_settings_row("AI VISUALS",_dynamic_visual_status(),"When online, important current scenes can be generated dynamically. If unavailable, gameplay continues instantly with built-in artwork.",func():
		_show_visual_service_info()
	))
	body.add_child(_button("CLEAR ALL CASE PROGRESS",func(): _confirm_clear_progress(),false))
	body.add_child(_button("ABOUT / VERSION 1.5.3",func(): _show_about(),false))
	_build_home_nav("SETTINGS")

func _dynamic_visual_status() -> String:
	if dynamic_image_client != null and dynamic_image_client.enabled:
		return "ONLINE"
	return "OFFLINE FALLBACK"

func _show_visual_service_info() -> void:
	overlay_title.text = "AI VISUALS"
	var online := dynamic_image_client != null and dynamic_image_client.enabled
	if online:
		overlay_body.text = "[color=#e6b85c][b]ONLINE[/b][/color]\n\nImportant current scenes can request a dynamic visual. The game never generates future scenes in advance. Gameplay continues immediately with fallback art while the image is being generated."
	else:
		overlay_body.text = "[color=#9db1c7][b]OFFLINE FALLBACK[/b][/color]\n\nThe image service is not active yet. All cases remain fully playable with built-in artwork. Once the secure backend endpoint is configured, live scene generation activates automatically."
	_clear(overlay_actions)
	overlay_actions.add_child(_button("CLOSE",func(): overlay.visible=false,false))
	overlay.visible = true

func _settings_row(label_text: String,value_text: String,description: String,action: Callable) -> Control:
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel",_panel_style(C_PANEL,14,C_LINE,2,14))
	var stack := VBoxContainer.new()
	stack.add_theme_constant_override("separation",8)
	card.add_child(stack)

	var label := Label.new()
	label.text = label_text
	label.add_theme_font_size_override("font_size",_fs(22))
	label.add_theme_color_override("font_color",C_TEXT)
	stack.add_child(label)

	var detail := Label.new()
	detail.text = description
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail.add_theme_font_size_override("font_size",_fs(16))
	detail.add_theme_color_override("font_color",C_MUTED)
	stack.add_child(detail)

	var b := _button(value_text,action,false)
	b.custom_minimum_size = Vector2(0,62)
	b.add_theme_font_size_override("font_size",_fs(18))
	stack.add_child(b)
	return card

func _confirm_clear_progress() -> void:
	overlay_title.text = "CLEAR ALL PROGRESS?"
	overlay_body.text = "This removes saved progress for all ten Season 1 cases on this device. This cannot be undone."
	_clear(overlay_actions)
	overlay_actions.add_child(_button("CLEAR PROGRESS",func(): _clear_all_progress(),true))
	overlay_actions.add_child(_button("CANCEL",func(): overlay.visible=false,false))
	overlay.visible = true

func _clear_all_progress() -> void:
	for item in case_catalog:
		save_manager.clear(str(item.get("id","")))
	current_case_id = ""
	state = {}
	overlay.visible = false
	_show_settings()

func _show_about() -> void:
	overlay_title.text = "TIME LOOP DETECTIVE"
	overlay_body.text = "[center][color=#e6b85c][b]Version 1.5.3[/b][/color][/center]\n\nA story-driven detective mystery built for Android and iOS. Investigate ten Season 1 cases, choose your investigator, use outfits and equipment, request hints, expose contradictions, confront culprits and uncover the origin of the time loop."
	_clear(overlay_actions)
	overlay_actions.add_child(_button("CLOSE",func(): overlay.visible=false,false))
	overlay.visible = true

func _travel(loc: String) -> void:
	state.location = loc
	_save()
	_show_game()

func _show_casebook() -> void:
	_set_polished_background(ART_CASEBOOK,0.36)
	overlay_title.text = "CASEBOOK / EVIDENCE"
	var text := "[color=#9db1c7]COLLECTED EVIDENCE %d/%d[/color]\n\n" % [state.clues.size(),case_data.clues.size()]
	for id in case_data.clues.keys():
		var found: bool = id in state.clues
		text += ("[color=#e6b85c]■[/color] " if found else "[color=#44627f]□[/color] ") + str(case_data.clues[id].get("name",id))
		if found:
			text += "\n[color=#9db1c7]   " + str(case_data.clues[id].get("description","")) + "[/color]"
		text += "\n\n"
	text += "[color=#9db1c7]CONTRADICTIONS: %d[/color]\n" % state.contradictions.size()
	text += "[color=#2c8cff]SEASON LOOP FRAGMENTS: %d[/color]\n\n" % settings_manager.season_fragments.size()
	text += "[b]TIMELINE[/b]\n"
	for line in case_data.get("timeline",[]):
		text += "• " + str(line) + "\n"
	overlay_body.text = text
	_clear(overlay_actions)
	overlay_actions.add_child(_button("EVIDENCE BOARD",func(): _show_evidence_board(),false))
	overlay_actions.add_child(_button("GET A HINT",func(): _use_hint(),false))
	overlay_actions.add_child(_button("MAKE A DEDUCTION  →",func(): _show_deduction(),true))
	overlay_actions.add_child(_button("CASE SELECT",func(): _show_case_select_from_overlay(),false))
	overlay_actions.add_child(_button("CLOSE",func(): _close_and_refresh(),false))
	overlay.visible = true

func _show_evidence_board() -> void:
	overlay_title.text = "EVIDENCE BOARD"
	var text := "[color=#e6b85c][b]KNOWN CONNECTIONS[/b][/color]\n\n"
	var found_count := 0
	for clue_id in state.clues:
		var clue: Dictionary = case_data.clues.get(str(clue_id),{})
		var loc_name := str(case_data.locations.get(str(clue.get("location","")),{}).get("name","Unknown"))
		text += "• %s  →  %s\n" % [str(clue.get("name",clue_id)),loc_name]
		found_count += 1
	text += "\n[color=#9db1c7]Suspects interviewed: %d/%d[/color]" % [state.talked.size(),case_data.suspects.size()]
	text += "\n[color=#9db1c7]Contradictions exposed: %d[/color]" % state.contradictions.size()
	text += "\n[color=#9db1c7]Evidence collected: %d/%d[/color]" % [found_count,case_data.clues.size()]
	overlay_body.text = text
	_clear(overlay_actions)
	overlay_actions.add_child(_button("BACK TO CASEBOOK",func(): _show_casebook(),true))
	overlay.visible = true

func _use_hint() -> void:
	var used := int(state.get("hints_used",0))
	var cost := 0 if used == 0 else 25
	if cost > 0 and not settings_manager.spend_credits(cost):
		overlay_title.text = "MORE CREDITS NEEDED"
		overlay_body.text = "Your first hint for this case was free. Additional hints cost 25 credits."
		_clear(overlay_actions)
		overlay_actions.add_child(_button("OPEN DETECTIVE STORE",func():
			overlay.visible = false
			_show_store()
		,true))
		overlay_actions.add_child(_button("CLOSE",func(): _close_and_refresh(),false))
		overlay.visible = true
		return

	var hint := "Recheck the timeline and compare suspect statements against your strongest evidence."
	for clue_id in case_data.get("strong_clues",[]):
		if str(clue_id) not in state.clues:
			var clue: Dictionary = case_data.clues.get(str(clue_id),{})
			hint = "Focus on %s at %s. %s" % [str(clue.get("name","a missing clue")),str(case_data.locations.get(str(clue.get("location","")),{}).get("name","the scene")),_clue_hint_text(clue)]
			break
	state.hints_used = used + 1
	_save()
	overlay_title.text = "INVESTIGATION HINT"
	overlay_body.text = "[center][color=#e6b85c][b]%s[/b][/color][/center]\n\n%s" % ["FREE HINT" if cost == 0 else "25 CREDITS USED",hint]
	_clear(overlay_actions)
	overlay_actions.add_child(_button("BACK TO CASEBOOK",func(): _show_casebook(),true))
	overlay.visible = true

func _show_deduction() -> void:
	_play_deduction()
	_apply_scene_visual("confrontation","",0.48)
	overlay_title.text = "FINAL DEDUCTION"
	overlay_body.text = "[center][color=#e32636][font_size=34][b]WHO IS RESPONSIBLE?[/b][/font_size][/color][/center]\n\n" + str(case_data.get("deduction_prompt","Choose carefully. Your evidence decides the ending."))
	_clear(overlay_actions)
	for id in case_data.suspects.keys():
		var sid: String = str(id)
		overlay_actions.add_child(_button(str(case_data.suspects[id].get("name",id)),func(): _accuse(sid),false))
	overlay_actions.add_child(_button("NOT YET",func(): _close_and_refresh(),false))
	overlay.visible = true

func _accuse(id: String) -> void:
	var count: int = 0
	for clue in case_data.get("strong_clues",[]):
		if str(clue) in state.clues:
			count += 1
	var culprit := str(case_data.get("culprit",""))
	var required := str(case_data.get("required_contradiction",""))
	if id == culprit and count >= _required_strong_count() and required in state.contradictions:
		_start_confrontation(id)
	elif id == culprit and count >= 2:
		_finish("partial")
	else:
		_finish("wrong")

func _start_confrontation(culprit_id: String) -> void:
	var culprit_name := str(case_data.suspects.get(culprit_id,{}).get("name","the suspect"))
	var confrontation_request := _request_dynamic_visual("confrontation","",{
		"characters":["Detective Asma","the player detective partner",culprit_name],
		"action":"the culprit attempts to escape after the accusation",
		"force_visual":true
	})
	_set_polished_background(str(confrontation_request.get("fallback_art",ART_DEDUCTION)),0.50)
	overlay_title.text = "FINAL CONFRONTATION"
	overlay_body.text = "[center][color=#e32636][font_size=30][b]%s tries to escape.[/b][/font_size][/color][/center]\n\nYou solved the case. Now choose how your investigator brings the culprit into custody." % culprit_name
	_clear(overlay_actions)
	overlay_actions.add_child(_button("CHASE & ARREST",func(): _resolve_confrontation("chase"),true))
	overlay_actions.add_child(_button("FIGHT / RESTRAIN",func(): _resolve_confrontation("fight"),false))
	if "sidearm" in settings_manager.unlocked_gear:
		overlay_actions.add_child(_button("DRAW SERVICE SIDEARM • ORDER SURRENDER",func(): _resolve_confrontation("sidearm"),false))
	overlay_actions.add_child(_button("USE HANDCUFFS",func(): _resolve_confrontation("cuff"),false))
	overlay.visible = true

func _resolve_confrontation(method: String) -> void:
	var visual_kind := "capture"
	if method == "chase": visual_kind = "chase"
	elif method == "fight": visual_kind = "confrontation"
	elif method == "sidearm": visual_kind = "cover"
	_apply_scene_visual(visual_kind,"",0.52)
	_remember_action("confrontation_" + method)
	var outcome := ""
	match method:
		"fight":
			outcome = "After a short struggle, your investigator restrains the culprit and takes them into custody."
		"sidearm":
			outcome = "Your investigator keeps distance, orders the culprit to surrender, and makes the arrest without firing."
		"cuff":
			outcome = "You close the distance at the right moment and secure the culprit with handcuffs."
		_:
			outcome = "You pursue the culprit through the scene, cut off the escape route, and make the arrest."
	state["confrontation"] = method
	_save()
	_finish("true")
	overlay_body.text += "\n\n[color=#9db1c7]%s[/color]" % outcome

func _detective_rank() -> String:
	var score := 100
	score -= maxi(0,int(state.get("loop",1))-1) * 12
	score -= int(state.get("hints_used",0)) * 8
	score -= maxi(0,int(state.get("action",0)) - int(case_data.get("max_actions",8))) * 2
	if score >= 90:
		return "S"
	if score >= 78:
		return "A"
	if score >= 65:
		return "B"
	return "C"

func _finish(kind: String) -> void:
	state.ending = kind
	_save()
	overlay_title.text = "CASE CLOSED" if kind=="true" else "THE LOOP RESISTS"
	if kind=="true":
		var rank := _detective_rank()
		var reward := settings_manager.reward_case_once(current_case_id,50)
		settings_manager.mark_case_completed(current_case_id)
		var case_fragment := str(case_data.get("season_fragment",""))
		if case_fragment != "":
			settings_manager.unlock_season_fragment(case_fragment)
		settings_manager.unlock_achievement("first_case")
		if int(state.get("hints_used",0)) == 0:
			settings_manager.unlock_achievement("no_hint_case")
		if int(state.get("loop",1)) < 3:
			settings_manager.unlock_achievement("perfect_loop")
		if current_case_id == "case_10":
			settings_manager.unlock_achievement("season_one")
		overlay_body.text = "[center][font_size=34][color=#e6b85c][b]TRUE ENDING[/b][/color][/font_size]\nDETECTIVE RANK: [b]%s[/b][/center]\n\n%s" % [rank,str(case_data.get("truth",""))]
		if reward > 0:
			overlay_body.text += "\n\n[color=#e6b85c]+%d DETECTIVE CREDITS[/color]" % reward
		overlay_body.text += "\n[color=#2c8cff]%s[/color]" % settings_manager.season_progress_text()
	elif kind=="partial":
		overlay_body.text = "[center][color=#e6b85c][b]PARTIAL TRUTH[/b][/color][/center]\n\n"+str(case_data.get("partial","Incomplete deduction."))
	else:
		overlay_body.text = "[center][color=#e32636][b]WRONG ACCUSATION[/b][/color][/center]\n\n"+str(case_data.get("wrong","Wrong accusation."))
	_clear(overlay_actions)
	if kind == "true" and current_case_id == "case_10":
		overlay_actions.add_child(_button("SEASON 2 TEASER  →",func():
			overlay.visible = false
			_show_season2_teaser()
		,true))
	overlay_actions.add_child(_button("RESTART CASE",func(): _restart_case(),true))
	overlay_actions.add_child(_button("CASE SELECT",func(): _show_case_select_from_overlay(),false))
	overlay.visible = true

func _restart_case() -> void:
	save_manager.clear(current_case_id)
	state = save_manager.load_state(current_case_id,str(case_data.get("start_location","")))
	overlay.visible = false
	_start_new()

func _show_case_select_from_overlay() -> void:
	overlay.visible = false
	_show_case_select()

func _show_help() -> void:
	_set_polished_background(ART_MENU,0.42)
	overlay_title.text = "HOW TO PLAY"
	overlay_body.text = "[color=#e6b85c][b]1. INVESTIGATE[/b][/color]\nMove between locations and inspect the scene.\n\n[color=#e6b85c][b]2. INTERROGATE[/b][/color]\nQuestion suspects. Their stories can change between loops.\n\n[color=#e6b85c][b]3. COLLECT CLUES[/b][/color]\nEvidence survives the reset.\n\n[color=#e6b85c][b]4. FIND CONTRADICTIONS[/b][/color]\nUse evidence to break false stories.\n\n[color=#e32636][b]5. BREAK THE LOOP[/b][/color]\nAfter three loops, make the final deduction."
	_clear(overlay_actions)
	overlay_actions.add_child(_button("CLOSE",func(): _show_main_menu(),true))
	overlay.visible = true

func _close_and_refresh() -> void:
	overlay.visible = false
	if current_case_id != "" and not case_data.is_empty():
		_show_game()
	else:
		_show_main_menu()

func _spend_action(refresh := true) -> void:
	state.action = mini(int(state.action)+1,_effective_max_actions())
	_save()
	if refresh:
		_show_game()

func _save() -> void:
	save_manager.save_state(current_case_id,state)

func _set_background(path: String) -> void:
	background.texture = _load_tex(path)
	var strength := 0.58 if settings_manager.graphics_quality == "enhanced" else 0.42
	background.modulate = Color(0.94,0.97,1.0,strength)

func _set_polished_background(path: String,alpha := 0.40) -> void:
	background.texture = _load_tex(path)
	var strength := alpha if settings_manager.graphics_quality == "enhanced" else alpha * 0.72
	background.modulate = Color(0.82,0.88,0.96,strength)

func _atlas_portrait(index: int) -> Texture2D:
	var atlas := _load_tex(ART_CHARACTER_ATLAS)
	if atlas == null:
		return null
	var safe_index := posmod(index,20)
	var col := safe_index % 10
	var row := safe_index / 10
	var cell_w := float(atlas.get_width()) / 10.0
	var x := float(col) * cell_w + 5.0
	var y := 0.0 if row == 0 else 260.0
	var h := 198.0 if row == 0 else 185.0
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = Rect2(x,y,cell_w - 10.0,h)
	return tex

func _character_portrait(id: String,fallback_path: String) -> Texture2D:
	if CHARACTER_REAL_ART.has(id):
		return _load_tex(str(CHARACTER_REAL_ART[id]))
	if CHARACTER_ATLAS_MAP.has(id):
		return _atlas_portrait(int(CHARACTER_ATLAS_MAP[id]))
	if fallback_path != "" and ResourceLoader.exists(fallback_path):
		return _load_tex(fallback_path)
	var atlas_pick: int = abs(id.hash()) % 20
	return _atlas_portrait(atlas_pick)

func _load_tex(path: String) -> Texture2D:
	if texture_cache.has(path):
		return texture_cache[path]
	if path.ends_with(".txt") and FileAccess.file_exists(path):
		var file := FileAccess.open(path,FileAccess.READ)
		if file != null:
			var raw: PackedByteArray = Marshalls.base64_to_raw(file.get_as_text().strip_edges())
			var decoded := Image.new()
			if decoded.load_jpg_from_buffer(raw) == OK:
				var tex := ImageTexture.create_from_image(decoded)
				texture_cache[path] = tex
				return tex
	if path != "" and ResourceLoader.exists(path):
		var resource_tex = load(path)
		if resource_tex is Texture2D:
			texture_cache[path] = resource_tex
			return resource_tex
	var image := Image.create(64,64,false,Image.FORMAT_RGBA8)
	image.fill(C_PANEL)
	var fallback := ImageTexture.create_from_image(image)
	texture_cache[path] = fallback
	return fallback

func _scroll_to_top() -> void:
	if main_scroll != null:
		main_scroll.scroll_vertical = 0
		main_scroll.call_deferred("set_v_scroll",0)

func _scroll_container_at(position: Vector2) -> ScrollContainer:
	if overlay != null and overlay.visible and overlay_scroll != null and overlay_scroll.get_global_rect().has_point(position):
		return overlay_scroll
	if main_scroll != null and main_scroll.get_global_rect().has_point(position):
		return main_scroll
	return null

func _ensure_audio() -> void:
	if audio == null:
		audio = AudioManager.new()
		add_child(audio)

func _play_click() -> void:
	_ensure_audio()
	if audio != null:
		audio.click()

func _play_evidence() -> void:
	_vibrate(35)
	_ensure_audio()
	if audio != null:
		audio.evidence()

func _play_loop_reset() -> void:
	_vibrate(60)
	_ensure_audio()
	if audio != null:
		audio.loop_reset()

func _play_deduction() -> void:
	_vibrate(45)
	_ensure_audio()
	if audio != null:
		audio.deduction()

func _effective_max_actions() -> int:
	var base := int(case_data.get("max_actions",8))
	match settings_manager.difficulty:
		"easy":
			return base + 2
		"hardest":
			return maxi(4,base - 2)
		_:
			return base

func _is_narrow_mobile() -> bool:
	return get_viewport().get_visible_rect().size.x < 560.0

func _responsive_box() -> BoxContainer:
	var box: BoxContainer = VBoxContainer.new() if _is_narrow_mobile() else HBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return box

func _required_strong_count() -> int:
	var available: int = int(case_data.get("strong_clues",[]).size())
	match settings_manager.difficulty:
		"easy":
			return mini(3,available)
		"hardest":
			return available
		_:
			return mini(4,available)

func _clue_hint_text(data: Dictionary) -> String:
	match settings_manager.difficulty:
		"easy":
			return "Hint: inspect carefully here. Evidence in this area may connect to a suspect."
		"hardest":
			return "No hint available. Trust your observations."
		_:
			return "Inspect this area for evidence."

func _fs(size: int) -> int:
	return maxi(12,roundi(float(size) * settings_manager.font_scale()))

func _vibrate(duration_ms: int) -> void:
	if settings_manager.vibration_enabled and OS.has_feature("mobile"):
		Input.vibrate_handheld(duration_ms)

func _button(text: String,action: Callable,accent := false) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0,82)
	b.add_theme_font_size_override("font_size",_fs(24))
	b.add_theme_color_override("font_color",C_TEXT)
	b.add_theme_color_override("font_hover_color",Color.WHITE)
	b.add_theme_stylebox_override("normal",_panel_style(Color("#2a1b0d") if accent else C_PANEL_2,13,C_GOLD if accent else C_LINE,2,10))
	b.add_theme_stylebox_override("hover",_panel_style(Color("#3a260f") if accent else Color("#1b1712"),13,C_GOLD,2,10))
	b.add_theme_stylebox_override("pressed",_panel_style(Color("#171007"),13,C_GOLD,2,10))
	b.pressed.connect(func():
		_play_click()
		action.call()
	)
	return b

func _nav_button(text: String,action: Callable,active: bool) -> Button:
	var b := _button(text,action,false)
	b.custom_minimum_size = Vector2(0,56)
	b.add_theme_font_size_override("font_size",_fs(14))
	if active:
		b.add_theme_color_override("font_color",C_RED)
		b.add_theme_stylebox_override("normal",_panel_style(Color("#101b2b"),12,C_RED,2,8))
	return b

func _add_section_title(text: String) -> void:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size",_fs(25))
	l.add_theme_color_override("font_color",C_GOLD)
	body.add_child(l)

func _panel_style(bg: Color,radius: int,border: Color,width: int,padding: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(width)
	s.set_corner_radius_all(radius)
	s.set_content_margin_all(padding)
	return s

func _add_unique(arr: Array,value) -> void:
	if value not in arr:
		arr.append(value)
	_save()

func _clear(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.free()
