extends Area2D

var is_fed = false
var is_chosen = false

@export_file("*.tscn") var level
@export var target_door : String  = "Door"
@export var cost : int

@onready var door: Area2D = $"."
@onready var sprite: Sprite2D = $Sprite
@onready var is_fed_data: PersistentDataHandler = $IsFed
@onready var bubble_marker: Marker2D = $BubbleMarker

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false
	_place_player()
	
	await  LevelManager.level_loaded
	
	monitoring = true
	Dialogic.signal_event.connect(_on_dialogic_signal)
	is_fed_data.data_loaded.connect( set_door_state )
	set_door_state()

func _on_body_entered(body: Node2D) -> void:
	player = body

func set_door_state() -> void:
	is_fed = is_fed_data.value
	if is_fed:
		#already collected
		sprite.frame = 1


func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position)
	PlayerManager.update_spawn_position(global_position)
	print(global_position)

func action():
	if is_fed:
		LevelManager.load_new_level(level, target_door)
	else:
		is_chosen = true
		player.dialog_start()
		Dialogic.VAR.cracker_cost = cost
		Dialogic.VAR.latest_crackers = EventManager.crackers
		var layout = Dialogic.start("res://dialog/hungry_door.dtl")
		layout.register_character(load("res://dialog/characters/empty.dch"), bubble_marker)
		layout.register_character(load("res://dialog/characters/mable.dch"), player.bubble_marker)

func _on_dialogic_signal(argument:String):
	if argument == "open_hungry_door" and is_chosen:
		EventManager.cracker_collected(-cost)
		is_fed_data.set_value()
		is_fed = true
		sprite.frame = 1
		
