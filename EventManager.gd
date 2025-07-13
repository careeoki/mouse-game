extends Node

const levels = "[level_test.tscn]"
enum cheese_ids { A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P }

var deaths = 0
var crackers = 0
var cheese: Array = []
var cheese_count = 0
var current_level := 0

func _init():
	for l in len(levels):
		var level_cheese = [false]
		for c in len(cheese_ids):
			level_cheese.append(false)
		cheese.append(level_cheese)

func _ready():
	deaths = SaveLoad.contents_to_save.deaths
	crackers = SaveLoad.contents_to_save.deaths
	cheese_count = SaveLoad.contents_to_save.cheese_count
	cheese = SaveLoad.contents_to_save.cheese

func player_died(value: int):
	deaths += value
	emit_signal("death_update", deaths)

func cracker_collected(value: int):
	crackers += value
	emit_signal("cracker_update", crackers)

func cheese_collected(id: cheese_ids):
	cheese[current_level][id] = true
	cheese_count += 1
	emit_signal("cheese_update", cheese)
	emit_signal("cheese_count_update", cheese_count)

func is_cheese_collected(id: cheese_ids):
	return cheese[current_level][id]


signal cracker_update(value: int)
signal death_update(value: int)
signal cheese_update(value: Array)
signal cheese_count_update(value: int)
