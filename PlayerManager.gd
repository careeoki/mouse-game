extends Node


const PLAYER = preload("res://characters/player.tscn")
const CAMERA = preload("res://characters/player_camera.tscn")
const HUD = preload("res://UI/hud.tscn")

var player : Player
var camera
var player_spawned : bool = false
var hud
var hud_spawned : bool = false

var jump_poof = preload("res://particles/jump_poof.tscn")
var land_poof = preload("res://particles/land_poof.tscn")
var die_poof = preload("res://particles/die_poof.tscn")

func _ready() -> void:
	#if get_parent().get_child():
		#print("yeah thats a level")
	add_player_instance()

func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	camera = CAMERA.instantiate()
	add_child(camera)
	hud = HUD.instantiate()
	add_child(hud)
	
	player.camera = camera

func set_player_position(_new_pos : Vector2) -> void:
	camera.position_smoothing_enabled = false
	player.global_position = _new_pos
	await get_tree().create_timer(0.1).timeout
	camera.position_smoothing_enabled = true


func update_spawn_position(_new_pos : Vector2) -> void:
	player.spawn_position = _new_pos

#func set_as_parent(_p : Node2D) -> void:
	#if player.get_parent():
		#player.get_parent()

func unparent_player(_p : Node2D) -> void:
	_p.remove_child(player)
	
func create_jump_poof():
	var jump_poof_instance = jump_poof.instantiate()
	add_child(jump_poof_instance)

func create_land_poof():
	var land_poof_instance = land_poof.instantiate()
	add_child(land_poof_instance)

func create_die_poof():
	var die_poof_instance = die_poof.instantiate()
	add_child(die_poof_instance)
	await die_poof_instance.tree_exiting
	player.visible = true
	player.can_move_slide = true
	player.camera_transform.remote_path = camera.get_path()
