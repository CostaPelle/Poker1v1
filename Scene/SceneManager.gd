extends Node2D

@export var PlayerScene : PackedScene

@onready var CardScene: PackedScene = preload("res://Scene/Main.tscn")
@onready var spawn_point = $Deck
@onready var ChipCount: Label = $UI/ChipCount
@onready var EnemyChipCount: Label = $UI/EnemyChipCount
@onready var BetText: Label = $UI/BetAmount
@onready var BetSlider: Slider = $UI/BetSlider
@onready var StopWatch = $Timer
@onready var StopWatchLabel = $Timer

@onready var CardSuitsList = ["Club", "Diamond", "Heart", "Spade"]
var cardvalue = 1

var BetAmount

signal server_cards_given
signal client_cards_given

var PlayersCards: bool
var AbilityGiven: bool
var PlayerCard1
var PlayerCard2

# Called when the node enters the scene tree for the first time.
@rpc("authority","call_remote","reliable")
func _ready() -> void:
	if is_multiplayer_authority():
		InizializeDeck()
		rpc("InizializeDeck")
		
		connect("server_cards_given", Callable(self, "_on_server_cards_given"))
		
		GiveServerPlayerCards()
	connect("client_cards_given", Callable(self, "_on_client_cards_given"))
	
	var my_id = multiplayer.get_unique_id()
	ChipCount.text = str(GameManager.Players[my_id]["ChipCount"])
	for id in GameManager.Players.keys():
		if id != my_id:
			EnemyChipCount.text = str(GameManager.Players[id]["ChipCount"])
	pass 

@rpc("authority")
func InizializeDeck() -> void:
	var index = 0
	var Current_Sprite = 1
	
	var i = 0
	
	while Current_Sprite < 52:
		
		var card: Card = CardScene.instantiate()
		spawn_point.add_child(card)
		card.set_values(cardvalue, Current_Sprite, CardSuitsList[i])
		if cardvalue <= 12:
			cardvalue += 1
		else:
			cardvalue = 1
			i += 1
			if i > 3:
				i = 3
		Current_Sprite += 1
		card.visible = false
		
		pass 

@rpc("authority", "call_remote", "reliable")
func GiveServerPlayerCards():
	var Deck = $Deck
	var PlayerHand = $PlayerHand
	var my_id = multiplayer.get_unique_id()
	var others_id
	
	if my_id == 1:
		for id in GameManager.Players.keys():
			if id != my_id:
				others_id = id
		
		var Card1 = Deck.get_child(randi() % Deck.get_child_count())
		
		GameManager.Players[my_id]["PlayerCard1"] = Card1
		GameManager.Players[my_id]["PlayerCard1Path"] = Card1.get_path()
		
		Card1.set_visible(true)
		Card1.position = Vector2(505,400)
		Card1.scale = Vector2(.5,.5)
		Card1.PlayerCard = true
		Card1.reparent(PlayerHand)
		
		var Card2 = Deck.get_child(randi() % Deck.get_child_count())
		GameManager.Players[my_id]["PlayerCard2"] = Card2
		GameManager.Players[my_id]["PlayerCard2Path"] = Card2.get_path()
		
		Card2.set_visible(true)
		Card2.position = Vector2(405,400)
		Card2.scale = Vector2(.5,.5)
		Card2.PlayerCard = true
		Card2.reparent(PlayerHand)
		
		GameManager.update_player_info(my_id, GameManager.Players[my_id]["PlayerCard1Path"], GameManager.Players[my_id]["PlayerCard2Path"])
		
		
		emit_signal("server_cards_given")


@rpc("any_peer","call_remote","reliable")
func GiveClientPlayerCards():
	var Deck = $Deck
	var PlayerHand = $PlayerHand
	var EnemyHand = $EnemyHand
	var my_id = multiplayer.get_unique_id()
	var others_id
	
	var Card1
	var Card2
	
	if my_id != 1:
		for id in GameManager.Players.keys():
			if id != my_id:
				others_id = id
		
		var EnemyCard1Node = GameManager.Players[others_id]["PlayerCard1Path"]
		var EnemyCard1 = get_node(EnemyCard1Node)
		
		while true:
			Card1 = Deck.get_child(randi() % Deck.get_child_count())
			if Card1 != EnemyCard1:
				break
		
		GameManager.Players[my_id]["PlayerCard1Path"] = Card1.get_path()
		
		Card1.set_visible(true)
		Card1.position = Vector2(505,400)
		Card1.scale = Vector2(.5,.5)
		Card1.PlayerCard = true
		Card1.reparent(PlayerHand)
		
		var EnemyCard2Node = GameManager.Players[others_id]["PlayerCard2Path"]
		var EnemyCard2 = get_node(EnemyCard2Node)
		
		while true:
			Card2 = Deck.get_child(randi() % Deck.get_child_count())
			if Card2 != EnemyCard2:
				break
		
		GameManager.Players[my_id]["PlayerCard2Path"] = Card2.get_path()
		
		Card2.set_visible(true)
		Card2.position = Vector2(405,400)
		Card2.scale = Vector2(.5,.5)
		Card2.PlayerCard = true
		Card2.reparent(PlayerHand)
		
		
		GameManager.update_player_info(my_id, GameManager.Players[my_id]["PlayerCard1Path"], GameManager.Players[my_id]["PlayerCard2Path"])
		
		
		
		emit_signal("client_cards_given")

