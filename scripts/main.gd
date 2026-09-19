extends Control

const CASE_FILES := [
	"res://data/case_01.json",
	"res://data/case_02.json",
	"res://data/case_03.json",
	"res://data/case_04.json",
	"res://data/case_05.json"
]

var case_catalog: Array[Dictionary] = []
var case_data: Dictionary = {}
var state: Dictionary = {}
var save_manager := SaveManager.new()
var audio: AudioManager
var current_case_id := ""

var background: TextureRect
var title_label: Label
var status_label: Label
var body: VBoxContainer
var nav: HBoxContainer
var overlay: PanelContainer
var overlay_title: Label
var overlay_body: RichTextLabel
var overlay_actions: VBoxContainer

func _ready() -> void:
	_load_catalog()
	audio = AudioManager.new()
	add_child(audio)
	_build_shell()
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
	add_child(background)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.015,0.012,0.022,0.44)
	add_child(shade)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left",24)
	margin.add_theme_constant_override("margin_right",24)
	margin.add_theme_constant_override("margin_top",26)
	margin.add_theme_constant_override("margin_bottom",24)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation",14)
	margin.add_child(root)

	title_label = Label.new()
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size",34)
	title_label.add_theme_color_override("font_color",Color("#f0c46c"))
	root.add_child(title_label)

	status_label = Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.add_theme_font_size_override("font_size",18)
	root.add_child(status_label)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)

	body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation",14)
	scroll.add_child(body)

	nav = HBoxContainer.new()
	nav.alignment = BoxContainer.ALIGNMENT_CENTER
	nav.add_theme_constant_override("separation",6)
	root.add_child(nav)

	overlay = PanelContainer.new()
	overlay.anchor_left = 0.05
	overlay.anchor_top = 0.12
	overlay.anchor_right = 0.95
	overlay.anchor_bottom = 0.9
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035,0.03,0.05,0.98)
	style.border_color = Color("#c79a4a")
	style.set_border_width_all(2)
	style.set_corner_radius_all(20)
	style.set_content_margin_all(22)
	overlay.add_theme_stylebox_override("panel",style)
	add_child(overlay)

	var ov := VBoxContainer.new()
	ov.add_theme_constant_override("separation",12)
	overlay.add_child(ov)
	overlay_title = Label.new()
	overlay_title.add_theme_font_size_override("font_size",30)
	overlay_title.add_theme_color_override("font_color",Color("#f0c46c"))
	ov.add_child(overlay_title)
	overlay_body = RichTextLabel.new()
	overlay_body.bbcode_enabled = true
	overlay_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	overlay_body.add_theme_font_size_override("normal_font_size",20)
	ov.add_child(overlay_body)
	overlay_actions = VBoxContainer.new()
	overlay_actions.add_theme_constant_override("separation",8)
	ov.add_child(overlay_actions)
	overlay.visible = false

func _show_main_menu() -> void:
	_clear(body)
	_clear(nav)
	overlay.visible = false
	title_label.text = "TIME LOOP DETECTIVE"
	status_label.text = "Five mysteries. Five loops in time. One detective who remembers."
	_set_background("res://art/backgrounds/cafe.svg")

	var hero := TextureRect.new()
	hero.texture = _load_tex("res://art/ui/keyart.svg")
	hero.custom_minimum_size = Vector2(0,360)
	hero.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hero.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	body.add_child(hero)

	body.add_child(_button("CASE SELECT",func(): _show_case_select()))
	body.add_child(_button("HOW TO PLAY",func(): _show_help()))

func _show_case_select() -> void:
	_clear(body)
	_clear(nav)
	title_label.text = "CASE SELECT"
	status_label.text = "Choose an investigation."
	for data in case_catalog:
		var case_id := str(data.get("id",""))
		var box := PanelContainer.new()
		var s := StyleBoxFlat.new()
		s.bg_color = Color(0.07,0.055,0.09,0.94)
		s.set_corner_radius_all(16)
		s.set_content_margin_all(16)
		box.add_theme_stylebox_override("panel",s)
		var vb := VBoxContainer.new()
		box.add_child(vb)
		var t := Label.new()
		t.text = str(data.get("title","Untitled Case"))
		t.add_theme_font_size_override("font_size",24)
		t.add_theme_color_override("font_color",Color("#f0c46c"))
		vb.add_child(t)
		var d := Label.new()
		d.text = str(data.get("subtitle",""))
		d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vb.add_child(d)
		var cid: String = case_id
		vb.add_child(_button("CONTINUE" if save_manager.has_save(cid) else "START CASE",func(): _open_case(cid)))
		body.add_child(box)
	body.add_child(_button("BACK",func(): _show_main_menu()))

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
	title_label.text = str(loc.get("name","Investigation"))
	var total_clues: int = case_data.get("clues",{}).size()
	var max_actions: int = int(case_data.get("max_actions",8))
	status_label.text = "Loop %d/3 • Actions %d/%d • Evidence %d/%d" % [int(state.loop),int(state.action),max_actions,state.clues.size(),total_clues]
	_set_background(str(loc.get("art","")))
	_show_location(loc_key)

