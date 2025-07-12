extends CanvasLayer

@onready var death_label: Label = $CrackerCount/DeathCount/DeathLabel
@onready var cracker_label: Label = $CrackerCount/CrackerLabel

var deaths = 0
var crackers = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deaths = SaveLoad.contents_to_save.deaths
	crackers = SaveLoad.contents_to_save.deaths
	death_label.text = str(deaths)
	cracker_label.text = str(crackers)
	EventManager.connect("death_update", _on_event_death_update)
	EventManager.connect("cracker_update", _on_event_cracker_update)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		SaveLoad.contents_to_save.deaths = deaths
		SaveLoad.contents_to_save.crackers = crackers
		SaveLoad._save()
		print("Saved")

func _on_event_death_update(value: int) -> void:
	deaths = value
	death_label.text = str(deaths)

func _on_event_cracker_update(value: int) -> void:
	crackers = value
	cracker_label.text = str(crackers)
