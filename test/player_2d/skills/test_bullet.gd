extends CharacterBody2D


@export var speed: float = 50000.0
@export var lifetime: float = 5.0

var direction: Vector2 = Vector2(0, 0)


func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity = direction.normalized() * speed * delta
	move_and_slide()