func _show_location(loc_key: String) -> void:
	var loc: Dictionary = case_data.get("locations",{}).get(loc_key,{})
	var intro := Label.new()
	intro.text = str(loc.get("description","Search carefully."))
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.add_theme_font_size_override("font_size",20)
	body.add_child(intro)

	var people: Array = loc.get("people",[])
	if people.size() > 0:
		_add_section_title("People")
		for person in people:
			body.add_child(_person_card(str(person)))

	_add_section_title("Search")
	for clue_id in case_data.get("clues",{}).keys():
		var clue: Dictionary = case_data.clues[clue_id]
		if str(clue.get("location","")) == loc_key:
			body.add_child(_clue_card(str(clue_id)))

	if int(state.action) >= int(case_data.get("max_actions",8)):
		var w := Label.new()
		w.text = "The loop is collapsing..."
		w.add_theme_color_override("font_color",Color("#ffb467"))
		body.add_child(w)
		body.add_child(_button("LET THE LOOP RESET",func(): _reset_loop()))

func _person_card(id: String) -> Control:
	var data: Dictionary = case_data.suspects[id]
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation",12)
	var portrait := TextureRect.new()
	portrait.texture = _load_tex(str(data.get("art","")))
	portrait.custom_minimum_size = Vector2(120,160)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(portrait)
	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(vb)
	var n := Label.new()
	n.text = str(data.get("name",id))
	n.add_theme_font_size_override("font_size",23)
	vb.add_child(n)
	var role := Label.new()
	role.text = str(data.get("role",""))
	role.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(role)
	var sid: String = id
	vb.add_child(_button("INTERROGATE",func(): _interrogate(sid)))
	return row

func _clue_card(id: String) -> Control:
	var data: Dictionary = case_data.clues[id]
	var found: bool = id in state.clues
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation",12)
	var icon := TextureRect.new()
	icon.texture = _load_tex(str(data.get("art","")))
	icon.custom_minimum_size = Vector2(82,82)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)
	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(vb)
	var n := Label.new()
	n.text = ("✓ " if found else "") + str(data.get("name",id))
	n.add_theme_font_size_override("font_size",20)
	vb.add_child(n)
	var d := Label.new()
	d.text = str(data.get("description","")) if found else "Inspect this area for evidence."
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(d)
	var cid: String = id
	var b := _button("RECORDED" if found else "INSPECT",func(): _collect_clue(cid))
	b.disabled = found
	row.add_child(b)
	return row

func _interrogate(id: String) -> void:
	var data: Dictionary = case_data.suspects[id]
	var lines: Array = data.get("dialogue",[])
	var idx := clampi(int(state.loop)-1,0,maxi(0,lines.size()-1))
	overlay_title.text = str(data.get("name",id))
	overlay_body.text = str(lines[idx]) if lines.size() > 0 else "They watch you carefully."
	_clear(overlay_actions)
	var sid: String = id
	overlay_actions.add_child(_button("PRESS ON THEIR STORY",func(): _press_suspect(sid)))
	overlay_actions.add_child(_button("CLOSE",func(): overlay.visible=false))
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
		overlay_body.text = "[color=#f0c46c][b]CONTRADICTION / TRUTH UNLOCKED[/b][/color]

" + str(rule.get("result",""))
		audio.evidence()
	else:
		overlay_body.text = "You do not yet have enough evidence to break this story."
	_spend_action(false)

func _collect_clue(id: String) -> void:
	if id in state.clues:
		return
	_add_unique(state.clues,id)
	var data: Dictionary = case_data.clues[id]
	overlay_title.text = "Evidence Found"
	overlay_body.text = "[b]%s[/b]

%s" % [str(data.get("name",id)),str(data.get("description",""))]
	_clear(overlay_actions)
	overlay_actions.add_child(_button("ADD TO CASEBOOK",func(): _close_and_refresh()))
	overlay.visible = true
	audio.evidence()
	_spend_action(false)

