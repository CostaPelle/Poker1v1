extends VSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var my_id = multiplayer.get_unique_id()
	
	self.max_value = GameManager.Players[my_id]["ChipCount"]
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
