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

signal cracker_update(value: int)
signal death_update(value: int)