func _reset_loop() -> void:
	audio.loop_reset()
	if int(state.loop) >= 3:
		_show_deduction()
		return
	state.loop = int(state.loop)+1
	state.action = 0
	state.location = str(case_data.get("start_location",""))
	_save()
	overlay_title.text = "THE LOOP REWINDS"
	overlay_body.text = str(case_data.get("loop_reset_text","Time folds backward. You remember."))
	_clear(overlay_actions)
	overlay_actions.add_child(_button("BEGIN LOOP %d" % int(state.loop),func(): _close_and_refresh()))
	overlay.visible = true

func _build_nav() -> void:
	_clear(nav)
	for loc_id in case_data.get("locations",{}).keys():
		var lid: String = str(loc_id)
		var name := str(case_data.locations[loc_id].get("name",lid))
		var label := name.substr(0,min(6,name.length())).to_upper()
		nav.add_child(_button(label,func(): _travel(lid)))
	nav.add_child(_button("CASE",func(): _show_casebook()))

func _travel(loc: String) -> void:
	state.location = loc
	_save()
	_show_game()

func _show_casebook() -> void:
	overlay_title.text = "CASEBOOK"
	var text := "[b]Evidence[/b]
"
	for id in case_data.clues.keys():
		text += ("✓ " if id in state.clues else "? ") + str(case_data.clues[id].get("name",id)) + "
"
	text += "
[b]Contradictions[/b]
%d found

[b]Timeline[/b]
" % state.contradictions.size()
	for line in case_data.get("timeline",[]):
		text += "• " + str(line) + "
"
	overlay_body.text = text
	_clear(overlay_actions)
	overlay_actions.add_child(_button("MAKE FINAL DEDUCTION",func(): _show_deduction()))
	overlay_actions.add_child(_button("CASE SELECT",func(): _show_case_select_from_overlay()))
	overlay_actions.add_child(_button("CLOSE",func(): overlay.visible=false))
	overlay.visible = true

func _show_deduction() -> void:
	overlay_title.text = "FINAL DEDUCTION"
	overlay_body.text = str(case_data.get("deduction_prompt","Who is responsible?"))
	_clear(overlay_actions)
	for id in case_data.suspects.keys():
		var sid: String = str(id)
		overlay_actions.add_child(_button(str(case_data.suspects[id].get("name",id)),func(): _accuse(sid)))
	overlay_actions.add_child(_button("NOT YET",func(): overlay.visible=false))
	overlay.visible = true

func _accuse(id: String) -> void:
	var count: int = 0
	for clue in case_data.get("strong_clues",[]):
		if str(clue) in state.clues:
			count += 1
	var culprit := str(case_data.get("culprit",""))
	var required := str(case_data.get("required_contradiction",""))
	if id == culprit and count >= 4 and required in state.contradictions:
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
		overlay_body.text = "[center][font_size=30][color=#f0c46c]TRUE ENDING[/color][/font_size][/center]

"+str(case_data.get("truth",""))
	elif kind=="partial":
		overlay_body.text = str(case_data.get("partial","Incomplete deduction."))
	else:
		overlay_body.text = str(case_data.get("wrong","Wrong accusation."))
	_clear(overlay_actions)
	overlay_actions.add_child(_button("RESTART CASE",func(): _restart_case()))
	overlay_actions.add_child(_button("CASE SELECT",func(): _show_case_select_from_overlay()))
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
	overlay_title.text = "HOW TO PLAY"
	overlay_body.text = "Explore locations, interrogate suspects, collect evidence and expose contradictions. Every action advances the loop. Knowledge and evidence survive resets. After three loops, make your final deduction."
	_clear(overlay_actions)
	overlay_actions.add_child(_button("CLOSE",func(): overlay.visible=false))
	overlay.visible = true

func _close_and_refresh() -> void:
	overlay.visible = false
	_show_game()

func _spend_action(refresh := true) -> void:
	state.action = mini(int(state.action)+1,int(case_data.get("max_actions",8)))
	_save()
	if refresh:
		_show_game()

func _save() -> void:
	save_manager.save_state(current_case_id,state)

func _set_background(path: String) -> void:
	background.texture = _load_tex(path)

func _load_tex(path: String) -> Texture2D:
	if path != "" and ResourceLoader.exists(path):
		return load(path)
	var image := Image.create(64,64,false,Image.FORMAT_RGBA8)
	image.fill(Color(0.08,0.06,0.10))
	return ImageTexture.create_from_image(image)

func _button(text: String,action: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0,52)
	b.add_theme_font_size_override("font_size",17)
	b.pressed.connect(func():
		audio.click()
		action.call()
	)
	return b

func _add_section_title(text: String) -> void:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size",26)
	l.add_theme_color_override("font_color",Color("#f0c46c"))
	body.add_child(l)

func _add_unique(arr: Array,value) -> void:
	if value not in arr:
		arr.append(value)
	_save()

func _clear(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()
