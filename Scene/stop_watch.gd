extends Label
class_name Stopwatch

var time = 3.0
var started = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func reset():
	time = 3.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if started == true:
		time -= delta
		self.text = time_to_string()
	

func time_to_string() -> String:
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var format_string = "%02d : %02d"
	var actual_string = format_string % [sec, msec]
	return actual_string
