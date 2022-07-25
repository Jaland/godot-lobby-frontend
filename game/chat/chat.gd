###################
# chat
#
# Script used for chat interactions
##################
extends Node


##################
# UI Integration Elements
##################
onready var _log_dest = get_parent().get_node("Chat/ChatArea")
onready var _parent_client = get_parent().get_node("../Client")


##################
# Node Functions
##################
func send_message(message):
	var chatData = JSON.print({"message": message, "requestType": GlobalVariables.request_type.chat})
	_parent_client.send_data(chatData)

func process_message(response):
	match response.type:
		GlobalVariables.response_type.chat:
			LoggerUtils._log(_log_dest, response.message)