func _on_server_cards_given():
	GiveClientPlayerCards.rpc()  # Calls the client RPC function
	GiveClientEnemyCards.rpc()


func _on_client_cards_given():
	var my_id = multiplayer.get_unique_id()
	GiveServerEnemyCards.rpc_id(1)


@rpc("any_peer")
func GiveServerEnemyCards():
	var Deck = $Deck
	var EnemyHand = $EnemyHand
	var my_id = multiplayer.get_unique_id()
	var others_id
	print(my_id)
	if my_id == 1:
	
		for id in GameManager.Players.keys():
			if id != my_id:
				others_id = id
		
		var EnemyCard1Path = GameManager.Players[others_id]["PlayerCard1Path"]
		var EnemyCard1 = get_node(EnemyCard1Path)
		
		
		EnemyCard1.set_visible(true)
		EnemyCard1.position = Vector2(505,25)
		EnemyCard1.scale = Vector2(.5,.5)
		EnemyCard1.EnemyCard = true
		var EnemyCard1Sprite = EnemyCard1.get_node("Sprite2D")
		EnemyCard1Sprite.texture = preload("res://CardAssets/assets/card_back.png")
		EnemyCard1.reparent(EnemyHand)
		
		var EnemyCard2Path = GameManager.Players[others_id]["PlayerCard2Path"]
		var EnemyCard2 = get_node(EnemyCard2Path)
		
		EnemyCard2.set_visible(true)
		EnemyCard2.position = Vector2(405,25)
		EnemyCard2.scale = Vector2(.5,.5)
		EnemyCard2.EnemyCard = true
		var EnemyCard2Sprite = EnemyCard2.get_node("Sprite2D")
		EnemyCard2Sprite.texture = preload("res://CardAssets/assets/card_back.png")
		EnemyCard2.reparent(EnemyHand)

@rpc("authority","call_remote","reliable")
func GiveClientEnemyCards():
	var Deck = $Deck
	var EnemyHand = $EnemyHand
	
	var my_id = multiplayer.get_unique_id()
	var others_id
	
	if my_id != 1:
		for id in GameManager.Players.keys():
			if id != my_id:
				others_id = id
		
		var EnemyCard1Path = GameManager.Players[others_id]["PlayerCard1Path"]
		var EnemyCard1 = get_node(EnemyCard1Path)
		
		
		EnemyCard1.set_visible(true)
		EnemyCard1.position = Vector2(505,25)
		EnemyCard1.scale = Vector2(.5,.5)
		EnemyCard1.EnemyCard = true
		var EnemyCard1Sprite = EnemyCard1.get_node("Sprite2D")
		EnemyCard1Sprite.texture = preload("res://CardAssets/assets/card_back.png")
		EnemyCard1.reparent(EnemyHand)
		
		var EnemyCard2Path = GameManager.Players[others_id]["PlayerCard2Path"]
		var EnemyCard2 = get_node(EnemyCard2Path)
		
		EnemyCard2.set_visible(true)
		EnemyCard2.position = Vector2(405,25)
		EnemyCard2.scale = Vector2(.5,.5)
		EnemyCard2.EnemyCard = true
		var EnemyCard2Sprite = EnemyCard2.get_node("Sprite2D")
		EnemyCard2Sprite.texture = preload("res://CardAssets/assets/card_back.png")
		EnemyCard2.reparent(EnemyHand)
	
	

@rpc("authority")
func SyncCardIndexes(my_id, Card1Index, Card2Index):
	GameManager.update_player_info(my_id, Card1Index, Card2Index)


@rpc("authority")
func place_initial_cards() -> void:
	if not is_multiplayer_authority:
		return
	# Server selects cards and syncs these to all clients
	sync_card_to_clients("River", 555, 210)
	sync_card_to_clients("Turn", 655, 210)
	sync_card_to_clients("Flop1", 255, 210)
	sync_card_to_clients("Flop2", 355, 210)
	sync_card_to_clients("Flop3", 455, 210)

