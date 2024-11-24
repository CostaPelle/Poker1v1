extends Camera2D

@onready var PlayButton = $"../Page0/NinePatchRect/VBoxContainer/Play"
# Define target values for zoom and position
var target_zoom: Vector2 = Vector2(1, 1)
var target_position: Vector2 = Vector2.ZERO

# Speed for zooming and panning effects
@export var zoom_speed: float = 1
@export var pan_speed: float = 0

func _process(delta: float) -> void:
	# Smoothly adjust zoom towards the target zoom level
	zoom = lerp(zoom, target_zoom, zoom_speed * delta)
	# Smoothly pan towards the target position
	position = lerp(position, target_position, pan_speed * delta)

# Updated function to match the signature with a Vector2 parameter
func set_zoomm(new_zoom: Vector2) -> void:
	target_zoom = new_zoom

# Function to move to a specific part of the background
func move_to(new_position: Vector2) -> void:
	target_position = new_position


func _on_new_game_pressed() -> void:
	set_zoomm(Vector2(3, 3))
	move_to(Vector2(500, 300))


func _on_load_game_pressed() -> void:
	set_zoomm(Vector2(3, 3))
	move_to(Vector2(500, 300))
