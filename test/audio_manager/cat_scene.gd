extends AnimatedSprite2D


signal pressed


@warning_ignore("unused_parameter")
func _on_mouse_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and not event.is_echo():
			AUMA.play_one_shot(&"sfx", &"meow")
			pressed.emit()
