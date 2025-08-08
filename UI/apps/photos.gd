extends Control
@onready var first_button: Button = $GridContainer/First


func get_focus():
	first_button.grab_focus()
