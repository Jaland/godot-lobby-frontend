extends Node


# Used to store User Info while waiting to connect
var user_info = null

var _client = WebSocketClient.new()
var _write_mode = WebSocketPeer.WRITE_MODE_BINARY

# TODO: Externalize hostname
var hostname="ws://localhost:8080/login"

func _init():
	_client.connect("connection_established", self, "_client_connected")
	_client.connect("connection_error", self, "_client_disconnected")
	_client.connect("connection_closed", self, "_client_disconnected")
	_client.connect("server_close_request", self, "_client_close_request")
	_client.connect("data_received", self, "_client_received")

	_client.connect("peer_packet", self, "_client_received")
	_client.connect("peer_connected", self, "_peer_connected")
	_client.connect("connection_succeeded", self, "_client_connected", [])
	_client.connect("connection_failed", self, "_client_disconnected")

	# I think this is how this works
	# _client.connect("custom_signal", self, "_custom_method_")


func _client_close_request(code, reason):
	print("Close code: %d, reason: %s" % [code, reason])

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
	var fullHostname = hostname + "/" + username
	var err = _client.connect_to_url(fullHostname, protocols, false)
	if(err != OK):
		printerr("Got error while trying to connect to host: %s" % err)
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
	var is_string = _client.get_peer(1).was_string_packet()
	print("Received data. BINARY: %s: %s" % [not is_string, Utils.decode_data(packet, is_string)])
	

func disconnect_from_host():
	_client.disconnect_from_host(1000, "Bye bye!")


