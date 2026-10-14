extends LoadingScreen

# ------------------------------------------------------------------------------

@export var context: StringName = &"loading_screen"
@export var success_load_action: StringName = &"finished"
@export var fail_load_action: StringName = &"failed"
@export var next_scene: String = ""

# ------------------------------------------------------------------------------

# Overridable
func _on_load_finished(failed_paths: PackedStringArray) -> void:
	var action: StringName = (
			fail_load_action if not failed_paths.is_empty() and abort_if_fail
			else success_load_action)
	Action.trigger(context, action, [next_scene, failed_paths])


# Overridable
func _on_progress_updated(progress: float) -> void:
	pass

# ------------------------------------------------------------------------------
