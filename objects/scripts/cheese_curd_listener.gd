extends Node2D

func _ready() -> void:
	EventManager.connect("curds_cheese_spawn", activate_spawner)

func activate_spawner():
	get_child(0).focus()
