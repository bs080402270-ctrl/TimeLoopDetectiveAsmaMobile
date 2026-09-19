extends Control

const CLUES := [
	"Broken Watch",
	"Coffee Receipt",
	"Wet Umbrella",
	"Red Thread",
	"Voicemail"
]

const SUSPECTS := ["Maya", "Omar", "Lina"]

const ART := {
	"background": "res://art/phase1/backgrounds/daily_bean_cafe.png",
	"maya": "res://art/phase1/characters/maya.png",
	"omar": "res://art/phase1/characters/omar.png",
	"lina": "res://art/phase1/characters/lina.png",
	"Broken Watch": "res://art/phase1/clues/broken_watch.png",
	"Coffee Receipt": "res://art/phase1/clues/coffee_receipt.png",
	"Wet Umbrella": "res://art/phase1/clues/wet_umbrella.png",
	"Red Thread": "res://art/phase1/clues/red_thread.png",
	"Voicemail": "res://art/phase1/clues/voicemail.png"
}

var loop_number := 1
var found_clues: Array[String] = []
var game_ended := false

var status_label: Label
var dialogue_panel: PanelContainer
var dialogue_label: Label
var notebook_panel: PanelContainer
var notebook_label: RichTextLabel
var ending_panel: PanelContainer
var ending_label: Label
var suspects_box: HBoxContainer
var clues_box: GridContainer

func _ready() -> void:
	set_process_unhandled_input(true)
	_load_progress()
	_build_ui()
	_refresh_all()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("notebook"):
		_toggle_notebook()
	elif event.is_action_pressed("reset_loop"):
		_reset_loop()
	elif event.is_action_pressed("interact"):
		_show_dialogue("Tap a suspect portrait or clue card to investigate.")

func _build_ui() -> void:
	var bg := TextureRect.new()
	bg.name = "Background"
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	if ResourceLoader.exists(ART.background):
		bg.texture = load(ART.background)
	add_child(bg)
	move_child(bg, 0)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.015, 0.012, 0.02, 0.38)
	add_child(shade)

	var root_margin := MarginContainer.new()
	root_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root_margin.add_theme_constant_override("margin_left", 32)
	root_margin.add_theme_constant_override("margin_right", 32)
	root_margin.add_theme_constant_override("margin_top", 24)
	root_margin.add_theme_constant_override("margin_bottom", 24)
	add_child(root_margin)

	var root_v := VBoxContainer.new()
	root_v.add_theme_constant_override("separation", 18)
	root_margin.add_child(root_v)

	var header := HBoxContainer.new()
	root_v.add_child(header)
	status_label = Label.new()
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_label.add_theme_font_size_override("font_size", 28)
	header.add_child(status_label)

	var notebook_button := Button.new()
	notebook_button.text = "Case Notebook"
	notebook_button.custom_minimum_size = Vector2(190, 58)
	notebook_button.pressed.connect(_toggle_notebook)
	header.add_child(notebook_button)

	var reset_button := Button.new()
	reset_button.text = "Reset Loop"
	reset_button.custom_minimum_size = Vector2(160, 58)
	reset_button.pressed.connect(_reset_loop)
	header.add_child(reset_button)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_v.add_child(spacer)

	suspects_box = HBoxContainer.new()
	suspects_box.alignment = BoxContainer.ALIGNMENT_CENTER
	suspects_box.add_theme_constant_override("separation", 24)
	root_v.add_child(suspects_box)
	for suspect in SUSPECTS:
		suspects_box.add_child(_make_suspect_card(suspect))

	var instruction := Label.new()
	instruction.text = "Investigate suspects and evidence. Knowledge survives each loop."
	instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instruction.add_theme_font_size_override("font_size", 20)
	root_v.add_child(instruction)

	clues_box = GridContainer.new()
	clues_box.columns = 5
	clues_box.add_theme_constant_override("h_separation", 12)
	clues_box.add_theme_constant_override("v_separation", 12)
	root_v.add_child(clues_box)
	for clue in CLUES:
		clues_box.add_child(_make_clue_button(clue))

	dialogue_panel = _make_overlay_panel(Vector2(0.12, 0.68), Vector2(0.88, 0.94))
	dialogue_label = Label.new()
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_label.add_theme_font_size_override("font_size", 25)
	dialogue_panel.add_child(dialogue_label)
	dialogue_panel.visible = false

	notebook_panel = _make_overlay_panel(Vector2(0.04, 0.10), Vector2(0.42, 0.72))
	notebook_label = RichTextLabel.new()
	notebook_label.bbcode_enabled = true
	notebook_label.fit_content = true
	notebook_label.add_theme_font_size_override("normal_font_size", 21)
	notebook_panel.add_child(notebook_label)
	notebook_panel.visible = false

	ending_panel = _make_overlay_panel(Vector2(0.18, 0.20), Vector2(0.82, 0.80))
	var ending_box := VBoxContainer.new()
	ending_box.alignment = BoxContainer.ALIGNMENT_CENTER
	ending_box.add_theme_constant_override("separation", 24)
	ending_panel.add_child(ending_box)
	ending_label = Label.new()
	ending_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ending_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ending_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ending_label.add_theme_font_size_override("font_size", 34)
	ending_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ending_box.add_child(ending_label)
	var restart := Button.new()
	restart.text = "Restart Case"
	restart.custom_minimum_size = Vector2(240, 64)
	restart.pressed.connect(_restart_case)
	ending_box.add_child(restart)
	ending_panel.visible = false

