extends Area2D

@export var cheese_name: String = "Cheese Name"
@export var id: EventManager.cheese_ids

func _ready():
	if EventManager.is_cheese_collected(id):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	EventManager.cheese_collected(id)
	queue_free()
