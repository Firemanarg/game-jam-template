@tool
extends Node

# ------------------------------------------------------------------------------

enum {
	TRACE,
	DEBUG,
	INFO,
	NOTICE,
	WARNING,
	ERROR,
	CRITICAL,
}

enum LogLevel {
	TRACE,
	DEBUG,
	INFO,
	NOTICE,
	WARNING,
	ERROR,
	CRITICAL,
}
const SettingPath = preload("res://addons/fire_droid_log/scripts/setting_path.gd")


const DEFAULT_LOG_FILE_NAME_PREFIX: String = "log_file"
const LOG_FILE_EXTENSION: String = "log"

const DEFAULT_COLOR: Color = Color.GRAY
const DEFAULT_BG_COLOR: Color = Color.TRANSPARENT
const DEFAULT_FG_COLOR: Color = Color.TRANSPARENT
const DEFAULT_BOLD: bool = false
const DEFAULT_ITALIC: bool = false
const DEFAULT_UNDERLINED: bool = false
const DEFAULT_STRIKETHROUGH: bool = false

const DEFAULT_SETTINGS: Dictionary[StringName, Variant] = {
	&"color": DEFAULT_COLOR,
	&"bg_color": DEFAULT_BG_COLOR,
	&"fg_color": DEFAULT_FG_COLOR,
	&"bold": DEFAULT_BOLD,
	&"italic": DEFAULT_ITALIC,
	&"underlined": DEFAULT_UNDERLINED,
	&"strikethrough": DEFAULT_STRIKETHROUGH,
}

const _TIMESTAMP_T_CHAR_INDEX: int = 10

const DefaultStyle: Dictionary[LogLevel, Dictionary] = {
	LogLevel.TRACE: { &"color": Color.GRAY, &"italic": true },
	LogLevel.DEBUG: { &"color": Color.WHITE },
	LogLevel.INFO: { &"color": Color.DEEP_SKY_BLUE },
	LogLevel.NOTICE: { &"color": Color.CYAN, &"bold": true },
	LogLevel.WARNING: { &"color": Color.YELLOW },
	LogLevel.ERROR: { &"color": Color.RED },
	LogLevel.CRITICAL: {
		&"color": Color.WHITE,
		&"bg_color": Color.RED,
		&"bold": true,
	},
}

var _current_file_path: String = ""

# ------------------------------------------------------------------------------

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass

# ------------------------------------------------------------------------------

## Prints a message in the console and log it to the log file. [param message]
## is the String message to be displayed and [param level] is the log level of
## the message (see [enum LogLevel]).
## [br][br]The message is displayed in the following format:
## [code][YYYY-MM-DD HH:mm:SS]: [LEVEL]: Message[/code].[br][br][b]Suggestion:[/b]
## begin the log message with it's context.[codeblock]
## FDLog.logm("[Player]: HP decreased 12 points.", FDLog.LogLevel.DEBUG)
##
## FDLog.logm("[GameManager]: Level completed.", FDLog.LogLevel.INFO)
##
## FDLog.logm("[Level]: Missing textures. Replacing by default", FDLog.LogLevel.WARNING)
## [/codeblock]
func logm(message: String, level: LogLevel = LogLevel.INFO) -> void:
	_log_message(message, level)


## This method is similar to [method logm], but shortened to call only
## [code]TRACE[/code] level from [enum LogLevel].[br][br]This is an anternative
## to log messages instead of call [code]FDLog.logm(message, FDLog.LogLevel.TRACE)[/code]
func log_trace(message: String) -> void:
	_log_message(message, LogLevel.TRACE)


## This method is similar to [method logm], but shortened to call only
## [code]DEBUG[/code] level from [enum LogLevel].[br][br]This is an anternative
## to log messages instead of call [code]FDLog.logm(message, FDLog.LogLevel.DEBUG)[/code]
func log_debug(message: String) -> void:
	_log_message(message, LogLevel.DEBUG)


## This method is similar to [method logm], but shortened to call only
## [code]INFO[/code] level from [enum LogLevel].[br][br]This is an anternative
## to log messages instead of call [code]FDLog.logm(message, FDLog.LogLevel.INFO)[/code]
func log_info(message: String) -> void:
	_log_message(message, LogLevel.INFO)


## This method is similar to [method logm], but shortened to call only
## [code]NOTICE[/code] level from [enum LogLevel].[br][br]This is an anternative
## to log messages instead of call [code]FDLog.logm(message, FDLog.LogLevel.NOTICE)[/code]
func log_notc(message: String) -> void:
	_log_message(message, LogLevel.NOTICE)


