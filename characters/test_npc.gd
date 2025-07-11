extends AnimatedSprite2D

@onready var player = get_tree().get_first_node_in_group("Player")

var player_present = false

func _process(delta: float) -> void:
	if player_present:
		if Input.is_action_just_pressed("interact"):
			do_dialog()

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("in randge")
	player_present = true
	
func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	player_present = false

func do_dialog():
	print("die a log")
