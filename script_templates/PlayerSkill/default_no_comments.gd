# meta-name: Default (no comments)
# meta-description: Initial script containing overridable methods needed to create custom Player Skills.
# meta-default: true
# meta-space-indent: 4
@tool
extends PlayerSkill


func _init() -> void:
	input_action = &""
	activation_type = ActivationType.SINGLE_PRESS
	cooldown = 0.0
	cast_duration = -1.0
	max_casts = -1


# Overridable
func _can_cast_skill() -> bool:
	return true


# Overridable
func _on_cast_started() -> void:
	pass


# Overridable
func _on_cast_finished() -> void:
	pass
