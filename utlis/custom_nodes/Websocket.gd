###################
# Websocket
#
# Node extension that has client used for Websocket connections to our custom Java server builtin
##################
extends Node

var _client= WebSocketClient.new()

###################
# Custom Websocket Error Codes
##################

const CANNOT_ACCEPT=1003
const CLOSED_ABNORMALLY=1006
const VIOLATED_POLICY=1008

###################
# Preloaded Assests
##################
const _error_menu = preload("res://game/menus/error_menu/menu.tscn")

func _init():
	_client.connect("connection_established", self, "_client_connected")
	_client.connect("connection_error", self, "_client_error")
	_client.connect("connection_closed", self, "_client_disconnected")
	_client.connect("server_close_request", self, "_client_close_request")
	_client.connect("data_received", self, "_client_received")
	
# Once we have successfully connected to the host login
func _client_connected(_protocol):
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	print("Connected to host")
	client_connected()
	
func _client_error():
	client_error()
	show_error("Issue connecting with host")

func _client_close_request(code: int, reason: String):
	print("Client close request code: ", code, " reason: ", reason)
	client_close_request(code, reason)

func _client_disconnected(clean=true):
	print("Client Disconnected. Was clean: %s" % clean)
	client_disconnected(clean)

# Honestly not really sure what this does beyound checking to make sure the client is connected
# so I'm not going to bother making an override method. Can be overidden directly if needed
func _process(_delta):
	if _client.get_connection_status() == WebSocketClient.CONNECTION_DISCONNECTED:
		return
	_client.poll()

func _client_received(_p_id = 1):
	var packet = _client.get_peer(1).get_packet()
	var textResult = WebSocketUtils.decode_data(packet, true)
	var response = JSON.parse(textResult)
	if(response.get_error() != OK):
		printerr("Unable to parse json %s \nException: %s" % textResult, response.error)
		return
	var result = response.result
	object_recieved(result)



###################
# Functions
#
# Functions intended to be called directly
###################


func connect_to_websocket_path(path: String):
	var base_host= ProjectSettings.get_setting("ws/hostname") + path
	var err = _client.connect_to_url(base_host, [], false)
	assert (err == OK, "Unable to connect to host")
	return err

func send_data(data):
	if(_client.get_connection_status() == WebSocketClient.CONNECTION_CONNECTED):
		_client.get_peer(1).put_packet(data.to_utf8())

func disconnect_from_host():
	_client.disconnect_from_host(1000, "Client disconnecting...")


###################
# Overrideable Functions
#
# Functions intended to be over written
###################

# Reports when the client has succesfully connected to the server
func client_connected():
	pass

	
# Reports when the client has encountered an error
# Note: `show_error` will still be called. Override _client_error to handle this differently
func client_error():
	printerr("Got exception connecting to client")
	var error_menu = _error_menu.instance()
	get_parent().add_child(error_menu)
	error_menu.show()
	
# Allows client class to override if there is a place to report errors
func show_error(msg: String):
	print(msg)

# Reports when the client has been disconnected from the server
func client_close_request(_code, _reason):
	var error_menu = _error_menu.instance()
	get_parent().add_child(error_menu)
	error_menu.show()

# Reports when the client has disconnected from the server
func client_disconnected(_clean):
	pass

# Returns the Object from the client's data_received event 
func object_recieved(response):
	match response.type:
		GlobalVariables.response_type.invalid:
			printerr("Recieved invalid response %s" % response)
