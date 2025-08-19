class_name Actionable extends Area2D
@export var timeline: String = "res://dialog/testi.dtl"
@export var character: String = "res://dialog/characters/empty.dch"
@onready var bubble_marker: Node2D = $BubbleMarker
@onready var personal_space: Area2D = $PersonalSpace
@onready var focus_transform: RemoteTransform2D = $FocusTransform
@export var personal_space_distance = 256

var player
var move_direction

func _ready():
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_body_entered(body: Node2D) -> void:
	player = body

func action() -> void:
	if Dialogic.current_timeline != null:
		return
	var space = personal_space.get_overlapping_bodies()
	if space.size() > 0:
		print("please move")
		if player.global_position.x > global_position.x:
			move_direction = 1
			player.change_direction(-1)
		else:
			move_direction = -1
			player.change_direction(1)
		player.move_to(global_position.x + (personal_space_distance * move_direction))
		
	get_parent().active = true
	player.dialog_start()
	var layout = Dialogic.start(timeline)
	layout.register_character(load(character), bubble_marker)
	layout.register_character(load("res://dialog/characters/mable.dch"), player.bubble_marker)

func _on_timeline_ended():
	focus_transform.remote_path = ""
