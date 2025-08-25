extends Control

@export var hide_home_screen = true

var is_open = false
@onready var pause_menu: Control = $"../.."

func _ready() -> void:
	scale = Vector2(0, 0)


func _process(delta: float) -> void:
	if is_open:
		back_press()

func open():
	get_child(0).get_focus()
	visible = true
	is_open = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	if is_open and hide_home_screen:
		pause_menu.home_screen.hide()

func close():
	get_child(0).remove_focus()
	is_open = false
	pause_menu.home_screen.show()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.finished
	pause_menu.return_focus()
	if not is_open:
		hide()

func back_press():
	if get_tree().paused == true and is_open:
		if Input.is_action_just_pressed("move_attack"):
			close()
