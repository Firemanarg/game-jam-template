extends Node

# ------------------------------------------------------------------------------

enum ConstraintMode {
	WHITELIST, ## Only allow exection for actions in _whitelist_actions
	BLACKLIST, ## Deny execution of actions in _blacklist_actions
}


var _default_actions: ActionList = null
var _override_actions: ActionList = null

var _enable_default_actions: bool = true
var _enable_override_actions: bool = true

var _constraint_mode: ConstraintMode = ConstraintMode.BLACKLIST
var _blacklist_actions: Dictionary[StringName, Array] = {} # { &"context": [&"action"] }
var _whitelist_actions: Dictionary[StringName, Array] = {} # { &"context": [&"action"] }

# ------------------------------------------------------------------------------

func _ready() -> void:
	_setup()


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass

# ------------------------------------------------------------------------------

func set_override_actions(action_list: ActionList) -> void:
	_set_override_actions(action_list)


func set_default_actions(action_list: ActionList) -> void:
	_set_default_actions(action_list)


func create(callable: Callable) -> ActionResponse:
	return ActionResponse.new(callable)


func trigger(
		context: StringName, action_name: StringName, args: Array = []) -> bool:
	return _trigger(context, action_name, args)

# ------------------------------------------------------------------------------

func _trigger(
		context: StringName, action_name: StringName, args: Array = []) -> bool:
	if context.is_empty() or action_name.is_empty():
		return false
		# Trigger action from override actions
	if _enable_override_actions:
		if _trigger_from_override(context, action_name, args):
			return true
	else:
		FDLog.log_message(
				"[Action]: Override actions are disabled. Attempting to " \
				+ "get from default actions.", FDLog.LogLevel.DEBUG)

		# Trigger action from default actions
	if _enable_default_actions:
		if _trigger_from_default(context, action_name, args):
			return true
	else:
		FDLog.log_message(
				"[Action]: Default actions are disabled. No action was " \
				+ "triggered.", FDLog.LogLevel.DEBUG)
	return false


func _trigger_from_override(
		context: StringName, action_name: StringName, args: Array = []) -> bool:
	var action: Action.ActionResponse = _get_action_from_override(context, action_name)
	if action:
		FDLog.log_message(
				"[Action]: Triggered override action " \
				+ "[%s->%s]." % [context, action_name])
		action.execute(args)
		return true
	FDLog.log_message(
			"[Action]: Action not found in override actions. Attempting to " \
			+ "get from default actions.", FDLog.LogLevel.DEBUG)
	return false


func _trigger_from_default(
		context: StringName, action_name: StringName, args: Array = []) -> bool:
	var action: Action.ActionResponse = _get_action_from_default(context, action_name)
	if not action:
		FDLog.log_message(
				"[Action]: Action [%s->%s] not found. " % [context, action_name]
				+ "No action was triggered.")
		return false
	FDLog.log_message(
			"[Action]: Triggered default action [%s->%s]." % [context, action_name])
	action.execute(args)
	return true


func _set_override_actions(action_list: ActionList) -> void:
	FDLog.log_message(
			"[Action]: Setting override actions value.", FDLog.LogLevel. DEBUG)
	if _override_actions:
		remove_child(_override_actions)
	_override_actions = action_list
	add_child(_override_actions)


func _set_default_actions(action_list: ActionList) -> void:
	FDLog.log_message(
			"[Action]: Setting default actions value.", FDLog.LogLevel. DEBUG)
	if _default_actions:
		remove_child(_default_actions)
	_default_actions = action_list
	add_child(_default_actions)


func _get_action_from_default(
		context: StringName, action_name: StringName) -> Action.ActionResponse:
	if not _default_actions:
		FDLog.log_message(
				("[Action]: Attempting to get action [%s->%s] from default "
				+ "actions, but it is not set.") % [context, action_name],
				FDLog.LogLevel.DEBUG)
		return null
	return _default_actions.get_action(context, action_name)


func _get_action_from_override(
		context: StringName, action_name: StringName) -> Action.ActionResponse:
	if not _override_actions:
		FDLog.log_message(
				("[Action]: Attempting to get action [%s->%s] from override "
				+ "actions, but it is not set.") % [context, action_name],
				FDLog.LogLevel.DEBUG)
		return null
	return _override_actions.get_action(context, action_name)


func _is_action_allowed(context: StringName, action_name: StringName) -> bool:
	if _constraint_mode == ConstraintMode.WHITELIST:
		return _whitelist_actions.get(context, {}).has(action_name)

	elif _constraint_mode == ConstraintMode.BLACKLIST:
		return not _blacklist_actions.get(context, {}).has(action_name)

	return false


func _setup() -> void:
	var default_action_list = (
			ProjectSettings.get_setting_with_override(
					"Action/default_actions_script_path"))
	var enable_default_actions = (
			ProjectSettings.get_setting_with_override(
					"Action/enable_default_actions"))
	var override_action_list = (
			ProjectSettings.get_setting_with_override(
					"Action/override_actions_script_path"))
	var enable_override_actions = (
			ProjectSettings.get_setting_with_override(
					"Action/enable_override_actions"))
	if default_action_list == null:
		FDLog.log_message(
				"[ActionManager]: Default Action List is not defined.",
				FDLog.LogLevel.NOTICE)
	if enable_default_actions == null:
		FDLog.log_message(
				"[ActionManager]: Flag 'enable_default_actions' not found. "
				+ "Setting it to 'true'.",
				FDLog.LogLevel.WARNING)
		enable_default_actions = true
	if override_action_list == null:
		FDLog.log_message(
				"[ActionManager]: Override Action List is not defined.",
				FDLog.LogLevel.NOTICE)
	if enable_override_actions == null:
		FDLog.log_message(
				"[ActionManager]: Flag 'enable_override_actions' not found. "
				+ "Setting it to 'true'.",
				FDLog.LogLevel.WARNING)
		enable_override_actions = true
	if default_action_list:
		_default_actions = load(default_action_list).new()
	else:
		_default_actions = null
	_enable_default_actions = enable_default_actions
	if override_action_list:
		_override_actions = load(override_action_list).new()
	else:
		_override_actions = null
	_enable_override_actions = enable_override_actions

# ------------------------------------------------------------------------------

class ActionResponse extends Resource:
	var _callable: Callable = (
			func(): FDLog.log_message(
					"[ActionResponse]: Default callable was called.",
					FDLog.LogLevel.TRACE))


	func _init(callable: Callable) -> void:
		_callable = callable


	func execute(args: Array) -> void:
		_callable.callv(args)
