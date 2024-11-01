@tool
extends Node2D


@onready var CardScene: PackedScene = preload("res://Scene/Main.tscn")
@onready var spawn_point = $CanvasLayer/Deck

@onready var CardSuitsList = ["Club", "Diamond", "Heart", "Spade"]

var save_path = "res://SavedData/level.save"

#PlayerVariables
@export var PlayerChips: int = 50000
var BetAmount: int
var PlayerScore = 0
var PlayersCards: bool
var AbilityGiven: bool
var PlayerCard1
var PlayerCard2
var Level1: bool
var Level2: bool
var Level3: bool
var WinMethod: int

#EnemyVariables
@export var EnemyChips: int = 50000
var EnemyScore = 0
var EnemyCard1Texture
var EnemyCard2Texture
var enemycard1

#Buttons
@onready var PlayButton = $CanvasLayer/Play
@onready var BetButton = $CanvasLayer/Bet
@onready var BetSlider = $CanvasLayer/BetSlider
@onready var PlayerChipsField: Label = $CanvasLayer/ChipCount
@onready var BetAmountField: Label = $CanvasLayer/BetAmount
@onready var PokerChip = $CanvasLayer/PokerChip
@onready var PlayerScoreLabel: Label = $CanvasLayer/PlayerScore
@onready var EnemyChip = $CanvasLayer/EnemyChip
@onready var EnemyChipCount: Label = $CanvasLayer/EnemyChipCount
@onready var NextButton = $CanvasLayer/NextButton
@onready var Level1UI = $TextureRect/Sprite2D
@onready var Level1Des = $TextureRect/Level1Des

var Current_Sprite = 0
var cardvalue = 1
var FlopDown = false
var TurnDown = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_data()
	
	if Level3 == false and Level2 == true and Level1 == true:
		WinMethod = 1000000
	if Level3 == false and Level2 == false and Level1 == true:
		WinMethod = 500000
	if Level3 == false and Level2 == false and Level1 == false:
		WinMethod = 250000
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_button_pressed() -> void:
	
	Level1UI.visible = false
	Level1Des.visible = false
	PlayButton.visible = false
	BetButton.visible = true
	BetSlider.visible = true
	PokerChip.visible = true
	#EnemyChip.visible = true
	#EnemyChipCount.visible = true
	var EnemyHand = $CanvasLayer/EnemyHand
	var PlayerHand = $CanvasLayer/PlayerHand
	var PlayerCards = $CanvasLayer/PlayedCards
	var ClickedCards = $CanvasLayer/ClickedCards
	var Deck = $CanvasLayer/Deck
	
	
	if AbilityGiven == false:
		GiveAbility1()
		GiveAbility2()
	
	EnemyChipCount.set_text(str(EnemyChips))
	
	PlayerChipsField.set_text(str(PlayerChips))
	var i = 0
	while Current_Sprite < 52:
		
		var card: Card = CardScene.instantiate()
		spawn_point.add_child(card)
		card.set_values(cardvalue, Current_Sprite, CardSuitsList[i])
		if cardvalue <= 12:
			cardvalue += 1
		else:
			i += 1
			cardvalue = 1
		Current_Sprite += 1
		card.visible = false
		
		pass 
		
		#CreatePlayerCards
	if Current_Sprite > 51:
		var Card1 = Deck.get_child(randi() % Deck.get_child_count())
		PlayerCard1 = Card1
			
		Card1.set_visible(true)
		Card1.position = Vector2(505,400)
		Card1.scale = Vector2(.5,.5)
		Card1.PlayerCard = true
		Card1.reparent(PlayerHand)
		
		var Card2 = Deck.get_child(randi() % Deck.get_child_count())
		PlayerCard2 = Card2
		print(Card2)
		Card2.set_visible(true)
		Card2.position = Vector2(405,400)
		Card2.scale = Vector2(.5,.5)
		Card2.PlayerCard = true
		Card2.reparent(PlayerHand)
			
		var EnemyCard1 = Deck.get_child(randi() % Deck.get_child_count())
		
		enemycard1 = EnemyCard1
		
		EnemyCard1.set_visible(true)
		EnemyCard1.position = Vector2(505,25)
		EnemyCard1.scale = Vector2(.5,.5)
		EnemyCard1.EnemyCard = true
		var EnemyCard1Sprite = EnemyCard1.get_node("Sprite2D")
		EnemyCard1Texture = EnemyCard1Sprite.texture.resource_path
		EnemyCard1Sprite.texture = preload("res://CardAssets/assets/card_back.png")
		EnemyCard1.reparent(EnemyHand)
			
		var EnemyCard2 = Deck.get_child(randi() % Deck.get_child_count())
			
		EnemyCard2.set_visible(true)
		EnemyCard2.position = Vector2(405,25)
		EnemyCard2.scale = Vector2(.5,.5)
		EnemyCard2.EnemyCard = true
		var EnemyCard2Sprite = EnemyCard2.get_node("Sprite2D")
		EnemyCard2Sprite.texture = preload("res://CardAssets/assets/card_back.png")
		EnemyCard2.reparent(EnemyHand)
			
		#call_deferred("SetCards(Card1, Card2, EnemyCard1, EnemyCard2)")
		pass
