extends KinematicBody2D


var velocity:Vector2 = Vector2(0,0)

func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector2.UP)
