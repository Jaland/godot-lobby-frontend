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

# This property is used by the websocket node to determine the websocket server path
var websocket_path= "/login"


###################
# Node Methods
##################

# Connect to server and set user info
func login(username, password, register):
	connect_to_websocket_path(websocket_path)
	var user_info = JSON.print({"username": username, "password": password,
			"register": register, "requestType": GlobalVariables.request_type.login})
	WebSocketUtils.save_user_info(username)
	yield(self, "client_connected")
	_client.get_peer(1).put_packet(Marshalls.utf8_to_base64(user_info).to_utf8())
	user_info = null

###################
# Websocket Events #
###################

# Prevent the popup from being shown for login page
func client_error():
	pass

func show_error(error_text: String):
	_error_label.text=error_text
	_error_label.show()

# Need to override the entire _client_recieved method so we can decode the data
# Once we have retrieved the users JWT store it and log out
func _client_received(_p_id = 1):
	var packet = _client.get_peer(1).get_packet()
	var response = Marshalls.base64_to_utf8(WebSocketUtils.decode_data(packet, true))
	WebSocketUtils.save_token(response)
	disconnect_from_host()
	SceneManager.load_new_scene(GlobalVariables.scene_path.lobby)

# Once we have successfully connected to the host login
func client_connected():
	emit_signal("client_connected")

func client_close_request(code, reason):
	# Returned from server for login failure
	if code != 1000:
		print("Login Failure: ", reason)
		show_error(reason)
