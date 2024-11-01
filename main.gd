extends Node2D

var lobby_id = 0
var peer = SteamMultiplayerPeer.new()

@onready var ms = $MultiplayerSpawner

@export_category("Settings")
@export_group("Travel")
@export_dir var travel_to_scene: String
@export_group("Customize Lobby")
@export_enum("Default", "Adventure", "Pixel", "Custom") var scheme = "Default"

#LOBBY INTEGRATION
#1.1 Host & Join Signals
func _on_host_button_pressed():
	reset_buttons()
	hide_host_and_join_buttons()
	$host/ip_address.show()
	$host/port.show()
	$room.show()
	
	SendPlayerInfo(multiplayer.get_unique_id())
	
	host($settings/max_players.value)
	

func _on_join_button_pressed():
	hide_host_and_join_buttons()
	$join/waiting_text.show()
	$room.show()
	
	join($join/ip_address.text, $join/port.text.to_int())

func _on_settings_pressed():
	hide_host_and_join_buttons()
	$settings.show()

func _on_back_button_pressed():
	reset_buttons()
	leave()

func _on_safe_back_button_pressed():
	reset_buttons()

#1.2 Host Signals
func _on_start_button_pressed():
	StartGame.rpc()

@rpc("any_peer","call_local")
func StartGame():
	print("works")
	var scene = load("res://Scene/OnlineGame.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()
	pass


#2 UI Help Functions
func reset_buttons():
	hide_host_and_join_buttons()
	$room.hide()
	$settings.hide()
	$host/host_button.show()
	$host/start_button.hide()
	$host/settings.show()
	$join/join_button.show()
	$join/ip_address.show()
	$join/port.show()
	$join/error_text.show()

func hide_host_and_join_buttons():
	for i in get_node("host").get_child_count():
		get_node("host").get_child(i).hide()
	for i in get_node("join").get_child_count():
		get_node("join").get_child(i).hide()

func show_join_error(error_text):
	reset_buttons()
	$join/error_text.text = error_text
	if error_text == "Error: Full Room":
		$join/error_text/AnimationPlayer.play("full")
	elif error_text == "Error: Invalid IP Address" or error_text == "Error: Invalid Port":
		$join/error_text/AnimationPlayer.play("invalid")

#SERVER INTEGRATION
var cache = "user://connected_players.dat"
var max_players = 2
var port = 5000
var connected_players = []

#Server
signal server_started(host_id: int) ## Server receives this signal.

#Server & Players
signal player_connected(id: int) ## Server & players receive this signal.
signal player_disconnected(id: int, connected_players: Array) ## Server & players receive this signal.

#Players
signal server_ended ## Players receive this signal.

#DO NOT USE
signal update_for_new_player() ## THIS IS USED IN SCRIPT, DO NOT TOUCH!

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ms.spawn_function = spawn_level
	peer.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(on_lobby_match_list)
	open_lobby_list()
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

@rpc("any_peer")
func spawn_level(data):
	var a = (load(data) as PackedScene).instantiate()
	return a

@rpc("call_local")
func load_scene(path: String):
	ms.spawn(path)

@rpc("any_peer")
func SendPlayerInfo(id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"id" : id,
			"PlayerCard1" : Object,
			"PlayerCard1Index" : 0,
			"PlayerCard2" : Object,
			"PlayerCard2Index" : 0,
			"ChipCount" : 50000
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInfo.rpc(i)


func _on_player_connected(id):
	if multiplayer.is_server():
		test_if_allowed_on_server(id)
	SendPlayerInfo.rpc_id(1, multiplayer.get_unique_id())
	connected_players.append(id)
	add_room_player(id)
	
	if multiplayer.is_server():
		$host/start_button.show()
		
	emit_signal("player_connected", id)
	print("works")

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	remove_all_room_players()
	reset_buttons()
	emit_signal("server_ended")

func test_if_allowed_on_server(id):
	if connected_players.size() == max_players:
		rpc_id(id, "process_kick", "Error: Full Room", id)
	else:
		rpc("processed_player")

@rpc("authority", "call_local", "reliable", 0)
func processed_player():
	call_deferred("emit_signal", "update_for_new_player")

#Kick Process
@rpc("authority", "call_remote", "reliable", 0)
func process_kick(reason, my_id):
	show_join_error(reason)
	rpc_id(1, "processed_kick", my_id)

@rpc("any_peer", "call_remote", "reliable", 0)
func processed_kick(id):
	multiplayer.multiplayer_peer.disconnect_peer(id)

func _on_player_disconnected(id):
	connected_players.erase(id)
	remove_room_player(id)
	
	if multiplayer.is_server():
		if connected_players.size() < 2:
			$host/start_button.hide()
			
	emit_signal("player_disconnected", id, connected_players)


func _on_host_pressed() -> void:
	peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.multiplayer_peer = peer
	SendPlayerInfo(multiplayer.get_unique_id())
	load_scene("res://Scene/Level.tscn")
	rpc("load_scene", "res://Scene/Level.tscn")  # Tell clients to load the scene
	$Host.hide()
	$LobbyContainer/Lobbies.hide()
	$Refresh.hide()


func join_lobby(id):
	peer.connect_lobby(id)
	multiplayer.multiplayer_peer = peer
	lobby_id = id
	SendPlayerInfo.rpc_id(1, id)
	rpc_id(1, "request_scene_sync")  # Request current scene from host
	$Host.hide()
	$LobbyContainer/Lobbies.hide()
	$Refresh.hide()

func request_scene_sync():
	# Host sends the current scene to the client
	rpc_id(multiplayer.get_unique_id(), "load_scene", "res://Scene/Level.tscn")

func _on_lobby_created(connect, id):
	if connect:
		lobby_id = id
		Steam.setLobbyData(lobby_id,"name",str(Steam.getPersonaName()+"'s Lobby"))
		Steam.setLobbyJoinable(lobby_id,true)

func open_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()

func on_lobby_match_list(lobbies):
	
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby,"name")
		var memb_count = Steam.getNumLobbyMembers(lobby)
		
		var but = Button.new()
		but.set_text(str(lobby_name,"| Player Count: ", memb_count))
		but.set_size(Vector2(100,5))
		but.connect("pressed",Callable(self,"join_lobby").bind(lobby))
		
		$LobbyContainer/Lobbies.add_child(but)

func _on_refresh_pressed():
	if $LobbyContainer/Lobbies.get_child_count() > 0:
		for n in $LobbyContainer/Lobbies.get_children():
			n.queue_free()
		
	open_lobby_list()



#Player tools
func start():
	rpc("start_scene", connected_players, $settings/time.value)

func leave():
	multiplayer.multiplayer_peer.close()
	remove_all_room_players()
	connected_players.clear()

@rpc("authority", "call_local", "reliable", 0)
func start_scene(connected_players, time):
	save(connected_players, time)
	get_tree().change_scene_to_file(travel_to_scene)

func save(connected_players, time):
	var file = FileAccess.open(cache, FileAccess.WRITE)
	file.store_var(connected_players)
	file.store_var(time)

func add_room_player(id):
	var room_player = preload("res://addons/lan_multiplayer/scenes/room_player.tscn").instantiate()
	room_player.name = str(id)
	update_for_new_player.connect(room_player.get_node("player_controller")._on_update_for_new_player)
	server_ended.connect(room_player.get_node("player_controller")._on_server_disconnected)
	$room/room.add_child(room_player)

func remove_all_room_players():
	for i in connected_players.size():
		remove_room_player(connected_players[i])

func remove_room_player(id):
	if $room/room.get_node_or_null(str(id)):
		$room/room.get_node(str(id)).queue_free()

#Server tools
func host(max):
	max_players = max
	port = randi_range(9999, 5000)
	peer.create_server(port, max_players)
	multiplayer.multiplayer_peer = peer
	connected_players.append(1)
	add_room_player(1)
	
	$host/port.text = str(port)
	emit_signal("server_started", 1)

func join(ip, p):
	if not ip.is_valid_ip_address():
		show_join_error("Error: Invalid IP Address")
	elif not (p >= 5000 and p <= 9999):
		show_join_error("Error: Invalid Port")
	else:
		peer.create_client(ip, p)
		multiplayer.multiplayer_peer = peer
		
		connected_players.append(multiplayer.get_unique_id())
		add_room_player(multiplayer.get_unique_id())
