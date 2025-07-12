extends Area2D

@export var value: int = 1


func _on_body_entered(body: Node2D) -> void:
	EventManager.cracker_collected(value)
	queue_free()
