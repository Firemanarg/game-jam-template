@tool
extends EditorPlugin

# ------------------------------------------------------------------------------

func _enable_plugin() -> void:
	add_autoload_singleton(
			"Action",
			"res://addons/fire_droid_action_manager/scripts/action_manager.gd")


func _disable_plugin() -> void:
	remove_autoload_singleton("Action")
	ProjectSettings.save()


func _enter_tree() -> void:
	_setup_custom_setting(
			"FDActionManager/enable_default_actions", TYPE_BOOL, true)
	_setup_custom_setting(
			"FDActionManager/default_actions_script_path", TYPE_STRING, "",
			{ &"hint": PROPERTY_HINT_FILE, &"hint_string": "*.gd"})
	_setup_custom_setting(
			"FDActionManager/enable_override_actions", TYPE_BOOL, true)
	_setup_custom_setting(
			"FDActionManager/override_actions_script_path", TYPE_STRING, "",
			{ &"hint": PROPERTY_HINT_FILE, &"hint_string": "*.gd"})
	ProjectSettings.save()


func _exit_tree() -> void:
	pass

# ------------------------------------------------------------------------------

func _setup_custom_setting(
		path: String,
		type: int,
		initial_value: Variant,
		args: Dictionary = {},
		is_basic: bool = true) -> void:
	if not ProjectSettings.get_setting(path):
		ProjectSettings.set_setting(path, initial_value)
	ProjectSettings.set_initial_value(path, initial_value)
	ProjectSettings.add_property_info({
		&"name": path,
		&"type": type,
		&"hint": args.get(&"hint", PROPERTY_HINT_NONE),
		&"hint_string": args.get(&"hint_string", "")
	})
	ProjectSettings.set_as_basic(path, true)
