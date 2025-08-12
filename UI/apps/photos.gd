extends Control
@onready var popup_app: Control = $"../../PopupApp"
@onready var popup: Control = $"../../PopupApp/Popup"

@onready var photos_app: Control = $".."
@onready var first_button: Button = $GridContainer/First




func get_focus():
	first_button.grab_focus()

func remove_focus():
	pass
