class_name Player2DState
extends State

# ------------------------------------------------------------------------------

@onready var player: Player2D = get_parent().get_parent()
@onready var playback: AnimationNodeStateMachinePlayback = (
		player.get_node("AnimationTree").get("parameters/playback"))

# ------------------------------------------------------------------------------

# Overridable
func _setup() -> void:
	pass


# Overridable
func _s_enter() -> void:
	pass


# Overridable
func _s_exit() -> void:
	pass


# Overridable
func _s_update(_delta: float) -> void:
	pass


# Overridable
func _s_physics_update(_delta: float) -> void:
	pass
