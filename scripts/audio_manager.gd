class_name AudioManager
extends Node

var player: AudioStreamPlayer
var generator: AudioStreamGenerator
var playback: AudioStreamGeneratorPlayback

func _ready() -> void:
	generator = AudioStreamGenerator.new()
	generator.mix_rate = 22050.0
	generator.buffer_length = 0.5
	player = AudioStreamPlayer.new()
	player.stream = generator
	player.volume_db = -12.0
	add_child(player)
	player.play()
	playback = player.get_stream_playback()

func click() -> void:
	_tone(520.0, 0.04, 0.12)

func evidence() -> void:
	_tone(740.0, 0.07, 0.16)
	_tone(980.0, 0.06, 0.12)

func loop_reset() -> void:
	_tone(330.0, 0.10, 0.12)
	_tone(220.0, 0.12, 0.10)

func deduction() -> void:
	_tone(660.0, 0.05, 0.13)
	_tone(880.0, 0.05, 0.13)
	_tone(1100.0, 0.07, 0.12)

func _tone(freq: float, duration: float, amp: float) -> void:
	if playback == null:
		return
	var frames := int(generator.mix_rate * duration)
	for i in frames:
		var t := float(i) / generator.mix_rate
		var env := 1.0 - float(i) / max(1.0, float(frames))
		var s := sin(TAU * freq * t) * amp * env
		playback.push_frame(Vector2(s, s))
