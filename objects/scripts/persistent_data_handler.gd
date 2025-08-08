class_name PersistentDataHandler extends Node

signal data_loaded
var value : bool = false

func _ready() -> void:
	get_value()
	pass

func set_value() -> void:
	SaveLoad.add_persistent_value(_get_name(), _get_type())

func get_value() -> void:
	value = SaveLoad.check_persistent_value(_get_name(), _get_type())
	data_loaded.emit() 
	pass

func _get_name() -> String:
	# res: // path to scence / the name of the thing / PersistentDataHandler
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name

func _get_type() -> String:
	return name
