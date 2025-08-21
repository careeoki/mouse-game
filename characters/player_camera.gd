extends Camera2D

var player: Player
var player_transform

@export var death_shake = Vector2(25.0, 25.0)
@export var drop_shake = Vector2(0.0, 10.0)
@export var break_shake = Vector2(6.0, 0.0)
@export var shake_falloff = 15.0

var rng = RandomNumberGenerator.new()
var shake_strength: Vector2 = Vector2(0.0, 0.0)

var look_tween: Tween
var look_dir = 0
var vertical_look_dir = 0
var default_zoom: Vector2
var close_zoom: Vector2 = Vector2(0.35, 0.35)

func _ready() -> void:
	player = PlayerManager.get_child(0)
	player_transform = player.camera_transform
	player_transform.remote_path = get_path()
	
	default_zoom = zoom
	LevelManager.tilemap_bounds_changed.connect(update_limits)
	update_limits(LevelManager.current_tilemap_bounds)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_on_floor():
		drag_vertical_enabled = false
	else:
		drag_vertical_enabled = true
	#position.x = look_dir
	
	#if look_tween:
		#look_tween.kill()
	#position.x = 0
	
	if shake_strength > Vector2.ZERO:
		shake_strength.x = lerpf(shake_strength.x, 0, shake_falloff * delta)
		shake_strength.y = lerpf(shake_strength.y, 0, shake_falloff * delta)
		offset = randomOffset()

func update_limits(bounds : Array[Vector2]) -> void:
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
	pass

func apply_shake(shake_it):
	if shake_it == "death":
		shake_strength = death_shake
	if shake_it == "drop":
		shake_strength = drop_shake
	if shake_it == "break":
		shake_strength = break_shake
	#*epic drop*

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength.x, shake_strength.x), randf_range(-shake_strength.y, shake_strength.y))

func get_focus(focus):
	focus.remote_path = get_path()

func lookahead(look_direction: int):
	
	look_tween = create_tween()
	look_tween.tween_property(player_transform, "position:x", 200 * look_direction, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#await look_tween.finished
	#look_dir = 200 * look_direction

func look_down():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 700, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	vertical_look_dir = 700

#func on_land_look():
	#global_position.y = player.camera_y

func reset_vertical():
	pass
	#var tween = create_tween()
	#tween.tween_property(self, "position:y", 0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#await tween.finished
	#vertical_look_dir = 0


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
