extends Node
class_name StateMachine


@export var initial_state: State = null
@export var enable_process: bool = true:
	set(value):
		enable_process = value
		set_process(enable_process)
@export var enable_physics_process: bool = true:
	set(value):
		enable_physics_process = value
		set_physics_process(enable_physics_process)

var current_state: State
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(_on_child_transition)
			child.setup()
	if initial_state:
		initial_state.s_enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.s_update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.s_physics_update(delta)


func travel_to(state_name: String) -> void:
	_on_child_transition(current_state, state_name)


func _on_child_transition(state: State, new_state_name: String) -> void:
	if not state == current_state:
		return
	var new_state: State = states.get(new_state_name.to_lower())
	if not new_state:
		return
	if current_state:
		current_state.s_exit()
	new_state.s_enter()
	current_state = new_state
