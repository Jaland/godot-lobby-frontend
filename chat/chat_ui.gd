extends Control

onready var _client = $Client
onready var _chat_area = $Chat/ChatArea
onready var _chat_input = $Chat/Message/ChatTextSend

onready var _path_to_login = "login/login.tscn"

signal change_current_scene(path_to_new_scene)
signal disconnect_from_game

func _on_Send_pressed_game():
	if _chat_input.text == "":
		return
	print("Send Pressed")
	_client.send_message(_chat_input.text)
	_chat_input.text = ""


func _on_Disconnect_pressed_game():
	emit_signal("change_current_scene", _path_to_login)
	emit_signal("disconnect_from_game", _path_to_login)
