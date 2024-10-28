extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Gamestart():
	
		
	PlayerChips -= NewBet
	PlayerChipsField.set_text(str(PlayerChips))
	BetSlider.ResetSliderAmount()
	
	if TurnDown == true:
		var River = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
		River.set_visible(true)
		River.position = Vector2(200,-200)
		River.scale = Vector2(.5,.5)
		River.reparent($CanvasLayer/PlayedCards)
		pass
	
	if FlopDown == true and TurnDown == false:
		var Turn = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
		Turn.set_visible(true)
		Turn.position = Vector2(100,-200)
		Turn.scale = Vector2(.5,.5)
		Turn.reparent($CanvasLayer/PlayedCards)
		TurnDown = true;
		pass
	
	if FlopDown == false:
		FlopDown = true
		var Flop1 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
		Flop1.set_visible(true)
		Flop1.position = Vector2(-200,-200)
		Flop1.scale = Vector2(.5,.5)
		Flop1.reparent($CanvasLayer/PlayedCards)
		
		var Flop2 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
		Flop2.set_visible(true)
		Flop2.position = Vector2(-100,-200)
		Flop2.scale = Vector2(.5,.5)
		Flop2.reparent($CanvasLayer/PlayedCards)
		
		var Flop3 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
		Flop3.set_visible(true)
		Flop3.position = Vector2(0,-200)
		Flop3.scale = Vector2(.5,.5)
		Flop3.reparent($CanvasLayer/PlayedCards)
		
		pass
	
	pass
	
	
	pass
