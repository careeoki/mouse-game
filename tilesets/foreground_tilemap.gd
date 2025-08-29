extends TileMapLayer

var player
var alpha = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = PlayerManager.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.is_on_foreground:
		fade_in()
	else:
		fade_out()

func fade_in():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.2)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
