extends Node2D

@onready var cheese_slice: NinePatchRect = $CheeseSlice
@onready var count: RichTextLabel = $Count
@onready var one_way: StaticBody2D = $OneWay


var cheese: float
var max_cheese = 4.0
var loaded = false
var max_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_size = cheese_slice.size.y
	if not loaded:
		var c = SaveLoad.contents_to_save.cheese as Array
		cheese = c.size()
		loaded = true
	
	if cheese == 0:
		cheese_slice.hide()
	else:
		resize_cheese()

func resize_cheese():
	var progress = cheese / max_cheese
	count.text = str(cheese, "/", max_cheese, ", ", progress)
	cheese_slice.size.y *= progress
	cheese_slice.position.y = -max_size + cheese_slice.size.y
	one_way.position.y = -max_size + cheese_slice.size.y + 32
