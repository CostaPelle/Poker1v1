extends Button

var Page0 = true
var Page1 = false
var Page2 = false
var Page3 = false
var OnlinePage = false
var WorldsPage = false
var LevelsPage = false
var AbilitiesPage = false
var i = 1

var LevelTextures = ["res://Cards/card_diamonds_02.png", "res://Cards/card_diamonds_03.png"]
@onready var PeekScene = load("res://peekAbilities.tscn")
@onready var HandRerollScene = load("res://hand_rerollAbility.tscn")
@onready var LifelineScene = load("res://life_lineAbility.tscn")

var Level1: bool
var Level2: bool
var Level3: bool

@onready var W1Level1Complete = $"../../../../Levels/WorldLevels/World1Levels/World1Level1/Sprite2D"
@onready var W1Level2Complete = $"../../../../Levels/WorldLevels/World1Levels/World1Level2/Sprite2D"
@onready var W1Level2Node = $"../../../../Levels/WorldLevels/World1Levels/World1Level2/Sprite2D2"
@onready var W1Level3Complete = $"../../../../Levels/WorldLevels/World1Levels/World1Boss/Sprite2D"
@onready var W1Level3Node = $"../../../../Levels/WorldLevels/World1Levels/World1Boss/Sprite2D2"
@onready var GridCont = $"../../../../TabContainer/Abilities/AbilitiesTab/ScrollContainer/MarginContainer/GridContainer"

@onready var Backbut = $"../../../../BackBut"
@onready var Page0vis = $"../../.."
@onready var Page1vis = $"../../../../Page1"
@onready var Back = $"../../../../BackBut"
@onready var Levels = $"../../../../Levels"
@onready var SaveData = $"../../../../SaveData"
@onready var Worlds = $"../../../../Levels/Worlds"
@onready var World1 = $"../../../../Levels/WorldLevels/World1Levels"
@onready var World2 = $"../../../../Levels/WorldLevels/World2Levels"
@onready var World3 = $"../../../../Levels/WorldLevels/World3Levels"
#@onready var Camera = $"../../../../Camera2D"
@onready var OnlineTab = $"../../../../Online"


var save_path = "res://SavedData/level.save"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioPlayer.play_music_level()
	GlobalVariable.timestarted = false
	GlobalVariable.time = 480.0
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	
	
	
	Page0vis.visible = false
	Page1vis.visible = true
	Back.visible = true
	Page0 = false
	Page1 = true
	
	pass # Replace with function body.

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_var(Level1)
	file.store_var(Level2)
	file.store_var(Level3)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		Level1 = file.get_var(Level1)
		Level2 = file.get_var(Level2)
		Level3 = file.get_var(Level3)
	else:
		Level1 = false
		Level2 = false
		Level3 = false

func _on_back_but_pressed() -> void:
	if Page1 == true:
		Page1vis.visible = false
		Page0vis.visible = true
		Page1 = false
		Page0 = true
		Backbut.visible = false
		return
	if Page2 == true:
		SaveData.visible = false
		Page1vis.visible = true
		Page2 = false
		Page1 = true
		return
	if WorldsPage == true:
		SaveData.visible = true
		#Levels.visible = false
		Worlds.visible = false
		Page3 = false
		Page2 = true
		WorldsPage = false
		#Camera.set_zoomm(Vector2(1, 1))
		return
	if LevelsPage == true:
		World1.visible = false
		World2.visible = false 
		World3.visible = false  
		Worlds.visible = true
		LevelsPage = false
		WorldsPage = true
		return
	if OnlinePage == true:
		OnlineTab.visible = false
		Page1vis.visible = true
		OnlinePage = false
		Page1 = true
		return


	pass # Replace with function body.


#Page1
func _on_load_game_pressed() -> void:
	
	GlobalVariable.load_data()
	#GlobalVariable.save()
	
	ReloadVariables()
	
	DayScreen.transition()
	await DayScreen.on_transition_finished
	
	SaveData.visible = false
	Worlds.visible = true
	
	Page2 = false
	WorldsPage = true
	
	
	
	pass # Replace with function body.
func _on_new_game_pressed() -> void:
	
	GlobalVariable.new_game()
	
	ReloadVariables()
	
	DayScreen.transition()
	await DayScreen.on_transition_finished
	
	Worlds.visible = true
	
	SaveData.visible = false
	
	Page2 = false
	WorldsPage = true
	
	
	pass # Replace with function body.

func ReloadVariables():
	
	GlobalVariable.PeekAbility = false
	GlobalVariable.HandRerollAbility = false
	GlobalVariable.LifeLineAbility = false
	GlobalVariable.AbilityCounter = 2
	GlobalVariable.Blackjack = false
	
	if GlobalVariable.GameData["LoanDaysLeft"] == 0:
		GlobalVariable.GameData["PlayerCoins"] -= GlobalVariable.GameData["LoanAmt"]
		ReloadLoan()
	
	for child in GridCont.get_children():
		child.queue_free()
	
	if GlobalVariable.GameData["PeekCount"] > 0:
		for i in range(GlobalVariable.GameData["PeekCount"]):
			var Ability = PeekScene.instantiate()
			GridCont.add_child(Ability)
	if GlobalVariable.GameData["HandrerollCount"] > 0:
		for i in range(GlobalVariable.GameData["HandrerollCount"]):
			var Ability = HandRerollScene.instantiate()
			GridCont.add_child(Ability)
	if GlobalVariable.GameData["LifelineCount"] > 0:
		for i in range(GlobalVariable.GameData["LifelineCount"]):
			var Ability = LifelineScene.instantiate()
			GridCont.add_child(Ability)
		
	
	