## This method is similar to [method logm], but shortened to call only
## [code]WARNING[/code] level from [enum LogLevel].[br][br]This is an anternative
## to log messages instead of call [code]FDLog.logm(message, FDLog.LogLevel.WARNING)[/code]
func log_warn(message: String) -> void:
	_log_message(message, LogLevel.WARNING)


## This method is similar to [method logm], but shortened to call only
## [code]ERROR[/code] level from [enum LogLevel].[br][br]This is an anternative
## to log messages instead of call [code]FDLog.logm(message, FDLog.LogLevel.ERROR)[/code]
func log_err(message: String) -> void:
	_log_message(message, LogLevel.ERROR)


## This method is similar to [method logm], but shortened to call only
## [code]CRITICAL[/code] level from [enum LogLevel].[br][br]This is an anternative
## to log messages instead of call [code]FDLog.logm(message, FDLog.LogLevel.CRITICAL)[/code]
func log_crit(message: String) -> void:
	_log_message(message, LogLevel.CRITICAL)


## @deprecated: Prefer using [method logm] instead. For short method call, use:
## [method log_trace], [method log_debug], [method log_info], [method log_notc],
## [method log_warn], [method log_err] or [method log_crit].
func log_message(message: String, level: LogLevel = LogLevel.INFO) -> void:
	_log_message(message, level)


func can_print_log_level() -> bool:
	return ProjectSettings.get_setting(SettingPath.PRINT_LOG_LEVEL, true)


func is_level_enabled(level: LogLevel) -> bool:
	return ProjectSettings.get_setting(SettingPath.ENABLE_LEVEL[level], true)


func get_default_style_setting(level: LogLevel, setting: StringName) -> Variant:
	return DefaultStyle[level].get(setting, DEFAULT_SETTINGS.get(setting))


func get_style_setting(level: LogLevel, setting: StringName) -> Variant:
	return ProjectSettings.get_setting(
		SettingPath.LOG_STYLE[level][setting],
		get_default_style_setting(level, setting)
	)


func get_log_style(level: LogLevel) -> LogStyle:
	return LogStyle.new(
		get_style_setting(level, &"color"),
		get_style_setting(level, &"bg_color"),
		get_style_setting(level, &"fg_color"),
		get_style_setting(level, &"bold"),
		get_style_setting(level, &"italic"),
		get_style_setting(level, &"underlined"),
		get_style_setting(level, &"strikethrough"),
	)

# ------------------------------------------------------------------------------

func _log_message(message: String, level: LogLevel = LogLevel.INFO) -> void:
	if not is_level_enabled(level):
		return
	var datetime_dict: Dictionary = Time.get_datetime_dict_from_system()
	var timestamp: String = (
			Time.get_datetime_string_from_datetime_dict(datetime_dict, true))
	var style: LogStyle = get_log_style(level)
	if can_print_log_level():
		var level_string: String = LogLevel.keys().get(level)
		message = "[%s]: %s" % [level_string, message]
	if level == LogLevel.WARNING:
		push_warning("[%s]: %s" % [timestamp, message])
	elif level == LogLevel.ERROR or level == LogLevel.CRITICAL:
		push_error("[%s]: %s" % [timestamp, message])
	print_rich(style.get_stylized_text("[%s]: %s" % [timestamp, message]))
	if _current_file_path.is_empty():
		var file_name: String = _get_log_file_filename(datetime_dict)
		_current_file_path = ProjectSettings.get_setting(
			SettingPath.LOG_FILE_ROOT_DIR,
			OS.get_user_data_dir()
		) + "/" + file_name
	if not _log_to_file(_current_file_path, "[%s]: %s" % [timestamp, message]):
		push_error("[%s]: [%s]: %s" % [
			timestamp,
			LogLevel.keys()[LogLevel.ERROR],
			"Error while logging to file!"
		])


func _get_log_file_filename(datetime_dict: Dictionary) -> String:
	var prefix: String = ProjectSettings.get_setting(
		SettingPath.LOG_FILE_NAME_PREFIX, DEFAULT_LOG_FILE_NAME_PREFIX
	)
	if not prefix.is_valid_filename():
		prefix = DEFAULT_LOG_FILE_NAME_PREFIX
	var filename: String = "%s_%02d%02d%02d_%02d%02d%02d.%s" % [
		prefix,
		datetime_dict.get(&"year", ""),
		datetime_dict.get(&"month", ""),
		datetime_dict.get(&"day", ""),
		datetime_dict.get(&"hour", ""),
		datetime_dict.get(&"minute", ""),
		datetime_dict.get(&"second", ""),
		LOG_FILE_EXTENSION
	]
	return filename


