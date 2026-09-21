extends LoadingScreen

# ------------------------------------------------------------------------------

# Overridable
func _on_load_finished(failed_paths: PackedStringArray) -> void:
	if failed_paths.is_empty():
		FDLog.log_info("[TestLoadingScreen]: Finished load with no failures.")
		var next_scene: PackedScene = (
				ResourceLoader.load("res://test/loading_system/test_loading_level.tscn"))
		get_tree().change_scene_to_packed(next_scene)
		return
	FDLog.log_warn(
			"[TestLoadingScreen]: Finished load with %d failures." % failed_paths.size())


# Overridable
func _on_progress_updated(progress: float) -> void:
	pass

# ------------------------------------------------------------------------------
