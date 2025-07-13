extends CanvasLayer

@onready var death_label: Label = $DeathCount/DeathLabel
@onready var cracker_label: Label = $CrackerCount/CrackerLabel
@onready var cheese_label: Label = $CheeseCount/CheeseLabel

var deaths = 0
var crackers = 0
var cheese = 0
var cheese_array: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deaths = SaveLoad.contents_to_save.deaths
	crackers = SaveLoad.contents_to_save.deaths
	cheese = SaveLoad.contents_to_save.cheese_count
	death_label.text = str(deaths)
	cracker_label.text = str(crackers)
	cheese_label.text = str(cheese)
	EventManager.connect("death_update", _on_event_death_update)
	EventManager.connect("cracker_update", _on_event_cracker_update)
	EventManager.connect("cheese_update", _on_event_cheese_update)
	EventManager.connect("cheese_count_update", _on_event_cheese_count_update)
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		SaveLoad.contents_to_save.deaths = deaths
		SaveLoad.contents_to_save.crackers = crackers
		SaveLoad.contents_to_save.cheese_count = cheese
		SaveLoad.contents_to_save.cheese = cheese_array
		SaveLoad._save()
		print("Saved")

func _on_event_death_update(value: int) -> void:
	deaths = value
	death_label.text = str(deaths)

func _on_event_cracker_update(value: int) -> void:
	crackers = value
	cracker_label.text = str(crackers)

func _on_event_cheese_update(array: Array) -> void:
	cheese_array = array

func _on_event_cheese_count_update(value: int) -> void:
	cheese = value
	cheese_label.text = str(cheese)
