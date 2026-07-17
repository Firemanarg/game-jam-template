class_name ActionTextureButton
extends TextureButton

# ------------------------------------------------------------------------------

@export var context: StringName = &""

@export_group("Pressed Action")
@export var pressed_action: StringName = &""
@export var pressed_action_args: Array = []

@export_group("Button Up Action")
@export var button_up_action: StringName = &""
@export var button_up_action_args: Array = []

@export_group("Button Down Action")
@export var button_down_action: StringName = &""
@export var button_down_action_args: Array = []

@export_group("Toggled Action")
@export var toggled_action: StringName = &""
@export var toggled_action_args: Array = []

# ------------------------------------------------------------------------------

func _ready() -> void:
	pressed.connect(_on_pressed)
	button_up.connect(_on_button_up)
	button_down.connect(_on_button_down)
	toggled.connect(_on_toggled)

# ------------------------------------------------------------------------------

func _on_pressed() -> void:
	Action.trigger(context, pressed_action, pressed_action_args)


func _on_button_up() -> void:
	Action.trigger(context, button_up_action, button_up_action_args)


func _on_button_down() -> void:
	Action.trigger(context, button_down_action, button_down_action_args)


func _on_toggled(toggled_on: bool) -> void:
	var args_array: Array = [toggled_on] + toggled_action_args
	Action.trigger(context, toggled_action, args_array)
