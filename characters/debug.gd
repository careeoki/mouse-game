extends Node2D

@onready var control: Control = $Control
@onready var velocity_x: Label = $Control/VelocityX
@onready var velocity_y: Label = $Control/VelocityY
@onready var is_crouching: Label = $Control/IsCrouching
@onready var p_speed: Label = $Control/PSpeed
@onready var can_p_speed: Label = $Control/CanPSpeed


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
		if player.is_crouching:
			is_crouching.visible = true
		else:
			is_crouching.visible = false
		if player.is_p_speed:
			p_speed.visible = true
		else:
			p_speed.visible = false
		if player.allow_p_speed:
			can_p_speed.visible = true
		else:
			can_p_speed.visible = false
