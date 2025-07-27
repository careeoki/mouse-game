extends Control

@onready var resume_button: Button = $MainPanel/VBoxContainer/Resume


func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	escape_press()

func resume():
	get_tree().paused = false
	visible = false
	get_parent().both_timers()

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
