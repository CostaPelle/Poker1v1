extends MultiplayerSpawner

@export var PlayerScene : PackedScene

func _ready() -> void:
	spawn_function = SpawnPlayer
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(RemovePlayer)

var Players = {}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func SpawnPlayer(data):
	var p = PlayerScene.instantiate()
	p.set_multiplayer_authority(data)
	Players[data] = p
	return p

func RemovePlayer(data):
	Players[data].queue_free()
	Players.erase(data)
