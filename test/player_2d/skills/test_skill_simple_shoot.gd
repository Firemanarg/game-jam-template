@tool
extends Player2DSkill

# ------------------------------------------------------------------------------

@export var shoot_output_position: Vector2 = Vector2(0, 0)

# ------------------------------------------------------------------------------

func _init() -> void:
	input_action = &"attack"
	activation_type = ActivationType.ON_RELEASE
	cooldown = 0.0
	cast_duration = 0.2
	max_casts = -1

# ------------------------------------------------------------------------------


# Overridable
func _on_cast_started() -> void:
	const BULLET_SCENE: PackedScene = preload("uid://b1iqqov8psbsk")

	var bullet: CharacterBody2D = BULLET_SCENE.instantiate()
	player.add_child(bullet)
	bullet.global_position = player.global_position + shoot_output_position
	bullet.direction = Vector2.RIGHT
	print("Shoot!")


# Overridable
func _on_cast_finished() -> void:
	print("\tFinished!")
