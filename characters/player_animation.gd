extends AnimatedSprite2D

@onready var player: Player = $".."


func _physics_process(delta: float) -> void:
	if not player.is_dialog:
		if player.velocity.x and not player.is_dialog :
			if player.is_p_speed:
				play("p_speed")
			else:
				play("walk")
				speed_scale = 1 + ((abs(player.velocity.x) - player.speed) / player.p_speed)
		else:
			play("idle")
		if player.is_crouching:
			play("slide")
		if not player.is_on_floor():
			if player.velocity.y < 0:
				play("jump")
			else:
				if player.is_wall_sliding:
					play("wall_slide")
				else:
					play("fall")
		if player.is_collecting:
			play("collect")
		if player.is_dying:
			play("die")
