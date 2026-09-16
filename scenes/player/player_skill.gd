class_name PlayerSkill
extends Node

# ------------------------------------------------------------------------------

enum ActivationType {
	SINGLE_PRESS, ## Skill is activated once input_action is pressed for the first time
	CONTINUOUS_PRESS, ## Skill is activated while input_action is being pressed
	ON_RELEASE, ## Skill is activated once input_action is released
}


@export var input_action: StringName = &""
@export var activation_type: ActivationType = ActivationType.SINGLE_PRESS
@export var cooldown: float = 0.0
## 0.0 = instant cast | >0.0 = timed cast | Acts as a delay in CONTINUOUS_PRESS activation
@export var cast_duration: float = 0.0
## -1 = unlimited cast count | 0 = cannot be castd | >0 = limited casts (consumable)
@export var max_casts: int = -1

var _is_casting: bool = false
var _cast_timer: SceneTreeTimer = null
var _cooldown_timer: SceneTreeTimer = null
var _casts: int = 0

# ------------------------------------------------------------------------------

func _init() -> void:
	pass


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass

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

# ------------------------------------------------------------------------------

func attempt_cast_skill() -> bool:
	if input_action.is_empty():
		if _is_active():
			FDLog.log_debug(
					"[PlayerSkill]: Attempted to cast skill with empty input_action.")
		return false
	elif _cooldown_timer and _cooldown_timer.time_left > 0.0:
		if _is_active():
			FDLog.log_debug(
					"[PlayerSkill]: The Skill is on cooldown.")
		return false

	var has_cast: bool = false
	match activation_type:
		ActivationType.SINGLE_PRESS:
			has_cast = _cast_single_press()
		ActivationType.CONTINUOUS_PRESS:
			has_cast = _cast_continuous_press()
		ActivationType.ON_RELEASE:
			has_cast = _cast_on_release()

	return has_cast


func get_cooldown_time_left() -> float:
	if not _cooldown_timer:
		return 0.0
	return _cooldown_timer.time_left


func get_cast_count() -> int:
	return _casts


func has_reached_max_casts() -> bool:
	if max_casts < 0:
		return false
	return _casts >= max_casts

# ------------------------------------------------------------------------------

func _is_active() -> bool:
	match activation_type:
		ActivationType.SINGLE_PRESS:
			return Input.is_action_just_pressed(input_action)
		ActivationType.CONTINUOUS_PRESS:
			return Input.is_action_pressed(input_action)
		ActivationType.ON_RELEASE:
			return Input.is_action_just_released(input_action)
	return false


func _cast_single_press() -> bool:
	var is_active: bool = Input.is_action_just_pressed(input_action)
	if not is_active or _is_casting or has_reached_max_casts():
		return false
	_perform_instant_cast()
	return true


func _cast_continuous_press() -> bool:
	var is_active: bool = Input.is_action_pressed(input_action)
	if is_active:
		if _is_casting:
			return true
		if has_reached_max_casts():
			return false
		_is_casting = true
		if cast_duration > 0.0:
			_cast_timer = get_tree().create_timer(cast_duration)
			_cast_timer.timeout.connect(
					func(): _is_casting = false; _cast_timer = null)
		else:
			_is_casting = false
		_casts += 1
		_on_cast_started()
		return true
	elif not is_active and _is_casting:
		_is_casting = false
		_on_cast_finished()
		if cooldown > 0.0:
			_cooldown_timer = get_tree().create_timer(cooldown)
	return false


func _cast_on_release() -> bool:
	var is_active: bool = Input.is_action_just_released(input_action)
	if not is_active or _is_casting or has_reached_max_casts():
		return false
	_perform_instant_cast()
	return true


func _perform_instant_cast() -> void:
	_is_casting = true
	_casts += 1
	_on_cast_started()
	if cast_duration > 0.0:
		await get_tree().create_timer(cast_duration).timeout
	_is_casting = false
	_on_cast_finished()
	if cooldown > 0.0:
		_cooldown_timer = get_tree().create_timer(cooldown)
		_cooldown_timer.timeout.connect(func(): _cooldown_timer = null)