func _log_to_file(file_path: String, content: String) -> bool:
	if Engine.is_editor_hint():
		return true
	if not FileAccess.file_exists(file_path):
		if not DirAccess.make_dir_recursive_absolute(file_path.get_base_dir()) == OK:
			return false
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		if file == null:
			return false
		file.store_line(content)
		file.close()
		return true
	var file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	if file == null:
		return false
	file.seek_end()
	file.store_line(content)
	file.close()
	return true

# ------------------------------------------------------------------------------

class LogStyle extends Resource:
	var color: Color = DEFAULT_COLOR
	var bg_color: Color = DEFAULT_BG_COLOR
	var fg_color: Color = DEFAULT_FG_COLOR
	var bold: bool = DEFAULT_BOLD
	var italic: bool = DEFAULT_ITALIC
	var underlined: bool = DEFAULT_UNDERLINED
	var strikethrough: bool = DEFAULT_STRIKETHROUGH


	func _init(
		color: Color = DEFAULT_COLOR,
		bg_color: Color = DEFAULT_BG_COLOR,
		fg_color: Color = DEFAULT_FG_COLOR,
		bold: bool = DEFAULT_BOLD,
		italic: bool = DEFAULT_ITALIC,
		underlined: bool = DEFAULT_UNDERLINED,
		strikethrough: bool = DEFAULT_STRIKETHROUGH
	) -> void:
		self.color = color
		self.bg_color = bg_color
		self.fg_color = fg_color
		self.bold = bold
		self.italic = italic
		self.underlined = underlined
		self.strikethrough = strikethrough


	static func create(args: Dictionary) -> LogStyle:
		return LogStyle.new(
			args.get(&"color", DEFAULT_COLOR),
			args.get(&"bg_color", DEFAULT_BG_COLOR),
			args.get(&"fg_color", DEFAULT_FG_COLOR),
			args.get(&"bold", DEFAULT_BOLD),
			args.get(&"italic", DEFAULT_ITALIC),
			args.get(&"underlined", DEFAULT_UNDERLINED),
			args.get(&"strikethrough", DEFAULT_STRIKETHROUGH)
		)


	func is_equal_to(style: LogStyle) -> bool:
		const PROPERTIES: Array[StringName] = [
			&"color",
			&"bg_color",
			&"fg_color",
			&"bold",
			&"italic",
			&"underlined",
			&"strikethrough"
		]
		for property: StringName in PROPERTIES:
			if not (get(property) == style.get(property)):
				return false
		return true


	func apply_color(color: Color) -> LogStyle:
		self.color = color
		return self


	func apply_bg_color(bg_color: Color) -> LogStyle:
		self.bg_color = bg_color
		return self


	func apply_fg_color(fg_color: Color) -> LogStyle:
		self.fg_color = fg_color
		return self


	func apply_bold(bold: bool) -> LogStyle:
		self.bold = bold
		return self


	func apply_italic(italic: bool) -> LogStyle:
		self.italic = italic
		return self


	func apply_underlined(underlined: bool) -> LogStyle:
		self.underlined = underlined
		return self


	func apply_strikethrough(strikethrough: bool) -> LogStyle:
		self.strikethrough = strikethrough
		return self


	func get_stylized_text(text: String) -> String:
		var style_string_begin: String = "[color=#%s]" % [color.to_html()]
		var style_string_end: String = "[/color]"
		if not is_zero_approx(bg_color.a):
			style_string_begin += "[bgcolor=#%s]" % [bg_color.to_html()]
			style_string_end = "[/bgcolor]" + style_string_end
		if not is_zero_approx(fg_color.a):
			style_string_begin += "[fgcolor=#%s]" % [fg_color.to_html()]
			style_string_end = "[/fgcolor]" + style_string_end
		style_string_begin += (
			"[b]" if bold else ""
			+ "[i]" if italic else ""
			+ "[u]" if underlined else ""
			+ "[s]" if strikethrough else ""
		)
		style_string_end = (
			"[/s]" if strikethrough else ""
			+ "[/u]" if underlined else ""
			+ "[/i]" if italic else ""
			+ "[/b]" if bold else ""
		) + style_string_end
		return style_string_begin + text + style_string_end
