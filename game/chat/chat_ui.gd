###################
# chat_ui
#
# Chat UI handler.
##################
extends Control


##################
# UI Objects
##################
onready var _client = $Client
onready var _chat_input = $Chat/Message/ChatTextSend


##################
# Node Signals
##################
signal disconnect_from_game


##################
# Node Functions
##################

#Input just taken so we can connect the button and the input enter to the same method
func _send_message(_ignored_input):
	if _chat_input.text == "":
		return
	print("Send Pressed")
	_client.send_message(_chat_input.text)
	_chat_input.text = ""

func _on_Disconnect_pressed_game():
	emit_signal("disconnect_from_game")
	SceneManager.load_new_scene(GlobalVariables.scene_path.login)
