extends Node

onready var _root_client= get_parent().get_node("/root/RootNode/WebClient")
onready var _chat_client = get_parent().get_node("chat/Client")

var refresh_request = "LOBBY_REFRESH"
var create_game_request = "CREATE_GAME"

var _client = WebSocketClient.new()
var _write_mode = WebSocketPeer.WRITE_MODE_BINARY
var last_connected_client = 0
var base_host= ProjectSettings.get_setting("ws/hostname") + "/lobby"

func _init():
	_client.connect("connection_established", self, "_client_connected")
	_client.connect("connection_error", self, "_client_disconnected")
	_client.connect("connection_closed", self, "_client_disconnected")
	_client.connect("server_close_request", self, "_client_close_request")
	_client.connect("data_received", self, "_client_received")


func _client_connected(protocol):
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
#	Send auth request
	var token = _root_client.load_token()
	var request = JSON.print({"token": token, "requestType": "AUTH"})
	_send_data(request)

func _client_close_request(code, reason):
	print("Client closed request with code %s reason %s" % code, reason)


func _peer_connected(id):
	print( "%s: Client just connected" % id)
	last_connected_client = id


func _exit_tree():
	_client.disconnect_from_host(1001, "Bye bye!")


func _process(_delta):
	if _client.get_connection_status() == WebSocketClient.CONNECTION_DISCONNECTED:
		return
	_client.poll()
	
func refresh_lobby():
	var request = JSON.print({"requestType": refresh_request})
	_send_data(request)
	
func create_game():
	var request = JSON.print({"requestType": create_game_request})
	_send_data(request)


func _client_disconnected(clean=true):
	print("Client just disconnected. Was clean: %s" % clean)


func _client_received(_p_id = 1):
	var packet = _client.get_peer(1).get_packet()
	var textResult = Utils.decode_data(packet, true)
	var response = JSON.parse(textResult)
	if(response.get_error() != OK):
		printerr("Unable to parse json %s" % textResult)
		return
	_chat_client.process_message(response)


func _connect_to_lobby_service():
	var err = _client.connect_to_url(base_host, [], false)
	return err


func disconnect_from_host():
	_client.disconnect_from_host(1000, "Bye bye!")


func _send_data(data):
	_client.get_peer(1).put_packet(data.to_utf8())
