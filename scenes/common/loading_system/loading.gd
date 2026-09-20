extends Node

# ------------------------------------------------------------------------------

var _load_requests: Dictionary = {}

# ------------------------------------------------------------------------------

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	_process_load_requests()


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

	if not _load_requests.has(resource_path):
		var error_code: Error = (
				ResourceLoader.load_threaded_request(resource_path, "", true))
		if not error_code == OK:
			FDLog.log_err(
					"[Loading]: Error %d during threaded request for \"%s\"" % [
						error_code, resource_path,
					])
			on_load_finished.call(null)
			return
		_load_requests[resource_path] = {
			&"completion_callbacks": [], &"progress_callbacks": []
		}

	_load_requests[resource_path].completion_callbacks.append(on_load_finished)
	if on_progress_updated.is_valid():
		_load_requests[resource_path].progress_callbacks.append(on_load_finished)


func _process_load_requests() -> void:
	if _load_requests.is_empty():
		return

	var loaded_resources_paths: Array[String] = []
	for path: String in _load_requests.keys():
		var progress_array: Array = []
		var load_status: ResourceLoader.ThreadLoadStatus = (
				ResourceLoader.load_threaded_get_status(path, progress_array))
		match load_status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				var progress: float = progress_array[0] as float
				var progress_callbacks_array: Array[Callable] = (
						_load_requests[path].progress_callbacks)
				for callback_method: Callable in progress_callbacks_array:
					if callback_method.is_valid():
						callback_method.call(progress)

			ResourceLoader.THREAD_LOAD_LOADED:
				var loaded_resource: Resource = (
						ResourceLoader.load_threaded_get(path))
				var completion_callbacks_array: Array[Callable] = (
						_load_requests[path].completion_callbacks)
				for callback_method: Callable in completion_callbacks_array:
					if callback_method.is_valid():
						callback_method.call(loaded_resource)
				loaded_resources_paths.append(path)

			ResourceLoader.THREAD_LOAD_FAILED,\
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				FDLog.log_err(
						"[Loading]: Error during threaded request for \"%s\"" % [
							path,
						])
				var completion_callbacks_array: Array[Callable] = (
						_load_requests[path].completion_callbacks)
				for callback_method: Callable in completion_callbacks_array:
					if callback_method.is_valid():
						callback_method.call(null)

