extends Sprite2D

@export var timeline = "testi"
@onready var actionable: Actionable = $Actionable

func _ready() -> void:
	actionable.timeline = timeline
