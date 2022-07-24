extends "res://utlis/custom_nodes/Websocket.gd"

###################
# Node Objects
##################
onready var _error_label = get_parent().get_node("Login/ErrorMessage")


###################
# Node Signals
##################
signal client_connected

###################
# Node Properties
##################

# Used to store User Info while waiting to connect
#var user_info = null
var websocket_path= "/login"


###################
# Node Methods
##################

# Connect to server and set user info
func login(username, password, register):
	connect_to_websocket_path(websocket_path)
	var user_info = JSON.print({"username": username, "password": password,
			"register": register, "requestType": GlobalVariables.request_type.login})
	yield(self, "client_connected")
	_client.get_peer(1).put_packet(Marshalls.utf8_to_base64(user_info).to_utf8())
	user_info = null

func save_token(token: String):
	print("Saving token")
	var token_file = File.new()
	token_file.open("user://token.jwt", File.WRITE)
	token_file.store_line(token)
	token_file.close()


###################
# Websocket Events #
###################

func show_error(error_text: String):
	_error_label.text=error_text
	_error_label.show()

# Need to override the entire _client_recieved method so we can decode the data
# Once we have retrieved the users JWT store it and log out
func _client_received(_p_id = 1):
	var packet = _client.get_peer(1).get_packet()
	var response = Marshalls.base64_to_utf8(WebSocketUtils.decode_data(packet, true))
	save_token(response)
	disconnect_from_host()
	SceneManager.load_new_scene(GlobalVariables.scene_path.lobby)

# Once we have successfully connected to the host login
func client_connected():
	emit_signal("client_connected")

func client_close_request(code, _reason):
	# Returned from server for login failure
	if code == 1011:
		print("Login Failure")
		show_error("Login failed")
