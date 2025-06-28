extends Area2D

var is_open = false
@onready var is_open_data: PersistentDataHandler = $IsOpen

@onready var color_rect: ColorRect = $ColorRect
@onready var number_text: RichTextLabel = $NumberText
@onready var gate_solid: StaticBody2D = $GateSolid

@export var cheese_needed: int
var cheese_total


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var c = SaveLoad.contents_to_save.cheese as Array
	cheese_total = c.size()
	print(cheese_total)
	number_text.text = str(cheese_needed)
	is_open_data.data_loaded.connect(set_open_state)
	set_open_state()

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
