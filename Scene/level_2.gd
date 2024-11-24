extends Node2D


@onready var gamemanager = $".."
@onready var timer = $"../Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gamemanager.WinMethod = 500000
	timer.time = 240.0
	gamemanager.Level2 = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
