@tool
extends Node2D



@onready var CardScene: PackedScene = preload("res://Scene/Main.tscn")
@onready var spawn_point = $CanvasLayer/Deck

@onready var CardSuitsList = ["Club", "Diamond", "Heart", "Spade"]

var save_path = "res://SavedData/level.save"
#var save_path = "user+0.

#PlayerVariables
@export var PlayerChips = 50000
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
var PeekUsed = false
var HandRerollUsed = false

#EnemyVariables
@export var EnemyChips: int = 50000
var EnemyScore = 0
var EnemyCard1Texture
var EnemyCard2Texture
var enemycard1
var enemycard2

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
@onready var timer = $Timer
@onready var MenuUI = $CanvasLayer/MenuUI
@onready var PlusChip = $Animations/PlusChip
@onready var MinusChip = $Animations/MinusChip
@onready var LevelManager = $LevelManager
@onready var Hit_Stand = $CanvasLayer/Hit_Stand

var Current_Sprite = 0
var cardvalue = 1
var FlopDown = false
var TurnDown = false

var LifelineAbilityUsed = false
var PeekAbility1: bool
var HandRerollAbility1: bool
var LifelineAbility1: bool

var HitNumber = 1
var EnemyHitNumber = 1

var RoundStarted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PeekAbility1 = GlobalVariable.PeekAbility
	HandRerollAbility1 = GlobalVariable.HandRerollAbility
	LifelineAbility1 = GlobalVariable.LifeLineAbility
	WinMethod = GlobalVariable.winmethod
	stopwatch = GlobalVariable.stopwatch
	PlayerChips = GlobalVariable.GameData["PlayerCoins"]
	
	GlobalVariable.PeekAbility = false
	GlobalVariable.HandRerollAbility = false
	GlobalVariable.LifeLineAbility = false
	
	if PeekAbility1 == true:
		GlobalVariable.GameData["PeekCount"] -= 1
	if HandRerollAbility1 == true:
		GlobalVariable.GameData["HandrerollCount"] -= 1
	if LifelineAbility1 == true:
		GlobalVariable.GameData["LifelineCount"] -= 1

	if GlobalVariable.level == 1:
		$TextureRect/Level1Des.set_text("Blackjack: Be the
		closest to 21.
	
	
	
	Ties are a push")

	if GlobalVariable.level == 3:
		$TextureRect/Level1Des.set_text("BOSS: Local Casino

	Try to win 1,000 Chips in
	3 minutes while only having 3
	seconds to select cards



	You will be handicapped")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # "ui_cancel" maps to the Escape key by default in Godot
		toggle_menu()

func toggle_menu():
	MenuUI.visible = true

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
	timer.visible = true
	if stopwatch == true:
		$StopWatch.visible = true
	#EnemyChip.visible = true
	#EnemyChipCount.visible = true
	var EnemyHand = $CanvasLayer/EnemyHand
	var PlayerHand = $CanvasLayer/PlayerHand
	var PlayerCards = $CanvasLayer/PlayedCards
	var ClickedCards = $CanvasLayer/ClickedCards
	var Deck = $CanvasLayer/Deck
	#timer.started = true
	
	if AbilityGiven == false:
		GiveAbility1()
		GiveAbility2()
	
	EnemyChipCount.set_text(str(EnemyChips))
	
	PlayerChipsField.set_text(str(PlayerChips))
	BetSlider.ResetSliderAmount()
	
	var newcardvalue = 1
	
	var i = 0
	while Current_Sprite < 52:
		
		var card: Card = CardScene.instantiate()
		spawn_point.add_child(card)
		card.set_values(newcardvalue, Current_Sprite, CardSuitsList[i])
		if cardvalue <= 8:
			cardvalue += 1
			newcardvalue += 1
		elif cardvalue >= 9 and cardvalue < 12:
			cardvalue += 1
			newcardvalue = 9
		elif cardvalue == 12:
			cardvalue += 1
			newcardvalue = 10
		elif cardvalue == 13:
			newcardvalue = 1
			i += 1
			cardvalue = 1
		Current_Sprite += 1
		card.visible = false
		
		if Current_Sprite == 52:
			return
		
		pass 
		
		#CreatePlayerCards
		


func RoundStart():
	
	Hit_Stand.visible = true
	RoundStarted = true
	
	var EnemyHand = $CanvasLayer/EnemyHand
	var PlayerHand = $CanvasLayer/PlayerHand
	var PlayerCards = $CanvasLayer/PlayedCards
	var ClickedCards = $CanvasLayer/ClickedCards
	var Deck = $CanvasLayer/Deck
	
	var Card1 = Deck.get_child(randi() % Deck.get_child_count())
	PlayerCard1 = Card1
		
	Card1.set_visible(true)
	Card1.position = Vector2(505,350)
	Card1.scale = Vector2(.5,.5)
	Card1.PlayerCard = true
	Card1.reparent(PlayerHand)
	
	var Card2 = Deck.get_child(randi() % Deck.get_child_count())
	PlayerCard2 = Card2
	print(Card2)
	Card2.set_visible(true)
	Card2.position = Vector2(405,350)
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
	#EnemyCard1Sprite.texture = preload("res://CardAssets/assets/card_back.png")
	EnemyCard1.reparent(EnemyHand)
		
	var EnemyCard2 = Deck.get_child(randi() % Deck.get_child_count())
	
	enemycard2 = EnemyCard2
		
	EnemyCard2.set_visible(true)
	EnemyCard2.position = Vector2(405,25)
	EnemyCard2.scale = Vector2(.5,.5)
	EnemyCard2.EnemyCard = true
	var EnemyCard2Sprite = EnemyCard2.get_node("Sprite2D")
	EnemyCard2Texture = EnemyCard2Sprite.texture.resource_path
	EnemyCard2Sprite.texture = preload("res://CardAssets/assets/card_back.png")
	EnemyCard2.reparent(EnemyHand)
		
	#call_deferred("SetCards(Card1, Card2, EnemyCard1, EnemyCard2)")
	pass


func GivePlayersCards():
	
	if RoundStarted == false:
		return
	
	var CardPosition = HitNumber * 100
	
	var Card1 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	
	Card1.set_visible(true)
	Card1.position = Vector2(505 + CardPosition, 350)
	Card1.scale = Vector2(.5,.5)
	Card1.PlayerCard = true
	Card1.reparent($CanvasLayer/PlayerHand)
	
	HitNumber += 1
	
	var PlayerScore = $CanvasLayer/PlayerHand.evaluate_hand()
	
	if PlayerScore > 21:
		SetScore(0, 1)
	
func RemoveChipsFromPlayer(NewBet):
	
	BetAmount = NewBet
	PlayerChips -= NewBet
	PlayerChipsField.set_text(str(PlayerChips))
	BetSlider.ResetSliderAmount()
	
	pass
	
	
func SetScore(PlayerScore, EnemyScore):
	if stopwatch == true:
		$StopWatch.started = false
		$StopWatch.reset()
	HitNumber = 1
	EnemyHitNumber = 1
	RoundStarted = false
	NextButton.visible = true
	var PlayersHand: Dictionary = {}
	
	if PlayerScore > EnemyScore:
		PlayerScoreLabel.visible = true
		PlayerScoreLabel.text = "WIN"
		PlayerChips += BetAmount * 2
		PlayerChipsField.text = str(PlayerChips)
		NextButton.visible = true
		BetSlider.ResetSliderAmount()
		PlusChip.play()
		return
	if PlayerScore == EnemyScore:
		PlayerScoreLabel.visible = true
		PlayerScoreLabel.text = "TIE"
		PlayerChips += BetAmount
		PlayerChipsField.text = str(PlayerChips)
		BetSlider.ResetSliderAmount()
		NextButton.visible = true
		MinusChip.play()
		if PlayerChips <= 5:
			Lose()
			return
		return
	if EnemyScore > PlayerScore:
		PlayerScoreLabel.visible = true
		PlayerScoreLabel.text = "LOSE"
		NextButton.visible = true
		if LifelineAbilityUsed == true:
			PlayerChips += BetAmount
			LifelineAbilityUsed = false
			return
		MinusChip.play()
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
	
	



func GiveAbility1():
	
	var PeekAbility = $CanvasLayer/Ability1/Peek
	var HandRerollAbility = $CanvasLayer/Ability1/HandReroll
	var LifelineAbility = $CanvasLayer/Ability2/Lifeline
	var rng = randi_range(1, 1)
	
	if PeekAbility1 == true:
		PeekAbility.visible = true
		PeekAbility1 = false
		return
	if HandRerollAbility1 == true:
		HandRerollAbility.visible = true
		HandRerollAbility1 = false
		return
	if LifelineAbility1 == true:
		LifelineAbility.visible = true
		LifelineAbility1 = false
		return
	AbilityGiven = true
	pass

func GiveAbility2():
	
	var PeekAbility = $CanvasLayer/Ability2/Peek
	var HandRerollAbility = $CanvasLayer/Ability2/HandReroll
	var LifelineAbility = $CanvasLayer/Ability2/Lifeline
	var rng = randi_range(1, 2)
	
	if PeekAbility1 == true:
		PeekAbility.visible = true
		PeekAbility1 = false
		return
	if HandRerollAbility1 == true:
		HandRerollAbility.visible = true
		HandRerollAbility1 = false
		return
	if LifelineAbility1 == true:
		LifelineAbility.visible = true
		LifelineAbility1 = false
		return
	AbilityGiven = true
	pass

func PeekAbility():
	if PeekUsed == false:
		var EnemyCard2Sprite = enemycard2.get_node("Sprite2D")
		EnemyCard2Sprite.texture = load(EnemyCard2Texture)
		PeekUsed = true
		PeekTimer(30)

func HandReroll():
	var Deck = $CanvasLayer/Deck
	var PlayerHand = $CanvasLayer/PlayerHand
	
	if HandRerollUsed == false:
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
		HandRerollUsed = true
		HandRerollTimer(60)

func LifelineAbility():
	LifelineAbilityUsed = true

func PeekTimer(delay: float):
	await get_tree().create_timer(delay).timeout
	PeekUsed = false
	print("done")

func HandRerollTimer(delay: float):
	await get_tree().create_timer(delay).timeout
	HandRerollUsed = false

func Win():
	var WinLabel = $WinLabel
	var NextButton = $WinButton
	var CanvasLayer1 = $CanvasLayer
	CanvasLayer1.visible = false
	WinLabel.visible = true
	NextButton.visible = true
	GlobalVariable.GameData["PlayerCoins"] = PlayerChips
	GlobalVariable.GameData["Day"] += 1
	GlobalVariable.GameData["LoanDaysLeft"] -= 1
	GlobalVariable.save()

func Lose():
	var LoseLabel = $LoseLabel
	var RetryButton = $RetryButton
	var CanvasLayer1 = $CanvasLayer
	CanvasLayer1.visible = false
	LoseLabel.visible = true
	RetryButton.visible = true

func _on_win_button_pressed() -> void:
	
	
	save()
	
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
	
	pass # Replace with function body.


func _on_retry_button_pressed() -> void:
	
	
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
	GameManager.Online = false
	GameManager.Offline = false
	GlobalVariable.GameData["PlayerCoins"] = PlayerChips
	#print(GlobalVariable.GameData["PlayerCoins"])
	GlobalVariable.GameData["Day"] += 1
	GlobalVariable.GameData["LoanDaysLeft"] -= 1
	GlobalVariable.save()
	
	
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
		print("no saved file")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")
	GameManager.Online = false
	GameManager.Offline = false
	GlobalVariable.GameData["PlayerCoins"] = PlayerChips
	#print(GlobalVariable.GameData["PlayerCoins"])
	GlobalVariable.GameData["Day"] += 1
	GlobalVariable.GameData["LoanDaysLeft"] -= 1
	GlobalVariable.save()


func _on_resume_pressed() -> void:
	MenuUI.visible = false


func _on_play_pressed() -> void:
	pass # Replace with function body.

func DrawEnemyCard():
	
	var CardPosition = EnemyHitNumber * 100
	
	var Card1 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
	
	Card1.set_visible(true)
	Card1.position = Vector2(405 - CardPosition, 25)
	Card1.scale = Vector2(.5,.5)
	Card1.PlayerCard = true
	Card1.reparent($CanvasLayer/EnemyHand)
	
	EnemyHitNumber += 1
	
	
	EnemyTurn()

func EnemyTurn():
	
	var EnemyCard2Sprite = enemycard2.get_node("Sprite2D")
	EnemyCard2Sprite.texture = load(EnemyCard2Texture)
	
	var BotHand = $CanvasLayer/EnemyHand
	var AllCards = []
	AllCards += $CanvasLayer/EnemyHand.get_children()
	
	BotHand.evaluate_bot_hand(AllCards)

func _on_hit_pressed() -> void:
	GivePlayersCards()
