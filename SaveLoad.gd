extends Node

const save_location = "user://SaveFilegds.json"

var contents_to_save: Dictionary = {
	"deaths" = 0,
	"crackers" = 0
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
