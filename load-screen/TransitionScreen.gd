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
