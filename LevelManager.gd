extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed(bounds: Array[Vector2])

var target_transition : String
var position_offset : Vector2
var current_tilemap_bounds: Array[Vector2]

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func change_tilemap_bounds(bounds: Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)

func load_new_level(
	level_path : String,
	_target_transition : String,
) -> void:
	
	get_tree().paused = true
	target_transition = _target_transition
	
	await SceneTransition.fade_out()
	level_load_started.emit()
	
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	
	get_tree().paused = false
	await SceneTransition.fade_in()
	level_loaded.emit()
	
	pass
