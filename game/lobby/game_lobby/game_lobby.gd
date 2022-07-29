###################
# Game Lobby
#
# Helper Script to control the game lobby
# Keeps the lobby script a little more lean
##################
extends Node


###################
# UI Integration Elements
##################
onready var _game_lobby=self.get_parent()
onready var _game_label=self.get_parent().get_node("GameLabel")
onready var _user_list=self.get_parent().get_node("UserList")



###################
# Node Properties
##################
var websocket_path= "/lobby"


###################
# Node Methods
##################

func process_join(data):
	populate_game_label(data)
	populate_user_list(data)

func populate_game_label(data):
	_game_label.text=data.game.name
	_game_lobby.show()

func populate_user_list(data):
	_user_list.clear()
	var user_list = data.game.users
	var index =  _user_list.get_item_count();
	for user in user_list:
		_user_list.add_item(user)
		index = index + 1


###################
# Process Response #
###################


func process_message(response):
	match response.type:
		GlobalVariables.response_type.join_game:
			process_join(response)
			
