extends Node2D

@onready var speed: Label = $Speed

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed.text = str(player.velocity.x)
