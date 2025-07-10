class_name Actionable extends Area2D
@export var timeline: String = "testi"
@export var character: String = "empty"
@onready var bubble_marker: Node2D = $BubbleMarker
var player

func _on_body_entered(body: Node2D) -> void:
	player = body
	print(player)

func action() -> void:
	var layout = Dialogic.start(timeline)
	layout.register_character(load(character), bubble_marker)
	layout.register_character(load("res://dialog/characters/mable.dch"), player.bubble_marker)
