@tool
extends Area2D

@export var size = Vector2(1, 1)

@onready var collider: CollisionShape2D = $Collider
@onready var respawn_point: Marker2D = $RespawnPoint


func _ready() -> void:
	resize()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		resize()


func resize():
	var shape = RectangleShape2D.new()
	shape.size = Vector2(size.x * 128, size.y * 128)
	collider.set_shape(shape)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player hit checkpoint")
		body.spawn_position = respawn_point.global_position
