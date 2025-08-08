@tool
class_name MovingPlatform extends Path2D

@onready var path: PathFollow2D = $PathFollow2D
@onready var remote_transform: RemoteTransform2D = $PathFollow2D/RemoteTransform2D
@onready var body: AnimatableBody2D = $AnimatableBody2D
@onready var sprite: Sprite2D = $AnimatableBody2D/Sprite
@onready var collider: CollisionShape2D = $AnimatableBody2D/Collider
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_category("Platform")
@export var texture: Texture2D
@export var scale_width: float = 1.0
@export var scale_height: float = 1.0

@export_category("Movement")
@export var closed_path = true

@export var speed = 256
@export var speed_scale = 1.0

var path_progress = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = texture
	sprite.scale = Vector2(scale_width, scale_height)
	path.progress = 0
	path_progress = 0
	
	resize_collider_to_sprite()
	if not closed_path and not Engine.is_editor_hint():
		animation_player.play("move")
		animation_player.speed_scale = speed_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint() and closed_path:
		path_progress += speed * delta
		path.set_progress(path_progress)

func resize_collider_to_sprite():
	# see if it a texture
	if (sprite.texture):
		var _sprite_size = sprite.get_rect().size * sprite.scale
		# check collider has shape
		if collider.shape is RectangleShape2D:
			collider.shape.extents = _sprite_size / 2
		else:
			print("can't resize this collider")
	else:
		print("platform texture is missing")
