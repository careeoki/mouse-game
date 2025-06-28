extends Camera2D

@onready var player: Player = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lookahead()

func lookahead():
	var tween = create_tween()
	#tween.tween_interval(1)
	tween.tween_property(self, "position", Vector2(250 * player.look_direction, self.position.y), 1)
	tween.EASE_OUT_IN
	#else:
		#var tween = create_tween()
		#tween.tween_property(self, "position", Vector2(0, self.position.y), 1)


func _on_tween_timer_timeout() -> void:
	pass # Replace with function body.