func ReloadLoan():
	var rngAmt = randi_range(100, 250)
	var rng = randi_range(3, 6)
	
	GlobalVariable.GameData["LoanDaysLeft"] = rng
	GlobalVariable.GameData["LoanAmt"] = rngAmt

#Page2

func _on_offline_pressed() -> void:
	
	$"../../../../TableUpClose".play()
	$"../../../../TableUpClose".visible = true
	
	GameManager.Online = false
	GameManager.Offline = true
	Page1vis.visible = false
	Backbut.visible = false
	#SaveData.visible = true
	Page1 = false
	Page2 = true
	
	await $"../../../../TableUpClose".animation_finished
	
	SaveData.visible = true
	$"../../../../OfflineBackBut".visible = true
	pass # Replace with function body.


#Page3


func _on_online_pressed() -> void:
	GameManager.Online = true
	GameManager.Offline = false
	Page1vis.visible = false
	OnlineTab.visible = true
	Page1 = false
	OnlinePage = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_world_01_pressed() -> void:
	LevelsPage = true
	WorldsPage = false
	Worlds.visible = false
	World1.visible = true
	GlobalVariable.GameData["PlayerCoins"] -= 10
	$"../../../../Timer".visible = true
	GlobalVariable.timestarted = true


func _on_world_02_pressed() -> void:
	if GlobalVariable.GameData["W1L3"] == false:
		return
	LevelsPage = true
	WorldsPage = false
	Worlds.visible = false
	World2.visible = true



func _on_world_03_pressed() -> void:
	if GlobalVariable.GameData["W1L3"] == false:
		return
	LevelsPage = true
	WorldsPage = false
	Worlds.visible = false
	World3.visible = true



func _on_world_1_level_1_pressed() -> void:
	if GlobalVariable.GameData["W1L1"] == true:
		return
	else:
		GlobalVariable.time = 480.0
		GlobalVariable.stopwatch = true
		GlobalVariable.level = 1
		GlobalVariable.MaxBetAmount = 50
		get_tree().change_scene_to_file("res://Scene/Level01.tscn")


func _on_world_1_level_2_pressed() -> void:
	GlobalVariable.time = 480.0
	GlobalVariable.stopwatch = false
	GlobalVariable.Blackjack = true
	GlobalVariable.level = 1
	GlobalVariable.MaxBetAmount = 50
	get_tree().change_scene_to_file("res://black_jack.tscn")
	


func _on_world_1_boss_pressed() -> void:
	pass


func _on_juke_box_pressed() -> void:
	AudioPlayer.MusicNumber += 1
	if AudioPlayer.MusicNumber > 4:
		AudioPlayer.MusicNumber = 0
	AudioPlayer._play_music(load(AudioPlayer.Music[AudioPlayer.MusicNumber]))


func _on_practice_pressed() -> void:
	get_tree().change_scene_to_file("res://PracticeScene.tscn")
	GameManager.Online = true
	GameManager.Practice = true


func _on_offline_back_but_pressed() -> void:
	if LevelsPage == true:
		World1.visible = false
		World2.visible = false 
		World3.visible = false  
		Worlds.visible = true
		LevelsPage = false
		WorldsPage = true
		return
	if WorldsPage == true:
		SaveData.visible = true
		Worlds.visible = false
		WorldsPage = false
		Page2 = true
		return
	if AbilitiesPage == true:
		Worlds.visible = true
		$"../../../../TabContainer".visible = false
		AbilitiesPage = false
		WorldsPage = true
		return
	
	SaveData.visible = false
	Page2 = false
	Page1 = true
	$"../../../../OfflineBackBut".visible = false
	$"../../../../TableUpClose".play_backwards()
	await $"../../../../TableUpClose".animation_finished
	$"../../../../TableUpClose".visible = false
	Page1vis.visible = true
	Backbut.visible = true
	


func _on_abilities_pressed() -> void:
	SaveData.visible = false
	Worlds.visible = false
	AbilitiesPage = true
	WorldsPage = false
	$"../../../../TabContainer".visible = true
	$"../../../../TabContainer/Coins/CoinLabel".set_text(str(GlobalVariable.GameData["PlayerCoins"]))


func _on_life_line_pressed() -> void:
	pass # Replace with function body.


func _on_world_01_mouse_entered() -> void:
	$"../../../../Levels/Worlds/World 01/BuyIn".visible = true


func _on_world_01_mouse_exited() -> void:
	$"../../../../Levels/Worlds/World 01/BuyIn".visible = false
