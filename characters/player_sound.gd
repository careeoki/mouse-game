extends Node2D

@onready var player: Player = $".."
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var land: AudioStreamPlayer2D = $Land
@onready var pspeed: AudioStreamPlayer2D = $Pspeed
@onready var pspeed_slam: AudioStreamPlayer2D = $"Pspeed Slam"
@onready var punch: AudioStreamPlayer2D = $Punch
var p_speed_volume

func _ready() -> void:
	p_speed_volume = pspeed.volume_linear

# Called when the node enters the scene tree for the first time.
func play_sound(name):
	if name == "jump":
		jump.pitch_scale = randf_range(0.95, 1.05)
		jump.play()
	if name == "land":
		land.play()
	if name == "p_speed_slam":
		pspeed_slam.play()
		if pspeed.playing:
			pspeed.stop()
	if name == "punch":
		punch.play()

func _physics_process(delta: float) -> void:
	if player.is_p_speed and not player.is_crouching:
		if not pspeed.playing:
			pspeed.play()
	elif pspeed.playing:
		var tween = create_tween()
		tween.tween_property(pspeed, "volume_linear", 0, 0.4)
		await tween.finished
		pspeed.stop()
		pspeed.volume_linear = p_speed_volume
