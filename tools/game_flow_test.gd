extends SceneTree

var game

func _initialize() -> void:
	call_deferred("_run")

func _fail(message: String) -> void:
	push_error("FLOW TEST FAILED: " + message)
	quit(1)

func _run() -> void:
	var packed: PackedScene = load("res://scenes/main.tscn")
	if packed == null:
		_fail("main scene could not be loaded")
		return

	game = packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame

	if game.case_catalog.size() != 10:
		_fail("expected 10 cases, got %d" % game.case_catalog.size())
		return

	game._show_case_select()
	await process_frame
	if game.body.get_child_count() < 11:
		_fail("case select did not render all cases")
		return

	game._show_settings()
	await process_frame
	if game.title_label.text != "SETTINGS" or game.body.get_child_count() < 5:
		_fail("settings screen did not render")
		return

	game._show_intro()
	await process_frame
	if game.title_label.text != "HOW THE LOOP WORKS" or game.body.get_child_count() < 5:
		_fail("intro screen did not render")
		return

	game._show_difficulty()
	await process_frame
	if game.title_label.text != "SELECT DIFFICULTY" or game.body.get_child_count() < 5:
		_fail("difficulty screen did not render")
		return

	game.settings_manager.set_difficulty("easy")
	game._show_case_select()
	await process_frame

	for case_entry in game.case_catalog:
		var case_id := str(case_entry.get("id", ""))
		game.settings_manager.set_difficulty("easy")
		if not game._load_case(case_id):
			_fail("could not load " + case_id)
			return

		game._start_new()
		await process_frame
		var base_actions := int(game.case_data.get("max_actions",8))
		if game._effective_max_actions() != base_actions + 2:
			_fail(case_id + " easy difficulty did not add actions")
			return
		game.settings_manager.set_difficulty("hardest")
		if game._effective_max_actions() != maxi(4,base_actions - 2):
			_fail(case_id + " hardest difficulty did not reduce actions")
			return
		game.settings_manager.set_difficulty("hard")
		if game.nav.get_child_count() < game.case_data.get("locations", {}).size() + 1:
			_fail(case_id + " navigation is missing a location or casebook button")
			return

		if not game.case_data.has("visual_scenes"):
			_fail(case_id + " has no visual scene map")
			return
		if not game.case_data.has("loop_reveals"):
			_fail(case_id + " has no loop reveal progression")
			return

		var start_location := str(game.case_data.get("start_location", ""))
extends SceneTree

var game

func _initialize() -> void:
	call_deferred("_run")

func _fail(message: String) -> void:
	push_error("FLOW TEST FAILED: " + message)
	quit(1)

