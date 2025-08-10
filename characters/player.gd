class_name Player extends CharacterBody2D
	# Parameters

@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float

@onready var jump_velocity = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

@export var speed = 1400
@export var p_speed = 2200
@export var sliding_speed = 3000
@export var acceleration = 6000
@export var p_acceleration = 5500
@export var friction = 120
@export var slope_friction = 1000
@export var air_resistance = 80

@export var wall_jump_boost = 1000
@export var long_jump_boost = 2200
@export var slide_boost = 1.7
@export var jump_reduction = 0.5
@export var max_fall_velocity = 3600
@export var max_move_velocity = 4000

@export var gravity_multiplier = 1
@export var wall_slide_gravity = 0.8

	# Variables
@onready var starting_position = global_position
@onready var sprite = $Sprite
@onready var interact_icon: Sprite2D = $InteractIcon
@onready var tail_start = $Tail
@onready var tail_end = $Tail/HandleEnd
@onready var tail_start_initial = tail_start.position.x
@onready var tail_end_initial = tail_end.position.x
@onready var hurt_shape: CollisionShape2D = $Hurtbox/HurtShape
@onready var slide_hurt_shape: CollisionShape2D = $Hurtbox/SlideHurtShape
@onready var collision_feet: CollisionShape2D = $CollisionFeet
@onready var collision_slide: CollisionShape2D = $CollisionSlide
@onready var actionable_finder: Area2D = $ActionableFinder
@onready var collision_stand: Area2D = $CollisionStand
@onready var player_camera: Camera2D = $PlayerCamera
@onready var bubble_marker: Marker2D = $BubbleMarker
@onready var sound_effects: Node2D = $SoundEffects
@onready var dust_particles: CPUParticles2D = $DustParticles

# 1 million timers
@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBuffer
@onready var wall_jump_timer = $WallJumpTimer
@onready var wall_coyote_timer: Timer = $WallCoyoteTimer
@onready var death_timer: Timer = $DeathTimer
@onready var camera_tween_timer: Timer = $CameraTweenTimer
@onready var interact_cooldown: Timer = $InteractCooldown
@onready var hud_timer: Timer = $HUDTimer
@onready var p_speed_timer: Timer = $PSpeedTimer
@onready var long_jump_timer: Timer = $LongJumpTimer
@onready var funny_timer: Timer = $FunnyTimer
@onready var drop_timer: Timer = $DropTimer
@onready var drop_land_timer: Timer = $DropLandTimer

@onready var slide_duration: Timer = $SlideDuration
@onready var slide_cooldown: Timer = $SlideCooldown


var spawn_position = Vector2.ZERO

var direction
var facing_direction = 1
var can_coyote_jump = false
var jump_buffer = false
var can_slide_boost = true
var can_stand = true
var is_squished = false
var stand_buffer = false
var slide_buffer = false
var is_p_speed = false
var was_p_speed = false
var is_crouching = false
var is_sliding = false
var is_long_jumping = false
var is_wall_jumping = false
var is_wall_sliding = false
var is_drop = false
var is_drop_falling = false
var wall_tired = false
var is_dialog = false
var is_dying = false
var is_collecting = false
var is_moving = false
var hud_up = false
var can_move_slide = true
var air_jumped = false
var allow_p_speed = true
var turned_around = false
var maintained_momentum = 0
var look_direction = 0
var look_down = 0
var was_wall_normal = Vector2.ZERO
var last_wall_jump = Vector2.ZERO
var camera_y = 0
var wind_power: Vector2 = Vector2.ZERO

var slope_direction = 0
var slope

var moving_platform_speed = Vector2.ZERO
var moving_platform_speed_bonus = Vector2.ZERO



