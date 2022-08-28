extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Disconnect_pressed_game():
	emit_signal("disconnect_from_game")
	SceneManager.load_new_scene(GlobalVariables.scene_path.login)
