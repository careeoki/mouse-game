extends Area2D

@onready var door: Area2D = $"."

@export var scene: String = "next scence"
@export var next_position: Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_up"):
		var actionables = door.get_overlapping_bodies()
		if actionables.size() > 0:
			print("go door")
			get_tree().change_scene_to_file(scene)
			
			return

#func _on_body_entered(body: Node2D) -> void:
	#get_tree().change_scene_to_file(scene)