func SetCards(Card1, Card2, Card3, Card4):
	
	
	
	pass
func GivePlayersCards():
	
	var Card1 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
		
	Card1.set_visible(true)
	Card1.position = Vector2(505,400)
	Card1.scale = Vector2(.5,.5)
	Card1.PlayerCard = true
	Card1.reparent($CanvasLayer/PlayerHand)
	
	var Card2 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	
	Card2.set_visible(true)
	Card2.position = Vector2(405,400)
	Card2.scale = Vector2(.5,.5)
	Card2.PlayerCard = true
	Card2.reparent($CanvasLayer/PlayerHand)
	
	var EnemyCard1 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	
	EnemyCard1.set_visible(true)
	EnemyCard1.position = Vector2(505,25)	
	EnemyCard1.scale = Vector2(.5,.5)
	EnemyCard1.EnemyCard = true
	var EnemyCard1Sprite = EnemyCard1.get_node("Sprite2D")
	EnemyCard1Sprite.texture = preload("res://CardAssets/assets/card_back.png")
	EnemyCard1.reparent($CanvasLayer/EnemyHand)
	
	var EnemyCard2 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	
	EnemyCard2.set_visible(true)
	EnemyCard2.position = Vector2(405,25)
	EnemyCard2.scale = Vector2(.5,.5)
	EnemyCard2.EnemyCard = true
	var EnemyCard2Sprite = EnemyCard2.get_node("Sprite2D")
	EnemyCard2Sprite.texture = preload("res://CardAssets/assets/card_back.png")
	EnemyCard2.reparent($CanvasLayer/EnemyHand)
	pass

func RemoveChipsFromPlayer(NewBet):
	
	BetAmount = NewBet
	PlayerChips -= NewBet
	PlayerChipsField.set_text(str(PlayerChips))
	BetSlider.ResetSliderAmount()
	
	
	
	var River = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	River.set_visible(true)
	River.position = Vector2(555,210)
	River.scale = Vector2(.5,.5)
	River.reparent($CanvasLayer/PlayedCards)
	
	
	
	var Turn = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	Turn.set_visible(true)
	Turn.position = Vector2(655,210)
	Turn.scale = Vector2(.5,.5)
	Turn.reparent($CanvasLayer/PlayedCards)
	TurnDown = true;		
	

	FlopDown = true
	var Flop1 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	Flop1.set_visible(true)
	Flop1.position = Vector2(255,210)
	Flop1.scale = Vector2(.5,.5)
	Flop1.reparent($CanvasLayer/PlayedCards)
		
	var Flop2 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	Flop2.set_visible(true)
	Flop2.position = Vector2(355,210)
	Flop2.scale = Vector2(.5,.5)
	Flop2.reparent($CanvasLayer/PlayedCards)
		
	var Flop3 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	Flop3.set_visible(true)
	Flop3.position = Vector2(455,210)
	Flop3.scale = Vector2(.5,.5)
	Flop3.reparent($CanvasLayer/PlayedCards)
	
	var BotHand = $CanvasLayer/ClickedCards
	var AllCards = []
	AllCards += $CanvasLayer/PlayedCards.get_children()
	AllCards += $CanvasLayer/EnemyHand.get_children()
	
	BotHand.BotPickBestHand(AllCards)
	
	pass
	
	
