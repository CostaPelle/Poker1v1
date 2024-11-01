extends Node

var Players = {}

var ServerEnemyCard1
var ServerEnemyCard2

var Online =  true
var Offline = false

@rpc("any_peer")
func update_player_info(player_id, card1_index, card2_index):
		if !Players.has(player_id):
			Players[player_id] = {}
		
		Players[player_id]["PlayerCard1Path"] = card1_index
		Players[player_id]["PlayerCard2Path"] = card2_index
	
	# Synchronize to all clients
		rpc("sync_player_info", player_id, card1_index, card2_index)

# Synchronize function called on all clients
@rpc("any_peer", "call_remote", "reliable")
func sync_player_info(player_id, card1_index, card2_index):
	# Ensure every client has the same data
	if !Players.has(player_id):
		Players[player_id] = {}
	
	Players[player_id]["PlayerCard1Path"] = card1_index
	Players[player_id]["PlayerCard2Path"] = card2_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