func _run() -> void:
	var packed: PackedScene = load("res://scenes/main.tscn")
	if packed == null:
		_fail("main scene could not be loaded")
		return

	game = packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame

	if game.case_catalog.size() != 10:
		_fail("expected 10 cases, got %d" % game.case_catalog.size())
		return

	game._show_case_select()
	await process_frame
	if game.body.get_child_count() < 11:
		_fail("case select did not render all cases")
		return

	game._show_settings()
	await process_frame
	if game.title_label.text != "SETTINGS" or game.body.get_child_count() < 5:
		_fail("settings screen did not render")
		return

	game._show_intro()
	await process_frame
	if game.title_label.text != "HOW THE LOOP WORKS" or game.body.get_child_count() < 5:
		_fail("intro screen did not render")
		return

	game._show_difficulty()
	await process_frame
	if game.title_label.text != "SELECT DIFFICULTY" or game.body.get_child_count() < 5:
		_fail("difficulty screen did not render")
		return

	game.settings_manager.set_difficulty("easy")
	game._show_case_select()
	await process_frame

	for case_entry in game.case_catalog:
		var case_id := str(case_entry.get("id", ""))
		game.settings_manager.set_difficulty("easy")
		if not game._load_case(case_id):
			_fail("could not load " + case_id)
			return

		game._start_new()
		await process_frame
		var base_actions := int(game.case_data.get("max_actions",8))
		if game._effective_max_actions() != base_actions + 2:
			_fail(case_id + " easy difficulty did not add actions")
			return
		game.settings_manager.set_difficulty("hardest")
		if game._effective_max_actions() != maxi(4,base_actions - 2):
			_fail(case_id + " hardest difficulty did not reduce actions")
			return
		game.settings_manager.set_difficulty("hard")
		if game.nav.get_child_count() < game.case_data.get("locations", {}).size() + 1:
			_fail(case_id + " navigation is missing a location or casebook button")
			return

		if not game.case_data.has("visual_scenes"):\n\t\t\t_fail(case_id + " has no visual scene map")\n\t\t\treturn\n\t\tif not game.case_data.has("loop_reveals"):\n\t\t\t_fail(case_id + " has no loop reveal progression")\n\t\t\treturn\n\n\t\tvar start_location := str(game.case_data.get("start_location", ""))
		if str(game.state.location) != start_location:
			_fail(case_id + " did not start at configured location")
			return
		if game.body.get_child_count() == 0:
			_fail(case_id + " game body is empty")
			return

		var locations: Array = game.case_data.get("locations", {}).keys()
		if locations.size() < 2:
			_fail(case_id + " needs at least two locations")
			return

		var suspect_ids: Array = game.case_data.get("suspects", {}).keys()
		if suspect_ids.size() == 0:
			_fail(case_id + " has no suspects")
			return
		var first_suspect := str(suspect_ids[0])
		game._interrogate(first_suspect)
		await process_frame
		if not game.overlay.visible:
			_fail(case_id + " interrogation did not open dialog overlay")
			return
		game.overlay.visible = false

		var clue_ids: Array = game.case_data.get("clues", {}).keys()
		if clue_ids.size() == 0:
			_fail(case_id + " has no clues")
			return
		var first_clue := str(clue_ids[0])
		game._collect_clue(first_clue)
		await process_frame
		if first_clue not in game.state.clues:
			_fail(case_id + " evidence was not saved")
			return
		game.overlay.visible = false

		game._show_casebook()
		await process_frame
		if not game.overlay.visible:
			_fail(case_id + " casebook did not open")
			return
		game.overlay.visible = false

		var destination := str(locations[1])
		game._travel(destination)
		await process_frame
		if str(game.state.location) != destination:
			_fail(case_id + " navigation failed")
			return

		game.state.loop = 1
		game.state.action = int(game.case_data.get("max_actions", 8))
		game._reset_loop()
		await process_frame
		if int(game.state.loop) != 2:
			_fail(case_id + " loop reset failed")
			return
		game.overlay.visible = false

		game._show_deduction()
		await process_frame
		if not game.overlay.visible:
			_fail(case_id + " deduction screen did not open")
			return
		game.overlay.visible = false

		# Verify every case can reach its configured true ending.
		game.settings_manager.set_difficulty("hard")
		game.state.clues = game.case_data.get("strong_clues", []).duplicate()
		game.state.contradictions = [str(game.case_data.get("required_contradiction", ""))]
		var culprit := str(game.case_data.get("culprit", ""))
		if culprit == "":
			_fail(case_id + " has no culprit configured")
			return
		game._accuse(culprit)
		await process_frame
		if game.overlay_title.text == "FINAL CONFRONTATION":
			game._resolve_confrontation("chase")
			await process_frame
		if str(game.state.ending) != "true":
			_fail(case_id + " could not reach the true ending")
			return
		game.overlay.visible = false

		game.save_manager.clear(case_id)

	print("FLOW TEST PASSED: menu, onboarding, all difficulty levels, settings, case select, navigation, evidence, interrogation, loop reset, deduction and true endings work for all ten Season 1 cases.")
	quit(0)
