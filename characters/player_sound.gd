extends Node2D

@onready var player: Player = $".."
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var land: AudioStreamPlayer2D = $Land
@onready var pspeed: AudioStreamPlayer2D = $Pspeed

# Called when the node enters the scene tree for the first time.
func play_sound(name):
	if name == "jump":
		jump.pitch_scale = randf_range(0.95, 1.05)
		jump.play()
	if name == "land":
		land.play()

func _physics_process(delta: float) -> void:
	if player.is_p_speed and player.is_on_floor() and not player.is_crouching:
		if not pspeed.playing:
			pspeed.play()
	else:
		pspeed.stop()
