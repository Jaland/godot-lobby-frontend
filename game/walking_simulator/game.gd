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

onready var _game_viewport = get_parent().get_node("Game/Viewport")

onready var _spawn_points = get_parent().get_node("Game/Viewport/SpawnPoints")

onready var _goal_spawn_points = get_parent().get_node("Game/Viewport/GoalSpawnPoints")

onready var _players_list  = get_parent().get_node("Game/Viewport/Players")

onready var _game_camera  = get_parent().get_node("Game/Viewport/Camera")

onready var _start_game_popup  = get_parent().get_node("Start_Menu")


onready var _game_scene = get_parent()

var websocket_path= "/walkingsimulator"


###################
# Signals
##################

signal game_over

signal prep_start_game

signal host_clicked_start

###################
# Game Objects
##################

const _ingame_object_base_path = "res://game/walking_simulator/ingame-objects"

var my_player
onready var my_player_name = WebSocketUtils.load_user_info().username 
var current_host = "" 
var other_players = [] 

###################
# Preloaded Assests
##################
const _player_scene_path = _ingame_object_base_path + "/player/player.tscn"
const player_scene = preload(_player_scene_path)
const _goal_scene_path = _ingame_object_base_path + "/coin/coin.tscn"
const goal_scene = preload(_goal_scene_path)


###################
# Node Methods
##################

func _connect_to_game():
	connect_to_websocket_path(websocket_path)


###################
# Game Methods
##################
	
func _get_spawn_points(numOfPoints: int) -> Array:
	var spawnPoints = shuffleList(_spawn_points.get_children())
	var returnVectors = []
	for i in numOfPoints:
		returnVectors.append(spawnPoints[i].position)
	return returnVectors
	
func _get_goal_spawn_position() -> Vector2:
	var numOfSpawnPoints = _goal_spawn_points.get_child_count()
	var random = RandomNumberGenerator.new()
	random.randomize()
#	var randomPoint = random.randi_range(numOfSpawnPoints-1, 0)
	var randomPoint = 1 # Used for testing
	var goalSpawnPoint = _goal_spawn_points.get_child(randomPoint)
	return goalSpawnPoint.position

func _spawn_player_with_position(position: Vector2):
	var player = player_scene.instance()
	player.position = position
	return player

func setup_players(players):
	var playerNames = players.keys()
	remove_all_children(_players_list)
	for playerName in playerNames:
		var playerInfo = players[playerName]
		if(!playerInfo.has("position")):
			print("Player: %s, is not a part of the current game" % playerName)
			continue;
		var player = _spawn_player_with_position(WebSocketUtils.object_to_vector(playerInfo.position))
		if(playerName == my_player_name):
			my_player=player
			player.set_script(load(_ingame_object_base_path + "/player/my_player.gd"))
			_game_camera.player = my_player
			_game_camera.current = true
		else:
			player.set_script(load(_ingame_object_base_path + "/player/other_player.gd"))			
		player.set_meta("username", playerName)
		_players_list.add_child(player)
	if(my_player != null):
		my_player.connect("update_player_position", self, "_update_player_position")


func setup_goal(goalData):
	if(goalData == null):
		printerr("Goal data not provided in map setup")
		return
	if(_game_viewport.has_node("goal")):
		_game_viewport.remove_child(_game_viewport.get_node("goal"))
	var goal = goal_scene.instance()
	goal.name = "goal"
	goal.connect("body_entered", self, "_goal_touched")
	goal.position = WebSocketUtils.object_to_vector(goalData.position)
	_game_viewport.add_child(goal)
	
###################
# Websocket Events #
###################

func object_recieved(response):
	.object_recieved(response)
	_chat_client.process_message(response)
	match response.type:
		GlobalVariables.response_type.load_assets:
			process_load_assets(response)
		GlobalVariables.response_type.map_setup:
			process_setup_map(response)
		GlobalVariables.response_type.player_update:
			process_player_update(response)
		GlobalVariables.response_type.game_over:
			process_game_over(response)
		GlobalVariables.response_type.starting_game:
			process_starting_game(response)
	
func client_connected():
	send_data(WebSocketUtils.request_to_json(GlobalVariables.request_type.initial_request))

	
###################
# Process Responses #
###################

func process_setup_map(data):
	setup_players(data.players)
	setup_goal(data.goal)
	current_host = data.host
	emit_signal("prep_start_game", is_host())
	

func process_load_assets(data):
	var userList = data.users
	var spawnPositions = _get_spawn_points(userList.size())
	var gameSetupRequest = {"players": {}}
	for i in userList.size():
		var user = userList[i]
		var spawnPosition = spawnPositions[i]
		var playerRequest = {"position": WebSocketUtils.vector_to_object(spawnPosition), 
			"velocity": WebSocketUtils.vector_to_object(Vector2(0,0))}
		gameSetupRequest.players[user.username] = playerRequest
	var goalPosition = _get_goal_spawn_position()
	var goalInfo = {"position" : WebSocketUtils.vector_to_object(goalPosition)}
	gameSetupRequest.goal = goalInfo
	send_data(WebSocketUtils.object_to_json(gameSetupRequest, GlobalVariables.request_type.load_assets))
	
func process_player_update(data):
	var players = _players_list.get_children()
	for player in players:
		var username = player.get_meta("username")
		if(username == data.username):
			player.set_global_position(Vector2(data.position.x, data.position.y))
			player.velocity = Vector2(data.velocity.x, data.velocity.y)
			return

func process_game_over(data):
	print("Processing Game Over")
	var winner:String = data.winner
	emit_signal("game_over", winner + " HAS WON!", is_host())


func process_starting_game(data):
	print("Processing Starting Game")
	emit_signal("host_clicked_start")

###################
# Process Signals #
###################
		
func _update_player_position(position:Vector2, velocity:Vector2):
	var current_position = {"position": WebSocketUtils.vector_to_object(position)
		, "velocity": WebSocketUtils.vector_to_object(velocity), "username": my_player_name}
	send_data(WebSocketUtils.object_to_json(current_position, GlobalVariables.request_type.player_update))

func _start_game():
	send_data(WebSocketUtils.request_to_json(GlobalVariables.request_type.start_game))

func _goal_touched(body: Node):
	var winner = body.get_meta("username")
	if(winner != my_player_name):
		print("Some other player got to the goal :(")
	print("Sending WIN message")
	var goal_touched = {"winner": winner}
	send_data(WebSocketUtils.object_to_json(goal_touched, GlobalVariables.request_type.goal_touched))


########################
# Genaric Game Methods #
########################

func restart_game():
	send_data(WebSocketUtils.request_to_json(GlobalVariables.request_type.restart_game))

###################
# Utility Class #
###################

# Stole this from sa form hoping it works
func shuffleList(list):
	var shuffledList = [] 
	var indexList = range(list.size())
	for _i in range(list.size()):
		var x = randi()%indexList.size()
		shuffledList.append(list[indexList[x]])
		indexList.remove(x)
	return shuffledList


# Stole this from sa form hoping it works
func remove_all_children(node: Node):
	for n in node.get_children():
		node.remove_child(n)

func is_host():
	return current_host == my_player_name
