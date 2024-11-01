class_name OnlineCard extends Button

@export var value: int
@export var CardImage: int
@export var suit: String
@export var CardPicked: bool

@onready var base_sprite: Sprite2D = $Sprite2D

@onready var GameManager = get_parent().get_parent()


@onready var my_sprite = $Sprite2D

signal CardHasBeenClicked
var CardClicked
var EnemyCard: bool
var PlayerCard: bool

var new_texture = ["res://Cards/card_clubs_02.png", "res://Cards/card_clubs_03.png", "res://Cards/card_clubs_04.png", "res://Cards/card_clubs_05.png", "res://Cards/card_clubs_06.png", "res://Cards/card_clubs_07.png", "res://Cards/card_clubs_08.png", "res://Cards/card_clubs_09.png", "res://Cards/card_clubs_10.png", "res://Cards/card_clubs_J.png", "res://Cards/card_clubs_Q.png", "res://Cards/card_clubs_K.png", "res://Cards/card_clubs_A.png", "res://Cards/card_diamonds_02.png", "res://Cards/card_diamonds_03.png", "res://Cards/card_diamonds_04.png", "res://Cards/card_diamonds_05.png", "res://Cards/card_diamonds_06.png", "res://Cards/card_diamonds_07.png", "res://Cards/card_diamonds_08.png", "res://Cards/card_diamonds_09.png", "res://Cards/card_diamonds_10.png", "res://Cards/card_diamonds_J.png", "res://Cards/card_diamonds_Q.png", "res://Cards/card_diamonds_K.png", "res://Cards/card_diamonds_A.png", "res://Cards/card_hearts_02.png", "res://Cards/card_hearts_03.png", "res://Cards/card_hearts_04.png", "res://Cards/card_hearts_05.png", "res://Cards/card_hearts_06.png", "res://Cards/card_hearts_07.png", "res://Cards/card_hearts_08.png", "res://Cards/card_hearts_09.png", "res://Cards/card_hearts_10.png", "res://Cards/card_hearts_J.png", "res://Cards/card_hearts_Q.png", "res://Cards/card_hearts_K.png", "res://Cards/card_hearts_A.png", "res://Cards/card_spades_02.png", "res://Cards/card_spades_03.png", "res://Cards/card_spades_04.png", "res://Cards/card_spades_05.png", "res://Cards/card_spades_06.png", "res://Cards/card_spades_07.png", "res://Cards/card_spades_08.png", "res://Cards/card_spades_09.png", "res://Cards/card_spades_10.png", "res://Cards/card_spades_J.png", "res://Cards/card_spades_Q.png", "res://Cards/card_spades_K.png", "res://Cards/card_spades_A.png"]


func move_next():
	
	my_sprite.texture = new_texture[CardImage]
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	value = 0
	visible = false
	CardClicked = false
	
	
	pass # Replace with function body.

func set_values(_value: int, card_image: int, card_suit):
	
	value = _value + 1
	my_sprite.texture = load(new_texture[card_image])
	suit = str(card_suit)
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass




func _on_pressed() -> void:
	if EnemyCard == true:
		return
	if CardClicked == true:
		call_deferred("UnclickedCards")
		
		return
	else:
		call_deferred("ClickedCards")
		CardClicked = true
		return
	pass # Replace with function body.
	


func _on_mouse_entered() -> void:
	if EnemyCard == true:
		return
	if CardClicked == false:
		self.position += Vector2(+0,-12)
		pass
	
	pass
	
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	if EnemyCard == true:
		return
	if CardClicked == false:
		self.position += Vector2(+0,12)
		pass
	
	pass # Replace with function body.

func ClickedCards():
	GameManager.ClickedCards(self.get_index(), PlayerCard)
	var ClickedCards = get_parent()
	ClickedCards.get_selected_cards(self.get_index())
func UnclickedCards():
	GameManager.UnclickedCards(self.get_index(), PlayerCard)
	CardClicked = false
