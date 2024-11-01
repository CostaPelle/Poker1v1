extends Button

var Page0 = true
var Page1 = false
var Page2 = false
var Page3 = false

var Level1: bool
var Level2: bool
var Level3: bool

@onready var Level1Node = $"../../Levels/Level 01/Sprite2D"
@onready var Level2Node = $"../../Levels/Level 02/Sprite2D"
@onready var Level3Node = $"../../Levels/Level 03/Sprite2D"

@onready var Backbut = $"../../BackBut"
@onready var Page0vis = $".."
@onready var Page1vis = $"../../Page1"
@onready var Back = $"../../BackBut"
@onready var Levels = $"../../Levels"
@onready var SaveData = $"../../SaveData"

var save_path = "res://SavedData/level.save"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	if Page3 == true:
		SaveData.visible = true
		Levels.visible = false
		Page3 = false
		Page2 = true
		return


	pass # Replace with function body.


#Page1
func _on_load_game_pressed() -> void:
	
	load_data()
	
	if Level1 == true:
		Level1Node.visible = true
	if Level2 == true:
		Level2Node.visible = true
	if Level3 == true:
		Level3Node = true
		
	SaveData.visible = false
	Levels.visible = true
	
	Page2 = false
	Page3 = true
	
	pass # Replace with function body.
func _on_new_game_pressed() -> void:
	
	Level1 = false
	Level2 = false
	Level3 = false
	
	Level1Node.visible = false
	Level2Node.visible = false
	Level3Node.visible = false
	
	save()
	
	SaveData.visible = false
	Levels.visible = true
	
	Page2 = false
	Page3 = true
	
	pass # Replace with function body.



#Page2

func _on_offline_pressed() -> void:
	
	GameManager.Online = false
	GameManager.Offline = true
	Page1vis.visible = false
	SaveData.visible = true
	Page1 = false
	Page2 = true
	
	pass # Replace with function body.


#Page3
func _on_level_01_pressed() -> void:
	if Level1 == false:
		get_tree().change_scene_to_file("res://Scene/Level01.tscn")
	pass # Replace with function body.


func _on_level_02_pressed() -> void:
	if Level2 == false:
		get_tree().change_scene_to_file("res://Scene/Level02.tscn")
	pass # Replace with function body.


func _on_level_03_pressed() -> void:
	if Level3 == false:
		get_tree().change_scene_to_file("res://Scene/Level03.tscn")
	pass # Replace with function body.


func _on_online_pressed() -> void:
	GameManager.Online = true
	GameManager.Offline = false
	get_tree().change_scene_to_file("res://addons/lan_multiplayer/scenes/lobby_controller.tscn")