func SetScore(PlayerScore, EnemyScore, PlayerHand, EnemyHand):
	NextButton.visible = true
	print(PlayerScore, EnemyScore)
	var PlayersHand: Dictionary = {}

	print(PlayersHand)
	var tie_result = $CanvasLayer/ClickedCards.Tie_Breaker(PlayerHand, EnemyHand)
	print(PlayerHand)
	print(EnemyHand)
	print(tie_result)
	if PlayerScore > EnemyScore:
		PlayerScoreLabel.visible = true
		PlayerScoreLabel.text = "WIN"
		PlayerChips += BetAmount * 2
		PlayerChipsField.text = str(PlayerChips)
		NextButton.visible = true
		BetSlider.ResetSliderAmount()
		if PlayerChips >= WinMethod:
			Win()
			return
		return
	if PlayerScore == EnemyScore:
		if tie_result == 1:
			PlayerScoreLabel.visible = true
			PlayerScoreLabel.text = "WIN"
			PlayerChips += BetAmount * 2
			PlayerChipsField.text = str(PlayerChips)
			NextButton.visible = true
			BetSlider.ResetSliderAmount()
			if PlayerChips >= WinMethod:
				Win()
				return
			return
		if tie_result == 2:
			PlayerScoreLabel.visible = true
			PlayerScoreLabel.text = "LOSE"
			NextButton.visible = true
			if PlayerChips <= 5:
				Lose()
				return
			return
		if tie_result == 3:
			PlayerScoreLabel.visible = true
			PlayerScoreLabel.text = "TIE"
			PlayerChips += BetAmount * .5
			PlayerChipsField.text = str(PlayerChips)
			BetSlider.ResetSliderAmount()
			NextButton.visible = true
			if PlayerChips <= 5:
				Lose()
				return
			return
	if EnemyScore > PlayerScore:
		PlayerScoreLabel.visible = true
		PlayerScoreLabel.text = "LOSE"
		NextButton.visible = true
		if PlayerChips <= 5:
				Lose()
				return
		return
	pass
	


func ResetCards():
	
	var PlayedCards = $CanvasLayer/PlayedCards
	var EnemyHand = $CanvasLayer/EnemyHand
	var PlayerHand = $CanvasLayer/PlayerHand
	var ClickedCards = $CanvasLayer/ClickedCards
	
	var PlayedCardsChildren = PlayedCards.get_children()
	for card in PlayedCardsChildren:
		card.visible = false
		PlayedCards.remove_child(card)
		$CanvasLayer/Deck.add_child(card)
		
	var EnemyCardsChildren = EnemyHand.get_children()
	for card in EnemyCardsChildren:
		card.visible = false
		EnemyHand.remove_child(card)
		$CanvasLayer/Deck.add_child(card)
	
	var PlayerHandChildren = PlayerHand.get_children()
	for card in PlayerHandChildren:
		card.visible = false
		PlayerHand.remove_child(card)
		$CanvasLayer/Deck.add_child(card)
	
	var ClickedCardsChildren = ClickedCards.get_children()
	for card in ClickedCardsChildren:
		card.visible = false
		ClickedCards.remove_child(card)
		$CanvasLayer/Deck.add_child(card)
		
	
	var DeckChildren = $CanvasLayer/Deck.get_children()
	
	Current_Sprite = 0
	
	for card in DeckChildren:
		card.free()

	$CanvasLayer/Play.emit_signal("pressed")
	pass
	

