extends Button

@onready var GameManager = $"../../.."
var Used: bool
@onready var Des = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Used == true:
		$CoolDown.visible = true


func _on_pressed() -> void:
	GameManager.LifelineAbility()
	Used = true
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	Des.visible = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	Des.visible = false
