extends CanvasLayer

signal faded_to_black
signal fade_completed

func hide_scene():
	$CoverScreen.visible=true
	$AnimationPlayer.play("fade_to_black")
	
func show_scene():
	print("Playing fade complete anamation")
	$AnimationPlayer.play("fade_completed")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		print("emitting signal %s" % anim_name)
		emit_signal("faded_to_black")
	if anim_name == "fade_completed":
		$CoverScreen.visible=false
		print("emitting signal %s" % anim_name)
		emit_signal("fade_completed")

#Removes node with name "CurrentScene" and loads new scene as "CurrentScene" node
func load_new_scene(path_to_new_scene : String):
	print ("Loading %s..." % path_to_new_scene)
	hide_scene()
	yield(self, "faded_to_black")
	var rootNode = get_node("/root/RootNode")
	rootNode.remove_child(rootNode.get_node("CurrentScene"))
	rootNode.get_tree()
	var scene = ResourceLoader.load(path_to_new_scene)
	var current_scene = scene.instance()
	current_scene.set_name("CurrentScene")
	rootNode.add_child(current_scene)
	show_scene()
