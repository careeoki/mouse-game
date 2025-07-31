extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
	global_position = PlayerManager.get_child(0).global_position


func _on_animation_finished() -> void:
	queue_free()
