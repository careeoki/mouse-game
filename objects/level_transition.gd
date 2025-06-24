class_name LevelTransition extends Area2D

@export_file("*.tscn") var level
@export var target_transition_area : String  = "LevelTransition"

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	monitoring = false
	_place_player()
	
	await  LevelManager.level_loaded
	
	monitoring = true
	body_entered.connect(_player_entered)


func _player_entered(p : Node2D) -> void:
	LevelManager.load_new_level(level, target_transition_area)

func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position)
	PlayerManager.update_spawn_position(global_position)
	print(global_position)
