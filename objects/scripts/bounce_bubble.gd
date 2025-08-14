extends Area2D

@onready var jump_node: Area2D = $"."
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var buffer_timer: Timer = $BufferTimer
@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var player
var is_in_area
var buffer
var is_cooldown = false

func _ready() -> void:
	animation_player.play("Idle")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_jump"):
		if is_in_area:
			air_jump()
		else:
			buffer = true
			buffer_timer.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		is_in_area = true
	if buffer:
		air_jump()
		print("did a buffer")

func air_jump():
	if not is_cooldown:
		player.air_jumped = true
		player.velocity.y = player.jump_velocity * 1.1
		if player.direction == 1 and player.velocity.x < player.speed:
			player.velocity.x = player.speed
		elif player.direction == -1 and player.velocity.x > -player.speed:
			player.velocity.x = -player.speed
		player.is_drop = false
		player.is_drop_falling = false
		player.drop_timer.stop()
		player.maintained_momentum = 0
		animation_player.play("Pop")
		is_cooldown = true

func _on_body_exited(body: Node2D) -> void:
	coyote_timer.start()


func _on_coyote_timer_timeout() -> void:
	is_in_area = false

func _on_buffer_timer_timeout() -> void:
	buffer = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Pop":

		animation_player.play("Reform")
	if anim_name == "Reform":
		is_cooldown = false
		animation_player.play("Idle")
