extends Node

@export var PeekAbility = false
@export var HandRerollAbility = false
@export var LifeLineAbility = false
@export var AbilityCounter = 2

@onready var W1L1Node = get_tree().root.get_node("Levels/WorldLevels/World1Levels/HBoxContainer/World1Level1/Sprite2D")
@onready var W1L2Node = get_tree().root.get_node("Levels/WorldLevels/World1Levels/HBoxContainer/World1Level2/Sprite2D")
@onready var W1L3Node = get_tree().root.get_node("Levels/WorldLevels/World1Levels/HBoxContainer/World1Boss/Sprite2D")
@onready var timer = $Timer

@export var winmethod: int
@export var time = 480.0
@export var stopwatch: bool
@export var level: int
var MaxBetAmount: int
var timestarted = false

var Blackjack = false

@export var GameData = {}

#var save_path = "res://SavedData/level.json"
var save_path = "user://savegame.json"

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if timestarted == true:
		time -= delta
		if time <= 0.0:
			$".".Lose()
			timestarted = false

func time_to_string() -> String:
	var msec = fmod(time, 1) * 1000
	var sec = fmod(time, 60)
	var min = time/60
	var format_string = "%02d : %02d"
	var actual_string = format_string % [min, sec]
	return actual_string

func save():
	var jsonString = JSON.stringify(GameData)
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_line(jsonString)
	file.close()

func load_data():
	var rngAmt = randi_range(100, 500)
	var rng = randi_range(1, 5)
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	if not file.file_exists(save_path):
		GameData = {
		"PlayerCoins": 50,
		"PeekCount": 0,
		"HandrerollCount": 0,
		"LifelineCount": 0,
		"Day": 1,
		"LoanAmt": rngAmt,
		"LoanDaysLeft": rng,
		"W1L1": false,
		"W1L2": false,
		"W1L3": false
		}
		save()
	if FileAccess.file_exists(save_path):
		var jsonString = file.get_as_text()
		file.close()
		GameData = JSON.parse_string(jsonString)
	else:
		print("File does not exist")

func new_game():
	var rngAmt = randi_range(100, 250)
	var rng = randi_range(3, 6)
	
	GameData = {
		"PlayerCoins": 50,
		"PeekCount": 0,
		"HandrerollCount": 0,
		"LifelineCount": 0,
		"Day": 1,
		"LoanAmt": rngAmt,
		"LoanDaysLeft": rng,
		"W1L1": false,
		"W1L2": false,
		"W1L3": false
	}
	
	
	save()
	
