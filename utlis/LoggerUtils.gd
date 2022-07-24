###################
# <name>
#
# Description
##################
extends Node

func _log(node, msg):
	print(msg)
	node.append_bbcode(str(msg) + "\n")
