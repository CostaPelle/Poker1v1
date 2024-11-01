extends Button

@onready var GameManager = $"../../.."
var Used: bool
@onready var PeekDes = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if Used == false:
		GameManager.PeekAbility()
		Used = true
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	PeekDes.visible = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	PeekDes.visible = false
	pass # Replace with function body.