func _physics_process(delta: float) -> void:
	#var stretch_amount_y = 1 + (abs(velocity.y) / 5000)
	#var stretch_amount_x = 1 - ((abs(velocity.y) / 5000) / 2)
	sprite.scale.x = move_toward(sprite.scale.x, 1, 1 * delta)
	sprite.scale.y = move_toward(sprite.scale.y, 1, 1 * delta)
	# Add the gravity.
	if not is_on_floor() or wind_power:
		if velocity.y < max_fall_velocity and not is_drop:
			if wind_power and velocity.y > -3000:
				velocity.y += (get_gravity_type() + wind_power.y) * delta
			else:
				velocity.y += get_gravity_type() * delta
			if velocity.y > 0 and not wind_power:
				fast_fall()
			#else:
				#if is_crouching:
					#velocity += get_gravity() * delta
	
	jump()
	slide(delta)
	crouch()
	#stand()
	squish()
	drop()
	if not is_dialog:
		direction = Input.get_axis("move_left", "move_right")
		update_animations(direction)
	slope_rotation()
	handle_direction(delta)
	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		was_wall_normal = get_wall_normal()
	if can_move_slide:
		move_and_slide()
	if not can_move_slide:
		look_direction = 0
		player_camera.reset_vertical()
	
	moving_platform_speed = get_platform_velocity()
	
	# Started to fall
	if was_on_floor && is_on_floor() && velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	var just_left_wall = was_on_wall and not is_on_wall()
	if just_left_wall:
		wall_coyote_timer.start()
	
	if get_wall_normal() == last_wall_jump:
		wall_tired = true
	else:
		wall_tired = false
	
	if is_sliding:
		floor_constant_speed = false
	else:
		floor_constant_speed = true
	#they gonna kill me for this
	
	# Slow to normal speed when real fast
	if velocity.x > speed and direction == 1 or velocity.x < -speed and direction == -1:
		if not is_on_floor():
			acceleration = 400
		else:
			acceleration = 500
	else:
		acceleration = 6000
		
	if velocity.x > p_speed or velocity.x < -p_speed:
		p_acceleration = 500
	else:
		p_acceleration = 5000
	
	# going upwards a slope is harder than going down
	if is_sliding:
		if velocity.x > 0 and slope_direction == -1:
			slope_friction = 2000
		elif velocity.x < 0 and slope_direction == 1:
			slope_friction = 2000
		else:
			slope_friction = 700
	
	if abs(velocity.x) > 2500:
		if not is_p_speed and allow_p_speed:
			is_p_speed = true
		if not allow_p_speed:
			is_p_speed = false
	
	if is_p_speed:
		if abs(velocity.x) > 2100:
			was_p_speed = true
			is_p_speed = true
		else:
			#if p_speed_timer.time_left > 0:
				#is_p_speed = true
			if is_p_speed:
				if velocity.x == 0 and is_on_floor() and is_on_wall() and not slope_direction:
					is_p_speed = false
					sound_effects.play_sound("p_speed_slam")
					sound_effects.play_sound("punch")
					is_dialog = true
					sprite.play("slam")
					funny_timer.start()
				elif p_speed_timer.is_stopped():
						p_speed_timer.start()

	
	
	# Stop from moving faster than max_move_velocity
	if velocity.x > max_move_velocity:
		velocity.x = max_move_velocity
	if velocity.x < -max_move_velocity:
		velocity.x = max_move_velocity * -1
	
	
	if is_drop_falling:
		velocity.x = 0
	
	# Check if player is moving
	if velocity.x == 0 and velocity.y == 0:
		if is_moving:
			is_moving = false
	else:
		is_moving = true
	
	# Watch for the player to stop
	if is_moving:
		if hud_up:
			EventManager.player_waiting(false)
			hud_up = false
			return
		if velocity.length() > 0.01:
			hud_timer.start()
		else:
			return
	
	# Touched ground
	if !was_on_floor && is_on_floor():
		sound_effects.play_sound("land")
		PlayerManager.create_land_poof()
		sprite.scale = Vector2(1.3, 0.7)
		#player_camera.reset_vertical()
		last_wall_jump = Vector2.ZERO
		if not moving_platform_speed_bonus == Vector2.ZERO :
			moving_platform_speed_bonus = Vector2.ZERO
			if not direction:
				velocity.x = 0
		can_slide_boost = true
		air_jumped = false
		if is_drop_falling:
			is_drop_falling = false
			drop_land_timer.start()
		if abs(maintained_momentum) >= speed:
			if direction:
				velocity.x = maintained_momentum
			maintained_momentum = 0
		if is_long_jumping:
			allow_p_speed = false
			long_jump_timer.start()
			is_long_jumping = false
		if jump_buffer:
			jump_buffer = false
			if drop_land_timer.time_left > 0 and not maintained_momentum:
				velocity.y = jump_velocity * 1.2
				PlayerManager.create_jump_poof()
				print("buffer drop")
			else:
				velocity.y = jump_velocity
				print("buffer")
			sound_effects.play_sound("jump")
		if Input.is_action_pressed("move_slide"):
			slide_buffer = true
			crouch()
		if not Input.is_action_pressed("move_slide") and is_crouching:
			stand()
	if is_on_wall_only() and direction and velocity.y >= 0 and not Input.is_action_pressed("move_slide"):
		is_wall_sliding = true
		velocity.y *= wall_slide_gravity
	else:
		is_wall_sliding = false

