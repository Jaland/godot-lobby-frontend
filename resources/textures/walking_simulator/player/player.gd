extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


const WALK_FORCE = 50


func _physics_process(delta):
	print(Input.get)
	var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	move_and_collide(velocity)

