extends Player2DState

# ------------------------------------------------------------------------------

func _setup() -> void:
	pass


func _s_enter() -> void:
	player.set_animation(&"Idle")


func _s_exit() -> void:
	pass


func _s_update(_delta: float) -> void:
	pass


func _s_physics_update(delta: float) -> void:
	if not player.is_alive():
		transition.emit(self, "Dead")
		return

	var direction: Vector2 = player.get_input_direction()

	if direction:
		transition.emit(self, "Moving")

	player.apply_friction(delta)
