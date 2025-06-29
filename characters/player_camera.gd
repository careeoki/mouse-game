extends Camera2D

@onready var player: Player = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lookahead()

func lookahead():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(100 * player.look_direction, self.position.y), 1)
	tween.EASE_OUT

#func change_direction(direction: int):
	#var tween = create_tween()
	#tween.tween_property(self, "position", Vector2(300 * direction, self.position.y), 1)
	#tween.EASE_OUT_IN

func focus_zoom():
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(0.35, 0.35), 0.5)
	tween.EASE_IN_OUT

func reset_zoom():
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(0.25, 0.25), 0.5)
