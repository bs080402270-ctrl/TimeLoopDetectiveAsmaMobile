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
var suspects_grid: GridContainer
var clues_grid: GridContainer
var root_margin: MarginContainer
var content_box: VBoxContainer

func _ready() -> void:
	set_process_unhandled_input(true)
	_load_progress()
	_build_ui()
	get_viewport().size_changed.connect(_apply_responsive_layout)
	_refresh_all()
	call_deferred("_apply_responsive_layout")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("notebook"):
		_toggle_notebook()
	elif event.is_action_pressed("reset_loop"):
		_reset_loop()
	elif event.is_action_pressed("interact"):
		_show_dialogue("Tap a suspect portrait or clue card to investigate.")

func _build_ui() -> void:
	var background := TextureRect.new()
	background.name = "Background"
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	if ResourceLoader.exists(ART.background):
		background.texture = load(ART.background)
	else:
		background.texture = _make_placeholder_texture(Color(0.10, 0.075, 0.12))
	add_child(background)

	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.01, 0.01, 0.02, 0.34)
	add_child(shade)

	root_margin = MarginContainer.new()
	root_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(root_margin)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_margin.add_child(scroll)

	content_box = VBoxContainer.new()
	content_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.add_theme_constant_override("separation", 18)
	scroll.add_child(content_box)

	var title := Label.new()
	title.text = "TIME LOOP DETECTIVE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.95, 0.78, 0.44))
	content_box.add_child(title)

	var header := HBoxContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_theme_constant_override("separation", 10)
	content_box.add_child(header)

	status_label = Label.new()
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header.add_child(status_label)

	var notebook_button := Button.new()
	notebook_button.text = "Notebook"
	notebook_button.custom_minimum_size = Vector2(140, 56)
	notebook_button.pressed.connect(_toggle_notebook)
	header.add_child(notebook_button)

	var reset_button := Button.new()
	reset_button.text = "Reset Loop"
	reset_button.custom_minimum_size = Vector2(140, 56)
	reset_button.pressed.connect(_reset_loop)
	header.add_child(reset_button)

	var suspect_title := Label.new()
	suspect_title.text = "Suspects"
	suspect_title.add_theme_font_size_override("font_size", 24)
	suspect_title.add_theme_color_override("font_color", Color(0.95, 0.86, 0.70))
	content_box.add_child(suspect_title)

	suspects_grid = GridContainer.new()
	suspects_grid.columns = 1
	suspects_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	suspects_grid.add_theme_constant_override("h_separation", 14)
	suspects_grid.add_theme_constant_override("v_separation", 14)
	content_box.add_child(suspects_grid)

	for suspect in SUSPECTS:
		suspects_grid.add_child(_make_suspect_card(suspect))

	var instruction := Label.new()
	instruction.text = "Investigate suspects and evidence. Knowledge survives each loop."
	instruction.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	instruction.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content_box.add_child(instruction)

	var clue_title := Label.new()
	clue_title.text = "Evidence"
	clue_title.add_theme_font_size_override("font_size", 24)
	clue_title.add_theme_color_override("font_color", Color(0.95, 0.86, 0.70))
	content_box.add_child(clue_title)

	clues_grid = GridContainer.new()
	clues_grid.columns = 2
	clues_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	clues_grid.add_theme_constant_override("h_separation", 12)
	clues_grid.add_theme_constant_override("v_separation", 12)
	content_box.add_child(clues_grid)

	for clue in CLUES:
		clues_grid.add_child(_make_clue_button(clue))

	dialogue_panel = _make_overlay_panel(Vector2(0.05, 0.70), Vector2(0.95, 0.96))
	dialogue_label = Label.new()
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	dialogue_label.add_theme_font_size_override("font_size", 22)
	dialogue_panel.add_child(dialogue_label)
	dialogue_panel.visible = false

	notebook_panel = _make_overlay_panel(Vector2(0.04, 0.08), Vector2(0.96, 0.74))
	notebook_label = RichTextLabel.new()
	notebook_label.bbcode_enabled = true
	notebook_label.fit_content = true
	notebook_label.add_theme_font_size_override("normal_font_size", 20)
	notebook_panel.add_child(notebook_label)
	notebook_panel.visible = false

	ending_panel = _make_overlay_panel(Vector2(0.08, 0.20), Vector2(0.92, 0.80))
	var ending_box := VBoxContainer.new()
	ending_box.alignment = BoxContainer.ALIGNMENT_CENTER
	ending_box.add_theme_constant_override("separation", 20)
	ending_panel.add_child(ending_box)

	ending_label = Label.new()
	ending_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ending_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ending_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ending_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	ending_box.add_child(ending_label)

	var restart := Button.new()
	restart.text = "Restart Case"
	restart.custom_minimum_size = Vector2(220, 58)
	restart.pressed.connect(_restart_case)
	ending_box.add_child(restart)
	ending_panel.visible = false

