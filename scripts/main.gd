extends Control

const CASE_PATH := "res://data/case_01.json"
const MAX_ACTIONS := 8

var case_data: Dictionary
var state: Dictionary
var save_manager := SaveManager.new()
var audio: AudioManager

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
	_load_case()
	state = save_manager.load_state()
	audio = AudioManager.new()
	add_child(audio)
	_build_shell()
	if state.started:
		_show_game()
	else:
		_show_menu()

func _load_case() -> void:
	var file := FileAccess.open(CASE_PATH, FileAccess.READ)
	if file == null:
		push_error("Case data missing: " + CASE_PATH)
		case_data = {}
		return
	var parsed = JSON.parse_string(file.get_as_text())
	case_data = parsed if typeof(parsed) == TYPE_DICTIONARY else {}

func _build_shell() -> void:
	background = TextureRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(background)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.015, 0.012, 0.022, 0.42)
	add_child(shade)

	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 26)
	margin.add_theme_constant_override("margin_right", 26)
	margin.add_theme_constant_override("margin_top", 28)
	margin.add_theme_constant_override("margin_bottom", 26)
	add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 14)
	margin.add_child(root)

	var header := VBoxContainer.new()
	root.add_child(header)

	title_label = Label.new()
	title_label.add_theme_font_size_override("font_size", 34)
	title_label.add_theme_color_override("font_color", Color("#f0c46c"))
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_child(title_label)

	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 18)
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	header.add_child(status_label)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)

	body = VBoxContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 14)
	scroll.add_child(body)

	nav = HBoxContainer.new()
	nav.alignment = BoxContainer.ALIGNMENT_CENTER
	nav.add_theme_constant_override("separation", 8)
	root.add_child(nav)

	overlay = PanelContainer.new()
	overlay.anchor_left = 0.05
	overlay.anchor_top = 0.13
	overlay.anchor_right = 0.95
	overlay.anchor_bottom = 0.88
	var box := StyleBoxFlat.new()
	box.bg_color = Color(0.035,0.03,0.05,0.98)
	box.border_color = Color("#c79a4a")
	box.set_border_width_all(2)
	box.set_corner_radius_all(20)
	box.set_content_margin_all(22)
	overlay.add_theme_stylebox_override("panel", box)
	add_child(overlay)

	var ov := VBoxContainer.new()
	ov.add_theme_constant_override("separation", 12)
	overlay.add_child(ov)
	overlay_title = Label.new()
	overlay_title.add_theme_font_size_override("font_size", 30)
	overlay_title.add_theme_color_override("font_color", Color("#f0c46c"))
	ov.add_child(overlay_title)
	overlay_body = RichTextLabel.new()
	overlay_body.bbcode_enabled = true
	overlay_body.fit_content = false
	overlay_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	overlay_body.add_theme_font_size_override("normal_font_size", 20)
	ov.add_child(overlay_body)
	overlay_actions = VBoxContainer.new()
	overlay_actions.add_theme_constant_override("separation", 8)
	ov.add_child(overlay_actions)
	overlay.visible = false

func _show_menu() -> void:
	_clear(body)
	_clear(nav)
	title_label.text = "TIME LOOP DETECTIVE"
	status_label.text = "A cinematic mystery where knowledge survives the reset."
	_set_background("res://art/backgrounds/cafe.svg")

	var hero := TextureRect.new()
	hero.texture = _load_tex("res://art/ui/keyart.svg")
	hero.custom_minimum_size = Vector2(0, 430)
	hero.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hero.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	body.add_child(hero)

	var desc := Label.new()
	desc.text = str(case_data.get("subtitle", ""))
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc.add_theme_font_size_override("font_size", 22)
	body.add_child(desc)

	var start := _button("NEW CASE", func(): _start_new())
	start.custom_minimum_size.y = 68
	body.add_child(start)
	if FileAccess.file_exists(SaveManager.SAVE_PATH):
		var cont := _button("CONTINUE", func(): _show_game())
		cont.custom_minimum_size.y = 60
		body.add_child(cont)

	var how := _button("HOW TO PLAY", func(): _show_help())
	body.add_child(how)

func _start_new() -> void:
	save_manager.clear()
	state = save_manager.load_state()
	state.started = true
	state.loop = 1
	state.action = 0
	state.location = "cafe"
	state.clues = []
	state.contradictions = []
	state.talked = []
	state.ending = ""
	_save()
	audio.click()
	_show_game()

