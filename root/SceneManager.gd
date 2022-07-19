extends Node


onready var _transition_player = $TransitionScreen


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Removes node with name "CurrentScene" and loads new scene as "CurrentScene" node
func _load_new_scene(path_to_new_scene : String):
	print ("Loading %s..." % path_to_new_scene)
	_transition_player.hide_scene()
	yield(_transition_player, "faded_to_black")
	var root = self
	root.remove_child(root.get_node("CurrentScene"))
	root.get_child(0).queue_free()
	root.get_tree()
	var scene = load(path_to_new_scene)
	var childNode = scene.instance()
	childNode.set_name("CurrentScene")
	root.add_child(childNode)
	_transition_player.show_scene()
	

# Currently used just for testing
func load_token():
	var token_file = File.new()
	if not token_file.file_exists("user://token.jwt"):
		printerr("Could not find JWT token, note: This application requires 3rd party cookies to be enabled")
		# TODO Return to login screen
		return # Error! We don't have a save to load.
	token_file.open("user://token.jwt", File.READ)
	return token_file.get_line()
