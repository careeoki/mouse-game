extends Node2D

@onready var jump: AudioStreamPlayer2D = $Jump
@onready var land: AudioStreamPlayer2D = $Land


# Called when the node enters the scene tree for the first time.
func play_sound(name):
	if name == "jump":
		jump.play()
	if name == "land":
		land.play()
