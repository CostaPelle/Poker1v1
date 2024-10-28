@tool
class_name Hand extends Node2D

@onready var GameManager = $"../.."

var PlayerScore
var BotScore1
var BotScore

var PlayerHand


var clicked_cards:Hand
var cards: Array
var BotHand: Array
var RoundDone: bool

func evaluate_hand():
	
	cards.sort_custom(_compare_cards)
	
	
	var value_counts = {}
	for card in cards:
		if not value_counts.has(card.value):
			value_counts[card.value] = 0
		value_counts[card.value] += 1
	
	var sorted_value_counts = []
	for value in value_counts:
		sorted_value_counts.append([value, value_counts[value]])
		

	sorted_value_counts.sort_custom(func(a, b):
		if a[1] == b[1]:
			return b[0] - a[0]
		return b[1] - a[1]
	)
	
	var counts = []
	for pair in sorted_value_counts:
		counts.append(pair[1])
	counts.sort()
	sorted_value_counts.sort()
	
	var is_flush = is_flush()
	var is_straight = is_straight(sorted_value_counts)
	print(sorted_value_counts)
	PlayerHand = sorted_value_counts
	print(counts)
	if is_flush and is_straight and cards[0].value == 10:
		print("Royal Flush")
		PlayerScore = 13
		return
	if is_flush and is_straight:
		print("straight flush")
		PlayerScore = 12.6
	if counts.size() == 2 and (counts[1] == 4):
		print("four of a kind")
		PlayerScore = 11.2
		return
	if counts.size() == 2 and (counts[1 ] == 3):
		print("full house")
		PlayerScore = 9.8
		return
	if is_flush:
		print("flush")
		PlayerScore = 8.4
		return
	if is_straight:
		print("straight")
		PlayerScore = 7
		return
	if counts.size() == 3 and (counts[2] == 3):
		print("three of a kind")
		PlayerScore = 5.6
		return
	if counts.size() == 3 and (counts[1] == 2 and counts[2] == 2):
		print("two pair")
		PlayerScore = 4.2
		return
	if counts.size() == 4:
		print("one pair")
		PlayerScore = 2.8
		return
	else:
		print("High Card")
		PlayerScore = 1.4
		
	pass
	
func _compare_cards(a: Card, b: Card) -> int:
	return a.value - b.value

func is_flush() -> bool:
	return cards[0].suit == cards[1].suit and cards[0].suit == cards[2].suit and cards[0].suit == cards[3].suit and cards[0].suit == cards[4].suit
func is_flush_bot() -> bool:
	
	return BotHand[0].suit == BotHand[1].suit and BotHand[0].suit == BotHand[2].suit and BotHand[0].suit == BotHand[3].suit and BotHand[0].suit == BotHand[4].suit
func is_straight(sorted_value_counts) -> bool:
	
	if sorted_value_counts.size() != 5:
		return false
	
	var values = []
	for pair in sorted_value_counts:
		values.append(pair[0])
		
	values.sort()
	
	
	for i in range(1, values.size()):
		if values[i] != values[i - 1]+ 1:
			return false
	return true
func is_straight_bot(sorted_value_counts) -> bool:
	if sorted_value_counts.size() != 5:
		return false
	
	var values = []
	for pair in sorted_value_counts:
		values.append(pair[0])
		
	values.sort()
	
	
	for i in range(1, values.size()):
		if values[i] != values[i - 1]+ 1:
			return false
	return true
func _ready() -> void:
	clicked_cards = Hand.new()
	pass # Replace with function body.


func get_selected_cards(Index: int) -> Array:
	
	cards.clear()
	
	var selected_cards_array = []
	for i in range (get_child_count()):
		var child = get_child(i)
		cards.append(child)
	if cards.size() > 4 and RoundDone == false:
		evaluate_hand()
		print(BotScore)
		GameManager.SetScore(PlayerScore, BotScore, PlayerHand, BotHand)
		RoundDone = true
	return selected_cards_array

