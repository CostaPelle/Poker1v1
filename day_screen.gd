extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var PackOpeningAnim = $BasicPackOpening
@onready var DayLabel = $ColorRect/Label
@onready var LoanLabel = $ColorRect/Label/Label
@onready var BasicCardOpening = $BasicPackOpening
@onready var BasicPackSprite = $BasicPackOpening/HandReroll

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BasicPackSprite.visible = false
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	PackOpeningAnim.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
	elif anim_name == "PackOpening":
		color_rect.visible = false
		DayLabel.visible = true
		BasicPackSprite.visible = false
	elif anim_name == "PackOpening_Bino":
		color_rect.visible = false
		DayLabel.visible = true
		BasicPackSprite.visible = false
	elif anim_name == "PackOpening_Life":
		color_rect.visible = false
		DayLabel.visible = true
		BasicPackSprite.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func transition():
	color_rect.visible = true
	DayLabel.set_text("Day " + str(GlobalVariable.GameData["Day"]))
	if GlobalVariable.GameData["LoanDaysLeft"] == 1:
		LoanLabel.set_text(str(GlobalVariable.GameData["LoanAmt"]) + " Coins due tomorrow")
	if GlobalVariable.GameData["LoanDaysLeft"] == 0:
		LoanLabel.set_text(str(GlobalVariable.GameData["LoanAmt"]) + " Coins due NOW")
	if GlobalVariable.GameData["LoanDaysLeft"] > 1:
		LoanLabel.set_text(str(GlobalVariable.GameData["LoanAmt"]) + " Coins due in " + str(GlobalVariable.GameData["LoanDaysLeft"]) + " days")
	animation_player.play("fade_to_black")

func HandReRoll():
	color_rect.visible = true
	DayLabel.visible = false
	BasicPackSprite.visible = true
	PackOpeningAnim.play("PackOpening")
func Bino():
	color_rect.visible = true
	DayLabel.visible = false
	BasicPackSprite.visible = true
	PackOpeningAnim.play("PackOpening_Bino")
func LifeLine():
	color_rect.visible = true
	DayLabel.visible = false
	BasicPackSprite.visible = true
	PackOpeningAnim.play("PackOpening_Life")


func _on_skip_anim_pressed() -> void:
	color_rect.visible = false
	DayLabel.visible = true
	BasicPackSprite.visible = false
	PackOpeningAnim.stop()
	emit_signal("animation_finished", PackOpeningAnim.current_animation)
	animation_player.stop()
	emit_signal("on_transition_finished", animation_player.current_animation)
