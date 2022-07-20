extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func load_token():
	var token_file = File.new()
	if not token_file.file_exists("user://token.jwt"):
		printerr("Could not find JWT token, note: This application requires 3rd party cookies to be enabled")
		# TODO Return to login screen
		return # Error! We don't have a save to load.
	token_file.open("user://token.jwt", File.READ)
	return token_file.get_line()
