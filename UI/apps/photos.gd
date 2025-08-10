extends Control
@onready var popup_app: Control = $"../../PopupApp"
@onready var popup: Control = $"../../PopupApp/Popup"

@onready var photos_app: Control = $".."
@onready var first_button: Button = $GridContainer/First

func _process(delta: float) -> void:
	icon_press()


func get_focus():
	first_button.grab_focus()

func icon_press():
	if Input.is_action_just_pressed("move_jump") and photos_app.is_open:
		popup_app.open()
