@tool
extends FDTransition


@export var color_1: Color = Color.WHITE:
	set = _set_color_1
@export var color_2: Color = Color.BLACK:
	set = _set_color_2
@export var strips_width: float = 20.0:
	set = _set_strips_width

@onready var color_rect: ColorRect = get_node("ColorRect")


func _ready() -> void:
	pass


func _setup_play_in() -> void:
	pass


func _setup_play_out() -> void:
	pass


func _on_play_in(ratio: float) -> void:
	color_rect.material.set_shader_parameter(&"ratio", ratio)


func _on_play_out(ratio: float) -> void:
	color_rect.material.set_shader_parameter(&"ratio", ratio)


func _set_color_1(value: Color) -> void:
	color_1 = value
	if is_node_ready():
		color_rect.material.set_shader_parameter(&"color_1", color_1)


func _set_color_2(value: Color) -> void:
	color_2 = value
	if is_node_ready():
		color_rect.material.set_shader_parameter(&"color_2", color_2)


func _set_strips_width(value: float) -> void:
	strips_width = value
	if is_node_ready():
		color_rect.material.set_shader_parameter(&"strips_width", strips_width)
