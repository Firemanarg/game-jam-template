# meta-name: Default - Basic Properties
# meta-description: Template containing basic properties to create new State for StateMachine class
# meta-default: true
# meta-space-indent: 4
extends State


@onready var holder = get_parent().get_parent()
@onready var playback: AnimationNodeStateMachinePlayback = (
	holder.get_node("AnimationTree").get("parameters/playback")
)

# Relevant snippets
# playback.travel("NextAnimationState")
# transition.emit(self, "NextState")


func _setup() -> void:
	pass


func _s_enter() -> void:
	pass


func _s_exit() -> void:
	pass


func _s_update(_delta: float) -> void:
	pass


func _s_physics_update(_delta: float) -> void:
	pass
