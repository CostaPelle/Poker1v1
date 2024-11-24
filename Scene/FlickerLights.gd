extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("frame_changed", Callable(self, "_on_frame_changed"))

func _on_frame_changed():
	match frame:
		1, 2:
			$"../LightsFlickering".play()
			$"../AudioStreamPlayer2D".stop()
			$"../AudioStreamPlayer2D".play()
			AudioPlayer.stream_paused = true
		3:
			AudioPlayer.stream_paused = false
			$"../AudioStreamPlayer2D".play()
			

func PlayBackgroundMusic():
	$"../BackgroundMusic".stream_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
