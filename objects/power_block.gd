@tool
extends CollisionShape2D

@export var powered = true


@onready var sprite: AnimatedSprite2D = $Sprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventManager.connect("change_power_state", change_state)
	if not powered:
		sprite.play("off")
		set_deferred("disabled", true)


func change_state():
	if powered:
		powered = false
		sprite.play("off")
		set_deferred("disabled", true)
	else:
		powered = true
		sprite.play("on")
		set_deferred("disabled", false)
