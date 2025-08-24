extends Area2D

var is_collected = false

@onready var is_collected_data: PersistentDataHandler = $IsCollected
@onready var sprite: Sprite2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var popup: Node2D = $Popup
@onready var cheese_name_text: RichTextLabel = $Popup/CheeseNameText


@export var cheese_name: String = "Cheese Name"

func _ready() -> void:
	cheese_name_text.text = cheese_name
	is_collected_data.data_loaded.connect( set_cheese_state ) #this too
	set_cheese_state()
	animation_player.play("float")
	popup.scale = Vector2.ZERO

func set_cheese_state() -> void:
	is_collected = is_collected_data.value
	if is_collected:
		sprite.modulate = "ffffff78"

func _on_body_entered(body: Node2D) -> void:
	popup.scale = Vector2.ZERO
	body.collect_cheese(self)
	body.global_position = global_position
	body.camera_transform.position = Vector2.ZERO
	sprite.offset.y = -200
	if not is_collected:
		is_collected_data.set_value()
		EventManager.emit_signal("cheese_update")
	EventManager.emit_signal("cheese_ui", cheese_name)

func popup_appear():
	popup.show()
	var tween = create_tween()
	tween.tween_property(popup, "scale", Vector2(1, 1), 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
