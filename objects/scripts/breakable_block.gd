class_name Breakable extends StaticBody2D
@onready var solid_collider: CollisionShape2D = $SolidCollider
@onready var break_particles: CPUParticles2D = $BreakParticles
@onready var sprite: Sprite2D = $Sprite
@onready var break_sound: AudioStreamPlayer2D = $BreakSound

@export var health: int = 2

var rng = RandomNumberGenerator.new()
var shake_strength: Vector2 = Vector2(0.0, 0.0)
var shake_falloff = 10.0

var player
var is_in_area = false
var just_damaged = false
var broken = false

func _ready() -> void:
	player = PlayerManager.get_child(0)

func _process(delta: float) -> void:
	if is_in_area and player.is_drop_falling and not broken and not just_damaged:
		damage()
	if just_damaged:
		if not player.is_drop_falling and not player.is_tail_spinning and player.drop_land_timer.time_left == 0:
			just_damaged = false
	
	if shake_strength > Vector2.ZERO:
		shake_strength.x = lerpf(shake_strength.x, 0, shake_falloff * delta)
		shake_strength.y = lerpf(shake_strength.y, 0, shake_falloff * delta)
		sprite.offset = randomOffset()

func damage():
	if not just_damaged:
		just_damaged = true
		health -= 1
		if health == 1:
			sprite.frame = 1
		if health == 0:
			destroy()
		else:
			apply_shake()

func apply_shake():
	shake_strength = Vector2(16, 16)

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
	if not Input.is_action_pressed("move_attack"):
		player.is_drop_falling = false
	await break_particles.finished
	queue_free()


func _on_drop_area_body_entered(body: Node2D) -> void:
	is_in_area = true
	if body.is_drop_falling or body.drop_land_timer.time_left > 0 and not just_damaged:
		damage()



func _on_drop_area_body_exited(body: Node2D) -> void:
	is_in_area = false


func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength.x, shake_strength.x), randf_range(-shake_strength.y, shake_strength.y))
