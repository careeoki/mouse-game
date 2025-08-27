extends Control
@onready var gameplay_menu: PanelContainer = $Wallpaper/HomeScreen/Gameplay
@onready var options_menu: PanelContainer = $Wallpaper/HomeScreen/Options
@onready var home_screen: Control = $Wallpaper/HomeScreen

@onready var options_button: Button = $Wallpaper/HomeScreen/Options/Vbox/Options
@onready var resume_button: Button = $Wallpaper/HomeScreen/Gameplay/VBox/Resume
@onready var checklist_button: Button = $Wallpaper/HomeScreen/Gameplay/VBox/Checklist
@onready var photos_button: Button = $Wallpaper/HomeScreen/Gameplay/VBox/Photos
@onready var go_home_button: Button = $"Wallpaper/HomeScreen/Gameplay/VBox/Go Home"
@onready var quit_button: Button = $Wallpaper/HomeScreen/Options/Vbox/Quit



@onready var checklist_app: Control = $Wallpaper/ChecklistApp
@onready var photos_app: Control = $Wallpaper/PhotosApp
@onready var popup_app: Control = $Wallpaper/PopupApp
@onready var popup: Control = $Wallpaper/PopupApp/Popup


var initial_x
var initial_y

var current_menu = "gameplay"
var app_open = false
var menu_offset = 300
var last_focus = "resume"

func _ready() -> void:
	visible = false
	position.y = 660
	options_menu.position.x += menu_offset
	initial_x = home_screen.position.x
	initial_y = home_screen.position.y

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
	PlayerManager.get_child(0).interact_cooldown.start()
	PlayerManager.get_child(0).tail_start.pause = false

	if current_menu == "options":
		change_menu()

func pause():
	get_tree().paused = true
	visible = true
	resume_button.grab_focus()
	drop_in()
	get_parent().hud_drop_in()
	PlayerManager.get_child(0).is_dialog = true

func escape_press():
	if not Dialogic.current_timeline != null:
		if Input.is_action_just_pressed("escape") and get_tree().paused == false:
			PlayerManager.get_child(0).sprite.play("phone")
			PlayerManager.get_child(0).tail_start.pause = true
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
		tween.tween_property(home_screen, "position", Vector2(initial_x - menu_offset, initial_y), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		options_button.grab_focus()
	elif current_menu == "options":
		current_menu = "gameplay"
		var tween = create_tween()
		tween.tween_property(home_screen, "position", Vector2(initial_x, initial_y), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		resume_button.grab_focus()

func _on_resume_pressed() -> void:
	resume()

func return_focus():
	app_open = false
	if last_focus == "checklist":
		checklist_button.grab_focus()
	if last_focus == "photos":
		photos_button.grab_focus()
	if last_focus == "go_home":
		go_home_button.grab_focus()
	if last_focus == "quit":
		quit_button.grab_focus()

func _on_checklist_pressed() -> void:
	app_open = true
	checklist_app.open()
	checklist_button.release_focus()
	last_focus = "checklist"

func _on_return_to_mouseholm_pressed() -> void:
	app_open = true
	popup_app.open()
	go_home_button.release_focus()
	popup.new_popup("go_home")
	last_focus = "go_home"

func go_home():
	resume()
	LevelManager.load_new_level("res://levels/mouseholm/town_square.tscn", "PhoneExit")

func _on_options_pressed() -> void:
	pass


func _on_quit_pressed() -> void:
	app_open = true
	popup_app.open()
	go_home_button.release_focus()
	popup.new_popup("quit")
	last_focus = "quit"

func quit():
	get_tree().quit()

func _on_statistics_pressed() -> void:
	app_open = true
	photos_app.open()
	last_focus = "photos"
