extends Node


onready var _error_label = get_parent().get_node("Login/ErrorMessage")
onready var _transition_player = get_parent().get_node("TransitionScreen")

# Used to store User Info while waiting to connect
var user_info = null

var _client = WebSocketClient.new()

# TODO: Externalize hostname
var hostname="ws://localhost:8080/login"
var path_to_lobby_scene=""

func _init():
	_client.connect("connection_established", self, "_client_connected")
	_client.connect("connection_error", self, "_client_disconnected")
	_client.connect("connection_closed", self, "_client_disconnected")
	_client.connect("server_close_request", self, "_client_close_request")
	_client.connect("data_received", self, "_client_received")
	_client.connect("connection_failed", self, "_client_disconnected")


func _client_close_request(code, reason):
	print("Close code: %d, reason: %s" % [code, reason])
	# Returned from server for login failure
	if code == 1011:
		print("Login Failure")
		show_error("Login failed")

func _exit_tree():
	_client.disconnect_from_host(1001, "Bye bye!")


func _process(_delta):
	if _client.get_connection_status() == WebSocketClient.CONNECTION_DISCONNECTED:
		return
	_client.poll()



func _client_disconnected(clean=true):
	print("Client just disconnected. Was clean: %s" % clean)


# Connect to server and set user info
func login(username, password, protocols, register):
	# if(OS.is_userfs_persistent()):
		# show_error("Cookies must be enabled to use login")
	var fullHostname = hostname + "/" + username
	var err = _client.connect_to_url(fullHostname, protocols, false)
	if(err != OK):
		printerr("Got error while trying to connect to host: %s" % err)
		show_error("Got error while trying to connect to host")
		return
	user_info = JSON.print({"username": username, "password": password,"register": register})
	return err

# Once we have successfully connected to the host login
func _client_connected(protocol):
	print("Client just connected with protocol: %s" % protocol)
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	if user_info == null:
		printerr("User info missing")
		return
	print("Sending user info %s" % user_info)
	print("Sending base64 info %s" % Marshalls.utf8_to_base64(user_info))
	_client.get_peer(1).put_packet(Marshalls.utf8_to_base64(user_info).to_utf8())
	user_info = null

# Once we have retrieved the users JWT store it and log out
func _client_received(_p_id = 1):
	var packet = _client.get_peer(1).get_packet()
	var response = Marshalls.base64_to_utf8(Utils.decode_data(packet, true))
	save_token(response)
	disconnect_from_host()
	_transition_player.hide_scene()
	
func _load_lobby():
#	ClientNode
	print("Loading Scene")
	var root = get_parent()
	root.remove_child(root.get_node("Login"))
	root.get_child(0).queue_free()
	var LobbyScene = preload("res://lobby/lobby.tscn")
	root.add_child(LobbyScene.instance())
	
#	get_tree().change_scene("lobby-client/lobby.tscn")
	_transition_player.show_scene()

func disconnect_from_host():
	_client.disconnect_from_host(1000, "Bye bye!")


func show_error(error_text: String):
	_error_label.text=error_text
	_error_label.show()

func save_token(token: String):
	print("Saving token")
	var token_file = File.new()
	token_file.open("user://token.jwt", File.WRITE)
	token_file.store_line(token)
	token_file.close()


# Currently used just for testing
func load_token():
	var token_file = File.new()
	if not token_file.file_exists("user://token.jwt"):
		printerr("Could not find JWT token, note: This application requires 3rd party cookies to be enabled")
		# TODO Return to login screen
		return # Error! We don't have a save to load.
	token_file.open("user://token.jwt", File.READ)
	return token_file.get_line()
