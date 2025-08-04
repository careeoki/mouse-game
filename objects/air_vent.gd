@tool
extends Area2D

@export var width = 1
@export var height = 1

@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $Collider
@onready var wind_particles: CPUParticles2D = $WindParticles
@onready var wind_anim: Sprite2D = $WindAnim
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var wind: Vector2 = Vector2(0, -12000)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.scale.x = width
	var shape = RectangleShape2D.new()
	shape.size = Vector2(width * 128, height * 128)
	collider.set_shape(shape)
	collider.position.y = height * 128 / -2
	wind_anim.region_rect = Rect2(0, 0, 384 * width, 128 * height)
	wind_anim.position.y = height * 128 / -2
	animation_player.play("wind")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		bodies[0].wind_power = wind


func _on_body_exited(body: Node2D) -> void:
	body.wind_power = Vector2.ZERO


func _on_body_entered(body: Node2D) -> void:
	if body.velocity.y > 0:
		body.velocity.y *= 0.4