func Tie_Breaker(PlayerHand, EnemyHand) -> int:
	
	var player_sorted = sort_hand_by_groups(PlayerHand)
	var enemy_sorted = sort_hand_by_groups(EnemyHand)
	
	# Compare sorted hands group by group
	for i in range(player_sorted.size()):
		if player_sorted[i][0] > enemy_sorted[i][0]:  # Compare group value
			return 1  # Player wins
		elif player_sorted[i][0] < enemy_sorted[i][0]:
			return 2  # Enemy wins
		elif player_sorted[i][1] > enemy_sorted[i][1]:  # Compare card value if groups are same
			return 1
		elif player_sorted[i][1] < enemy_sorted[i][1]:
			return 2

	# If all groups and values are the same, it's a tie
	return 3

	

func sort_hand_by_groups(hand: Array) -> Array:
	var value_counts = {}
	for card in hand:
		value_counts[card] = value_counts.get(card, 0) + 1

	# Create an array of (count, value) and sort by count (desc) then value (desc)
	var sorted_hand = []
	for value in value_counts.keys():
		sorted_hand.append([value_counts[value], value])
	sorted_hand.sort_custom(_compare_groups)
	return sorted_hand

func _compare_groups(a, b) -> int:
	# Extract counts and card values from the nested structure
	var a_count = a[0]
	var b_count = b[0]
	var a_value = a[1][0]
	var b_value = b[1][0]

	# Compare counts first (element [0] in each sub-array)
	if a_count != b_count:  
		return b_count - a_count  # Sort by count in descending order
	# If counts are the same, compare values (element [1][0] in each sub-array)
	return b_value - a_value  # Sort by card value in descending order if counts are equal




#Bot Code

func BotPickBestHand(all_cards: Array):
	
	var best_hand = []
	var best_score = -1.0
	BotScore = 0
	BotScore1 = 0
	
	var all_combinations = get_combinations(all_cards, 5)
	for combination in all_combinations:
		var score = evaluate_bot_hand(combination)
		
		if score > best_score:
			best_score = score
			
			if best_score > BotScore:
				BotScore = best_score
				best_hand = combination.duplicate()
	evaluate_bot_hand(best_hand)
			
	
	pass

func get_combinations(cards: Array, size: int):
	if size == 0:
		return [[]]
	if cards.size() < size:
		return[]
	
	var result = []
	for i in range(cards.size()):
		var card = cards[i]
		var remaining_cards = cards.slice(i + 1, cards.size())
	
		for combination in get_combinations(remaining_cards, size - 1):
			result.append([card] + combination)
	
	return result
	
	
	pass
	
func evaluate_bot_hand(hand: Array):
	
	hand.sort_custom(_compare_cards)
	
	
	var value_counts = {}
	for card in hand:
		if not value_counts.has(card.value):
			value_counts[card.value] = 0
		value_counts[card.value] += 1
		
	var sorted_value_counts = []
	for value in value_counts:
		sorted_value_counts.append([value, value_counts[value]])
		

	sorted_value_counts.sort_custom(func(a, b):
		if a[1] == b[1]:
			return b[0] - a[0]
		return b[1] - a[1]
	)
	
	var counts = []
	for pair in sorted_value_counts:
		counts.append(pair[1])
	counts.sort()
	sorted_value_counts.sort()
	BotHand = hand
	var is_flush = is_flush_bot()
	var is_straight = is_straight_bot(sorted_value_counts)
	BotHand = sorted_value_counts
	
	
	if is_flush and is_straight and cards[0].value == 10:
		#print("Royal Flush")
		BotScore1 = 13
		return BotScore1
	if is_flush and is_straight:
		#print("straight flush")
		BotScore1 = 12.6
		return BotScore1
	if counts.size() == 2 and (counts[1] == 4):
		#print("four of a kind")
		BotScore1 = 11.2
		return BotScore1
	if counts.size() == 2 and (counts[1 ] == 3):
		#print("full house")
		BotScore1 = 9.8
		return BotScore1
	if is_flush:
		#print("flush")
		BotScore1 = 8.4
		return BotScore1
	if is_straight:
		#print("straight")
		BotScore1 = 7
		return BotScore1
	if counts.size() == 3 and (counts[2] == 3):
		#print("three of a kind")
		BotScore1 = 5.6
		return BotScore1
	if counts.size() == 3 and (counts[1] == 2 and counts[2] == 2):
		#print("two pair")
		BotScore1 = 4.2
		return BotScore1
	if counts.size() == 4:
		#print("one pair")
		BotScore1 = 2.8
		return BotScore1
	else:
		#print("High Card")
		BotScore1 = 1.4
		return BotScore1
	pass
	
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
