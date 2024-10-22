@tool
class_name Hand extends Node2D

@export var hand_radius: int = 100
@export var card_angle: float = 90

@onready var Card = $Node2D
@onready var collission_shape: CollisionShape2D = $DebugShape

func add_card():
	
	pass


func get_card_position(angle_in_deg: float) -> Vector2:
	
	var x: float = hand_radius * cos(deg_to_rad(angle_in_deg))
	var y: float = hand_radius * sin(deg_to_rad(angle_in_deg))
	
	return Vector2(int(x), int(y))

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (collission_shape.shape as CircleShape2D).radius != hand_radius:
		(collission_shape.shape as CircleShape2D).set_radius(hand_radius)
		
		Card.set_position(get_card_position(card_angle))
		Card.set_rotation(deg_to_rad(card_angle))
	
	pass
