extends Node
class_name State

# ------------------------------------------------------------------------------

@warning_ignore("unused_signal")
signal transition(current_state, next_state)

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

# ------------------------------------------------------------------------------

func setup() -> void:
	_setup()


func s_enter() -> void:
	#print("Entered state ", self.name.to_lower())
	_s_enter()


func s_exit() -> void:
	#print("Exited state ", self.name.to_lower())
	_s_exit()


func s_update(_delta: float) -> void:
	_s_update(_delta)


func s_physics_update(_delta: float) -> void:
	_s_physics_update(_delta)
