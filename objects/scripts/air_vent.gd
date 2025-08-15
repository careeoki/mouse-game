@tool
extends Area2D

@export_category("Size")
@export var width = 1
@export var height = 1

@export_category("Power")
@export var is_power_type = false
@export var powered = false

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collider: CollisionShape2D = $Collider
@onready var wind_anim: Sprite2D = $WindAnim
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var wind: Vector2 = Vector2(0, -10000)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.connect("change_power_state", change_state)
	update_shape()
	if is_power_type:
		if powered:
			sprite.play("on")
		else:
			sprite.play("off")
			wind_anim.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_shape()
	if not is_power_type or powered:
		var bodies = get_overlapping_bodies()
		if bodies.size() > 0:
			bodies[0].wind_power = wind


func _on_body_exited(body: Node2D) -> void:
	if not is_power_type or powered:
		body.wind_power = Vector2.ZERO


func _on_body_entered(body: Node2D) -> void:
	if not is_power_type or powered:
		if body.is_drop_falling:
			body.is_drop_falling = false
		if body.velocity.y > 0:
			body.velocity.y *= 0.3

func change_state():
	if is_power_type:
		if powered:
			powered = false
			sprite.play("off")
			wind_anim.visible = false
		else:
			powered = true
			sprite.play("on")
			wind_anim.visible = true

func update_shape():
	sprite.scale.x = width
	var shape = RectangleShape2D.new()
	shape.size = Vector2(width * 128, height * 128)
	collider.set_shape(shape)
	collider.position.y = height * 128 / -2
	wind_anim.region_rect = Rect2(0, 0, 384 * width, 128 * height)
	wind_anim.position.y = height * 128 / -2
	animation_player.play("wind")
