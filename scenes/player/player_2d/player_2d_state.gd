class_name Player2DState
extends State

# ------------------------------------------------------------------------------

@onready var player: Player2D = get_parent().get_parent()
@onready var playback: AnimationNodeStateMachinePlayback = (
		player.get_node("AnimationTree").get("parameters/playback"))

# ------------------------------------------------------------------------------
