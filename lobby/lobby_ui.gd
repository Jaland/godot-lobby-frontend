extends Control

signal change_current_scene(path_to_new_scene)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _chat_propagateon_change_current_scene(path_to_scene:String):
	emit_signal("change_current_scene", path_to_scene)

func _connect_to_lobby_service():
	pass # Replace with function body.
