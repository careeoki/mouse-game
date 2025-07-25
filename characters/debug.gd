extends Node2D

@onready var control: Control = $Control
@onready var velocity_x: Label = $Control/VelocityX
@onready var velocity_y: Label = $Control/VelocityY


var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_F1):
		if control.visible == false:
			control.visible = true
		else:
			control.visible = false
	if Input.is_key_pressed(KEY_F2):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if control.visible == true:
		velocity_x.text = str("x:", player.velocity.x)
		velocity_y.text = str("y:", player.velocity.y)
