class_name ActionArea3D
extends Area3D

# ------------------------------------------------------------------------------

@export var context: StringName = &""

@export_group("Area Actions")
@export_subgroup("Area Entered")
@export var area_entered_action: StringName = &""
@export var area_entered_action_args: Array = []
@export_subgroup("Area Exited")
@export var area_exited_action: StringName = &""
@export var area_exited_action_args: Array = []
@export_subgroup("Area Shape Entered")
@export var area_shape_entered_action: StringName = &""
@export var area_shape_entered_action_args: Array = []
@export_subgroup("Area Shape Exited")
@export var area_shape_exited_action: StringName = &""
@export var area_shape_exited_action_args: Array = []

@export_group("Body Actions")
@export_subgroup("Body Entered")
@export var body_entered_action: StringName = &""
@export var body_entered_action_args: Array = []
@export_subgroup("Body Exited")
@export var body_exited_action: StringName = &""
@export var body_exited_action_args: Array = []
@export_subgroup("Body Shape Entered")
@export var body_shape_entered_action: StringName = &""
@export var body_shape_entered_action_args: Array = []
@export_subgroup("Body Shape Exited")
@export var body_shape_exited_action: StringName = &""
@export var body_shape_exited_action_args: Array = []

# ------------------------------------------------------------------------------

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	area_shape_entered.connect(_on_area_shape_entered)
	area_shape_exited.connect(_on_area_shape_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	body_shape_entered.connect(_on_body_shape_entered)
	body_shape_exited.connect(_on_body_shape_exited)


func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass

# ------------------------------------------------------------------------------

func _on_area_entered(_area: Area3D) -> void:
	var args_array: Array = [_area] + area_entered_action_args
	Action.trigger(context, area_entered_action, args_array)


func _on_area_exited(_area: Area3D) -> void:
	var args_array: Array = [_area] + area_exited_action_args
	Action.trigger(context, area_exited_action, args_array)


func _on_area_shape_entered(
		area_rid: RID, area: Area3D,
		area_shape_index: int, local_shape_index: int) -> void:
	var args_array: Array = (
			[area_rid, area, area_shape_index, local_shape_index]
			+ area_shape_entered_action_args)
	Action.trigger(context, area_shape_entered_action, args_array)


func _on_area_shape_exited(
		area_rid: RID, area: Area3D,
		area_shape_index: int, local_shape_index: int) -> void:
	var args_array: Array = (
			[area_rid, area, area_shape_index, local_shape_index]
			+ area_shape_exited_action_args)
	Action.trigger(context, area_shape_exited_action, args_array)


func _on_body_entered(_area: Area3D) -> void:
	var args_array: Array = [_area] + body_entered_action_args
	Action.trigger(context, body_entered_action, args_array)


func _on_body_exited(_area: Area3D) -> void:
	var args_array: Array = [_area] + body_exited_action_args
	Action.trigger(context, body_exited_action, args_array)


func _on_body_shape_entered(
		body_rid: RID, body: Area3D,
		body_shape_index: int, local_shape_index: int) -> void:
	var args_array: Array = (
			[body_rid, body, body_shape_index, local_shape_index]
			+ body_shape_entered_action_args)
	Action.trigger(context, body_shape_entered_action, args_array)


func _on_body_shape_exited(
		body_rid: RID, body: Area3D,
		body_shape_index: int, local_shape_index: int) -> void:
	var args_array: Array = (
			[body_rid, body, body_shape_index, local_shape_index]
			+ body_shape_exited_action_args)
	Action.trigger(context, body_shape_exited_action, args_array)
