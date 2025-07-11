extends Area2D

@export var cheese_name: String = "Cheese Name"

signal collected(cheese_name)

func _on_area_entered(area: Area2D) -> void:
	print(cheese_name)
	queue_free()
	
