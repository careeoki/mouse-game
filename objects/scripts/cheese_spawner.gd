extends Node2D


@onready var cheese_outline: Sprite2D = $CheeseOutline
@onready var focus_transform: RemoteTransform2D = $FocusTransform
@onready var timer: Timer = $Timer

var cheese

func _ready() -> void:
	EventManager.connect("camera_tween_finished", spawn_cheese)
	cheese = get_child(3)
	print(cheese)

#func _process(delta: float) -> void:
	#if Input.is_key_pressed(KEY_1):
		#PlayerManager.camera.tween_to_pos(self)

func focus():
	PlayerManager.camera.tween_to_pos(self)

func spawn_cheese():
	timer.start()
	
	cheese_outline.hide()
	cheese.reveal()




func _on_timer_timeout() -> void:
	PlayerManager.camera.return_focus(focus_transform)
