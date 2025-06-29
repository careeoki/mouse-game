extends Camera2D

@onready var player: Player = $".."
var look_tween: Tween
var look_dir = 0
var look_down = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.can_move_slide:
		position.x = look_dir
	else:
		if look_tween:
			look_tween.kill()
		position.x = 0
	

func lookahead(look_direction: int):
	look_tween = create_tween()
	look_tween.tween_property(self, "position", Vector2(100 * look_direction, self.position.y), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await look_tween.finished
	look_dir = 100 * look_direction



func focus_zoom():
	var tween = create_tween()
	look_dir = 0
	tween.tween_property(self, "zoom", Vector2(0.35, 0.35), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func reset_zoom():
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(0.25, 0.25), 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
