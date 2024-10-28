extends VSlider

@onready var BetAmount
@onready var BetText: Label = $"../BetAmount"
@onready var GameManager = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	self.max_value = GameManager.PlayerChips
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _value_changed(betamount: float) -> void:
	
	BetAmount = betamount
	BetText.set_text(str(BetAmount))
	
	pass

func ResetSliderAmount():
	
	self.max_value = GameManager.PlayerChips
	self.value = 0
	
	pass
