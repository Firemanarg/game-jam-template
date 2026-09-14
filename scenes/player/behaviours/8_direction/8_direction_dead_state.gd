extends Player2DState

# ------------------------------------------------------------------------------

func _setup() -> void:
	pass


func _s_enter() -> void:
	player.set_animation(&"Dead")


func _s_exit() -> void:
	pass


func _s_update(_delta: float) -> void:
	pass


func _s_physics_update(delta: float) -> void:
	if player.is_alive():
		player.update_skills_uses()
		transition.emit(self, "Idle")

	player.apply_friction(delta)
