@tool
class_name FDTransition
extends CanvasLayer


## Emitted when the transition start (by calling [method play], [method play_in] or [method play_out]).
signal started
## Emitted when a step finish (after calling [method play_in] or [method play_out]).
signal step_finished
## Emitted when the full cycle of transition finish (after calling [method play]).
signal finished


# Setup
@export_group("Setup")
@export_range(0.0, 5.0, 0.1, "or_greater") var duration_in: float = 2.0
@export var ease_in: Tween.EaseType = Tween.EaseType.EASE_OUT
@export var trans_in: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export_range(0.0, 5.0, 0.1, "or_greater") var duration_out: float = 2.0
@export var ease_out: Tween.EaseType = Tween.EaseType.EASE_OUT
@export var trans_out: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

# Delay
@export_group("Delay")
@export_range(0.0, 5.0, 0.1, "or_greater") var in_pre_delay: float = 0.0
@export_range(0.0, 5.0, 0.1, "or_greater") var in_post_delay: float = 0.0
@export_range(0.0, 5.0, 0.1, "or_greater") var out_pre_delay: float = 0.0
@export_range(0.0, 5.0, 0.1, "or_greater") var out_post_delay: float = 0.0

# Preview
@export_group("")
@export_tool_button("Preview In") var _preview_in_button = play_in
@export_tool_button("Preview Out") var _preview_out_button = play_out
@export_range(0.0, 1.0) var _custom_preview_in: float = 0.5:
	set = _set_custom_preview_in
@export_range(0.0, 1.0) var _custom_preview_out: float = 0.5:
	set = _set_custom_preview_out


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func play(
	in_callback: Callable = func(): return,
	out_callback: Callable = func(): return
) -> Array:
	var result: Array = []
	result.resize(2)
	started.emit()
	result[0] = await play_in(in_callback)
	result[1] = await play_out(out_callback)
	finished.emit()
	return result


func play_in(callback: Callable = func(): return) -> Variant:
	await _setup_play_in()
	started.emit()
	if not is_zero_approx(in_pre_delay):
		await get_tree().create_timer(in_pre_delay).timeout
	await get_tree().create_tween().set_ease(ease_in).set_trans(trans_in).tween_method(
		_on_play_in, 0.0, 1.0, duration_in
	).finished
	var result: Variant = await callback.call()
	if not is_zero_approx(in_post_delay):
		await get_tree().create_timer(in_post_delay).timeout
	step_finished.emit()
	return result


func play_out(callback: Callable = func(): return) -> Variant:
	await _setup_play_out()
	started.emit()
	if not is_zero_approx(out_pre_delay):
		await get_tree().create_timer(out_pre_delay).timeout
	await get_tree().create_tween().set_ease(ease_out).set_trans(trans_out).tween_method(
		_on_play_out, 1.0, 0.0, duration_out
	).finished
	var result: Variant = await callback.call()
	if not is_zero_approx(out_post_delay):
		await get_tree().create_timer(out_post_delay).timeout
	step_finished.emit()
	return result


# Overridable
func _setup_play_in() -> void:
	pass


# Overridable
func _setup_play_out() -> void:
	pass


# Overridable
func _on_play_in(ratio: float) -> void:
	pass


# Overridable
func _on_play_out(ratio: float) -> void:
	pass


func _set_custom_preview_in(value: float) -> void:
	_custom_preview_in = value
	if Engine.is_editor_hint() and is_node_ready():
		_on_play_in(Tween.interpolate_value(
			0.0, 1.0, lerp(0.0, duration_in, _custom_preview_in),
			duration_in, trans_in, ease_in
		))


func _set_custom_preview_out(value: float) -> void:
	_custom_preview_out = value
	if Engine.is_editor_hint() and is_node_ready():
		_on_play_out(Tween.interpolate_value(
			1.0, -1.0, lerp(0.0, duration_out, _custom_preview_out),
			duration_out, trans_out, ease_out
		))
