extends Control

onready var _client = $Client
onready var _chat_area = $ChatScreen/Chat/ChatArea
onready var _chat_input = $ChatScreen/Chat/Message/ChatTextSend
onready var _user_name = $Login/Username


func _on_Send_pressed_game():
	if _chat_input.text == "":
		return
	Utils._log(_chat_area, "Send Pressed")
	_client.send_data(_chat_input.text)
	_chat_input.text = ""


func _on_Connect_pressed_game():
	if _user_name.text != "":
		Utils._log(_chat_area, "Connecting with user: %s" % [_user_name.text])
		# var supported_protocols = PoolStringArray(["my-protocol2", "my-protocol", "binary"])
		var supported_protocols = PoolStringArray([])
		_client.connect_to_url(_user_name.text, supported_protocols)

func _on_Disconnect_pressed():
	_client.disconnect_from_host()


func _on_Send_pressed():
	pass # Replace with function body.
