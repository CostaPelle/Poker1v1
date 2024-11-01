extends Button

@onready var Levels = $"../../Levels"
@onready var PlayButton = $"../../Page0/Play"
@onready var Page1 = $".."
@onready var SavedData = $"../../SaveData"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	
	SavedData.visible = true
	Page1.visible = false
	PlayButton.SavedData = true
	PlayButton.Page1 = false
	pass # Replace with function body.


func _on_level_01_pressed() -> void:
	
	if PlayButton.Level1 == false:
		get_tree().change_scene_to_file("res://Scene/Level01.tscn")
	
	pass # Replace with function body.


func _on_level_02_pressed() -> void:
	
	if PlayButton.Level2 == false:
		get_tree().change_scene_to_file("res://Scene/Level02.tscn")
	
	pass # Replace with function body.


func _on_level_03_pressed() -> void:
	
	if PlayButton.Level3 == false:
		get_tree().change_scene_to_file("res://Scene/Level03.tscn")
	
	pass # Replace with function body.
