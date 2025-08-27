extends Area2D
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collect_sound: AudioStreamPlayer2D = $CollectSound
@onready var collector: Node2D = $Collector

@export var animated = false
@export var use_signal = false
var is_collected = false

func _ready() -> void:
	if animated:
		sprite.play("default")


func _on_body_entered(body: Node2D) -> void:
	if not is_collected:
		collect_sound.pitch_scale = randf_range(0.9, 1.1)
		collect_sound.play()
		collector.collect()
		is_collected = true
		sprite.visible = false


func _on_collect_sound_finished() -> void:
	if not use_signal:
		queue_free()


func _on_collector_complete() -> void:
	queue_free()
