extends ActionList


# Create all Actions on _init
# Example:
#func _init() -> void:
	#_actions = {
		#&"main_screen": {
			#&"play": Action.create(_main_screen__play),
			#&"quit": Action.create(func(): get_tree().quit())
		#},
		#&"level": {
			#&"exit": Action.create(_level__exit)
		#},
	#}
#
#func _main_screen__play() -> void:
	#get_tree().change_scene_to_file("scenes/level_selection.tscn")
#
#func _level__exit() -> void:
	#get_tree().change_scene_to_file("scenes/main_screen.tscn")

#func _init() -> void:
	#_actions = {}


func _init() -> void:
	_actions = {}
