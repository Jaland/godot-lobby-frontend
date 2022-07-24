###################
# Lobby
#
# Script used as a WebSocket client for lobby interactions
##################
extends "res://utlis/custom_nodes/Websocket.gd"

###################
# Node Objects
##################
onready var _chat_client = get_parent().get_node("chat/Client")
onready var _game_name = get_parent().get_node("Lobby/GameName")


###################
# Node Properties
##################
var websocket_path= "/lobby"


###################
# Node Methods
##################
func _connect_to_lobby_service():
	connect_to_websocket_path(websocket_path)
	
func refresh_lobby():
	var request = JSON.print({"requestType": GlobalVariables.request_type.refresh })
	send_data(request)
	
func create_game():
	var request = JSON.print({"requestType": GlobalVariables.request_type.create_game , "name": _game_name.text})
	send_data(request)


###################
# Websocket Events #
###################

func object_recieved(response):
	_chat_client.process_message(response)


