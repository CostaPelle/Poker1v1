extends Button

@onready var GameManager = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var WinStatus = $"../PlayerScore"
	GameManager.ResetCards()
	self.visible = false
	WinStatus.text = str("")
	WinStatus.visible = false
	$"../Bet".Pressed = false
	$"../ClickedCards".RoundDone = false
	pass # Replace with function body.
