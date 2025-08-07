extends Control

var is_open = false
@onready var area: RichTextLabel = $Area
@onready var pause_menu: Control = $"../.."


func _process(delta: float) -> void:
	if is_open:
		direction_press()

func open():
	visible = true
	is_open = true

func close():
	hide()
	is_open = false
	pause_menu.home_screen.show()
	pause_menu.return_focus()

func direction_press():
	if get_tree().paused == true and is_open:
		if Input.is_action_just_pressed("move_left"):
			area.text = "piss"
		if Input.is_action_just_pressed("move_right"):
			area.text = "b"
		if Input.is_action_just_pressed("move_drop"):
			close()
