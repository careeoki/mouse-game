extends Area2D


var player

func _on_body_entered(body: Node2D) -> void:
	player = get_parent().get_node("Player")
	player.spawn_position = position
