extends "res://game/menus/MenuDialog.gd"

func _unhandled_input(_event):
	if Input.is_action_pressed("ui_menu"):\
		show()
