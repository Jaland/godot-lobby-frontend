extends "res://game/menus/MenuDialog.gd"

onready var _label  = get_node("popup_label")
onready var _start_button  = get_node("restart")

func _show_game_complete(label_string: String, is_host: bool):
	_label.text = label_string
	if(!is_host):
		_start_button.hide()
	show()
