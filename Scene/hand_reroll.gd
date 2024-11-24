extends Button

@onready var GameManager = $"../../.."
var Used: bool
@onready var HandRerollDes = $Label
var time = 60.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Used == true:
		$CoolDown.visible = true
		time -= delta
		if time < 0:
			Used = false
			time = 60.0
			$CoolDown.visible = false


func _on_pressed() -> void:
	GameManager.HandReroll()
	Used = true
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	HandRerollDes.visible = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	HandRerollDes.visible = false
	pass # Replace with function body.
