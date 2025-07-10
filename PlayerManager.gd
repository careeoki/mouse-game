extends Node


const PLAYER = preload("res://characters/player.tscn")
const HUD = preload("res://UI/hud.tscn")
var player : Player
var player_spawned : bool = false
var hud
var hud_spawned : bool = false

func _ready() -> void:
	#if get_parent().get_child():
		#print("yeah thats a level")
	add_player_instance()

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	hud = HUD.instantiate()
	add_child(hud)

func set_player_position(_new_pos : Vector2) -> void:
	player.global_position = _new_pos

func update_spawn_position(_new_pos : Vector2) -> void:
	player.spawn_position = _new_pos

#func set_as_parent(_p : Node2D) -> void:
	#if player.get_parent():
		#player.get_parent()

func unparent_player(_p : Node2D) -> void:
	_p.remove_child(player)
