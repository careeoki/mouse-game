extends CanvasLayer

@onready var death_label: Label = $DeathCount/DeathLabel
@onready var cracker_label: Label = $CrackerCount/HFlowContainer/CrackerLabel
@onready var cheese_label: Label = $CheeseCount/HFlowContainer/CheeseLabel
@onready var cheese_collect: MarginContainer = $CheeseCollect
@onready var cheese_name: RichTextLabel = $CheeseCollect/VBoxContainer/CheeseName
@onready var cheese_drop_timer: Timer = $CheeseDropTimer
@onready var cracker_drop_timer: Timer = $CrackerDropTimer

@onready var cheese_count: Control = $CheeseCount
@onready var cracker_count: Control = $CrackerCount

var player
var deaths = 0
var crackers = 0
var cheese = 0
var loaded = false

var cheese_on_screen = false
var crackers_on_screen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not loaded:
		deaths = SaveLoad.contents_to_save.deaths
		crackers = SaveLoad.contents_to_save.deaths 
		var c = SaveLoad.contents_to_save.cheese as Array
		cheese = c.size()
		death_label.text = str(deaths)
		cracker_label.text = str(crackers)
		cheese_label.text = str(cheese)
		loaded = true
		cheese_count.position.y = -100
		cracker_count.position.y = -100
	EventManager.connect("death_update", _on_event_death_update)
	EventManager.connect("cracker_update", _on_event_cracker_update)
	EventManager.connect("cheese_update", _on_event_cheese_update)
	EventManager.connect("cheese_ui", _on_event_cheese_collect)
	EventManager.connect("show_hud", _on_event_show_hud)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		SaveLoad.contents_to_save.deaths = deaths
		SaveLoad.contents_to_save.crackers = crackers
		SaveLoad._save()
		print("Saved")
	if Input.is_action_just_pressed("move_jump") and cheese_collect.visible:
		cheese_collect.visible = false

func _on_event_death_update(value: int) -> void:
	deaths = value
	death_label.text = str(deaths)

func _on_event_cracker_update(value: int) -> void:
	cracker_drop_in(true)
	crackers = value
	cracker_label.text = str(crackers)

func _on_event_cheese_update() -> void:
	cheese_drop_in(true)
	var c = SaveLoad.contents_to_save.cheese as Array
	cheese = c.size()
	cheese_label.text = str(cheese)

func _on_event_cheese_collect(name: String) -> void:
	cheese_collect.visible = true
	cheese_name.text = name
	
func _on_event_show_hud(value: bool) -> void:
	if value:
		hud_drop_in() 
	else:
		hud_drop_out()

func hud_drop_in():
	if cheese_on_screen:
		cheese_drop_timer.stop()
	if crackers_on_screen:
		cracker_drop_timer.stop()
	cheese_drop_in(false)
	cracker_drop_in(false)

func hud_drop_out():
	cheese_drop_out()
	cracker_drop_out()

func cheese_drop_in(temp: bool):
	cheese_on_screen = true
	var tween = create_tween()
	tween.tween_property(cheese_count, "position", Vector2(0, 0), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if temp:
		cheese_drop_timer.start()

func cheese_drop_out():
	cheese_on_screen = false
	var tween = create_tween()
	tween.tween_property(cheese_count, "position", Vector2(0, -100), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func cracker_drop_in(temp: bool):
	crackers_on_screen = true
	var tween = create_tween()
	tween.tween_property(cracker_count, "position", Vector2(cracker_count.position.x, 0), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	if temp:
		cracker_drop_timer.start()

func cracker_drop_out():
	crackers_on_screen = false
	var tween = create_tween()
	tween.tween_property(cracker_count, "position", Vector2(cracker_count.position.x, -100), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func _on_cheese_drop_timer_timeout() -> void:
	cheese_drop_out()


func _on_cracker_drop_timer_timeout() -> void:
	cracker_drop_out()
