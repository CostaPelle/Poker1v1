extends Button

@onready var GameManager = $"../.."
@onready var BetSlider = $"../BetSlider"
@onready var ChipCount = $"../ChipCount"

var Pressed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:

	pass


func _on_pressed() -> void:
	if BetSlider.BetAmount <= 0:
		return
	#if BetSlider.BetAmount > GlobalVariable.MaxBetAmount:
		#return
	if Pressed == false:
		GameManager.RemoveChipsFromPlayer(BetSlider.BetAmount)
		BetSlider.ResetSliderAmount()
		Pressed = true
		
		if GlobalVariable.Blackjack == true:
			GameManager.RoundStart()
		
		pass # Replace with function body.
	else:
		print("Already bet")
