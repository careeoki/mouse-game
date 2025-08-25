extends Node

var deaths = 0
var crackers = 0

func _ready():
	deaths = SaveLoad.contents_to_save.deaths
	crackers = SaveLoad.contents_to_save.deaths

func player_died(value: int):
	deaths += value
	emit_signal("death_update", deaths)

func cracker_collected(value: int):
	crackers += value
	emit_signal("cracker_update", crackers)

func cheese_collected():
	emit_signal("cheese_update")

func cheese_collect_ui(name: String):
	emit_signal("cheese_collect", name)

func player_waiting(value: bool):
	emit_signal("show_hud", value)

func new_power_state():
	emit_signal("change_power_state")

func camera_tween_finish():
	emit_signal("camera_tween_finished")

signal cracker_update(value: int)
signal death_update(value: int)
signal cheese_update()
signal cheese_ui(name: String)
signal show_hud()
signal change_power_state()
signal camera_tween_finished()
