extends Button

@onready var GameManager = $"../../.."
var Used: bool
@onready var HandRerollDes = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if Used == false:
		GameManager.HandReroll()
		Used = true
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	HandRerollDes.visible = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	HandRerollDes.visible = false
	pass # Replace with function body.