func _make_overlay_panel(anchor_minimum: Vector2, anchor_maximum: Vector2) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.anchor_left = anchor_minimum.x
	panel.anchor_top = anchor_minimum.y
	panel.anchor_right = anchor_maximum.x
	panel.anchor_bottom = anchor_maximum.y
	panel.offset_left = 0
	panel.offset_top = 0
	panel.offset_right = 0
	panel.offset_bottom = 0
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.022, 0.035, 0.94)
	style.border_color = Color(0.72, 0.50, 0.23, 0.8)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	style.content_margin_left = 28
	style.content_margin_right = 28
	style.content_margin_top = 22
	style.content_margin_bottom = 22
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	return panel

func _make_suspect_card(suspect: String) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(280, 260)
	button.text = suspect
	var key := suspect.to_lower()
	if ART.has(key) and ResourceLoader.exists(ART[key]):
		button.icon = load(ART[key])
		button.icon_max_width = 190
		button.expand_icon = true
	button.pressed.connect(func(): _talk_to(suspect))
	return button

func _make_clue_button(clue: String) -> Button:
	var button := Button.new()
	button.name = clue.replace(" ", "")
	button.custom_minimum_size = Vector2(185, 92)
	button.text = clue
	if ResourceLoader.exists(ART[clue]):
		button.icon = load(ART[clue])
		button.icon_max_width = 64
		button.expand_icon = true
	button.pressed.connect(func(): _collect_clue(clue))
	return button

func _talk_to(suspect: String) -> void:
	if game_ended:
		return
	var line := ""
	match suspect:
		"Maya":
			if loop_number == 1:
				line = "Maya: I arrived at 8:40. Ask Omar; he was already here."
			elif "Coffee Receipt" in found_clues:
				line = "Maya: That receipt isn't mine. Lina ordered that exact drink."
			else:
				line = "Maya: You keep asking the same questions. How do you know what happens next?"
		"Omar":
			if "Broken Watch" in found_clues:
				line = "Omar: The watch stopped at 8:47, exactly when the lights failed."
			else:
				line = "Omar: The power flickered before the crash. I heard someone near the back door."
		"Lina":
			if "Wet Umbrella" in found_clues and "Red Thread" in found_clues:
				line = "Lina: Fine. I used the back door, but I was trying to stop Maya—not hurt anyone."
			else:
				line = "Lina: I never left my table. Check the front entrance camera."
	_show_dialogue(line)
	if found_clues.size() >= 3 and loop_number >= 2:
		_check_ending()

func _collect_clue(clue: String) -> void:
	if game_ended or clue in found_clues:
		if clue in found_clues:
			_show_dialogue("You already recorded the %s." % clue)
		return
	found_clues.append(clue)
	_save_progress()
	_show_dialogue("Clue found: %s\nThe loop remembers what you learn." % clue)
	_refresh_all()

func _reset_loop() -> void:
	if game_ended:
		return
	loop_number = mini(loop_number + 1, 3)
	_show_dialogue("Loop %d begins. Your clues remain in memory." % loop_number)
	_save_progress()
	_refresh_all()
	if loop_number == 3 and found_clues.size() >= 5:
		_end_game("TRUE ENDING\n\nWith every clue connected before the third reset, you expose the staged crime and escape the café.")

func _check_ending() -> void:
	if "Broken Watch" in found_clues and "Voicemail" in found_clues and "Red Thread" in found_clues:
		_end_game("TRUE ENDING\n\nYou reconstruct the 8:47 blackout and prove the incident was staged to hide a theft. The loop finally breaks.")
	elif found_clues.size() >= 4:
		_end_game("ENDING: WRONG ACCUSATION\n\nYou force a conclusion too early. The loop ends, but the real motive remains hidden.")

func _end_game(text: String) -> void:
	game_ended = true
	ending_label.text = text
	ending_panel.visible = true
	_save_progress()

func _toggle_notebook() -> void:
	notebook_panel.visible = not notebook_panel.visible
	_refresh_notebook()

func _show_dialogue(text: String) -> void:
	dialogue_label.text = text
	dialogue_panel.visible = true

func _refresh_all() -> void:
	status_label.text = "TIME LOOP DETECTIVE    Loop %d/3    Clues %d/5" % [loop_number, found_clues.size()]
	_refresh_notebook()
	for child in clues_box.get_children():
		var label := child.text
		child.disabled = label in found_clues
		if child.disabled:
			child.text = "✓ " + label.trim_prefix("✓ ")

func _refresh_notebook() -> void:
	var out := "[font_size=30][b]CASE NOTEBOOK[/b][/font_size]\n\n"
	for clue in CLUES:
		out += ("[color=#e1b66d]✓ %s[/color]\n" % clue) if clue in found_clues else ("[color=#999999]? %s[/color]\n" % clue)
	out += "\n[b]Objective[/b]\nConnect the 8:47 blackout, the back door, and the voicemail before Loop 3 ends."
	notebook_label.text = out

func _save_progress() -> void:
	var config := ConfigFile.new()
	config.set_value("case", "loop", loop_number)
	config.set_value("case", "clues", found_clues)
	config.save("user://save.cfg")

func _load_progress() -> void:
	var config := ConfigFile.new()
	if config.load("user://save.cfg") == OK:
		loop_number = clampi(int(config.get_value("case", "loop", 1)), 1, 3)
		var stored = config.get_value("case", "clues", [])
		for clue in stored:
			if clue in CLUES and clue not in found_clues:
				found_clues.append(clue)

func _restart_case() -> void:
	if FileAccess.file_exists("user://save.cfg"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://save.cfg"))
	get_tree().reload_current_scene()
