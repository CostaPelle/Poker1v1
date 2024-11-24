extends Node2D

var time = 6.0
var started = false
@onready var gamemanager = $".."
@onready var slider: Slider = $HSlider
@onready var label: Label = $StopWatch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func reset():
	time = 6.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started == true:
		time -= delta
		slider.value = time
		label.text = time_to_string()
	if time <= 0:
		gamemanager.SetScore(0, 1, [], [])
		gamemanager.ClickedCardNum = 5
		started = false
		reset()
	

func time_to_string() -> String:
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var format_string = "%02d : %02d"
	var actual_string = format_string % [sec, msec]
	return actual_string
