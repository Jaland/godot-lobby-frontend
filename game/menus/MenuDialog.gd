extends WindowDialog

onready var _parent_client = get_parent().get_node("Client")

###################
# Common Functions #
###################

func _close_popup():
	hide()
	
#Exiting and Restarting game seem to be used in a lot of the menus

func _exit_game():
	_parent_client.send_data(WebSocketUtils.request_to_json(GlobalVariables.request_type.leave_game))
	_parent_client.disconnect_from_host()
	SceneManager.load_new_scene(GlobalVariables.scene_path.lobby)


func _restart_game():
	_parent_client.restart_game()