func _show_game() -> void:
	overlay.visible = false
	_clear(body)
	_build_nav()
	var loc_key := str(state.location)
	var loc: Dictionary = case_data.locations.get(loc_key, {})
	title_label.text = str(loc.get("name", "Investigation"))
	status_label.text = "Loop %d/3  •  Actions %d/%d  •  Evidence %d/8" % [int(state.loop), int(state.action), MAX_ACTIONS, state.clues.size()]
	_set_background(str(loc.get("art","")))
	_show_location(loc_key)

func _show_location(loc_key: String) -> void:
	var intro := Label.new()
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.add_theme_font_size_override("font_size", 20)
	intro.text = _location_text(loc_key)
	body.add_child(intro)

	var people_here := _people_for_location(loc_key)
	if people_here.size() > 0:
		_add_section_title("People")
		var grid := GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 10)
		grid.add_theme_constant_override("v_separation", 10)
		body.add_child(grid)
		for person in people_here:
			grid.add_child(_person_card(person))

	_add_section_title("Search")
	var clues_here: Array = []
	for clue_id in case_data.clues.keys():
		if str(case_data.clues[clue_id].location) == loc_key:
			clues_here.append(str(clue_id))
	for clue_id in clues_here:
		body.add_child(_clue_card(clue_id))

	if int(state.action) >= MAX_ACTIONS:
		var warning := Label.new()
		warning.text = "The clock strikes 8:52. The loop is collapsing..."
		warning.add_theme_color_override("font_color", Color("#ffb467"))
		warning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(warning)
		body.add_child(_button("LET THE LOOP RESET", func(): _reset_loop()))

func _location_text(loc: String) -> String:
	match loc:
		"cafe":
			return "Warm light, cooling coffee, and too many people pretending not to watch Daniel Rowan. Every loop begins here."
		"office":
			return "The manager's office smells of paper, graphite and stale espresso. The breaker cabinet hums behind a framed staff photo."
		"alley":
			return "Rain turns the rear alley into a mirror. The back door latch catches fibers, fingerprints and secrets."
		"riverside":
			return "The riverside is quieter than the cafe. Omar sometimes comes here to review his recordings away from Daniel."
		_:
			return "Search carefully. What seems ordinary in one loop may matter in the next."

func _people_for_location(loc: String) -> Array:
	match loc:
		"cafe": return ["maya","theo"]
		"alley": return ["lina"]
		"riverside": return ["omar"]
		_: return []

func _person_card(id: String) -> Control:
	var data: Dictionary = case_data.suspects[id]
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08,0.065,0.10,0.94)
	style.set_corner_radius_all(14)
	style.set_content_margin_all(12)
	panel.add_theme_stylebox_override("panel", style)

	var vb := VBoxContainer.new()
	panel.add_child(vb)
	var portrait := TextureRect.new()
	portrait.texture = _load_tex(str(data.art))
	portrait.custom_minimum_size = Vector2(0, 210)
	portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	vb.add_child(portrait)
	var n := Label.new()
	n.text = str(data.name)
	n.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	n.add_theme_font_size_override("font_size", 23)
	vb.add_child(n)
	var role := Label.new()
	role.text = str(data.role)
	role.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	role.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(role)
	vb.add_child(_button("INTERROGATE", func(): _interrogate(id)))
	return panel

func _clue_card(id: String) -> Control:
	var data: Dictionary = case_data.clues[id]
	var found := id in state.clues
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	var icon := TextureRect.new()
	icon.texture = _load_tex(str(data.art))
	icon.custom_minimum_size = Vector2(86,86)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon)
	var vb := VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(vb)
	var label := Label.new()
	label.text = ("✓ " if found else "") + str(data.name)
	label.add_theme_font_size_override("font_size", 21)
	vb.add_child(label)
	var desc := Label.new()
	desc.text = str(data.description) if found else "Inspect this area for evidence."
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vb.add_child(desc)
	var b := _button("RECORDED" if found else "INSPECT", func(): _collect_clue(id))
	b.disabled = found
	row.add_child(b)
	return row

func _interrogate(id: String) -> void:
	audio.click()
	var data: Dictionary = case_data.suspects[id]
	overlay_title.text = str(data.name)
	overlay_body.text = _dialogue_for(id)
	_clear(overlay_actions)
	overlay_actions.add_child(_button("PRESS ON THEIR STORY", func(): _press_suspect(id)))
	overlay_actions.add_child(_button("CLOSE", func(): overlay.visible = false))
	overlay.visible = true
	_mark_talked(id)

