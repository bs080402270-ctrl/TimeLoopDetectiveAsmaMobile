class_name DynamicImageClient
extends Node

signal image_ready(scene_id: String, texture: Texture2D)
signal image_failed(scene_id: String, reason: String)

const CACHE_DIR := "user://dynamic_images"

var endpoint := ""
var game_token := ""
var enabled := false
var request_timeout_seconds := 50.0
var _request: HTTPRequest
var _active_scene_id := ""
var _pending_prompt := ""

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(CACHE_DIR))
	_request = HTTPRequest.new()
	_request.timeout = request_timeout_seconds
	add_child(_request)
	_request.request_completed.connect(_on_request_completed)

func configure(api_endpoint: String, token: String = "") -> void:
	endpoint = api_endpoint.strip_edges()
	game_token = token
	enabled = endpoint.begins_with("https://") or endpoint.begins_with("http://")

func request_scene(scene_id: String, prompt: String) -> void:
	if not enabled or prompt.strip_edges() == "":
		image_failed.emit(scene_id,"image_service_unavailable")
		return

	var cached := _load_cached(scene_id,prompt)
	if cached != null:
		image_ready.emit(scene_id,cached)
		return

	if _request.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		_request.cancel_request()

	_active_scene_id = scene_id
	_pending_prompt = prompt

	var headers := PackedStringArray(["Content-Type: application/json"])
	if game_token != "":
		headers.append("X-Game-Token: " + game_token)

	var body := JSON.stringify({
		"scene_id": scene_id,
		"prompt": prompt
	})

	var err := _request.request(endpoint,headers,HTTPClient.METHOD_POST,body)
	if err != OK:
		image_failed.emit(scene_id,"request_start_failed")

func _on_request_completed(result: int,response_code: int,_headers: PackedStringArray,body: PackedByteArray) -> void:
	var scene_id := _active_scene_id
	if result != HTTPRequest.RESULT_SUCCESS or response_code < 200 or response_code >= 300:
		image_failed.emit(scene_id,"http_%d" % response_code)
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not bool(parsed.get("ok",false)):
		image_failed.emit(scene_id,"invalid_response")
		return

	var encoded := str(parsed.get("image_base64",""))
	if encoded == "":
		image_failed.emit(scene_id,"missing_image")
		return

	var bytes := Marshalls.base64_to_raw(encoded)
	var image := Image.new()
	var err := image.load_jpg_from_buffer(bytes)
	if err != OK:
		err = image.load_png_from_buffer(bytes)
	if err != OK:
		image_failed.emit(scene_id,"decode_failed")
		return

	var texture := ImageTexture.create_from_image(image)
	_save_cached(scene_id,_pending_prompt,bytes)
	image_ready.emit(scene_id,texture)

func _cache_path(scene_id: String,prompt: String) -> String:
	var key := (scene_id + "|" + prompt).sha256_text()
	return CACHE_DIR + "/" + key + ".jpg"

func _load_cached(scene_id: String,prompt: String) -> Texture2D:
	var path := _cache_path(scene_id,prompt)
	if not FileAccess.file_exists(path):
		return null
	var bytes := FileAccess.get_file_as_bytes(path)
	var image := Image.new()
	if image.load_jpg_from_buffer(bytes) != OK:
		return null
	return ImageTexture.create_from_image(image)

func _save_cached(scene_id: String,prompt: String,bytes: PackedByteArray) -> void:
	var file := FileAccess.open(_cache_path(scene_id,prompt),FileAccess.WRITE)
	if file != null:
		file.store_buffer(bytes)
