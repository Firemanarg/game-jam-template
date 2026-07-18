extends ActionList

# ------------------------------------------------------------------------------

const MAIN_SCREEN = preload("uid://ssroffps0cp7")
const LEVEL_SELECTION_SCREEN = preload("uid://62walnjltsi0")
const SETTINGS_SCREEN = preload("uid://b4di7ixk5c6wg")
const CREDITS_SCREEN = preload("uid://boowktjmcq156")

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

#region Main Screen
func _main_screen__play() -> void:
	get_tree().change_scene_to_file(
			"res://scenes/gui/level_selection_screen.tscn")


func _main_screen__settings() -> void:
	get_tree().change_scene_to_file(
			"res://scenes/gui/settings_screen.tscn")


func _main_screen__credits() -> void:
	get_tree().change_scene_to_file(
			"res://scenes/gui/credits_screen.tscn")


func _main_screen__quit() -> void:
	get_tree().quit()
#endregion


#region Level Selection Screen
func _level_selection_screen__return() -> void:
	get_tree().change_scene_to_file(
			"res://scenes/gui/main_screen.tscn")
#endregion


#region Settings Screen
func _settings_screen__return() -> void:
	get_tree().change_scene_to_file(
			"res://scenes/gui/main_screen.tscn")
#endregion


#region Credits Screen
func _credits_screen__return() -> void:
	get_tree().change_scene_to_file(
			"res://scenes/gui/main_screen.tscn")
#endregion
