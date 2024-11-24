@tool
class_name BJHand extends Node2D

@onready var StopWatch = $"../Timer"


var gamemanager

var PlayerScore
var BotScore1
var BotScore

var EnemyScore = 0

var PlayerHand


var PlayerCards:BJHand
var cards: Array
var BotHand: Array
var RoundDone: bool

func _ready() -> void:
	PlayerCards = BJHand.new()
	gamemanager = $"../.."


func evaluate_hand():
	
	cards.clear()
	
	var selected_cards_array = []
	for i in range (get_child_count()):
		var child = get_child(i)
		cards.append(child)
	
	var total_value = 0
	var ace_count = 0
	
	for card in cards:
		if card.value == 11 and card.AceUsed == false:
			#card.AceUsed = true
			ace_count += 1
		total_value += card.value
		if total_value > 21 and ace_count > 0:
			ace_count -= 1
			total_value -= 10
	
	
	PlayerScore = total_value
	print(PlayerScore)
	
	return PlayerScore
	
	
	pass


func get_selected_cards(Index: int) -> Array:
	
	cards.clear()
	
	var selected_cards_array = []
	for i in range (get_child_count()):
		var child = get_child(i)
		cards.append(child)
	if cards.size() > 4 and RoundDone == false:
		evaluate_hand()
		if GameManager.Online == true:
			var TimerMult = StopWatch.time / 10
			var PlayerMult = 1 + TimerMult
			PlayerScore *= PlayerMult
			print(PlayerMult)
			StopWatch.started = false
			StopWatch.reset()
		gamemanager.SetScore(PlayerScore, BotScore, PlayerHand, BotHand)
		RoundDone = true
	return selected_cards_array

#Bot Code


	
func evaluate_bot_hand(all_cards: Array):
	
	var total_value = 0
	var ace_count = 0
	
	for card in all_cards:
		if card.value == 11 and card.AceUsed == false:
			#card.AceUsed = true
			ace_count += 1
		total_value += card.value
		if total_value > 21 and ace_count > 0:
			ace_count -= 1
			total_value -= 10
	
	EnemyScore = total_value
	
	
	if EnemyScore < 17:
		gamemanager.DrawEnemyCard()
	
	if EnemyScore > 21:
		EnemyScore = 0
	
	$"../PlayerHand".EnemyScore = EnemyScore
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func Blackjack_get_cards():
	cards.clear()
	
	var selected_cards_array = []
	for i in range (get_child_count()):
		var child = get_child(i)
		cards.append(child)
		
	evaluate_hand()
	if PlayerScore > 21:
		gamemanager.SetScore(0, 1)
		return
	gamemanager.EnemyTurn()
	gamemanager.SetScore(PlayerScore, EnemyScore)
	RoundDone = true
	return selected_cards_array


func _on_stand_pressed() -> void:
	Blackjack_get_cards()
