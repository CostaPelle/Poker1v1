@tool
extends Node2D

@onready var CardScene: PackedScene = preload("res://Scene/Main.tscn")
@onready var spawn_point = $CanvasLayer/Deck

@onready var PlayButton = $Play
@onready var BetButton = $Bet

var Current_Sprite = 0
var cardvalue = 1




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	
	PlayButton.visible = false
	BetButton.visible = true
	
	while Current_Sprite < 52:
		var card: Card = CardScene.instantiate()
		spawn_point.add_child(card)
		card.set_values(cardvalue, Current_Sprite)
		if cardvalue <= 12:
			cardvalue += 1
		else:
			cardvalue = 1
		Current_Sprite += 1
		card.visible = false
		#Deck.append(Card)
		pass # Replace with function body.
		if Current_Sprite > 51:
			var Card1 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
			
			Card1.set_visible(true)
			Card1.position = Vector2(-50,0)
			Card1.scale = Vector2(.5,.5)
			
			var Card2 = $CanvasLayer/Deck.get_child(randi() % $CanvasLayer/Deck.get_child_count())
			
			Card2.set_visible(true)
			Card2.position = Vector2(50,0)
			Card2.scale = Vector2(.5,.5)
			
			pass
		
		
	
