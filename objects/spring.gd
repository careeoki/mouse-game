extends Area2D

@export var spring_power = -3500


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if Input.is_action_pressed("move_jump"):
			body.velocity.y = spring_power * 1.5
		else:
			body.velocity.y = spring_power
