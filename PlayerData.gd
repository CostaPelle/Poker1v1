extends Resource
class_name PlayerData

const SAVE_GAME_PATH := "user://savegame.tres"

@export var World1Level1 := false
@export var World1Level2 := false
@export var World1Level3 := false



func save() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)
