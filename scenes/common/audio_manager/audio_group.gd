class_name AudioGroup
extends Resource

# ------------------------------------------------------------------------------

@export var content: Dictionary[StringName, AudioStream] = {}
@export var bus_name: StringName = &"Master":
	set(new_name):
		bus_name = new_name
		update_bus_index()

var _bus_index: int = 0

# ------------------------------------------------------------------------------

func _init() -> void:
	update_bus_index()


# ------------------------------------------------------------------------------

func update_bus_index() -> void:
	_bus_index = max(0, AudioServer.get_bus_index(bus_name))


func get_content_stream(id: StringName) -> AudioStream:
	return content.get(id)

