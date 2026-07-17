@tool
extends EditorPlugin

# ------------------------------------------------------------------------------

func _enable_plugin() -> void:
	add_autoload_singleton(
			"FDLog", "res://addons/fire_droid_log/scripts/fd_log.gd")


func _disable_plugin() -> void:
	remove_autoload_singleton("FDLog")


func _enter_tree() -> void:
	_setup_custom_setting(FDLog.SettingPath.PRINT_LOG_LEVEL, TYPE_BOOL, true)
	for level: FDLog.LogLevel in FDLog.LogLevel.values():
		_setup_custom_setting(
				FDLog.SettingPath.ENABLE_LEVEL[level], TYPE_BOOL, true)
		_setup_style_settings(level)
	_setup_custom_setting(
			FDLog.SettingPath.LOG_FILE_ROOT_DIR,
			TYPE_STRING, "", { &"hint": PROPERTY_HINT_GLOBAL_DIR })
	_setup_custom_setting(
			FDLog.SettingPath.LOG_FILE_NAME_PREFIX, TYPE_STRING, "")
	ProjectSettings.save()
	pass


func _exit_tree() -> void:
	ProjectSettings.save()
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


func _setup_style_settings(level: FDLog.LogLevel) -> void:
	for setting_name: StringName in [&"color", &"bg_color", &"fg_color"]:
		_setup_custom_setting(
				FDLog.SettingPath.LOG_STYLE[level][setting_name], TYPE_COLOR,
				FDLog.get_style_setting(level, setting_name))
	for setting_name: StringName in [&"bold", &"italic", &"underlined", &"strikethrough"]:
		_setup_custom_setting(
				FDLog.SettingPath.LOG_STYLE[level][setting_name], TYPE_BOOL,
				FDLog.get_style_setting(level, setting_name))
