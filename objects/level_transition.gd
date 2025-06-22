class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file("*.tscn") var level
@export var target_transition_area : String  = "LevelTransition"
@export var side: SIDE = SIDE.LEFT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	monitoring = false
	_place_player()
	
	await  LevelManager.level_loaded
	
	monitoring = true
	body_entered.connect(_player_entered)


func _player_entered(p : Node2D) -> void:
	LevelManager.load_new_level(level, target_transition_area, Vector2.ZERO)

func _place_player() -> void:
	if name != LevelManager.target_transition:
		print("can't find target transition")
		return
	PlayerManager.set_player_position(global_position + LevelManager.position_offset)
	print(global_position)

func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position #seems that it isn't finding the player
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y
		offset.x = 128
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 128
		if side == SIDE.TOP:
			offset.y *= -1
	
	return offset
