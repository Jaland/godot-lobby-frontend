extends "res://game/menus/MenuDialog.gd"

signal start_game

onready var _start_button  = get_node("start")

func _on_start_pressed():
	emit_signal("start_game")

func _show_start_menu(is_host: bool):
	if(!is_host):
		_start_button.hide()
	show()
	
