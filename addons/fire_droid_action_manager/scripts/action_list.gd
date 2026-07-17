class_name ActionList
extends Node

# ------------------------------------------------------------------------------

var _actions: Dictionary[StringName, Dictionary] = {}

# ------------------------------------------------------------------------------

# Initialize _actions on _init
func _init() -> void:
	pass

# ------------------------------------------------------------------------------

func get_action(
		context: StringName, action_name: StringName) -> Action.ActionResponse:
	return _get_action(context, action_name)

# ------------------------------------------------------------------------------

func _get_action(
		context: StringName, action_name: StringName) -> Action.ActionResponse:
	return _actions.get(context, {}).get(action_name)
