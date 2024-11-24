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
var stopwatch: bool
var ClickedCardNum = 0

#EnemyVariables
@export var EnemyChips: int = 50000
var EnemyScore = 0
var EnemyCard1Texture
var EnemyCard2Texture
var enemycard1
var enemycard2

#Buttons
@onready var PlayButton = $CanvasLayer/Play
@onready var ReadyButton = $CanvasLayer/Ready
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
@onready var timer = $Timer
@onready var MenuUI = $CanvasLayer/MenuUI
@onready var PlusChip = $Animations/PlusChip
@onready var MinusChip = $Animations/MinusChip
@onready var LevelManager = $LevelManager

var Current_Sprite = 0
var cardvalue = 1
var FlopDown = false
var TurnDown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # "ui_cancel" maps to the Escape key by default in Godot
		toggle_menu()

func toggle_menu():
	MenuUI.visible = true

func _on_play_pressed() -> void:
	Level1UI.visible = false
	Level1Des.visible = false
	PlayButton.visible = false
	ReadyButton.visible = true
	#BetButton.visible = true
	#BetSlider.visible = true
	#PokerChip.visible = true
	#timer.visible = true
	timer.visible = true
	#EnemyChip.visible = true
	#EnemyChipCount.visible = true
	var EnemyHand = $CanvasLayer/EnemyHand
	var PlayerHand = $CanvasLayer/PlayerHand
	var PlayerCards = $CanvasLayer/PlayedCards
	var ClickedCards = $CanvasLayer/ClickedCards
	var Deck = $CanvasLayer/Deck
	
	#if AbilityGiven == false:
		#GiveAbility1()
		#GiveAbility2()
	
	#EnemyChipCount.set_text(str(EnemyChips))
	
	#PlayerChipsField.set_text(str(PlayerChips))
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
	
	if stopwatch == true:
		$StopWatch.started = true
	
	pass

func _on_ready_pressed() -> void:
	
	timer.started = true
	
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

func SetScore(PlayerScore, EnemyScore, PlayerHand, EnemyHand):
	print(PlayerScore)
	NextButton.visible = true
	PlayerScoreLabel.visible = true
	PlayerScoreLabel.set_text(str(PlayerScore))
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
	if PlayersCards == false and ClickedCardNum <= 5:
		var SelectedCard = $CanvasLayer/PlayedCards.get_child(Index)
		SelectedCard.reparent($CanvasLayer/ClickedCards)
		ClickedCardNum += 1
		return
	else:
		var SelectedCard = $CanvasLayer/PlayerHand.get_child(Index)
		SelectedCard.reparent($CanvasLayer/ClickedCards)
		ClickedCardNum += 1

func UnclickedCards(Index: int, player_cards: bool):
	PlayersCards = player_cards
	if PlayersCards == false:
		var UnselectedCard = $CanvasLayer/ClickedCards.get_child(Index)
		UnselectedCard.position.y += 12
		UnselectedCard.reparent($CanvasLayer/PlayedCards)
		ClickedCardNum -= 1
		return
	else:
		var UnselectedCard = $CanvasLayer/ClickedCards.get_child(Index)
		UnselectedCard.position.y += 12
		UnselectedCard.reparent($CanvasLayer/PlayerHand)
		ClickedCardNum -= 1
	

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
	GameManager.Online = false
	GameManager.Offline = false


func _on_resume_pressed() -> void:
	MenuUI.visible = false


func _on_next_button_pressed() -> void:
	
	NextButton.visible = false
	PlayerScoreLabel.visible = false
