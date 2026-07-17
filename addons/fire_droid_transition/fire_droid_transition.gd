@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
		"FDTransition",
		"Node",
		preload("res://addons/fire_droid_transition/scripts/fd_transition.gd"),
		preload("res://addons/fire_droid_transition/icons/FDTransition.svg")
	)


func _exit_tree() -> void:
	remove_custom_type("FDTransition")