func get_gravity_type() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func handle_direction(delta):
	var direction := Input.get_axis("move_left", "move_right")
	if direction and not is_crouching and can_move_slide and not is_dialog:
		if is_p_speed:
			velocity.x = move_toward(velocity.x, (p_speed + moving_platform_speed_bonus.x) * direction, p_acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, (speed + moving_platform_speed_bonus.x) * direction, acceleration * delta)
		if direction == -1:
			change_direction(-1)
			if velocity.x < -1300 and velocity.y == 0:
				look_direction = -1
				player_camera.lookahead(look_direction)
		else:
			change_direction(1)
			if velocity.x > 1300 and velocity.y == 0:
				look_direction = 1
				player_camera.lookahead(look_direction)
	else:
		if is_crouching:
			if is_sliding and is_on_floor():
				velocity.x = move_toward(velocity.x, sliding_speed * slope_direction, slope_friction * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, 30)
		else:
			if is_on_floor():
				if is_p_speed:
					velocity.x = move_toward(velocity.x, 0, friction / 2)
				else:
					velocity.x = move_toward(velocity.x, 0, friction)
			else:
				velocity.x = move_toward(velocity.x, 0 + moving_platform_speed_bonus.x, air_resistance)
			#is_p_speed = false

func jump():
	if Input.is_action_just_pressed("move_jump") and can_stand and not is_dialog:
		if is_on_floor() or can_coyote_jump and not is_crouching:
			sound_effects.play_sound("jump")
			sprite.scale = Vector2(0.7, 1.3)
			moving_platform_speed_bonus += moving_platform_speed
			if is_crouching:
				velocity.y = jump_velocity * 0.3
				print("rollout")
			if drop_land_timer.time_left > 0 and not maintained_momentum:
				velocity.y = jump_velocity * 1.2
				PlayerManager.create_jump_poof()
				print("dropjump")
			else:
				velocity.y = jump_velocity
				print("normal jump")
			if can_coyote_jump:
				can_coyote_jump = false
		
		if is_crouching and direction == facing_direction and is_on_floor() or can_coyote_jump and not wind_power:
			sound_effects.play_sound("jump")
			if is_sliding:
				is_sliding = false
				if slope_direction != direction:
					return
			is_long_jumping = true
			
			if slope_direction == 0:
				allow_p_speed = false
			#do_slide_boost()
			if can_coyote_jump:
				can_coyote_jump = false
			sprite.scale = Vector2(0.9, 1.2)
			velocity.y = jump_velocity * 0.6
			
			if is_p_speed:
				velocity.x = (p_speed * 1.5) * facing_direction
			else:
				velocity.x = (speed * slide_boost + 300) * facing_direction
			
		if is_on_wall_only() or wall_coyote_timer.time_left > 0.0 and not is_crouching:
			print("wall jump")
			var wall_normal = get_wall_normal()
			if wall_jump_timer.time_left > 0.0:
				wall_normal = was_wall_normal
			if wall_normal == Vector2.LEFT and not last_wall_jump == Vector2.LEFT:
				sound_effects.play_sound("jump")
				wall_jump_timer.start()
				is_wall_jumping = true
				last_wall_jump = Vector2.LEFT
				sprite.scale = Vector2(0.7, 1.3)
				if is_p_speed:
					velocity.x = wall_normal.x * wall_jump_boost + 500
				else:
					velocity.x = wall_normal.x * wall_jump_boost
				velocity.y = jump_velocity
			if wall_normal == Vector2.RIGHT and not last_wall_jump == Vector2.RIGHT:
				sound_effects.play_sound("jump")
				wall_jump_timer.start()
				is_wall_jumping = true
				last_wall_jump = Vector2.RIGHT
				sprite.scale = Vector2(0.7, 1.3)
				if is_p_speed:
					velocity.x = wall_normal.x * wall_jump_boost + 500
				else:
					velocity.x = wall_normal.x * wall_jump_boost
				velocity.y = jump_velocity
		else:
			if !jump_buffer:
				jump_buffer = true
				jump_buffer_timer.start()


