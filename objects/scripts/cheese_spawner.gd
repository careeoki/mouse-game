extends Node2D

@export var cheese_name: String = "Spawned Cheese"

@onready var cheese_outline: Sprite2D = $CheeseOutline
@onready var focus_transform: RemoteTransform2D = $FocusTransform
@onready var timer: Timer = $Timer

const CHEESE = preload("res://objects/cheese.tscn")

var cheese

func _ready() -> void:
	EventManager.connect("camera_tween_finished", spawn_cheese)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		PlayerManager.camera.tween_to_pos(self)

func spawn_cheese():
	timer.start()
	
	cheese_outline.hide()
	cheese = CHEESE.instantiate()
	add_child(cheese)
	cheese.cheese_name = cheese_name




func _on_timer_timeout() -> void:
	PlayerManager.camera.return_focus(focus_transform)
