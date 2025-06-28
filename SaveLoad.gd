extends Node

const save_location = "user://SaveFilegds.json"

var contents_to_save: Dictionary = {
	"deaths" = 0,
	"crackers" = 0,
	"cheese" = [],
	"cheese_gates" = []
}

func _ready() -> void:
	_load()

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data
		contents_to_save.deaths = save_data.deaths
		contents_to_save.crackers = save_data.crackers
		contents_to_save.cheese = save_data.cheese
		contents_to_save.cheese_gates = save_data.cheese_gates

func add_persistent_value(value : String, type : String) -> void:
	if check_persistent_value(value, type) == false:
		if type == "IsCollected":
			contents_to_save.cheese.append(value)
		else:
			contents_to_save.cheese_gates.append(value)
	pass

func check_persistent_value(value : String, type : String) -> bool:
	if type == "IsCollected":
		var p = contents_to_save.cheese as Array
		return p.has(value)
	if type ==  "IsOpen":
		var p = contents_to_save.cheese_gates as Array
		return p.has(value)
	else:
		return false
		print("persistent is fuck")
