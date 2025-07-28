extends Camera2D

@onready var smoothing_timer: Timer = $SmoothingTimer
@onready var player: Player = $".."
var look_tween: Tween
var look_dir = 0
var vertical_look_dir = 0
var default_zoom: Vector2
var close_zoom: Vector2 = Vector2(0.35, 0.35)

func _ready() -> void:
	default_zoom = zoom
	LevelManager.tilemap_bounds_changed.connect(update_limits)
	update_limits(LevelManager.current_tilemap_bounds)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.can_move_slide:
		position.x = look_dir
		position.y = vertical_look_dir
	else:
		if look_tween:
			look_tween.kill()
		position.x = 0

func update_limits(bounds : Array[Vector2]) -> void:
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
	pass

func lookahead(look_direction: int):
	look_tween = create_tween()
	look_tween.tween_property(self, "position:x", 200 * look_direction, 3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await look_tween.finished
	look_dir = 200 * look_direction

func look_down():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 700, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	vertical_look_dir = 700

func on_land_look():
	global_position.y = player.camera_y

func reset_vertical():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	vertical_look_dir = 0


func focus_zoom():
	var tween = create_tween()
	look_dir = 0
	position = Vector2(0, 0)
	tween.tween_property(self, "zoom", close_zoom, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

func reset_zoom():
	var tween = create_tween()
	tween.tween_property(self, "zoom", default_zoom, 1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func _on_smoothing_timer_timeout() -> void:
	position_smoothing_enabled = true
