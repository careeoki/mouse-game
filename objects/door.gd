extends Area2D

@export_file("*.tscn") var level
@export var target_door : String  = "Door"
@onready var door: Area2D = $"."


var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	monitoring = false
	_place_player()
	
	await  LevelManager.level_loaded
	
	monitoring = true


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_up"):
		var actionables = door.get_overlapping_areas()
		if actionables.size() > 0:
			LevelManager.load_new_level(level, target_door)
			
			return

func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position)
	PlayerManager.update_spawn_position(global_position)
	print(global_position)
