# meta-name: Default (no comments)
# meta-description: Initial script containing overridable methods needed to create custom Player2D scenes.
# meta-default: true
# meta-space-indent: 4
@tool
extends Player2D


func _init() -> void:
	super._init()


func _ready() -> void:
	super._ready()


func _process(delta: float) -> void:
	super._process(delta)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)


# Overridable
func _on_death() -> void:
	pass


# Overridable
func _on_attack(index: int, args: Array = []) -> void:
	pass
