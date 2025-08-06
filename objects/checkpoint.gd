extends Area2D

@onready var respawn_point: Marker2D = $RespawnPoint

#var checkpoint_manager
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#checkpoint_manager = get_parent().get_parent().get_node("CheckpointManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player hit checkpoint")
		body.spawn_position = respawn_point.global_position
