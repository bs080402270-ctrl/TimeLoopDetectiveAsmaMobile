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

	if game.case_catalog.size() != 5:
		_fail("expected 5 cases, got %d" % game.case_catalog.size())
		return

	game._show_case_select()
	await process_frame
	if game.body.get_child_count() < 6:
		_fail("case select did not render all cases")
		return

	for case_entry in game.case_catalog:
		var case_id := str(case_entry.get("id", ""))
		if not game._load_case(case_id):
			_fail("could not load " + case_id)
			return

		game._start_new()
		await process_frame

		var start_location := str(game.case_data.get("start_location", ""))
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
		game._interrogate(str(suspect_ids[0]))
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

		game.save_manager.clear(case_id)

	print("FLOW TEST PASSED: menu, case select, start, interrogation, evidence, casebook, navigation, loop reset and deduction work across all 5 cases.")
	quit(0)
