extends Node


onready var _transition_player = $TransitionScreen
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _load_new_scene(path_to_new_scene : String):
	print ("Loading %s..." % path_to_new_scene)
	_transition_player.hide_scene()
	yield(_transition_player, "faded_to_black")
	var root = get_parent()
	root.remove_child(root.get_node("CurrentScene"))
	root.get_child(0).queue_free()
	var CurrentScene = load(path_to_new_scene)
	var newNode = Node.new()
	newNode.set_name("CurrentScene")
	root.add_child(newNode)
	newNode.add_child(CurrentScene.instance())
	_transition_player.show_scene()
