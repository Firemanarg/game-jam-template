extends Node

# ------------------------------------------------------------------------------

var _active_load_requests: Dictionary = {}

# ------------------------------------------------------------------------------

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	_process_active_load_requests()


func _physics_process(_delta: float) -> void:
	pass

# ------------------------------------------------------------------------------

func load_async(
		resource_path: String,
		on_load_finished: Callable,
		on_progress_updated: Callable = Callable()) -> void:
	_load_async(resource_path, on_load_finished, on_progress_updated)

# ------------------------------------------------------------------------------

func _load_async(
		resource_path: String,
		on_load_finished: Callable,
		on_progress_updated: Callable = Callable()) -> void:
	if ResourceLoader.has_cached(resource_path):
		on_load_finished.call(ResourceLoader.load(resource_path))
		return

	if not _active_load_requests.has(resource_path):
		var error_code: Error = (
				ResourceLoader.load_threaded_request(resource_path, "", true))
		if not error_code == OK:
			FDLog.log_err(
					"[Loading]: Error %d during threaded request for \"%s\"" % [
						error_code, resource_path,
					])
			on_load_finished.call(null)
			return
		_active_load_requests[resource_path] = {
			&"completion_callbacks": [], &"progress_callbacks": []
		}

	_active_load_requests[resource_path].completion_callbacks.append(on_load_finished)
	if on_progress_updated.is_valid():
		_active_load_requests[resource_path].progress_callbacks.append(on_progress_updated)


func _process_active_load_requests() -> void:
	if _active_load_requests.is_empty():
		return

	var completed_resource_paths: Array[String] = []
	for resource_path: String in _active_load_requests.keys():
		var progress_array: Array = []
		var load_status: ResourceLoader.ThreadLoadStatus = (
				ResourceLoader.load_threaded_get_status(resource_path, progress_array))
		match load_status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				var progress: float = progress_array[0] as float
				var progress_callbacks_array: Array = (
						_active_load_requests[resource_path].progress_callbacks)
				for callback_method: Callable in progress_callbacks_array:
					if callback_method.is_valid():
						callback_method.call(progress)

			ResourceLoader.THREAD_LOAD_LOADED:
				var loaded_resource: Resource = (
						ResourceLoader.load_threaded_get(resource_path))
				var progress_callbacks_array: Array = (
						_active_load_requests[resource_path].progress_callbacks)
				for callback_method: Callable in progress_callbacks_array:
					if callback_method.is_valid():
						callback_method.call(1.0)
				var completion_callbacks_array: Array = (
						_active_load_requests[resource_path].completion_callbacks)
				for callback_method: Callable in completion_callbacks_array:
					if callback_method.is_valid():
						callback_method.call(loaded_resource)
				completed_resource_paths.append(resource_path)

			ResourceLoader.THREAD_LOAD_FAILED:
				FDLog.log_err(
						"[Loading]: Threaded load failed for \"%s\"" % resource_path)
				var completion_callbacks_array: Array = (
						_active_load_requests[resource_path].completion_callbacks)
				for callback_method: Callable in completion_callbacks_array:
					if callback_method.is_valid():
						callback_method.call(null)
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				FDLog.log_err(
						"[Loading]: Threaded load found invalid resource "
						+ "for \"%s\"" % resource_path)
				var completion_callbacks_array: Array = (
						_active_load_requests[resource_path].completion_callbacks)
				for callback_method: Callable in completion_callbacks_array:
					if callback_method.is_valid():
						callback_method.call(null)

	for resource_path: String in completed_resource_paths:
		_active_load_requests.erase(resource_path)
