extends Area2D

@export_file("*.tscn") var level
@export var target_door : String  = "Door"
@onready var focus_transform: RemoteTransform2D = $FocusTransform
@onready var door: Area2D = $"."


var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false
	_place_player()
	
	await  LevelManager.level_loaded
	
	monitoring = true



func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position)
	PlayerManager.update_spawn_position(global_position)
	print(global_position)

func action():
	print("it's a DOOR, luigi")
	LevelManager.load_new_level(level, target_door)