func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false
	
func _on_jump_buffer_timeout() -> void:
	jump_buffer = false

func _input(event):
	if event.is_action_released("move_jump") and not is_wall_jumping and not is_dialog and not is_long_jumping:
		if velocity.y < 0 and not air_jumped:
			is_drop_falling = false
			is_drop = false
			velocity.y *= jump_reduction
			
func crouch():
	if Input.is_action_just_pressed("move_slide") and is_on_floor() or slide_buffer and not is_dialog:
		var direction := Input.get_axis("move_left", "move_right")
		slide_buffer = false
		sprite.scale = Vector2(1.3, 0.7)
		if not can_stand and direction != 0:
			do_slide_boost()
		if is_crouching:
			return
		is_crouching = true
		if not is_p_speed and direction:
			slide_duration.start()
		if direction != 0 and slide_cooldown.is_stopped():
			print("we slide boost")
			slide_cooldown.start()
			can_slide_boost = false
			do_slide_boost()
		hurt_shape.disabled = true
		collision_feet.disabled = true
		
		slide_hurt_shape.disabled = false
		collision_slide.disabled = false
	if Input.is_action_just_released("move_slide") and slide_duration.is_stopped():
		stand()
	if slide_duration.time_left > 0 and velocity.x == 0:
		slide_duration.stop()
	# BONK
	if is_crouching and velocity.x == 0 and is_on_wall():
		stand()


func do_slide_boost():
	if not is_long_jumping:
		sound_effects.play_sound("slide_boost")
	if is_p_speed and allow_p_speed:
		velocity.x = facing_direction * speed * 2.0
	else:
		if slope_direction != 0 and not is_long_jumping:
			velocity.x = direction * speed * 1.7
		else:
			velocity.x = direction * speed * slide_boost


func stand():
	if not is_crouching:
		return

	#if Input.is_action_just_released("move_slide") or stand_buffer and not is_dialog:
	if stand_buffer:
		stand_buffer = false
	if not can_stand:
		stand_buffer = true
		return
	if velocity.y != 0:
		can_slide_boost = true
		slide_cooldown.stop()
	is_crouching = false
	slide_buffer = false
	hurt_shape.disabled = false
	collision_feet.disabled = false
	is_sliding = false
	is_squished = false
	
	slide_hurt_shape.disabled = true
	collision_slide.disabled = true
	sprite.rotation = 0

func slide(delta):
	slope = rad_to_deg(get_floor_normal().angle())
	if is_on_floor():
		if slope < -100:
			slope_direction = -1
		elif slope > -80:
			slope_direction = 1
		else:
			slope_direction = 0
	
	
	if is_crouching and is_on_floor() and slope_direction:
		is_sliding = true
	else:
		is_sliding = false

func squish():
	var actionables = collision_stand.get_overlapping_bodies()
	if actionables.size() > 0:
		can_stand = false
		is_squished = true
	else:
		can_stand = true
	if is_squished and can_stand and not Input.is_action_pressed("move_slide"):
		stand()
		is_squished = false

