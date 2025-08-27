extends Node2D
@onready var number: RichTextLabel = $Number
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	number.text = str(get_tree().current_scene.cheese_curds)
	animation_player.play("bounce")
	await animation_player.animation_finished
	queue_free()
