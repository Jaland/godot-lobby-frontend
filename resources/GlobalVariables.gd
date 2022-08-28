###################
# GlobalVariables
#
# This class is intended to be used for variables that can be accessed throughout the project
#
# Note: For varables that may change based on environment such as server's hostname use the 
# `override.cfg` at the base of the project and get the var with "ProjectSettings.get_setting(<var>)
##################
extends Node

#Path To the different scenes in the game
export var base_path = "game/"
export(Dictionary) var scene_path={
	lobby=base_path + "lobby/lobby.tscn",
	login=base_path + "login/login.tscn",
	walking_simulator=base_path + "walking_simulator/game.tscn"
}

#Request Types
export(Dictionary) var request_type={
	login="LOGIN",
	chat="CHAT",
	lobby_refresh="LOBBY_REFRESH",
	join_lobby="JOIN_LOBBY",
	initial_request ="INITIAL_REQUEST",
	create_game ="CREATE_GAME",
	join_game ="JOIN_GAME",
	leave_game ="LEAVE_GAME",
	start_game ="START_GAME",
	restart_game ="RESTART_GAME",
	load_assets = "LOAD_ASSETS",
	player_update = "PLAYER_UPDATE",
	goal_touched = "GOAL_TOUCHED",
}


#Request Types
export(Dictionary) var response_type={
	invalid ="invalid",
	chat="chat",
	game_list ="game_list",	
	join_game ="join_game",	
	leave_game ="leave_game",
#	This will be the most common response, used for updating game information
	game ="game",
	start_game ="start_game",
	load_assets ="load_assets",
	map_setup ="map_setup",
	player_update ="player_update",
}



#Request Types
export(Dictionary) var game_state={
  waiting="WAITING",
  loading="LOADING",
  started="STARTED",
  finished="FINISHED",
  aborted="ABORTED",
  error="ERROR",

}

export var LOBBY_GAME_ID="0"
