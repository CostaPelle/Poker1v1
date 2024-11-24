extends Button

@onready var GameManager = $"../../.."
var Used: bool
@onready var PeekDes = $Label
var time = 30.0


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
			time = 30.0
			$CoolDown.visible = false



func _on_pressed() -> void:
	GameManager.PeekAbility()
	Used = true
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	PeekDes.visible = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	PeekDes.visible = false
	pass # Replace with function body.
