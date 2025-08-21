class_name Breakable extends StaticBody2D
@onready var solid_collider: CollisionShape2D = $SolidCollider
@onready var break_particles: CPUParticles2D = $BreakParticles
@onready var sprite: Sprite2D = $Sprite
@onready var break_sound: AudioStreamPlayer2D = $BreakSound

var player
var is_in_area = false
var broken = false

func _ready() -> void:
	player = PlayerManager.get_child(0)

func _process(delta: float) -> void:
	if is_in_area and player.is_drop_falling and not broken:
		destroy()

func destroy():
	broken = true
	break_particles.emitting = true
	break_sound.pitch_scale = randf_range(0.8, 1.1)
	break_sound.play()
	sprite.hide()
	solid_collider.set_deferred("disabled", true)
	player.do_shake("break")
	if player.velocity.y > 0:
		player.velocity.y = 0
	if not Input.is_action_pressed("move_drop"):
		player.is_drop_falling = false
	await break_particles.finished
	queue_free()


func _on_drop_area_body_entered(body: Node2D) -> void:
	is_in_area = true
	if body.is_drop_falling or body.drop_land_timer.time_left > 0:
		destroy()



func _on_drop_area_body_exited(body: Node2D) -> void:
	is_in_area = false
