class_name Player2DSkill
extends PlayerSkill

# ------------------------------------------------------------------------------

var player: Player2D = null

# ------------------------------------------------------------------------------

func _ready() -> void:
	player = get_parent().get_parent()

# ------------------------------------------------------------------------------

# Overridable
func _can_cast_skill() -> bool:
	return true


# Overridable
func _on_cast_started() -> void:
	pass


# Overridable
func _on_cast_finished() -> void:
	pass
