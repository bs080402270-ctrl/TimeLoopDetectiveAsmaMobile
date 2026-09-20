class_name AudioManager
extends Node

# Android-safe UI audio stub.
# Procedural AudioStreamGenerator playback is disabled because some older
# Android audio backends can terminate the process during initialization.
# These methods intentionally remain so gameplay code can call them safely.

func click() -> void:
	pass

func evidence() -> void:
	pass

func loop_reset() -> void:
	pass

func deduction() -> void:
	pass
