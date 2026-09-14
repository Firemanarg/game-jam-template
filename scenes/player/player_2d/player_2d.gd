class_name Player2D
extends CharacterBody2D

# ------------------------------------------------------------------------------

@export_group("Stats")
@export var max_hp: float = 100.0

@export_group("Movement")
@export var movement_speed: float = 600.0
@export var acceleration: float = 2500.0
@export var deacceleration: float = 2200.0

@export_group("Skills")
@export var allow_skills: bool = true

var _hp: float = max_hp

@onready var animation_player: AnimationPlayer = get_node("%AnimationPlayer")
@onready var animation_tree: AnimationTree = get_node("%AnimationTree")
@onready var playback: AnimationNodeStateMachinePlayback = (
		animation_tree.get("parameters/playback"))
@onready var skills_root: Node = get_node("%SkillsRoot")

# ------------------------------------------------------------------------------

func _init() -> void:
	_hp = max_hp


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	call_deferred(&"move_and_slide")

# ------------------------------------------------------------------------------

# Overridable
func _on_death() -> void:
	pass


## Overridable
#@warning_ignore("unused_parameter")
#func _on_skill_use(index: int, skill: Player2DSkill) -> void:
	#pass

# ------------------------------------------------------------------------------

func apply_friction(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, deacceleration * delta)
	velocity.y = move_toward(velocity.y, 0, deacceleration * delta)


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func apply_movement_toward(
		direction: Vector2, delta: float,
		custom_speed: float = movement_speed) -> void:
	velocity.x = move_toward(
			velocity.x, direction.x * custom_speed, acceleration * delta)
	velocity.y = move_toward(
			velocity.y, direction.y * custom_speed, acceleration * delta)


func update_skills_uses() -> void:
	for skill: PlayerSkill in skills_root.get_children():
		if not skill:
			continue
		skill.attempt_cast_skill()


#func use_skill(index: int) -> void:
	#if not allow_skills:
		#FDLog.log_debug("[Player2D]: Player skills are disabled.")
		#return
#
	#FDLog.log_debug("[Player2D]: Player is using skill")
	#_on_skill_use(index, skills_root.get_child(index))


func attempt_death() -> bool:
	if is_alive():
		return false
	FDLog.log_info("[Player2D]: Player has died!")
	_on_death()
	return true


func is_alive() -> bool:
	return _hp > 0.0


func set_animation(node_name: StringName) -> void:
	if not is_node_ready():
		return
	playback.travel(node_name)


func get_input_direction() -> Vector2:
	var input_direction: Vector2 = Input.get_vector(
			&"move_left", &"move_right", &"move_up", &"move_down")
	return input_direction
