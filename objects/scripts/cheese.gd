extends Area2D

var is_collected = false

@onready var is_collected_data: PersistentDataHandler = $IsCollected
@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var cheese_name: String = "Cheese Name"

func _ready() -> void:
	is_collected_data.data_loaded.connect( set_cheese_state ) #this too
	set_cheese_state()
	animation_player.play("float")

func set_cheese_state() -> void:
	is_collected = is_collected_data.value
	if is_collected:
		sprite.modulate = "ffffff78"

func _on_body_entered(body: Node2D) -> void:
	body.collect_cheese()
	if not is_collected:
		is_collected_data.set_value()
		EventManager.emit_signal("cheese_update")
	EventManager.emit_signal("cheese_ui", cheese_name)
	queue_free()
