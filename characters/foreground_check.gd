extends Area2D

@onready var player: Player = $".."

func _on_body_entered(body: Node2D) -> void:
	player.is_on_foreground = true


func _on_body_exited(body: Node2D) -> void:
	player.is_on_foreground = false