func ClickedCards(Index: int, player_cards: bool):
	PlayersCards = player_cards
	if PlayersCards == false:
		var SelectedCard = $CanvasLayer/PlayedCards.get_child(Index)
		SelectedCard.reparent($CanvasLayer/ClickedCards)
		return
	else:
		var SelectedCard = $CanvasLayer/PlayerHand.get_child(Index)
		SelectedCard.reparent($CanvasLayer/ClickedCards)

func UnclickedCards(Index: int, player_cards: bool):
	PlayersCards = player_cards
	if PlayersCards == false:
		var UnselectedCard = $CanvasLayer/ClickedCards.get_child(Index)
		UnselectedCard.position.y += 12
		UnselectedCard.reparent($CanvasLayer/PlayedCards)
		return
	else:
		var UnselectedCard = $CanvasLayer/ClickedCards.get_child(Index)
		UnselectedCard.position.y += 12
		UnselectedCard.reparent($CanvasLayer/PlayerHand)
	



func GiveAbility1():
	
	var PeekAbility = $CanvasLayer/Ability1/Peek
	var HandRerollAbility = $CanvasLayer/Ability1/HandReroll
	var rng = randi_range(1, 1)
	
	if rng == 1:
		PeekAbility.visible = true
	if rng == 2:
		HandRerollAbility.visible = true
	AbilityGiven = true
	pass

func GiveAbility2():
	
	var PeakAbility = $CanvasLayer/Ability2/Peek
	var HandRerollAbility = $CanvasLayer/Ability2/HandReroll
	var rng = randi_range(1, 2)
	
	if rng == 1:
		PeakAbility.visible = true
	if rng == 2:
		HandRerollAbility.visible = true
	AbilityGiven = true
	pass

func PeekAbility():
	var EnemyCard1Sprite = enemycard1.get_node("Sprite2D")
	EnemyCard1Sprite.texture = load(EnemyCard1Texture)

func HandReroll():
	var Deck = $CanvasLayer/Deck
	var PlayerHand = $CanvasLayer/PlayerHand
	
	PlayerCard1.visible = false
	PlayerCard1.reparent(Deck)
	
	var Card1 = Deck.get_child(randi() % Deck.get_child_count())
	PlayerCard1 = Card1
		
	Card1.set_visible(true)
	Card1.position = Vector2(505,400)
	Card1.scale = Vector2(.5,.5)
	Card1.PlayerCard = true
	Card1.reparent(PlayerHand)
	
	PlayerCard2.visible = false
	PlayerCard2.reparent(Deck)
	
	var Card2 = Deck.get_child(randi() % Deck.get_child_count())
	PlayerCard2 = Card2
	print(Card2)
	Card2.set_visible(true)
	Card2.position = Vector2(405,400)
	Card2.scale = Vector2(.5,.5)
	Card2.PlayerCard = true
	Card2.reparent(PlayerHand)

func Win():
	var WinLabel = $WinLabel
	var NextButton = $WinButton
	var CanvasLayer1 = $CanvasLayer
	CanvasLayer1.visible = false
	WinLabel.visible = true
	NextButton.visible = true

func Lose():
	var LoseLabel = $LoseLabel
	var RetryButton = $RetryButton
	var CanvasLayer1 = $CanvasLayer
	CanvasLayer1.visible = false
	LoseLabel.visible = true
	RetryButton.visible = true

func _on_win_button_pressed() -> void:
	
	if Level3 == false and Level2 == true and Level1 == true:
		Level3 = true
	if Level3 == false and Level2 == false and Level1 == true:
		Level2 = true
	if Level3 == false and Level2 == false and Level1 == false:
		Level1 = true
	
	save()
	
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
	
	pass # Replace with function body.


func _on_retry_button_pressed() -> void:
	
	
	get_tree().reload_current_scene()
	
	
	pass # Replace with function body.

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_var(Level1)
	file.store_var(Level2)
	file.store_var(Level3)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		Level1 = file.get_var(Level1)
		Level2 = file.get_var(Level2)
		Level3 = file.get_var(Level3)
	else:
		Level1 = false
		Level2 = false
		Level3 = false
