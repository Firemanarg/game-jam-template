@tool
extends FDTransition


@export var dots_size: float = 10.0:
	set = _set_dots_size
@export var invert_circles: bool = true:
	set = _set_invert_circles
@export var color: Color = Color.BLACK:
	set = _set_color

@onready var color_rect: ColorRect = get_node("ColorRect")


func _ready() -> void:
	pass


func _setup_play_in() -> void:
	color_rect.material.set_shader_parameter(&"invert_circles", invert_circles)
	color_rect.material.set_shader_parameter(&"dots_size", dots_size)
	color_rect.material.set_shader_parameter(&"height", _get_min_height())


func _setup_play_out() -> void:
	color_rect.material.set_shader_parameter(&"invert_circles", invert_circles)
	color_rect.material.set_shader_parameter(&"dots_size", dots_size)
	color_rect.material.set_shader_parameter(&"height", _get_max_height())


func _on_play_in(ratio: float) -> void:
	var height: float = lerp(_get_min_height(), _get_max_height(), ratio)
	color_rect.material.set_shader_parameter(&"height", height)


func _on_play_out(ratio: float) -> void:
	var height: float = lerp(_get_min_height(), _get_max_height(), ratio)
	color_rect.material.set_shader_parameter(&"height", height)


func _get_min_height() -> float:
	const MIN_HEIGHT_DEFAULT: float = -0.5
	const MIN_HEIGHT_WHEN_INVERTED: float = -1.0
	return MIN_HEIGHT_WHEN_INVERTED if invert_circles else MIN_HEIGHT_DEFAULT


func _get_max_height() -> float:
	const MAX_HEIGHT_DEFAULT: float = 1.0
	const MAX_HEIGHT_WHEN_INVERTED: float = 0.5
	return MAX_HEIGHT_WHEN_INVERTED if invert_circles else MAX_HEIGHT_DEFAULT


func _set_invert_circles(value: bool) -> void:
	invert_circles = value
	if is_node_ready():
		color_rect.material.set_shader_parameter(&"invert_circles", invert_circles)


func _set_color(value: Color) -> void:
	color = value
	if is_node_ready():
		color_rect.material.set_shader_parameter(&"color", color)


func _set_dots_size(value: float) -> void:
	dots_size = value
	if is_node_ready():
		color_rect.material.set_shader_parameter(&"dots_size", dots_size)
