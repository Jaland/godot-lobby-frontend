###################
# login_ui
#
# Login UI handler.
##################
extends Control


##################
# UI Objects
##################
onready var _client = $Client
onready var _user_name = $Login/Username/Username
onready var _password = $Login/Password/Password


##################
# Node Fuctions
##################
#Input ignored so we can call login when enter is pressed from the username/password LineEdits
func _login(_input):
	if _user_name.text == "" || _password.text == "" :
		_client.show_error("Username and password required")
		return
	_client.login( _user_name.text, _password.text, false)

func _register():
	if _user_name.text == "" || _password.text == "" :
		_client.show_error("Username and password required")
		return
	_client.login( _user_name.text, _password.text, true)
