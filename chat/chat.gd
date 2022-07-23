extends Node

onready var _log_dest = get_parent().get_node("Chat/ChatArea")
onready var _parent_client = get_parent().get_node("../Client")

var request_type = "CHAT"

func send_message(message):
	var chatData = JSON.print({"message": message, "requestType": request_type})
	_parent_client._send_data(chatData)

func process_message(response: JSONParseResult):
	if(response.result.type != "chat"):
		return;
	Utils._log(_log_dest, response.result.message)
