###################
# Game Lobby
#
# Helper Script to control the game lobby
# Keeps the lobby script a little more lean
##################
extends Node


onready var _lobby_client=self.get_parent().get_node("../Client")

###################
# UI Integration Elements
##################
onready var _game_lobby=self.get_parent()
onready var _game_label=self.get_parent().get_node("GameInfo/GameLabel")
onready var _game_id_holder=self.get_parent().get_node("GameInfo/IdHolder")
onready var _user_list=self.get_parent().get_node("UserList")



###################
# Node Properties
##################
var websocket_path= "/lobby"


###################
# Node Methods
##################

func disconnect_from_game():
	_lobby_client.send_data(WebSocketUtils.request_to_json(
		GlobalVariables.request_type.leave_game))

###################
# Process Responses #
###################

func process_join(data):
	populate_game_label(data)
	populate_user_list(data)
	_game_lobby.show()
	WebSocketUtils.save_game_info(data.game.id)
	
func process_leave(data):
	_game_lobby.hide()
	WebSocketUtils.save_game_info(GlobalVariables.LOBBY_GAME_ID)
	

###################
# Process Response #
###################

func populate_game_label(data):
	_game_label.text = data.game.name if (data.game.name != null) else "Custom Game"
	_game_id_holder.text=data.game.id

func populate_user_list(data):
	_user_list.clear()
	var user_list = data.game.users
	var index =  _user_list.get_item_count();
	for user in user_list:
		_user_list.add_item(user)
		index = index + 1


###################
# Websocket Events #
###################

func process_message(response):
	match response.type:
		GlobalVariables.response_type.join_game:
			process_join(response)
		GlobalVariables.response_type.leave_game:
			process_leave(response)
			

