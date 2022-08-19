###################
# WebsocketUtils
#
# Utility Class for calling/reciving information from the server
##################
extends Node

var gameInfoFile="user://game.info"
var userInfoFile="user://user.info"
export var tokenFile="user://token.jwt"

# Encodes Data when passing to server
func encode_data(data, mode):
	if mode == WebSocketPeer.WRITE_MODE_TEXT:
		return data.to_utf8()
	return var2bytes(data)

# Decodes data retrieved from server
func decode_data(data, is_string):
	if is_string:
		return data.get_string_from_utf8()
	return bytes2var(data)
	
# Converts objects into server request 
# Note: Automatically overwrites the gameId to include the game stored in the users local cache 
func object_to_json(object, requestType:String) -> String:
	object.requestType = requestType
	var gameInfo = load_game_info()
	object.gameId = gameInfo.gameId
	object.token=load_token()
	var jsonObject = JSON.print(object)
	return jsonObject
	
# Used to create request that does not require a body
func request_to_json(requestType:String) -> String:
	return object_to_json({}, requestType)
	
####################################
# Storing Information on User Machine
####################################

# Used to store game information that should be sent with every request
func save_game_info(gameId: String):
	print("Saving gameInfo")
	var game_file = File.new()
	game_file.open(gameInfoFile, File.WRITE)
	game_file.store_line(JSON.print({"gameId" : gameId}))
	game_file.close()

# Returns in the form of {gameId: <GAME_ID>}
func load_game_info():
	var default_game_info = {"gameId": GlobalVariables.LOBBY_GAME_ID}
	var game_file = File.new()
	if not game_file.file_exists(gameInfoFile):
		print("Game info does not exist defaulting to 0")
		return default_game_info
	game_file.open(gameInfoFile, File.READ)
	var gameInfoString:String = game_file.get_line()
	game_file.close()
#	Return defult if the sting is empty
	if (gameInfoString == null):
		return default_game_info
	var response = JSON.parse(gameInfoString)
	return response.result
	
	
func save_user_info(username: String):
	print("Saving user")
	var user_file = File.new()
	user_file.open(userInfoFile, File.WRITE)
	user_file.store_line(JSON.print({"username" : username}))
	user_file.close()
	

# Returns in the form of {gameId: <GAME_ID>}
func load_user_info():
	var user_file = File.new()
	if not user_file.file_exists(userInfoFile):
		print("UserInfo Missing must reauthenticate")
		push_error("UserInfo Missing must reauthenticate")
	user_file.open(userInfoFile, File.READ)
	var userInfoString:String = user_file.get_line()
	user_file.close()
	var response = JSON.parse(userInfoString)
	return response.result
	

# Removes existing game if from cache
func clear_game_info():
	var game_file = Directory.new()
	game_file.remove(gameInfoFile)

# Saves Token info
# Requires users to allow for Cookies on HTML5
func save_token(token: String):
	print("Saving token")
	var token_file = File.new()
	token_file.open(tokenFile, File.WRITE)
	token_file.store_line(token)
	token_file.close()
	
# Loads Previously Saved Token Info
func load_token() -> String:
	var token_file = File.new()
	if not token_file.file_exists(tokenFile):
		printerr("Could not find JWT token, note: This application requires 3rd party cookies to be enabled")
		push_error("JWT token not found")
	token_file.open(tokenFile, File.READ)
	var token:String = token_file.get_line()
	token_file.close()
	return token

