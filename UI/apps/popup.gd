extends Control

@onready var pause_menu: Control = $"../../.."
@onready var pop_text: RichTextLabel = $PopupPanel/PopText
@onready var popup_app: Control = $".."
@onready var darken: ColorRect = $"../../Darken"

@onready var yes_button: Button = $PopupPanel/Choices/Yes
@onready var no_button: Button = $PopupPanel/Choices/No

var state: String



func get_focus():
	yes_button.grab_focus()
	darken.show()

func remove_focus():
	darken.hide()

func new_popup(name):
	state = name
	if name == "go_home":
		pop_text.text = "Leave this area and return to Mouseholm?"
	if name == "quit":
		pop_text.text = "Quit the game?"


func _on_yes_pressed() -> void:
	if state == "go_home":
		popup_app.close()
		pause_menu.go_home()
	if state == "quit":
		pause_menu.quit()


func _on_no_pressed() -> void:
	popup_app.close()
	no_button.release_focus()
