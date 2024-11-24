extends Node2D

var EnteredMapArea = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	EnteredMapArea = true
