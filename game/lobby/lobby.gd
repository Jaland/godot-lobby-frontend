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
onready var _game_lobby = get_parent().get_node("GameLobby")
onready var _error_popup = get_parent().get_node("ErrorPopup")


###################
# UI Integration Elements
##################
onready var _game_list_ui = get_parent().get_node("Lobby/GameList")



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
	var request = JSON.print({"requestType": GlobalVariables.request_type.lobby_refresh })
	send_data(request)

func join_game():
	var selected_games = _game_list_ui.get_selected_items()
	if(selected_games.empty()):
		show_error("Game must be selected first")
		return
	var gameId = _game_list_ui.get_item_metadata(selected_games[0])
	var request = JSON.print({"requestType": GlobalVariables.request_type.join_game, "joinGameId": gameId})
	send_data(request)
	
func create_game():
	var request = JSON.print({"requestType": GlobalVariables.request_type.create_game , "name": _game_name.text})
	send_data(request)
	


###################
# Process Responces #
###################

func process_refresh(data):
	_game_list_ui.clear()
	var game_list = data.games
	var index =  _game_list_ui.get_item_count();
	for game in game_list:
		var item_name = game.name if (game.name != null) else game.id
		_game_list_ui.add_item(item_name)
		_game_list_ui.set_item_metadata(index, game.id)
		index = index + 1

func process_join(data):
	var game_label=_game_lobby.get_node("GameLabel")
	game_label.text=data.name
	_game_lobby.show()
	
	


###################
# Websocket Events #
###################

func show_error(msg: String):
	_error_popup.get_node("ErrorMessage").text=msg
	_error_popup.popup()

func object_recieved(response):
	_chat_client.process_message(response)
	match response.type:
		GlobalVariables.response_type.game_list:
			process_refresh(response)
		GlobalVariables.response_type.join_game:
			process_join(response)
			
func client_connected_authenticated():
	refresh_lobby()
