extends Button

@onready var PlayButton = $"../Page0/Play"
@onready var Page0 = $"../Page0"
@onready var Page1vis = $"../Page1"
@onready var Levels = $"../Levels"
@onready var SavedData = $"../SaveData"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	
	if PlayButton.Page1 == true:
		Page0.visible = true
		Page1vis.visible = false
		PlayButton.Page1 = false
		PlayButton.Page0 = true
		self.visible = false
	if PlayButton.Page2 == true:
		SavedData.visible = true
		Levels.visible = false
		PlayButton.Page1 = true
		PlayButton.Page2 = false
	if PlayButton.SaveData == true:
		Page1vis.visible = true
		Levels.visible = false
		PlayButton.Page1 = true
		PlayButton.Page2 = false
	
	pass # Replace with function body.
