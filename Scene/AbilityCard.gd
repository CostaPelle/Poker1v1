extends TextureButton


@onready var PeekScene = load("res://peekAbilities.tscn")
@onready var HandRerollScene = load("res://hand_rerollAbility.tscn")
@onready var LifelineScene = load("res://life_lineAbility.tscn")


@onready var Shadow = $Shadow
@onready var CardSound = $CardSelected
@onready var GridCont = $"../../../../TabContainer/Abilities/AbilitiesTab/ScrollContainer/MarginContainer/GridContainer"
@onready var PlayerCoins = $"../../../../TabContainer/Coins/CoinLabel"
var CardClicked = false

# Called when the node enters the scene tree for the first time.
func _on_pressed() -> void:
	if CardClicked == true:
		call_deferred("UnclickedCards")
		
		return
	else:
		call_deferred("ClickedCards")
		CardClicked = true
		return
	pass # Replace with function body.
	


func _on_mouse_entered() -> void:
	if CardClicked == false:
		self.position += Vector2(+0,-12)
		Shadow.visible = true
		CardSound.play()
		pass
	
	pass
	
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	if CardClicked == false:
		self.position += Vector2(+0,12)
		Shadow.visible = false
		#CardUnselectedSound.play()
		pass
	
	pass # Replace with function body.

func ClickedCards():
	pass
func UnclickedCards():
	CardClicked = false


func _on_peek_pressed() -> void:
	if CardClicked == true:
		call_deferred("UnclickedCards")
		GlobalVariable.PeekAbility = false
		GlobalVariable.AbilityCounter += 1
		return
	if GlobalVariable.PeekAbility == true:
		return
	else:
		if GlobalVariable.AbilityCounter > 0:
			call_deferred("ClickedCards")
			CardClicked = true
			GlobalVariable.PeekAbility = true
			GlobalVariable.AbilityCounter -= 1
			return


func _on_hand_roll_pressed() -> void:
	if CardClicked == true:
		call_deferred("UnclickedCards")
		GlobalVariable.HandRerollAbility = false
		GlobalVariable.AbilityCounter += 1
		return
	if GlobalVariable.HandRerollAbility == true:
		return
	else:
		if GlobalVariable.AbilityCounter > 0:
			call_deferred("ClickedCards")
			CardClicked = true
			GlobalVariable.HandRerollAbility = true
			GlobalVariable.AbilityCounter -= 1
			return


func _on_life_line_pressed() -> void:
	if CardClicked == true:
		call_deferred("UnclickedCards")
		GlobalVariable.LifeLineAbility = false
		GlobalVariable.AbilityCounter += 1
		return
	if GlobalVariable.LifeLineAbility == true:
		return
	else:
		if GlobalVariable.AbilityCounter > 0:
			call_deferred("ClickedCards")
			CardClicked = true
			GlobalVariable.LifeLineAbility = true
			GlobalVariable.AbilityCounter -= 1
			return


func _on_basic_pack_pressed() -> void:
	var rng = randi_range(1, 3)
	
	
	if rng == 1:
		var Ability = PeekScene.instantiate()
		GridCont.add_child(Ability)
		DayScreen.Bino()
		GlobalVariable.GameData["PeekCount"] += 1
	if rng == 2:
		var Ability = HandRerollScene.instantiate()
		GridCont.add_child(Ability)
		DayScreen.HandReRoll()
		GlobalVariable.GameData["HandrerollCount"] += 1
	if rng == 3:
		var Ability = LifelineScene.instantiate()
		GridCont.add_child(Ability)
		DayScreen.LifeLine()
		GlobalVariable.GameData["LifelineCount"] += 1
	
	GlobalVariable.GameData["PlayerCoins"] -= 10
	PlayerCoins.set_text(str(GlobalVariable.GameData["PlayerCoins"]))
	
	GlobalVariable.save()
