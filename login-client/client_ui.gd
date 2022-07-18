extends Control

onready var _client = $Client
onready var _user_name = $Login/Username/Username
onready var _password = $Login/Password/Password

func _on_Connect_pressed():
	if _user_name.text == "" || _password.text == "" :
		return
	var supported_protocols = PoolStringArray([])
	_client.login( _user_name.text, _password.text, supported_protocols, false)

func _on_Register_pressed():
	if _user_name.text == "" || _password.text == "" :
		return
	var supported_protocols = PoolStringArray([])
	_client.login( _user_name.text, _password.text, supported_protocols, true)

func _on_Disconnect_pressed():
	_client.disconnect_from_host()


func _input(event):
	if event.is_action_pressed("ui_focus_next") and has_focus():
		if focus_next != "":
			get_node(focus_next).grab_focus()
		get_tree().set_input_as_handled()

