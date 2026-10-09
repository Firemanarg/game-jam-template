extends LoadingScreen

# ------------------------------------------------------------------------------

# Overridable
func _on_load_finished(failed_paths: PackedStringArray) -> void:
	if failed_paths.is_empty():
		FDLog.log_info("[TestLoadingScreen]: Finished load with no failures.")
		var sfx_audio_group: AudioGroup = ResourceLoader.load(
				"res://test/audio_manager/assets/sfx_test_audio_group.tres")
		AUMA.add_group(&"sfx", sfx_audio_group)
		var bgm_audio_group: AudioGroup = ResourceLoader.load(
				"res://test/audio_manager/assets/bgm_test_audio_group.tres")
		AUMA.add_group(&"bgm", bgm_audio_group)
		var next_scene: PackedScene = (
				ResourceLoader.load("res://test/audio_manager/test_main_screen.tscn"))
		get_tree().change_scene_to_packed(next_scene)
		return
	FDLog.log_warn(
			"[TestLoadingScreen]: Finished load with %d failures." % failed_paths.size())


# Overridable
func _on_progress_updated(progress: float) -> void:
	pass

# ------------------------------------------------------------------------------
