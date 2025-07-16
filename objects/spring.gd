extends Area2D

@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collider: CollisionShape2D = $Collider

@export var spring_power = 1.5
@export var sliding_spring_power = 1
@export var sliding_spring_boost = 2.3

var player

func _ready() -> void:
	animation_player.play("Idle")


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if animation_player.current_animation == "Idle":
			animation_player.play("Bounce")
			player = body
			body.air_jumped = true
			if body.is_crouching and body.direction != 0:
				body.velocity.x = body.speed * sliding_spring_boost * body.direction
				body.velocity.y = body.jump_velocity * sliding_spring_power
			else:
				body.velocity.y = body.jump_velocity * spring_power
			



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bounce":
		animation_player.play("Reset")
		player.air_jumped = false
	if anim_name == "Reset":
		animation_player.play("Idle")