func _dialogue_for(id: String) -> String:
	var loop := int(state.loop)
	match id:
		"maya":
			if loop == 1:
				return "[b]Maya:[/b] Daniel argued with everyone. I stayed behind the counter until the blackout."
			return "[b]Maya:[/b] You're asking about the order again? The ticket changed after Daniel complained about his usual drink."
		"omar":
			if "voicemail" in state.clues:
				return "[b]Omar:[/b] Fine. I recorded Daniel. He threatened Lina with an audit. I hid it because I didn't want police taking my source material."
			return "[b]Omar:[/b] I left before the blackout. I was by the river, working."
		"lina":
			if loop >= 2 and "thread" in state.clues:
				return "[b]Lina:[/b] The thread proves I used the back door, not that I harmed Daniel. I needed air."
			return "[b]Lina:[/b] Daniel and I had business disagreements. I never went near the office."
		"theo":
			if "key" in state.clues:
				return "[b]Theo:[/b] Yes, I borrowed the office key. I returned it before 8:40. Maya saw me."
			return "[b]Theo:[/b] I was cleaning the grinder. I heard the breaker snap, then everything went black."
	return "They watch you carefully."

func _press_suspect(id: String) -> void:
	var result := ""
	var contradiction := ""
	match id:
		"lina":
			if "thread" in state.clues and "ledger" in state.clues:
				contradiction = "lina_access"
				result = "[color=#f0c46c][b]CONTRADICTION FOUND[/b][/color]\nThe violet thread places Lina at the rear corridor, while the ledger gives her a reason to access the office. Her claim that she never went near it cannot stand."
			else:
				result = "You need stronger evidence connecting Lina to the rear corridor and the office."
		"omar":
			if "voicemail" in state.clues:
				contradiction = "omar_recording"
				result = "[color=#f0c46c][b]TRUTH UNLOCKED[/b][/color]\nThe recording proves Omar concealed evidence, but it also places his voice away from the murder scene."
			else:
				result = "Something about Omar's timeline is missing. A recording could settle it."
		"maya":
			if "receipt" in state.clues:
				contradiction = "maya_receipt"
				result = "[color=#f0c46c][b]DETAIL UNLOCKED[/b][/color]\nMaya admits the drink order was changed after Daniel's complaint. Someone used that opportunity."
			else:
				result = "The order history would tell you whether Maya's story is complete."
		"theo":
			if "key" in state.clues:
				contradiction = "theo_key"
				result = "[color=#f0c46c][b]ALIBI STRENGTHENED[/b][/color]\nThe key was returned before the critical window. Theo had access earlier, but not when the breaker was bridged."
			else:
				result = "Find out exactly when Theo returned the office key."
	if contradiction != "":
		_add_unique(state.contradictions, contradiction)
	_save()
	overlay_body.text = result
	_spend_action()
	audio.evidence()

func _collect_clue(id: String) -> void:
	if id in state.clues:
		return
	_add_unique(state.clues, id)
	_save()
	audio.evidence()
	var data: Dictionary = case_data.clues[id]
	overlay_title.text = "Evidence Found"
	overlay_body.text = "[b]%s[/b]\n\n%s" % [str(data.name), str(data.description)]
	_clear(overlay_actions)
	overlay_actions.add_child(_button("ADD TO NOTEBOOK", func(): _close_and_refresh()))
	overlay.visible = true
	_spend_action(false)

func _close_and_refresh() -> void:
	overlay.visible = false
	_show_game()

func _mark_talked(id: String) -> void:
	_add_unique(state.talked, id)
	_save()
	_spend_action(false)

func _spend_action(refresh := true) -> void:
	state.action = mini(int(state.action) + 1, MAX_ACTIONS)
	_save()
	if refresh:
		_show_game()

func _reset_loop() -> void:
	audio.loop_reset()
	if int(state.loop) >= 3:
		_show_deduction()
		return
	state.loop = int(state.loop) + 1
	state.action = 0
	state.location = "cafe"
	_save()
	overlay_title.text = "THE LOOP REWINDS"
	overlay_body.text = "[center][font_size=34]8:52 → 8:15[/font_size][/center]\n\nThe room snaps backward. Cups refill. Rain climbs from the pavement. Everyone forgets.\n\n[b]You do not.[/b]"
	_clear(overlay_actions)
	overlay_actions.add_child(_button("BEGIN LOOP %d" % int(state.loop), func(): _close_and_refresh()))
	overlay.visible = true

func _build_nav() -> void:
	_clear(nav)
	for item in [
		["CAFE","cafe"],
		["OFFICE","office"],
		["ALLEY","alley"],
		["RIVER","riverside"]
	]:
		nav.add_child(_button(item[0], func(): _travel(item[1])))
	nav.add_child(_button("CASE", func(): _show_casebook()))

func _travel(loc: String) -> void:
	audio.click()
	state.location = loc
	_save()
	_show_game()

