extends Area2D

@export var wind: Vector2 = Vector2(0, -3000)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		bodies[0].wind_power = wind


func _on_body_exited(body: Node2D) -> void:
	body.wind_power = Vector2.ZERO


func _on_body_entered(body: Node2D) -> void:
	if body.velocity.y > 0:
		body.velocity.y *= 0.5
