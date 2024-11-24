extends Label

@onready var gamemanager = $".."
var time: float
var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = GlobalVariable.time


func reset():
	time = GlobalVariable.time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = GlobalVariable.time_to_string()

func time_to_string() -> String:
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time/60
	var format_string = "%02d : %02d"
	var actual_string = format_string % [min, sec]
	return actual_string
