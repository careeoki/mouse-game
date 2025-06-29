extends CanvasLayer

@onready var death_label: Label = $DeathCount/DeathLabel
@onready var cracker_label: Label = $CrackerCount/CrackerLabel
@onready var cheese_label: Label = $CheeseCount/CheeseLabel
@onready var cheese_collect: MarginContainer = $CheeseCollect
@onready var cheese_name: RichTextLabel = $CheeseCollect/VBoxContainer/CheeseName


var deaths = 0
var crackers = 0
var cheese = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deaths = SaveLoad.contents_to_save.deaths
	crackers = SaveLoad.contents_to_save.deaths 
	var c = SaveLoad.contents_to_save.cheese as Array
	cheese = c.size()
	death_label.text = str(deaths)
	cracker_label.text = str(crackers)
	cheese_label.text = str(cheese)
	EventManager.connect("death_update", _on_event_death_update)
	EventManager.connect("cracker_update", _on_event_cracker_update)
	EventManager.connect("cheese_update", _on_event_cheese_update)
	EventManager.connect("cheese_ui", _on_event_cheese_collect)
	

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
	crackers = value
	cracker_label.text = str(crackers)

func _on_event_cheese_update() -> void:
	var c = SaveLoad.contents_to_save.cheese as Array
	cheese = c.size()
	cheese_label.text = str(cheese)

func _on_event_cheese_collect(name: String) -> void:
	cheese_collect.visible = true
	cheese_name.text = name
	
