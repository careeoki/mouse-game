extends StaticBody2D
@onready var solid_collider: CollisionShape2D = $SolidCollider

#var player
#
#func _ready() -> void:
	#player = PlayerManager.get_child(0)
#
#func _process(delta: float) -> void:
	#if player.is_drop_falling:
		#solid_collider.set_deferred("disabled", true)
	#else:
		#solid_collider.set_deferred("disabled", false)

func _on_drop_area_body_entered(body: Node2D) -> void:
	if body.is_drop_falling or body.drop_land_timer.time_left > 0:
		#if body.velocity.y > 0:
			#body.velocity.y -= 1500
		queue_free()
		#if not Input.is_action_pressed("move_drop"):
			#body.is_drop_falling = false
		#else:
			#body.do_drop_fall()
