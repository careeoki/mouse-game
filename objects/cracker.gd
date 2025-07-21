extends Area2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collect_sound: AudioStreamPlayer2D = $CollectSound

@export var value: int = 1
var is_collected = false

func _ready() -> void:
	sprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	if not is_collected:
		collect_sound.play()
		EventManager.cracker_collected(value)
		is_collected = true
		sprite.visible = false


func _on_collect_sound_finished() -> void:
	queue_free()
