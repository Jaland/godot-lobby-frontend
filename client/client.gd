extends Node

onready var _log_dest = get_parent().get_node("ChatScreen/Chat/ChatArea")
onready var _login_screen = get_parent().get_node("Login")

var _client = WebSocketClient.new()
var _write_mode = WebSocketPeer.WRITE_MODE_BINARY
var last_connected_client = 0
var hostname="ws://localhost:8080/chat"

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
	Utils._log(_log_dest, "Close code: %d, reason: %s" % [code, reason])


func _peer_connected(id):
	Utils._log(_log_dest, "%s: Client just connected" % id)
	last_connected_client = id


func _exit_tree():
	_client.disconnect_from_host(1001, "Bye bye!")


func _process(_delta):
	if _client.get_connection_status() == WebSocketClient.CONNECTION_DISCONNECTED:
		return

	_client.poll()


func _client_connected(protocol):
	Utils._log(_log_dest, "Client just connected with protocol: %s" % protocol)
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)


func _client_disconnected(clean=true):
	Utils._log(_log_dest, "Client just disconnected. Was clean: %s" % clean)


func _client_received(_p_id = 1):
	var packet = _client.get_peer(1).get_packet()
	var is_string = _client.get_peer(1).was_string_packet()
	Utils._log(_log_dest, "Received data. BINARY: %s: %s" % [not is_string, Utils.decode_data(packet, is_string)])


func connect_to_url(username, protocols):
	var fullHostname = hostname + "/" + username
	var err = _client.connect_to_url(fullHostname, protocols, false)
	if(err == OK):
		_login_screen.hide()
	return err


func disconnect_from_host():
	var err = _client.disconnect_from_host(1000, "Bye bye!")
	if(err == OK):
		_login_screen.show()
	return err


func send_data(data):
	Utils._log(_log_dest, "Sending Data %s" % [data])
	_client.get_peer(1).put_packet(data.to_utf8())
