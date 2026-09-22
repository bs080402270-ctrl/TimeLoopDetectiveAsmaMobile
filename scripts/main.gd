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
const C_LINE := Color("#8a6437")
const C_TEXT := Color("#f4f7fb")
const C_MUTED := Color("#9db1c7")
const C_RED := Color("#e32636")
const C_RED_DARK := Color("#a51220")
const C_GOLD := Color("#e6b85c")
const C_BLUE := Color("#f0b85f")
const ART_MENU := "res://art/actual/detective_office.jpg"
const ART_CASES := "res://art/actual/detective_office.jpg"
const ART_INTERROGATION := "res://art/actual/detective_office.jpg"
const ART_CASEBOOK := "res://art/actual/evidence_room.jpg"
const ART_RESET := "res://art/actual/evidence_room.jpg"
const ART_DEDUCTION := "res://art/actual/final_deduction.jpg"
const ART_SETTINGS := "res://art/actual/detective_office.jpg"
const ART_INTRO := "res://art/actual/investigation_desk.jpg"
const ART_DIFFICULTY := "res://art/actual/investigation_desk.jpg"
const ART_CHARACTER_ATLAS := "res://art/actual/character_atlas.jpg"
const ART_SEASON2_TEASER := "res://art/actual/season2_teaser.jpg"

