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
# Textures
##################

var _disconnected_icon_texture = Texture.new()



###################
# Node Properties
##################
var websocket_path= "/lobby"


func _ready():
	_disconnected_icon_texture = load("res://resources/textures/lobby/disconnected.png")

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
	_populate_game_label(data.game)
	_populate_user_list(data.game)
	_game_lobby.show()
	WebSocketUtils.save_game_info(data.game.id)
	
func process_leave(data):
	_game_lobby.hide()
	WebSocketUtils.save_game_info(GlobalVariables.LOBBY_GAME_ID)
	

func process_update_game_info(data):
	_populate_user_list(data)
	

###################
# Helper Methods #
###################

func _populate_game_label(data):
	_game_label.text = data.name if (data.name != null) else "Custom Game"
	_game_id_holder.text=data.id

func _populate_user_list(data):
	_user_list.clear()
	var user_list = data.users
	var index =  _user_list.get_item_count();
	for user in user_list:
		if user.connected:
			_user_list.add_item(user.username)
		else:
			_user_list.add_item(user.username, _disconnected_icon_texture)			
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
		GlobalVariables.response_type.game:
			process_update_game_info(response)
			

