extends ActionList

# ------------------------------------------------------------------------------

# Transition Scenes
const FADE_TRANSITION = preload("uid://dvwyl74o1x6ie")
const V_DOTS_HALFTONE_TRANSITION = preload("uid://du4av3flq64jc")
const V_STRIPS_TRANSITION = preload("uid://d21b1mft4706r")


var MAIN_SCREEN: PackedScene = null
var LEVEL_SELECTION_SCREEN: PackedScene = null
var SETTINGS_SCREEN: PackedScene = null
var CREDITS_SCREEN: PackedScene = null

# ------------------------------------------------------------------------------

func _init() -> void:
	_actions = {
		&"initial_loading_screen": {
			&"finished": Action.create(_initial_loading_screen__finished),
			&"failed": Action.create(_initial_loading_screen__failed),
		},
		&"main_screen": {
			&"play": Action.create(_main_screen__play),
			&"settings": Action.create(_main_screen__settings),
			&"credits": Action.create(_main_screen__credits),
			&"quit": Action.create(_main_screen__quit),
		},
		&"level_selection_screen": {
			&"return": Action.create(_level_selection_screen__return),
		},
		&"settings_screen": {
			&"return": Action.create(_settings_screen__return),
		},
		&"credits_screen": {
			&"return": Action.create(_credits_screen__return),
		},
	}

# ------------------------------------------------------------------------------

#region Common Methods
func _transition_to_packed(
		packed_scene: PackedScene,
		transition_scene: PackedScene = FADE_TRANSITION,
		callback: Callable = Callable()) -> void:
	var transition: FDTransition = null
	if transition_scene:
		transition = transition_scene.instantiate()
	if transition == null:
		FDLog.log_warn(
				"[DefaultActionList]: Invalid transition scene. Changing "
				+ "scene without transition.")
		get_tree().change_scene_to_packed(packed_scene)
	transition.layer = 1024 # Optional: Keep if you want the transition to overlay all layers
	add_child(transition)
	await transition.play(
		func():
			get_tree().change_scene_to_packed(packed_scene)
			await get_tree().scene_changed
			if callback.is_valid():
				callback.call())
	transition.queue_free()


func _transition_to_file(
		filepath: String,
		transition_scene: PackedScene = FADE_TRANSITION,
		callback: Callable = Callable()) -> void:
	var scene: PackedScene = ResourceLoader.load(filepath)
	_transition_to_packed(scene, transition_scene, callback)
#endregion

# ------------------------------------------------------------------------------

#region Initial Loading Screen
func _initial_loading_screen__finished(
		next_scene: String, failed_paths: PackedStringArray) -> void:
	if not failed_paths.is_empty():
		FDLog.log_warn(
				"[ActionManager]: Loaded initial scenes with failures: [%s]" % [
					", ".join(failed_paths)
				])

	MAIN_SCREEN = (
			ResourceLoader.load("res://scenes/gui/main_screen.tscn"))
	LEVEL_SELECTION_SCREEN = (
			ResourceLoader.load("res://scenes/gui/level_selection_screen.tscn"))
	SETTINGS_SCREEN = (
			ResourceLoader.load("res://scenes/gui/settings_screen.tscn"))
	CREDITS_SCREEN = (
			ResourceLoader.load("res://scenes/gui/credits_screen.tscn"))

	if next_scene.is_empty():
		return
	_transition_to_file(next_scene)


@warning_ignore("unused_parameter")
func _initial_loading_screen__failed(
		next_scene: String, failed_paths: PackedStringArray) -> void:
	FDLog.log_warn(
			"[ActionManager]: Initial scenes loading has failed: [%s]" % [
				", ".join(failed_paths)
			])
#endregion


#region Main Screen
func _main_screen__play() -> void:
	_transition_to_packed(LEVEL_SELECTION_SCREEN)


func _main_screen__settings() -> void:
	_transition_to_packed(SETTINGS_SCREEN)


func _main_screen__credits() -> void:
	_transition_to_packed(CREDITS_SCREEN)


func _main_screen__quit() -> void:
	var transition: FDTransition = FADE_TRANSITION.instantiate()
	transition.layer = 1024 # Optional: Keep if you want the transition to overlay all layers
	add_child(transition)
	transition.play_in(get_tree().quit)
#endregion


#region Level Selection Screen
func _level_selection_screen__return() -> void:
	_transition_to_packed(MAIN_SCREEN)
#endregion


#region Settings Screen
func _settings_screen__return() -> void:
	_transition_to_packed(MAIN_SCREEN)
#endregion


#region Credits Screen
func _credits_screen__return() -> void:
	_transition_to_packed(MAIN_SCREEN)
#endregion