const CHARACTER_REAL_ART := {
	"maya": "res://art/actual/base64/maya.txt",
	"omar": "res://art/actual/base64/omar.txt",
	"lina": "res://art/actual/base64/lina.txt",
	"asma": "res://art/actual/characters/asma.tres",
	"chief_farid": "res://art/actual/characters/chief_farid.tres",
	"ryan_khan": "res://art/actual/characters/ryan_khan.tres",
	"dr_leila": "res://art/actual/characters/dr_leila.tres",
	"viktor_malik": "res://art/actual/characters/viktor_malik.tres",
	"nora_said": "res://art/actual/characters/nora_said.tres",
	"imran": "res://art/actual/characters/imran.tres",
	"mrs_zahra": "res://art/actual/characters/mrs_zahra.tres",
	"marco": "res://art/actual/characters/marco.tres",
	"ayumi": "res://art/actual/characters/ayumi.tres",
	"the_fixer": "res://art/actual/characters/the_fixer.tres",
	"samira": "res://art/actual/characters/samira.tres",
	"colonel_rashid": "res://art/actual/characters/colonel_rashid.tres",
	"kareem": "res://art/actual/characters/kareem.tres",
	"ayesha": "res://art/actual/characters/ayesha.tres",
	"dr_hassan": "res://art/actual/characters/dr_hassan.tres",
	"officer_lina": "res://art/actual/characters/officer_lina.tres",
	"the_mayor": "res://art/actual/characters/the_mayor.tres",
	"the_stranger": "res://art/actual/characters/the_stranger.tres",
	"young_omar": "res://art/actual/characters/young_omar.tres",
	"farid": "res://art/actual/characters/chief_farid.tres",
	"leila": "res://art/actual/characters/dr_leila.tres",
	"viktor": "res://art/actual/characters/viktor_malik.tres",
	"hassan": "res://art/actual/characters/dr_hassan.tres",
	"stranger": "res://art/actual/characters/the_stranger.tres"
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

var case_catalog: Array[Dictionary] = []
var case_data: Dictionary = {}
var state: Dictionary = {}
var save_manager := SaveManager.new()
var settings_manager := SettingsManager.new()
var audio: AudioManager
var current_case_id := ""

var background: TextureRect
var title_label: Label
var status_label: Label
var body: VBoxContainer
var main_scroll: ScrollContainer
var nav: GridContainer
var texture_cache: Dictionary = {}
var overlay: PanelContainer
var overlay_title: Label
var overlay_body: RichTextLabel
var overlay_actions: VBoxContainer

func _ready() -> void:
	_load_catalog()
	_build_shell()
	_show_main_menu()

func _input(event: InputEvent) -> void:
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
	margin.add_theme_constant_override("margin_bottom",56)
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

	overlay_body = RichTextLabel.new()
	overlay_body.bbcode_enabled = true
	overlay_body.fit_content = false
	overlay_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	overlay_body.add_theme_font_size_override("normal_font_size",_fs(25))
	overlay_body.add_theme_color_override("default_color",C_TEXT)
	ov.add_child(overlay_body)

	overlay_actions = VBoxContainer.new()
	overlay_actions.add_theme_constant_override("separation",10)
	ov.add_child(overlay_actions)
	overlay.visible = false

func _show_main_menu() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	_scroll_to_top()
	_set_polished_background(ART_MENU,0.46)
	title_label.text = "TIME LOOP DETECTIVE"
	title_label.add_theme_color_override("font_color",C_TEXT)
	status_label.text = "SAME TIME. DIFFERENT TRUTHS. BREAK THE LOOP."

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

	body.add_child(_button("START INVESTIGATION  →",func(): _show_intro(),true))
	body.add_child(_button("CHARACTERS",func(): _show_character_gallery(),false))
	body.add_child(_button("HOW TO PLAY",func(): _show_help(),false))
	body.add_child(_button("SEASON 2 TEASER",func(): _show_season2_teaser(),false))
	_build_home_nav("HOME")

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
		var row := HBoxContainer.new()
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
	var row := HBoxContainer.new()
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
		var row := HBoxContainer.new()
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

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation",12)
	stack.add_child(top)

	var start_id := str(data.get("start_location",""))
	var thumb_path := str(data.get("locations",{}).get(start_id,{}).get("art",""))
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
	state.ending = ""
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
	status_label.text = "%s   •   LOOP %d/3   •   ACTIONS %d/%d   •   CLUES %d/%d" % [settings_manager.difficulty_label(),int(state.loop),int(state.action),max_actions,state.clues.size(),total_clues]
	_set_background(str(loc.get("art","")))
	_show_location(loc_key)

func _show_location(loc_key: String) -> void:
	var loc: Dictionary = case_data.get("locations",{}).get(loc_key,{})

	var hero := TextureRect.new()
	hero.texture = _load_tex(str(loc.get("art","")))
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

func _person_card(id: String) -> Control:
	var data: Dictionary = case_data.suspects[id]
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel",_panel_style(Color(0.035,0.095,0.155,0.94),16,Color("#194d78"),2,12))

	var row := HBoxContainer.new()
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
	var card := PanelContainer.new()
	card.add_theme_stylebox_override("panel",_panel_style(C_PANEL,14,C_GOLD if found else Color("#174b78"),2,12))

	var row := HBoxContainer.new()
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
	d.text = str(data.get("description","")) if found else _clue_hint_text(data)
	d.add_theme_font_size_override("font_size",_fs(19))
	d.add_theme_color_override("font_color",C_MUTED)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(d)

	var cid: String = id
	var b := _button("RECORDED" if found else "INSPECT",func(): _collect_clue(cid),false)
	b.disabled = found
	b.custom_minimum_size = Vector2(145,72)
	row.add_child(b)
	return card

func _interrogate(id: String) -> void:
	background.texture = _character_portrait(id,str(case_data.suspects[id].get("art","")))
	background.modulate = Color(0.82,0.88,0.96,0.42)
	var data: Dictionary = case_data.suspects[id]
	var lines: Array = data.get("dialogue",[])
	var idx := clampi(int(state.loop)-1,0,maxi(0,lines.size()-1))
	overlay_title.text = str(data.get("name",id)) + " • INTERROGATION"
	overlay_body.text = "[color=#9db1c7]%s[/color]\n\n%s" % [str(data.get("role","Person of interest")), str(lines[idx]) if lines.size() > 0 else "They watch you carefully."]
	_clear(overlay_actions)
	var sid: String = id
	overlay_actions.add_child(_button("THIS DOESN'T ADD UP...  →",func(): _press_suspect(sid),true))
	overlay_actions.add_child(_button("CLOSE",func(): _close_and_refresh(),false))
	overlay.visible = true
	_add_unique(state.talked,id)
	_spend_action(false)

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
	var data: Dictionary = case_data.clues[id]
	overlay_title.text = "EVIDENCE FOUND"
	overlay_body.text = "[center][color=#e6b85c][font_size=30][b]%s[/b][/font_size][/color][/center]\n\n%s" % [str(data.get("name",id)),str(data.get("description",""))]
	_clear(overlay_actions)
	overlay_actions.add_child(_button("ADD TO CASEBOOK  →",func(): _close_and_refresh(),true))
	overlay.visible = true
	_play_evidence()
	_spend_action(false)

func _reset_loop() -> void:
	_play_loop_reset()
	_set_polished_background(ART_RESET,0.38)
	if int(state.loop) >= 3:
		_show_deduction()
		return
	state.loop = int(state.loop)+1
	state.action = 0
	state.location = str(case_data.get("start_location",""))
	_save()
	overlay_title.text = "↻  TIME LOOP RESET"
	overlay_body.text = "[center][font_size=28][color=#2c8cff]YOU KEEP THE KNOWLEDGE.\nTHE WORLD RESETS.[/color][/font_size][/center]\n\n" + str(case_data.get("loop_reset_text","Time folds backward. You remember."))
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
	nav.add_child(_nav_button("CHARACTERS",func(): _show_character_gallery(),active=="CHARACTERS"))
	nav.add_child(_nav_button("HOW TO",func(): _show_help(),active=="HOW TO"))

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
	body.add_child(_button("CLEAR ALL CASE PROGRESS",func(): _confirm_clear_progress(),false))
	body.add_child(_button("ABOUT / VERSION 1.2.0",func(): _show_about(),false))
	_build_home_nav("SETTINGS")

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
	overlay_body.text = "[center][color=#e6b85c][b]Version 1.2.0[/b][/color][/center]\n\nA story-driven detective mystery built for Android and iOS. Investigate ten Season 1 cases, carry knowledge across loops, expose contradictions and uncover the origin of the time loop."
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
	text += "[color=#9db1c7]CONTRADICTIONS: %d[/color]\n\n" % state.contradictions.size()
	text += "[b]TIMELINE[/b]\n"
	for line in case_data.get("timeline",[]):
		text += "• " + str(line) + "\n"
	overlay_body.text = text
	_clear(overlay_actions)
	overlay_actions.add_child(_button("MAKE A DEDUCTION  →",func(): _show_deduction(),true))
	overlay_actions.add_child(_button("CASE SELECT",func(): _show_case_select_from_overlay(),false))
	overlay_actions.add_child(_button("CLOSE",func(): _close_and_refresh(),false))
	overlay.visible = true

func _show_deduction() -> void:
	_play_deduction()
	_set_polished_background(ART_DEDUCTION,0.40)
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
		_finish("true")
	elif id == culprit and count >= 2:
		_finish("partial")
	else:
		_finish("wrong")

func _finish(kind: String) -> void:
	state.ending = kind
	_save()
	overlay_title.text = "CASE CLOSED" if kind=="true" else "THE LOOP RESISTS"
	if kind=="true":
		overlay_body.text = "[center][font_size=34][color=#e6b85c][b]TRUE ENDING[/b][/color][/font_size][/center]\n\n"+str(case_data.get("truth",""))
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
	background.modulate = Color(0.82,0.88,0.96,strength)

func _set_polished_background(path: String,alpha := 0.40) -> void:
	background.texture = _load_tex(path)
	var strength := alpha if settings_manager.graphics_quality == "enhanced" else alpha * 0.72
	background.modulate = Color(0.82,0.88,0.96,strength)

func _atlas_portrait(index: int) -> Texture2D:
	var atlas := _load_tex(ART_CHARACTER_ATLAS)
	if atlas == null:
		return null
	var col := index % 10
	var row := index / 10
	var x := float(col) * 76.8 + 5.0
	var y := 55.0 if row == 0 else 252.0
	var h := 136.0 if row == 0 else 139.0
	var tex := AtlasTexture.new()
	tex.atlas = atlas
	tex.region = Rect2(x,y,69.0,h)
	return tex

func _character_portrait(id: String,fallback_path: String) -> Texture2D:
	if CHARACTER_REAL_ART.has(id):
		return _load_tex(str(CHARACTER_REAL_ART[id]))
	if CHARACTER_ATLAS_MAP.has(id):
		return _atlas_portrait(int(CHARACTER_ATLAS_MAP[id]))
	return _load_tex(fallback_path)

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
