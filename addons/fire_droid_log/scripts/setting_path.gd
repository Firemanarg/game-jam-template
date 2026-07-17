extends Node


const LOG_FILE_ROOT_DIR: String = "FDLog/log_config/log_file/log_file_root_dir"
const LOG_FILE_NAME_PREFIX: String = "FDLog/log_config/log_file/log_file_name_prefix"
const PRINT_LOG_LEVEL: String = "FDLog/log_style/print_log_level"
const ENABLE_LEVEL: Dictionary[FDLog.LogLevel, String] = {
	FDLog.LogLevel.TRACE: _ROOT_PATH_ENABLE_LEVEL + "enable_trace",
	FDLog.LogLevel.DEBUG: _ROOT_PATH_ENABLE_LEVEL + "enable_debug",
	FDLog.LogLevel.INFO: _ROOT_PATH_ENABLE_LEVEL + "enable_info",
	FDLog.LogLevel.NOTICE: _ROOT_PATH_ENABLE_LEVEL + "enable_notice",
	FDLog.LogLevel.WARNING: _ROOT_PATH_ENABLE_LEVEL + "enable_warning",
	FDLog.LogLevel.ERROR: _ROOT_PATH_ENABLE_LEVEL + "enable_error",
	FDLog.LogLevel.CRITICAL: _ROOT_PATH_ENABLE_LEVEL + "enable_critical",
}
const LOG_STYLE: Dictionary[FDLog.LogLevel, Dictionary] = {
	FDLog.LogLevel.TRACE: {
		&"color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.TRACE] + "color",
		&"bg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.TRACE] + "bg_color",
		&"fg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.TRACE] + "fg_color",
		&"bold": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.TRACE] + "bold",
		&"italic": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.TRACE] + "italic",
		&"underlined": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.TRACE] + "underlined",
		&"strikethrough": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.TRACE] + "strikethrough",
	},
	FDLog.LogLevel.DEBUG: {
		&"color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.DEBUG] + "color",
		&"bg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.DEBUG] + "bg_color",
		&"fg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.DEBUG] + "fg_color",
		&"bold": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.DEBUG] + "bold",
		&"italic": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.DEBUG] + "italic",
		&"underlined": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.DEBUG] + "underlined",
		&"strikethrough": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.DEBUG] + "strikethrough",
	},
	FDLog.LogLevel.INFO: {
		&"color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.INFO] + "color",
		&"bg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.INFO] + "bg_color",
		&"fg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.INFO] + "fg_color",
		&"bold": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.INFO] + "bold",
		&"italic": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.INFO] + "italic",
		&"underlined": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.INFO] + "underlined",
		&"strikethrough": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.INFO] + "strikethrough",
	},
	FDLog.LogLevel.NOTICE: {
		&"color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.NOTICE] + "color",
		&"bg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.NOTICE] + "bg_color",
		&"fg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.NOTICE] + "fg_color",
		&"bold": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.NOTICE] + "bold",
		&"italic": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.NOTICE] + "italic",
		&"underlined": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.NOTICE] + "underlined",
		&"strikethrough": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.NOTICE] + "strikethrough",
	},
	FDLog.LogLevel.WARNING: {
		&"color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.WARNING] + "color",
		&"bg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.WARNING] + "bg_color",
		&"fg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.WARNING] + "fg_color",
		&"bold": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.WARNING] + "bold",
		&"italic": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.WARNING] + "italic",
		&"underlined": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.WARNING] + "underlined",
		&"strikethrough": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.WARNING] + "strikethrough",
	},
	FDLog.LogLevel.ERROR: {
		&"color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.ERROR] + "color",
		&"bg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.ERROR] + "bg_color",
		&"fg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.ERROR] + "fg_color",
		&"bold": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.ERROR] + "bold",
		&"italic": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.ERROR] + "italic",
		&"underlined": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.ERROR] + "underlined",
		&"strikethrough": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.ERROR] + "strikethrough",
	},
	FDLog.LogLevel.CRITICAL: {
		&"color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.CRITICAL] + "color",
		&"bg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.CRITICAL] + "bg_color",
		&"fg_color": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.CRITICAL] + "fg_color",
		&"bold": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.CRITICAL] + "bold",
		&"italic": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.CRITICAL] + "italic",
		&"underlined": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.CRITICAL] + "underlined",
		&"strikethrough": _LEVEL_ROOT_PATH_LOG_STYLE[FDLog.LogLevel.CRITICAL] + "strikethrough",
	},
}

const _ROOT_PATH_ENABLE_LEVEL: String = "FDLog/log_config/enable_level/"
const _ROOT_PATH_LOG_STYLE: String = "FDLog/log_style/"
const _LEVEL_ROOT_PATH_LOG_STYLE: Dictionary[FDLog.LogLevel, String] = {
	FDLog.LogLevel.TRACE: _ROOT_PATH_LOG_STYLE + "trace_style/",
	FDLog.LogLevel.DEBUG: _ROOT_PATH_LOG_STYLE + "debug_style/",
	FDLog.LogLevel.INFO: _ROOT_PATH_LOG_STYLE + "info_style/",
	FDLog.LogLevel.NOTICE: _ROOT_PATH_LOG_STYLE + "notice_style/",
	FDLog.LogLevel.WARNING: _ROOT_PATH_LOG_STYLE + "warning_style/",
	FDLog.LogLevel.ERROR: _ROOT_PATH_LOG_STYLE + "error_style/",
	FDLog.LogLevel.CRITICAL: _ROOT_PATH_LOG_STYLE + "critical_style/",
}
