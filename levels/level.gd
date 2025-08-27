class_name Level extends Node2D

@export var total_cheese_curds: int = 8

var cheese_curds: int = 0

func _ready() -> void:
	LevelManager.level_load_started.connect(_free_level)

func _free_level() -> void:
	#PlayerManager.unparent_player(self)
	queue_free()

func add_cheese_curd():
	cheese_curds += 1
	if cheese_curds == total_cheese_curds:
		EventManager.all_cheese_curds_collected()
