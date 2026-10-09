class_name AUMAPlayer
extends AudioStreamPlayer

# ------------------------------------------------------------------------------

signal fade_in_finished
signal fade_out_finished

# ------------------------------------------------------------------------------

const DEFAULT_FADE_IN_DURATION: float = 2.0
const DEFAULT_FADE_OUT_DURATION: float = 2.0

# ------------------------------------------------------------------------------

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass

# ------------------------------------------------------------------------------

func fade_in(duration: float = DEFAULT_FADE_IN_DURATION) -> void:
	_fade_in(duration)


func fade_out(duration: float = DEFAULT_FADE_OUT_DURATION) -> void:
	_fade_out(duration)

# ------------------------------------------------------------------------------

func _fade_in(duration: float) -> void:
	play()
	if is_zero_approx(duration):
		set_volume_linear(1.0)
		fade_in_finished.emit()
		return
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "volume_linear", 1.0, duration).from(0.0)
	tween.finished.connect(fade_in_finished.emit)


func _fade_out(duration: float) -> void:
	if is_zero_approx(duration):
		set_volume_linear(0.0)
		fade_out_finished.emit()
		stop()
		return
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "volume_linear", 0.0, duration).from(1.0)
	tween.finished.connect(fade_out_finished.emit)
	tween.finished.connect(stop)
