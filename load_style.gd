extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var style: DialogicStyle = load("res://UI/dialog/bubble.tres")
	style.prepare()