func drop():
	if Input.is_action_just_pressed("move_drop") and not is_on_floor():
		if not is_drop_falling:
			is_drop = true
			is_drop_falling = true
			velocity.y = 0
			maintained_momentum = velocity.x
			velocity.x = 0
			drop_timer.start()
		else:
			is_drop = false
			is_drop_falling = false
			maintained_momentum = 0
			if not wind_power:
				velocity.y = max_fall_velocity

func _on_drop_timer_timeout() -> void:
	is_drop = false
	if wind_power:
		velocity.y = (max_fall_velocity + 400) * 0.5
	else:
		velocity.y = max_fall_velocity + 400
	sound_effects.play_sound("slide_boost")

func update_animations(direction):
	
	if is_on_floor() and velocity.x and direction or is_wall_sliding and velocity.y:
		dust_particles.emitting = true
	else:
		dust_particles.emitting = false

func slope_rotation():
	if is_crouching and is_on_floor():
		sprite.rotation = get_floor_normal().angle() + deg_to_rad(90)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		PlayerManager.set_player_position(spawn_position)
	if Input.is_action_just_pressed("move_up"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].player = self
			actionables[0].action()
			return
	if Input.is_action_just_pressed("move_jump") and is_collecting:
		interact_cooldown.start()
		velocity = Vector2.ZERO
		player_camera.reset_zoom()

func dialog_start():
	player_camera.focus_zoom()
	is_dialog = true
	velocity.x = 0

func _ready():
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument):
	if "emote" in argument:
		sprite.play(argument)

func _on_timeline_ended():
	interact_cooldown.start()
	player_camera.reset_zoom()


func fast_fall():
	velocity.y *= gravity_multiplier

func _on_wall_jump_timer_timeout() -> void:
	is_wall_jumping = false


func _on_hurtbox_body_entered(body: Node2D) -> void:
	print("im hurt")
	is_dying = true
	can_move_slide = false
	death_timer.start()

#func can_interact():
	#var actionables = actionable_finder.get_overlapping_areas()
	#var doors = door_finder.get_overlapping_areas()
	#if actionables.size() > 0 or doors.size() > 0 and not is_dialog:
		#interact_icon.visible = true
	#else:
		#interact_icon.visible = false

func _on_slide_duration_timeout() -> void:
	
	if is_on_floor() and not is_sliding:
		velocity.x = move_toward(velocity.x, 0, 250)
	if not Input.is_action_pressed("move_slide"):
		stand()


func _on_slide_cooldown_timeout() -> void:
	can_slide_boost = true


func _on_death_timer_timeout() -> void:
	is_dying = false
	can_move_slide = true
	var value = 1
	EventManager.player_died(value)
	PlayerManager.set_player_position(spawn_position)

func collect_cheese():
	can_move_slide = false
	player_camera.focus_zoom()
	is_collecting = true

func change_direction(new_direction):
	facing_direction = new_direction
	if acceleration == 1000:
		turned_around = true
	if new_direction == -1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	tail_start.position.x = tail_start_initial * new_direction
	tail_end.position.x = tail_end_initial * new_direction

func move_to(new_pos):
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", new_pos, 0.2)

func _on_interact_cooldown_timeout() -> void:
	if is_dialog:
		is_dialog = false
	if is_collecting:
		is_collecting = false
	if jump_buffer:
		jump_buffer = false
	can_move_slide = true

func _on_p_speed_timer_timeout() -> void:
	#pass
	#if not is_wall_sliding:
	if is_wall_sliding:
		print("stop p speed")
		is_p_speed = false
	if abs(velocity.x) >= 0 and abs(velocity.x) < 2000:
		print("stop p speed")
		is_p_speed = false

func _on_long_jump_timer_timeout() -> void:
	allow_p_speed = true


func _on_hud_timer_timeout() -> void:
	hud_up = true
	EventManager.player_waiting(true)
	print("player is sitting around")


func _on_funny_timer_timeout() -> void:
	is_dialog = false
