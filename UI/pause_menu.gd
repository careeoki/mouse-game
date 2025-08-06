extends Control
@onready var gameplay_menu: PanelContainer = $Gameplay
@onready var options_menu: PanelContainer = $Options

@onready var options_button: Button = $Options/Vbox/Options
@onready var resume_button: Button = $Gameplay/VBox/Resume

var current_menu = "gameplay"

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	escape_press()
	direction_press()

func resume():
	get_tree().paused = false
	visible = false
	get_parent().hud_drop_out()

func pause():
	get_tree().paused = true
	visible = true
	resume_button.grab_focus()
	get_parent().hud_drop_in()

func escape_press():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume()

func direction_press():
	if get_tree().paused == true:
		if Input.is_action_just_pressed("move_left") and current_menu == "options":
			change_menu()
		if Input.is_action_just_pressed("move_right") and current_menu == "gameplay":
			change_menu()

func change_menu():
	if current_menu == "gameplay":
		current_menu = "options"
		gameplay_menu.visible = false
		options_menu.visible = true
		options_button.grab_focus()
	else:
		current_menu = "gameplay"
		gameplay_menu.visible = true
		options_menu.visible = false
		resume_button.grab_focus()

func _on_resume_pressed() -> void:
	resume()


func _on_checklist_pressed() -> void:
	pass # Replace with function body.

func _on_return_to_mouseholm_pressed() -> void:
	resume()
	LevelManager.load_new_level("res://levels/mouseholm/town_square.tscn", "EnterLeft")

func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
