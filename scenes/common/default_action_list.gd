extends ActionList

# ------------------------------------------------------------------------------

# GUI Scenes

const MAIN_SCREEN = preload("uid://ssroffps0cp7")
const LEVEL_SELECTION_SCREEN = preload("uid://62walnjltsi0")
const SETTINGS_SCREEN = preload("uid://b4di7ixk5c6wg")
const CREDITS_SCREEN = preload("uid://boowktjmcq156")

# Transition Scenes
const FADE_TRANSITION = preload("uid://dvwyl74o1x6ie")
const V_DOTS_HALFTONE_TRANSITION = preload("uid://du4av3flq64jc")
const V_STRIPS_TRANSITION = preload("uid://d21b1mft4706r")

# ------------------------------------------------------------------------------

func _init() -> void:
	_actions = {
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
func _transition_to_file(
		transition_scene: PackedScene,
		filepath: String) -> void:
	var transition: FDTransition = null
	if transition_scene:
		transition = transition_scene.instantiate()
	if transition == null:
		FDLog.log_warn(
				"[DefaultActionList]: Invalid transition scene. Changing "
				+ "scene without transition.")
		get_tree().change_scene_to_file(filepath)
	transition.layer = 1024 # Optional: Keep if you want the transition to overlay all layers
	add_child(transition)
	await transition.play(get_tree().change_scene_to_file.bind(filepath))
	transition.queue_free()
#endregion

# ------------------------------------------------------------------------------

#region Main Screen
func _main_screen__play() -> void:
	_transition_to_file(
			FADE_TRANSITION,
			"res://scenes/gui/level_selection_screen.tscn")


func _main_screen__settings() -> void:
	_transition_to_file(
			V_DOTS_HALFTONE_TRANSITION,
			"res://scenes/gui/settings_screen.tscn")


func _main_screen__credits() -> void:
	_transition_to_file(
			V_STRIPS_TRANSITION,
			"res://scenes/gui/credits_screen.tscn")


func _main_screen__quit() -> void:
	var transition: FDTransition = FADE_TRANSITION.instantiate()
	transition.layer = 1024 # Optional: Keep if you want the transition to overlay all layers
	add_child(transition)
	transition.play_in(get_tree().quit)
#endregion


#region Level Selection Screen
func _level_selection_screen__return() -> void:
	_transition_to_file(
			FADE_TRANSITION,
			"res://scenes/gui/main_screen.tscn")
#endregion


#region Settings Screen
func _settings_screen__return() -> void:
	_transition_to_file(
			V_DOTS_HALFTONE_TRANSITION,
			"res://scenes/gui/main_screen.tscn")
#endregion


#region Credits Screen
func _credits_screen__return() -> void:
	_transition_to_file(
			V_STRIPS_TRANSITION,
			"res://scenes/gui/main_screen.tscn")
#endregion
