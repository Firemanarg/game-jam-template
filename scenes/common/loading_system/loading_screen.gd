class_name LoadingScreen
extends CanvasLayer

# ------------------------------------------------------------------------------

signal finished_loading(failed_paths: PackedStringArray)

# ------------------------------------------------------------------------------

@export var paths_to_load: PackedStringArray = []
@export_range(0.0, 10.0, 0.1, "or_greater", "prefer_slider")
var load_pre_delay: float = 0.0
@export_range(0.0, 10.0, 0.1, "or_greater", "prefer_slider")
var load_post_delay: float = 0.0
@export_range(0.0, 10.0, 0.1, "or_greater", "prefer_slider")
var minimum_load_duration: float = 2.0
@export var abort_if_fail: bool = true

var _progress: float = 0.0
var _individual_path_progress: PackedFloat32Array = []
var _has_started_load: bool = false
var _has_finished_load: bool = false
var _completed_count: int = 0
var _failed_paths: PackedStringArray = []
var _elapsed_time: float = 0.0
var _require_abortion: bool = false

@onready var loading_text: Label = get_node("%LoadingText")
@onready var loading_bar: ProgressBar = get_node("%LoadingBar")

# ------------------------------------------------------------------------------

func _ready() -> void:
	if load_pre_delay > 0.0:
		await get_tree().create_timer(load_pre_delay).timeout
	_start_load()


func _process(delta: float) -> void:
	if not _has_started_load or _has_finished_load:
		return
	_elapsed_time += delta
	var has_reached_min_time: bool = _elapsed_time >= minimum_load_duration
	if _completed_count == paths_to_load.size() and has_reached_min_time:
		_has_finished_load = true
		if load_post_delay > 0.0:
			get_tree().create_timer(load_post_delay).timeout.connect(func():
					_log_finished_resources()
					finished_loading.emit(_failed_paths)
					_on_load_finished(_failed_paths))
		else:
			_log_finished_resources()
			finished_loading.emit(_failed_paths)
			_on_load_finished(_failed_paths)
	var time_ratio: float = (
			remap(
					_elapsed_time,
					0.0, minimum_load_duration, 0.0, 1.0))
	loading_bar.set_value(_progress * time_ratio * 100)
	_update_total_progress.call_deferred()


func _physics_process(_delta: float) -> void:
	pass

# ------------------------------------------------------------------------------

# Overridable
func _on_load_finished(failed_paths: PackedStringArray) -> void:
	pass


# Overridable
func _on_progress_updated(progress: float) -> void:
	pass

# ------------------------------------------------------------------------------

func _start_load() -> void:
	_progress = 0.0
	_has_started_load = true
	_individual_path_progress.resize(paths_to_load.size())
	if paths_to_load.is_empty():
		_progress = 1.0
		return
	var progress_index: int = 0
	for path: String in paths_to_load:
		Loading.load_async(
				path,
				_on_individual_load_finished.bind(path, progress_index),
				_on_individual_progress_updated.bind(progress_index))
		progress_index += 1


func _update_total_progress() -> void:
	if paths_to_load.is_empty():
		_progress = 1.0
		_on_progress_updated(_progress)
		return

	var int_progress: int = 0
	for path_progress: float in _individual_path_progress:
		int_progress += int(path_progress * 100)
	_progress = (float(int_progress) / 100.0) / float(paths_to_load.size())
	_on_progress_updated(_progress)


func _log_finished_resources() -> void:
	if paths_to_load.is_empty():
		FDLog.log_info("[LoadingScreen]: Finished loading 0 resources.")
		return
	FDLog.log_info(
			"[LoadingScreen]: Finished loading %d resources:%s" % [
				_completed_count,
				"\n\t* " + "\n\t* ".join(paths_to_load)
			])

# ------------------------------------------------------------------------------

func _on_individual_progress_updated(progress: float, index: int) -> void:
	_individual_path_progress[index] = progress


func _on_individual_load_finished(
		resource: Resource, path: String, progress_index: int) -> void:
	_individual_path_progress[progress_index] = 1.0
	_completed_count += 1
	if not resource:
		_failed_paths.append(path)
		_require_abortion = _require_abortion or abort_if_fail
		return
