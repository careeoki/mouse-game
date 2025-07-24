extends AnimatedSprite2D

@export var timeline = "res://dialog/testi.dtl"
@export var character = "res://dialog/characters/empty.dch"

@onready var actionable: Actionable = $Actionable

var active = false

func _ready() -> void:
	actionable.timeline = timeline
	actionable.character = character
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func _on_dialogic_signal(argument):
	if active and not "emote" in argument:
		play(argument)

func _on_timeline_ended():
	if active:
		play("npc_idle")
		active = false
