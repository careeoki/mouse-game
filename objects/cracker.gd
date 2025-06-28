extends Area2D
@onready var sprite: AnimatedSprite2D = $Sprite

@export var value: int = 1

func _ready() -> void:
	sprite.play("default")

func _on_body_entered(body: Node2D) -> void:
	EventManager.cracker_collected(value)
	queue_free()
