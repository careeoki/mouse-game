extends Sprite2D

@export var timeline = "res://dialog/testi.dtl"
@export var character = "res://dialog/characters/empty.dch"
@onready var actionable: Actionable = $Actionable

func _ready() -> void:
	actionable.timeline = timeline
	actionable.character = character
