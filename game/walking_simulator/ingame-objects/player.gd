extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


const WALK_FORCE = 5

func _physics_process(_delta):
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	move_and_collide(velocity*WALK_FORCE)

