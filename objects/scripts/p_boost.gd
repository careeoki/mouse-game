extends Area2D

enum dir {RIGHT, LEFT}
@export var direction: dir
var boost_direction

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	if direction == dir.RIGHT:
		boost_direction = 1
	else:
		boost_direction = -1
		sprite.flip_h = true
		
		

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity.x = 2500 * boost_direction
