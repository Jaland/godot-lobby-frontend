extends Node

onready var _parent_client = get_parent().get_node("../Client")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func exit_game():
	_parent_client.send_data(WebSocketUtils.request_to_json(GlobalVariables.request_type.leave_game))
	_parent_client.disconnect_from_host()
	SceneManager.load_new_scene(GlobalVariables.scene_path.lobby)
