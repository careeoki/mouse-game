@tool
extends Area2D

var is_open = false
@onready var is_open_data: PersistentDataHandler = $IsOpen

@onready var number_text: RichTextLabel = $NumberText
@onready var gate_sprite: TextureRect = $GateSprite
@onready var gate_collider: CollisionShape2D = $GateSolid/GateCollider
@onready var area_collider: CollisionShape2D = $AreaCollider


@export var cheese_needed: int
@export var height: int = 1
var cheese_total


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		var c = SaveLoad.contents_to_save.cheese as Array
		cheese_total = c.size()
		print(cheese_total)
		number_text.text = str(cheese_needed)
		is_open_data.data_loaded.connect(set_open_state)
		set_open_state()
		update_shape()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_shape()

func update_shape():
	gate_sprite.size.y = 128 * height
	gate_sprite.position.y = (-128 * height) / 2
	gate_collider.shape.size.y = 128 * height
	area_collider.shape.size.y = 128 * height
	

func set_open_state() -> void:
	is_open = is_open_data.value
	if is_open:
		#already collected
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if cheese_total >= cheese_needed:
		is_open_data.set_value()
		queue_free()
		is_open = true
		print("yes you has enought cheese")
	else:
		print("not enought chees")