@rpc("authority")
func sync_card_to_clients(card_name: String, x_pos: float, y_pos: float) -> void:
	if not is_multiplayer_authority:
		return
	var card = $Deck.get_child(randi() % $Deck.get_child_count())
	card.set_visible(true)
	card.position = Vector2(x_pos, y_pos)
	card.scale = Vector2(0.5, 0.5)
	rpc("update_card_state", card.get_index(), x_pos, y_pos)
	card.reparent($PlayedCards)
	


@rpc("authority", "call_local")
func update_card_state(card_index: int, x_pos: float, y_pos: float) -> void:
	var card = $Deck.get_child(card_index)
	card.visible = true
	card.position = Vector2(x_pos, y_pos)
	card.scale = Vector2(0.5, 0.5)
	card.reparent($PlayedCards)
	# This function will run on all clients to update card propertie

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_stopwatch_label()

func update_stopwatch_label():
	StopWatchLabel.text = StopWatch.time_to_string()


@rpc("any_peer")
func _on_bet_pressed() -> void:
	var my_id = multiplayer.get_unique_id()
	var others_id
	
	for id in GameManager.Players.keys():
		if id != my_id:
			others_id = id
	
	GameManager.Players[my_id]["BetAmount"] = BetAmount
	GameManager.Players[my_id]["HasBet"] = true
	
	UpdateBetVar.rpc_id(others_id, my_id, BetAmount, GameManager.Players[my_id]["HasBet"])
	
	var ServerHasBet = GameManager.Players[my_id]["HasBet"]
	var ClientHasBet = GameManager.Players[others_id]["HasBet"]
	
	if ServerHasBet == true and ClientHasBet == true:
		if is_multiplayer_authority():
			var others_ids
	
			for id in GameManager.Players.keys():
				if id != my_id:
					others_ids = id
			InitializeCards()
			StopWatch.started = true
			StartStopWatch.rpc_id(others_id)
		else:
			InitializeCards.rpc_id(1)
			StopWatch.started = true
			StartStopWatch.rpc_id(1)

@rpc("any_peer")
func UpdateBetVar(id, betamount, hasBet):
	GameManager.Players[id]["BetAmount"] = betamount
	GameManager.Players[id]["HasBet"] = hasBet

@rpc("any_peer")
func InitializeCards():
	place_initial_cards()

#SliderFunctions

func _on_bet_slider_value_changed(value: float) -> void:
	
	BetAmount = value
	BetText.set_text(str(BetAmount))
	pass # Replace with function body.

func ResetSliderAmount():
	
	BetSlider.max_value = GameManager.PlayerChips
	BetSlider.value = 0


func ClickedCards(Index: int, player_cards: bool):
	PlayersCards = player_cards
	if PlayersCards == false:
		var SelectedCard = $PlayedCards.get_child(Index)
		SelectedCard.reparent($ClickedCards)
		return
	else:
		var SelectedCard = $PlayerHand.get_child(Index)
		SelectedCard.reparent($ClickedCards)

func UnclickedCards(Index: int, player_cards: bool):
	PlayersCards = player_cards
	if PlayersCards == false:
		var UnselectedCard = $ClickedCards.get_child(Index)
		UnselectedCard.position.y += 12
		UnselectedCard.reparent($PlayerHand)
		return
	else:
		var UnselectedCard = $ClickedCards.get_child(Index)
		UnselectedCard.position.y += 12
		UnselectedCard.reparent($PlayerHand)

func SetScore(PlayerScore, BotScore, PlayerHand, BotHand):
	var my_id = multiplayer.get_unique_id()
	var others_id
	
	for id in GameManager.Players.keys():
		if id != my_id:
			others_id = id
	
	GameManager.Players[my_id]["PlayerScore"] = PlayerScore
	GameManager.Players[my_id]["HasScore"] = true
	
	ServerClientScore.rpc_id(others_id, my_id, PlayerScore, GameManager.Players[my_id]["HasScore"])
	
	var ServerHasScore = GameManager.Players[my_id]["HasScore"]
	var ClientHasScore = GameManager.Players[others_id]["HasScore"]
	
	if ServerHasScore == true and ClientHasScore == true:
		if is_multiplayer_authority():
			EndOfRound()
		else:
			EndOfRound.rpc_id(1)

@rpc("any_peer")
func ServerClientScore(id, PlayerScore, hasScore):
	GameManager.Players[id]["PlayerScore"] = PlayerScore
	GameManager.Players[id]["HasScore"] = hasScore

