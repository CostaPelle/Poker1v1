extends Node2D

@onready var gamemanager = $".."
@onready var timer = $"../Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer._play_music(load(AudioPlayer.Music[AudioPlayer.MusicNumber]))
	gamemanager.WinMethod = 250000
	timer.time = 300.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Win():
	if GlobalVariable.level == 1:
		GlobalVariable.GameData.W1L1 = true
		GlobalVariable.save()