func _apply_responsive_layout() -> void:
	var size := get_viewport_rect().size
	var portrait := size.y >= size.x

	var side_margin := 22 if portrait else 34
	root_margin.add_theme_constant_override("margin_left", side_margin)
	root_margin.add_theme_constant_override("margin_right", side_margin)
	root_margin.add_theme_constant_override("margin_top", 22)
	root_margin.add_theme_constant_override("margin_bottom", 22)

	if portrait:
		suspects_grid.columns = 1
		clues_grid.columns = 2
		status_label.add_theme_font_size_override("font_size", 20)
		dialogue_label.add_theme_font_size_override("font_size", 20)
		ending_label.add_theme_font_size_override("font_size", 26)

		for child in suspects_grid.get_children():
			if child is Button:
				child.custom_minimum_size = Vector2(0, 220)
				child.icon_max_width = 220

		for child in clues_grid.get_children():
			if child is Button:
				child.custom_minimum_size = Vector2(0, 96)
				child.icon_max_width = 72

		dialogue_panel.anchor_left = 0.04
		dialogue_panel.anchor_right = 0.96
		dialogue_panel.anchor_top = 0.69
		dialogue_panel.anchor_bottom = 0.96

		notebook_panel.anchor_left = 0.04
		notebook_panel.anchor_right = 0.96
		notebook_panel.anchor_top = 0.08
		notebook_panel.anchor_bottom = 0.74
	else:
		suspects_grid.columns = 3
		clues_grid.columns = 5
		status_label.add_theme_font_size_override("font_size", 26)
		dialogue_label.add_theme_font_size_override("font_size", 23)
		ending_label.add_theme_font_size_override("font_size", 30)

		for child in suspects_grid.get_children():
			if child is Button:
				child.custom_minimum_size = Vector2(240, 240)
				child.icon_max_width = 190

		for child in clues_grid.get_children():
			if child is Button:
				child.custom_minimum_size = Vector2(170, 92)
				child.icon_max_width = 64

		dialogue_panel.anchor_left = 0.12
		dialogue_panel.anchor_right = 0.88
		dialogue_panel.anchor_top = 0.68
		dialogue_panel.anchor_bottom = 0.94

		notebook_panel.anchor_left = 0.06
		notebook_panel.anchor_right = 0.42
		notebook_panel.anchor_top = 0.10
		notebook_panel.anchor_bottom = 0.72

func _make_overlay_panel(anchor_minimum: Vector2, anchor_maximum: Vector2) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.anchor_left = anchor_minimum.x
	panel.anchor_top = anchor_minimum.y
	panel.anchor_right = anchor_maximum.x
	panel.anchor_bottom = anchor_maximum.y

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.022, 0.035, 0.96)
	style.border_color = Color(0.78, 0.56, 0.24, 0.90)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 20
	style.content_margin_bottom = 20

	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	return panel

func _make_suspect_card(suspect: String) -> Button:
	var button := Button.new()
	button.text = suspect
	button.custom_minimum_size = Vector2(0, 220)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.expand_icon = true
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.icon_max_width = 220

	var key := suspect.to_lower()
	if ART.has(key) and ResourceLoader.exists(ART[key]):
		button.icon = load(ART[key])
	else:
		button.icon = _make_placeholder_texture(_suspect_color(suspect))

	button.pressed.connect(func(): _talk_to(suspect))
	return button

func _make_clue_button(clue: String) -> Button:
	var button := Button.new()
	button.name = clue.replace(" ", "")
	button.set_meta("clue_name", clue)
	button.custom_minimum_size = Vector2(0, 96)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.text = clue
	button.expand_icon = true
	button.icon_max_width = 72

	if ResourceLoader.exists(ART[clue]):
		button.icon = load(ART[clue])
	else:
		button.icon = _make_placeholder_texture(Color(0.32, 0.26, 0.14))

	button.pressed.connect(func(): _collect_clue(clue))
	return button

func _make_placeholder_texture(color: Color) -> Texture2D:
	var image := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)

func _suspect_color(suspect: String) -> Color:
	match suspect:
		"Maya":
			return Color(0.50, 0.20, 0.24)
		"Omar":
			return Color(0.18, 0.38, 0.24)
		"Lina":
			return Color(0.36, 0.22, 0.46)
		_:
			return Color(0.25, 0.25, 0.25)

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
	if game_ended:
		return

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
	status_label.text = "Loop %d/3   Clues %d/5" % [loop_number, found_clues.size()]
	_refresh_notebook()

	for child in clues_grid.get_children():
		var clue_name: String = str(child.get_meta("clue_name", child.text))
		child.disabled = clue_name in found_clues
		child.text = ("✓ " + clue_name) if child.disabled else clue_name

func _refresh_notebook() -> void:
	var out := "[font_size=28][b]CASE NOTEBOOK[/b][/font_size]\n\n"
	for clue in CLUES:
		if clue in found_clues:
			out += "[color=#e1b66d]✓ %s[/color]\n" % clue
		else:
			out += "[color=#999999]? %s[/color]\n" % clue
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
