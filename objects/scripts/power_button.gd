extends Area2D
@onready var sprite: Sprite2D = $Sprite

var powered = false
signal change_power_state

func _ready() -> void:
	EventManager.connect("change_power_state", change_state)

func _on_body_entered(body: Node2D) -> void:
	if body.is_drop_falling or body.drop_land_timer.time_left > 0:
		EventManager.new_power_state()

func change_state():
	if powered:
		powered = false
		sprite.frame = 0
	else:
		powered = true
		sprite.frame = 1
