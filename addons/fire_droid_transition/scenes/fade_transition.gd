@tool
extends FDTransition


@export_group("Fade Setup")
@export var use_texture: bool = false:
	set = _set_use_texture
var color: Color = Color.BLACK:
	set = _set_color
var texture: Texture2D = null:
	set = _set_texture

@onready var color_rect: ColorRect = get_node("ColorRect")
@onready var texture_rect: TextureRect = get_node("TextureRect")


func _ready() -> void:
	pass


func _property_can_revert(property: StringName) -> bool:
	if property == &"texture" or property == &"color":
		return true
	return false


func _property_get_revert(property: StringName) -> Variant:
	if property == &"texture": return null
	elif property == &"color": return Color.BLACK
	return null


func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		&"name": &"Fade Setup",
		&"type": TYPE_NIL,
		&"usage": PROPERTY_USAGE_GROUP
	})
	if use_texture:
		properties.append({
			&"name": &"texture",
			&"type": TYPE_OBJECT,
			&"hint": PROPERTY_HINT_RESOURCE_TYPE,
			&"hint_string": "Texture2D"
		})
	else:
		properties.append({
			&"name": &"color",
			&"type": TYPE_COLOR,
		})
	return properties


# Overridable
func _on_play_in(ratio: float) -> void:
	color_rect.modulate.a = ratio
	texture_rect.modulate.a = ratio


# Overridable
func _on_play_out(ratio: float) -> void:
	color_rect.modulate.a = ratio
	texture_rect.modulate.a = ratio


func _set_use_texture(value: bool) -> void:
	use_texture = value
	notify_property_list_changed()
	if is_node_ready():
		color_rect.color = color
		color_rect.set_visible(not use_texture)
		texture_rect.set_visible(use_texture)


func _setup_play_in() -> void:
	color_rect.set_color(color)
	texture_rect.set_texture(texture)


func _setup_play_out() -> void:
	color_rect.set_color(color)
	texture_rect.set_texture(texture)


func _set_color(value: Color) -> void:
	color = value
	if is_node_ready():
		color_rect.set_color(color)


func _set_texture(value: Texture2D) -> void:
	texture = value
	if is_node_ready():
		texture_rect.set_texture(texture)
