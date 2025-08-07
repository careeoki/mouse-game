extends Control
@onready var gameplay_menu: PanelContainer = $Wallpaper/HomeScreen/Gameplay
@onready var options_menu: PanelContainer = $Wallpaper/HomeScreen/Options
@onready var home_screen: Control = $Wallpaper/HomeScreen

@onready var options_button: Button = $Wallpaper/HomeScreen/Options/Vbox/Options
@onready var resume_button: Button = $Wallpaper/HomeScreen/Gameplay/VBox/Resume
@onready var checklist_button: Button = $Wallpaper/HomeScreen/Gameplay/VBox/Checklist

@onready var checklist: Control = $Wallpaper/Checklist


var current_menu = "gameplay"
var app_open = false
var menu_offset = 300
var last_focus = "resume"

func _ready() -> void:
	visible = false
	position.y = 660
	options_menu.position.x += menu_offset

func _process(delta: float) -> void:
	escape_press()
	direction_press()
	if app_open:
		pass

func drop_in():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 0), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func drop_out():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, 660), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await tween.finished
	if not get_tree().paused:
		visible = false

func resume():
	get_tree().paused = false
	drop_out()
	get_parent().hud_drop_out()

	if current_menu == "options":
		change_menu()

func pause():
	get_tree().paused = true
	visible = true
	resume_button.grab_focus()
	drop_in()
	get_parent().hud_drop_in()

func escape_press():
	if not Dialogic.current_timeline != null:
		if Input.is_action_just_pressed("escape") and get_tree().paused == false:
			PlayerManager.get_child(0).sprite.play("phone")
			pause()
		elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
			resume()

func direction_press():
	if get_tree().paused == true and not app_open:
		if Input.is_action_just_pressed("move_left") and current_menu == "options":
			change_menu()
		if Input.is_action_just_pressed("move_right") and current_menu == "gameplay":
			change_menu()

func change_menu():
	if current_menu == "gameplay":
		current_menu = "options"
		var tween = create_tween()
		tween.tween_property(home_screen, "position", Vector2(position.x - menu_offset, 0), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		options_button.grab_focus()
	elif current_menu == "options":
		current_menu = "gameplay"
		var tween = create_tween()
		tween.tween_property(home_screen, "position", Vector2(0, 0), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		resume_button.grab_focus()

func _on_resume_pressed() -> void:
	resume()

func return_focus():
	app_open = false
	if last_focus == "checklist":
		checklist_button.grab_focus()
		

func _on_checklist_pressed() -> void:
	app_open = true
	checklist.open()
	home_screen.hide()
	last_focus = "checklist"

func _on_return_to_mouseholm_pressed() -> void:
	resume()
	LevelManager.load_new_level("res://levels/mouseholm/town_square.tscn", "EnterLeft")

func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
