extends Button

@onready var gamemanager = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var WinStatus = $"../PlayerScore"
	gamemanager.ResetCards()
	gamemanager.ClickedCardNum = 0
	self.visible = false
	if GlobalVariable.Blackjack == true:
		gamemanager.Hit_Stand.visible = false
	WinStatus.text = str("")
	WinStatus.visible = false
	$"../PlayerHand".RoundDone = false
	
	if GameManager.Practice == true:
		return
	
	$"../Bet".Pressed = false
	pass # Replace with function body.
