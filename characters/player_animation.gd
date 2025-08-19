extends AnimatedSprite2D

@onready var player: Player = $".."
@onready var tail_end: RopeHandle = $"../Tail/HandleEnd"

var initial_tail_position
var did_fall_windup = false

func _ready() -> void:
	initial_tail_position = tail_end.position

func _physics_process(delta: float) -> void:
	tail_handling()
	if not player.is_dialog:
		if player.velocity.x and not player.is_dialog and player.is_on_floor():
			if player.is_p_speed:
				if abs(player.velocity.x) < player.p_speed:
					play("skid")
				else:
					play("p_speed")
			else:
				if player.velocity.x > 0 and player.direction == -1 or player.velocity.x < 0 and player.direction == 1:
					play("skid")
				else:
					play("walk")
					speed_scale = 1 + ((abs(player.velocity.x) - player.speed) / player.p_speed)
		elif player.is_on_floor():
			play("idle")
		
		if player.is_crouching:
			play("slide")
		
		if not player.is_on_floor() and not player.is_dying:
			if player.velocity.y < -100:
				play("jump")
			else:
				if player.is_wall_sliding:
					if player.wall_tired:
						play("wall_slide_tired")
					else:
						play("wall_slide")
				elif player.is_drop_falling:
					play("drop")
				elif animation == "jump":
					play("fall")
					speed_scale = 1
				elif not animation == "fall_loop" and not animation == "fall":
					play("fall_loop")
		
		if player.is_collecting:
			play("collect")
		if player.is_dying and not animation == "die_direction":
			play("die_direction")

func tail_handling():
	pass
	#if animation == "fall_loop":
		#tail_end.position.y = initial_tail_position.y - 500
		#tail_end.position.x = initial_tail_position.x - 200
	#elif not tail_end.position.y == initial_tail_position.y:
		#tail_end.position.y = initial_tail_position.y

func _on_animation_finished() -> void:
	if  animation == "fall":
		play("fall_loop")


func _on_animation_changed() -> void:
	speed_scale = 1
