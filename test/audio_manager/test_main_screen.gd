extends Node2D

# ------------------------------------------------------------------------------

func _ready() -> void:
	pass


func _on_cat_scene_pressed() -> void:
	AUMA.play_loop(&"bgm", &"music_1")


func _on_cat_scene_2_pressed() -> void:
	AUMA.play_loop(&"bgm", &"music_2")