func _show_casebook() -> void:
	overlay_title.text = "CASEBOOK"
	var text := "[b]Evidence[/b]\n"
	for id in case_data.clues.keys():
		var c: Dictionary = case_data.clues[id]
		text += ("✓ " if id in state.clues else "? ") + str(c.name) + "\n"
	text += "\n[b]Contradictions[/b]\n%d found\n\n[b]Timeline[/b]\n" % state.contradictions.size()
	for line in case_data.timeline:
		text += "• " + str(line) + "\n"
	overlay_body.text = text
	_clear(overlay_actions)
	overlay_actions.add_child(_button("MAKE FINAL DEDUCTION", func(): _show_deduction()))
	overlay_actions.add_child(_button("CLOSE", func(): overlay.visible = false))
	overlay.visible = true

func _show_deduction() -> void:
	audio.deduction()
	overlay_title.text = "FINAL DEDUCTION"
	overlay_body.text = "Who engineered Daniel Rowan's death and the 8:47 blackout?\n\nChoose carefully. Your evidence determines whether the loop breaks."
	_clear(overlay_actions)
	for id in ["maya","omar","lina","theo"]:
		var data: Dictionary = case_data.suspects[id]
		overlay_actions.add_child(_button(str(data.name), func(): _accuse(id)))
	overlay_actions.add_child(_button("NOT YET", func(): overlay.visible = false))
	overlay.visible = true

func _accuse(id: String) -> void:
	var strong := ["receipt","thread","voicemail","ledger","breaker"]
	var count := 0
	for clue in strong:
		if clue in state.clues:
			count += 1
	if id == "lina" and count >= 4 and "lina_access" in state.contradictions:
		_finish("true")
	elif id == "lina" and count >= 2:
		_finish("partial")
	else:
		_finish("wrong")

func _finish(kind: String) -> void:
	state.ending = kind
	_save()
	overlay_title.text = "CASE CLOSED" if kind == "true" else "THE LOOP RESISTS"
	if kind == "true":
		overlay_body.text = "[center][font_size=32][color=#f0c46c]TRUE ENDING[/color][/font_size][/center]\n\n%s\n\nThe clock reaches 8:53 for the first time. Rain falls forward. The loop is broken." % str(case_data.truth)
	elif kind == "partial":
		overlay_body.text = "[b]Incomplete deduction.[/b]\n\nYou identify Lina, but without enough evidence the case collapses under scrutiny. The loop breaks badly, leaving the full truth uncertain."
	else:
		overlay_body.text = "[b]Wrong accusation.[/b]\n\nThe evidence does not support your conclusion. At 8:52 the cafe tears itself backward again."
	_clear(overlay_actions)
	overlay_actions.add_child(_button("RESTART CASE", func(): _restart_case()))
	overlay_actions.add_child(_button("MAIN MENU", func(): _return_menu()))
	overlay.visible = true

func _restart_case() -> void:
	save_manager.clear()
	state = save_manager.load_state()
	overlay.visible = false
	_start_new()

func _return_menu() -> void:
	overlay.visible = false
	_show_menu()

func _show_help() -> void:
	overlay_title.text = "HOW TO PLAY"
	overlay_body.text = "• Move between locations with the bottom navigation.\n• Interrogate suspects and inspect evidence.\n• Each interaction advances the loop clock.\n• Evidence and knowledge survive resets.\n• Press suspects using facts to expose contradictions.\n• Use the Casebook to review evidence and timeline.\n• Make a final accusation when your theory is ready."
	_clear(overlay_actions)
	overlay_actions.add_child(_button("CLOSE", func(): overlay.visible = false))
	overlay.visible = true

func _save() -> void:
	save_manager.save_state(state)

func _set_background(path: String) -> void:
	background.texture = _load_tex(path)

func _load_tex(path: String) -> Texture2D:
	if path != "" and ResourceLoader.exists(path):
		return load(path)
	var image := Image.create(64,64,false,Image.FORMAT_RGBA8)
	image.fill(Color(0.08,0.06,0.10))
	return ImageTexture.create_from_image(image)

func _button(text: String, action: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0,52)
	b.add_theme_font_size_override("font_size", 18)
	b.pressed.connect(func():
		audio.click()
		action.call()
	)
	return b

func _add_section_title(text: String) -> void:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", 26)
	l.add_theme_color_override("font_color", Color("#f0c46c"))
	body.add_child(l)

func _add_unique(arr: Array, value) -> void:
	if value not in arr:
		arr.append(value)

func _clear(node: Node) -> void:
	for child in node.get_children():
		child.queue_free()
