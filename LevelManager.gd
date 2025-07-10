extends Node

signal level_load_started
signal level_loaded


var target_transition : String
var position_offset : Vector2

func _ready() -> void:
	if get_tree().current_scene == Level:
		await get_tree().process_frame
		level_loaded.emit()

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
