###################
# Lobby
#
# Script used as a WebSocket client for lobby interactions
##################
extends "res://utlis/custom_nodes/Websocket.gd"

###################
# Node Objects
##################

# Chat Clients
onready var _chat_client = get_parent().get_node("chat/Client")

onready var _spawn_points = get_parent().get_node("SpawnPoints")

onready var _players_list  = get_parent().get_node("Players")

onready var _game_scene = get_parent()

var websocket_path= "/walkingsimulator"


###################
# Game Objects
##################

var my_player
onready var my_player_name = WebSocketUtils.load_user_info().username 
var other_players = [] 

###################
# Preloaded Assests
##################

const player_scene = preload("res://game/walking_simulator/ingame-objects/player.tscn")
#const PlayerScript = preload("res://game/walking_simulator/ingame-objects/player.gd")
#var player_script:PlayerScript

###################
# Node Methods
##################

func _connect_to_game():
	connect_to_websocket_path(websocket_path)


###################
# Game Methods
##################

func _spawn_player():
	var spawnPoints = _spawn_points.get_children()
	var spawnPoint = spawnPoints[randi() % spawnPoints.size()]
	var player = player_scene.instance()
	player.position = spawnPoint.position
	_players_list.add_child(player)
	return player
	
func _get_spawn_points(numOfPoints: int) -> Array:
	var spawnPoints = shuffleList(_spawn_points.get_children())
	var returnVectors = []
	for i in numOfPoints:
		returnVectors.append(spawnPoints[i].position)
	return returnVectors

func _spawn_player_with_position(position: Vector2):
	var player = player_scene.instance()
	player.position = position
	return player
	

###################
# Process Responses #
###################

func process_setup_map(data):
	var playerNames = data.players.keys()
	for playerName in playerNames:
		var playerInfo = data.players[playerName]
		var player = _spawn_player_with_position(Vector2(playerInfo.x,playerInfo.y))
		if(playerName == my_player_name):
			my_player=player
			player.set_script(load("res://game/walking_simulator/ingame-objects/player.gd"))
		_players_list.add_child(player)
	
func process_load_assets(data):
	var userList = data.users
	var spawnPositions = _get_spawn_points(userList.size())
	var gameSetupRequest = {"players": {}}
	var players = {}
	for i in userList.size():
		var user = userList[i]
		var spawnPosition = spawnPositions[i]
		gameSetupRequest.players[user.username] = {"x": spawnPosition.x, "y": spawnPosition.y}
	send_data(WebSocketUtils.object_to_json(gameSetupRequest, GlobalVariables.request_type.load_assets))
	
		
###################
# Websocket Events #
###################

func object_recieved(response):
	_chat_client.process_message(response)
	match response.type:
		GlobalVariables.response_type.load_assets:
			process_load_assets(response)
		GlobalVariables.response_type.map_setup:
			process_setup_map(response)
	
func client_connected():
	send_data(WebSocketUtils.request_to_json(GlobalVariables.request_type.initial_request))


###################
# Utility Class #
###################

# Stole this from sa form hoping it works
func shuffleList(list):
	var shuffledList = [] 
	var indexList = range(list.size())
	for i in range(list.size()):
		var x = randi()%indexList.size()
		shuffledList.append(list[indexList[x]])
		indexList.remove(x)
	return shuffledList