@rpc("any_peer")
func EndOfRound():
	var my_id = multiplayer.get_unique_id()
	var others_id
	
	for id in GameManager.Players.keys():
		if id != my_id:
			others_id = id
	
	var ServerScore = GameManager.Players[my_id]["PlayerScore"]
	var ClientScore = GameManager.Players[others_id]["PlayerScore"]
	
	var ServerBetAmount = GameManager.Players[my_id]["BetAmount"]
	var ClientBetAmount = GameManager.Players[others_id]["BetAmount"]
	
	if ServerScore > ClientScore:
		if ServerBetAmount >= ClientBetAmount:
			GameManager.Players[my_id]["ChipCount"] += ClientBetAmount
			GameManager.Players[others_id]["ChipCount"] -= ClientBetAmount
		if ServerBetAmount < ClientBetAmount:
			GameManager.Players[my_id]["ChipCount"] += ServerBetAmount
			GameManager.Players[others_id]["ChipCount"] -= ServerBetAmount
	
	if ClientScore > ServerScore:
		if ClientBetAmount >= ServerBetAmount:
			GameManager.Players[others_id]["ChipCount"] += ServerBetAmount
			GameManager.Players[my_id]["ChipCount"] -= ServerBetAmount
		if ServerBetAmount < ClientBetAmount:
			GameManager.Players[others_id]["ChipCount"] += ClientBetAmount
			GameManager.Players[my_id]["ChipCount"] -= ClientBetAmount
	
	if ServerScore == ClientScore:
		print("Tie")
	
	ResetVariables.rpc_id(others_id, my_id, GameManager.Players[my_id]["ChipCount"], GameManager.Players[others_id]["ChipCount"])
	ResetCards.rpc_id(my_id)

@rpc("any_peer")
func ResetVariables(others_id, ServerChipCount, ClientChipCount):
	var my_id = multiplayer.get_unique_id()
	
	GameManager.Players[others_id]["ChipCount"] = ServerChipCount
	GameManager.Players[my_id]["ChipCount"] = ClientChipCount
	
	ResetCards.rpc_id(1)
	

@rpc("any_peer")
func ResetCards():
	
	var my_id = multiplayer.get_unique_id()
	var others_id
	
	for id in GameManager.Players.keys():
		if id != my_id:
			others_id = id
	
	ChipCount.text = str(GameManager.Players[my_id]["ChipCount"])
	EnemyChipCount.text = str(GameManager.Players[others_id]["ChipCount"])
	BetSlider.max_value = GameManager.Players[my_id]["ChipCount"]
	BetSlider.value = 0
	$ClickedCards.RoundDone = false
	
	var PlayedCards = $PlayedCards
	var EnemyHand = $EnemyHand
	var PlayerHand = $PlayerHand
	var ClickedCards = $ClickedCards
	
	var PlayedCardsChildren = PlayedCards.get_children()
	for card in PlayedCardsChildren:
		card.visible = false
		PlayedCards.remove_child(card)
		$Deck.add_child(card)
		
	var EnemyCardsChildren = EnemyHand.get_children()
	for card in EnemyCardsChildren:
		card.visible = false
		EnemyHand.remove_child(card)
		$Deck.add_child(card)
	
	var PlayerHandChildren = PlayerHand.get_children()
	for card in PlayerHandChildren:
		card.visible = false
		PlayerHand.remove_child(card)
		$Deck.add_child(card)
	
	var ClickedCardsChildren = ClickedCards.get_children()
	for card in ClickedCardsChildren:
		card.visible = false
		ClickedCards.remove_child(card)
		$Deck.add_child(card)
	
	var DeckChildren = $Deck.get_children()
	
	
	for card in DeckChildren:
		card.free()
	
	GameManager.Players[others_id]["BetAmount"] = 0
	GameManager.Players[my_id]["BetaMount"] = 0
	
	GameManager.Players[others_id]["HasBet"] = false
	GameManager.Players[my_id]["HasBet"] = false
	
	GameManager.Players[others_id]["PlayerScore"] = 0
	GameManager.Players[my_id]["PlayerScore"] = 0
	
	GameManager.Players[others_id]["HasScore"] = false
	GameManager.Players[my_id]["HasScore"] = false
	
	GameManager.Players[others_id]["PlayerCard1"] = Object
	GameManager.Players[my_id]["PlayerCard1"] = Object
	
	GameManager.Players[others_id]["PlayerCard1Path"] = 0
	GameManager.Players[my_id]["PlayerCard1Path"] = 0
	
	GameManager.Players[others_id]["PlayerCard2"] = Object
	GameManager.Players[my_id]["PlayerCard2"] = Object
	
	GameManager.Players[others_id]["PlayerCard2Path"] = 0
	GameManager.Players[my_id]["PlayerCard2Path"] = 0
	
	if is_multiplayer_authority():
		ResetCards.rpc_id(others_id)
		InizializeDeck()
		rpc("InizializeDeck")
		connect("server_cards_given", Callable(self, "_on_server_cards_given"))
		GiveServerPlayerCards()
	connect("client_cards_given", Callable(self, "_on_client_cards_given"))

@rpc("any_peer")
func StartStopWatch():
	StopWatch.started = true
