class_name Player extends CharacterBody2D
	# Parameters
@export var speed = 1300
@export var acceleration = 6000
@export var friction = 120
@export var jump_velocity = -2800
@export var wall_jump_boost = 1000
@export var slide_boost = 1.7
@export var jump_reduction = 0.5
@export var max_fall_velocity = 5000

@export var gravity_multiplier = 1.01
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
@onready var door_finder: Area2D = $DoorFinder #this is so fucking dumb
@onready var collision_stand: Area2D = $CollisionStand
@onready var player_camera: Camera2D = $PlayerCamera
@onready var bubble_marker: Marker2D = $BubbleMarker


@onready var coyote_timer = $CoyoteTimer
@onready var jump_buffer_timer = $JumpBuffer
@onready var wall_jump_timer = $WallJumpTimer
@onready var wall_coyote_timer: Timer = $WallCoyoteTimer
@onready var death_timer: Timer = $DeathTimer
@onready var camera_tween_timer: Timer = $CameraTweenTimer
@onready var interact_cooldown: Timer = $InteractCooldown
@onready var hud_timer: Timer = $HUDTimer


@onready var slide_duration: Timer = $SlideDuration
@onready var slide_cooldown: Timer = $SlideCooldown

var spawn_position = Vector2.ZERO

var direction
var can_coyote_jump = false
var jump_buffer = false
var can_slide_boost = true
var can_stand = true
var stand_buffer = false
var slide_buffer = false
var is_crouching = false
var is_wall_jumping = false
var is_wall_sliding = false
var is_dialog = false
var is_dying = false
var is_collecting = false
var is_moving = false
var hud_up = false
var can_move_slide = true
var air_jumped = false
var look_direction = 0
var look_down = 0
var was_wall_normal = Vector2.ZERO
var last_wall_jump = Vector2.ZERO
var checkpoint_manager
var camera_y = 0


func _physics_process(delta: float) -> void:
	sprite.scale.x = move_toward(sprite.scale.x, 1, 1 * delta)
	sprite.scale.y = move_toward(sprite.scale.y, 1, 1 * delta)
	# Add the gravity.
	if not is_on_floor():
		if velocity.y < max_fall_velocity:
			velocity += get_gravity() * delta
			if velocity.y > 0:
				fast_fall()
			else:
				if is_crouching:
					velocity += get_gravity() * delta
	
	jump()
	crouch()
	stand()
	squish()
	can_interact()
	direction = Input.get_axis("move_left", "move_right")
	update_animations(direction)
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
	# Started to fall
	if was_on_floor && is_on_floor() && velocity.y >= 0:
		can_coyote_jump = true
		coyote_timer.start()
	
	var just_left_wall = was_on_wall and not is_on_wall()
	if just_left_wall:
		wall_coyote_timer.start()
	
	#if velocity.y > max_fall_velocity * 0.9:
		#look_down = 1
		#player_camera.look_down()
	#else:
		#look_down = 0
	
	# Check if player is moving
	if velocity.x == 0 and velocity.y == 0:
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
			print("player is stopping.")
		else:
			return
	
	# Touched ground
	if !was_on_floor && is_on_floor():
		sprite.scale = Vector2(1.3, 0.7)
		#player_camera.reset_vertical()
		last_wall_jump = Vector2.ZERO
		can_slide_boost = true
		air_jumped = false
		if jump_buffer:
			jump_buffer = false
			velocity.y = jump_velocity
			print("bugger")
		if Input.is_action_pressed("move_slide"):
			slide_buffer = true
			crouch()
		#if slide_buffer:
			#slide_buffer = false
			#crouch()
	if is_on_wall_only() and Input.get_axis("move_left", "move_right") and velocity.y >= 0 and not Input.is_action_pressed("move_slide"):
		is_wall_sliding = true
		velocity.y *= wall_slide_gravity
	else:
		is_wall_sliding = false

func handle_direction(delta):
	var direction := Input.get_axis("move_left", "move_right")
	if direction and not is_crouching and can_move_slide:
		velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)
		if direction == -1:
			sprite.flip_h = true
			tail_start.position.x = tail_start_initial * -1
			tail_end.position.x = tail_end_initial * -1
			if velocity.x < -1300 and velocity.y == 0:
				look_direction = -1
				player_camera.lookahead(look_direction)
		else:
			sprite.flip_h = false
			tail_start.position.x = tail_start_initial
			tail_end.position.x = tail_end_initial
			if velocity.x > 1300 and velocity.y == 0:
				look_direction = 1
				player_camera.lookahead(look_direction)
	else:
		if is_crouching:
			velocity.x = move_toward(velocity.x, 0, 30)
		else:
			velocity.x = move_toward(velocity.x, 0, friction)

