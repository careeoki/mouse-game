extends Area2D

var is_collected = false

@onready var is_collected_data: PersistentDataHandler = $IsCollected

@export var cheese_name: String = "Cheese Name"

func _ready() -> void:
	is_collected_data.data_loaded.connect( set_cheese_state ) #this too
	set_cheese_state()

func set_cheese_state() -> void:
	is_collected = is_collected_data.value
	if is_collected:
		#already collected
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	is_collected_data.set_value()
	EventManager.emit_signal("cheese_update")
	queue_free()
