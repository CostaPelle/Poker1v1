class_name Card extends Node2D

@export var cardvalue: int
@export var CardImage: int

@onready var my_sprite = $Sprite2D
var new_texture = ["res://Cards/card_clubs_02.png", "res://Cards/card_clubs_03.png", "res://Cards/card_clubs_04.png", "res://Cards/card_clubs_05.png", "res://Cards/card_clubs_06.png", "res://Cards/card_clubs_07.png", "res://Cards/card_clubs_08.png", "res://Cards/card_clubs_09.png", "res://Cards/card_clubs_10.png", "res://Cards/card_clubs_J.png", "res://Cards/card_clubs_Q.png", "res://Cards/card_clubs_K.png", "res://Cards/card_clubs_A.png", "res://Cards/card_diamonds_02.png", "res://Cards/card_diamonds_03.png", "res://Cards/card_diamonds_04.png", "res://Cards/card_diamonds_05.png", "res://Cards/card_diamonds_06.png", "res://Cards/card_diamonds_07.png", "res://Cards/card_diamonds_08.png", "res://Cards/card_diamonds_09.png", "res://Cards/card_diamonds_10.png", "res://Cards/card_diamonds_J.png", "res://Cards/card_diamonds_Q.png", "res://Cards/card_diamonds_K.png", "res://Cards/card_diamonds_A.png", "res://Cards/card_hearts_02.png", "res://Cards/card_hearts_03.png", "res://Cards/card_hearts_04.png", "res://Cards/card_hearts_05.png", "res://Cards/card_hearts_06.png", "res://Cards/card_hearts_07.png", "res://Cards/card_hearts_08.png", "res://Cards/card_hearts_09.png", "res://Cards/card_hearts_10.png", "res://Cards/card_hearts_J.png", "res://Cards/card_hearts_Q.png", "res://Cards/card_hearts_K.png", "res://Cards/card_hearts_A.png", "res://Cards/card_spades_02.png", "res://Cards/card_spades_03.png", "res://Cards/card_spades_04.png", "res://Cards/card_spades_05.png", "res://Cards/card_spades_06.png", "res://Cards/card_spades_07.png", "res://Cards/card_spades_08.png", "res://Cards/card_spades_09.png", "res://Cards/card_spades_10.png", "res://Cards/card_spades_J.png", "res://Cards/card_spades_Q.png", "res://Cards/card_spades_K.png", "res://Cards/card_spades_A.png"]


func move_next():
	
	my_sprite.texture = new_texture[CardImage]
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	cardvalue = 0
	
	visible = false
	pass # Replace with function body.

func set_values(_value: int, card_image: int):
	
	cardvalue = _value + 1
	my_sprite.texture = load(new_texture[card_image])
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