func jump():
	if Input.is_action_just_pressed("move_jump") and can_stand and not is_dialog:
		if is_on_floor() or can_coyote_jump:
			print("normal jump")
			sprite.scale = Vector2(0.7, 1.3)
			velocity.y = jump_velocity
			if can_coyote_jump:
				can_coyote_jump = false
		
		if Input.is_action_pressed("move_slide") and is_on_floor():
			sprite.scale = Vector2(0.9, 1.2)
			velocity.y = jump_velocity * 0.7
			velocity.x = velocity.x * 1.3
			
		if is_on_wall_only() or wall_coyote_timer.time_left > 0.0 and not is_crouching:
			print("wall jump")
			var wall_normal = get_wall_normal()
			if wall_jump_timer.time_left > 0.0:
				wall_normal = was_wall_normal
			if wall_normal == Vector2.LEFT and not last_wall_jump == Vector2.LEFT:
				wall_jump_timer.start()
				is_wall_jumping = true
				last_wall_jump = Vector2.LEFT
				sprite.scale = Vector2(0.7, 1.3)
				velocity.x = wall_normal.x * wall_jump_boost
				velocity.y = jump_velocity
			if wall_normal == Vector2.RIGHT and not last_wall_jump == Vector2.RIGHT:
				wall_jump_timer.start()
				is_wall_jumping = true
				last_wall_jump = Vector2.RIGHT
				sprite.scale = Vector2(0.7, 1.3)
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
	if event.is_action_released("move_jump") and not is_wall_jumping and not is_dialog:
		if velocity.y < 0 and not air_jumped:
			velocity.y *= jump_reduction
			
func crouch():
	if Input.is_action_just_pressed("move_slide") and is_on_floor() or slide_buffer and not is_dialog:
		var direction := Input.get_axis("move_left", "move_right")
		slide_buffer = false
		sprite.scale = Vector2(1.3, 0.7)
		if not can_stand and direction != 0:
			velocity.x = direction * speed * slide_boost
		if is_crouching:
			return
		is_crouching = true
		#floor_stop_on_slope = false
		slide_duration.start()
		if direction != 0 and slide_cooldown.is_stopped():
			slide_cooldown.start()
			can_slide_boost = false
			velocity.x = direction * speed * slide_boost
		hurt_shape.disabled = true
		collision_feet.disabled = true
		
		slide_hurt_shape.disabled = false
		collision_slide.disabled = false
	
func stand():
	if not is_crouching:
		return

	if Input.is_action_just_released("move_slide") or stand_buffer and not is_dialog:
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
		
		slide_hurt_shape.disabled = true
		collision_slide.disabled = true
	
func squish():
	var actionables = collision_stand.get_overlapping_bodies()
	if actionables.size() > 0:
		can_stand = false
	else:
		can_stand = true
		stand()

func update_animations(direction):
	if direction != 0 and not is_dialog:
		sprite.play("walk")
	else:
		sprite.play("idle")
	if is_crouching:
		sprite.play("slide")
	if not is_on_floor():
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")
	if is_collecting:
		sprite.play("collect")
	if is_dying:
		sprite.play("die")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
		PlayerManager.set_player_position(spawn_position)
	if Input.is_action_just_pressed("move_up"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			player_camera.focus_zoom()
			is_dialog = true
			can_move_slide = false
			return
	if Input.is_action_just_pressed("move_jump") and is_collecting:
		interact_cooldown.start()
		velocity = Vector2.ZERO
		player_camera.reset_zoom()

func _ready():
	Dialogic.timeline_ended.connect(_on_timeline_ended)

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

func can_interact():
	var actionables = actionable_finder.get_overlapping_areas()
	var doors = door_finder.get_overlapping_areas()
	if actionables.size() > 0 or doors.size() > 0 and not is_dialog:
		interact_icon.visible = true
	else:
		interact_icon.visible = false

func _on_slide_duration_timeout() -> void:
	
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, 250)


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


func _on_interact_cooldown_timeout() -> void:
	if is_dialog:
		is_dialog = false
	if is_collecting:
		is_collecting = false
	if jump_buffer:
		jump_buffer = false
	can_move_slide = true


func _on_hud_timer_timeout() -> void:
	hud_up = true
	EventManager.player_waiting(true)
	print("player is sitting around")
