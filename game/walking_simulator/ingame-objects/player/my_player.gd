extends KinematicBody2D

var _update_position_timer = null
var _velocity:Vector2 = Vector2(0,0);

const WALK_FORCE = 500
const UPDATE_POSITION_FREQ_IN_SECONDS=0.05

signal update_player_position(x, y)

func _ready():
	_update_position_timer = Timer.new()
	add_child(_update_position_timer)
	_update_position_timer.connect("timeout", self, "_on_Timer_timeout")
	_update_position_timer.set_wait_time(UPDATE_POSITION_FREQ_IN_SECONDS)
	_update_position_timer.set_one_shot(false) # Make sure it loops
	_update_position_timer.start()

func _physics_process(_delta):
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")*WALK_FORCE
	_velocity = move_and_slide(velocity, Vector2.UP)


func _on_Timer_timeout():
	emit_signal("update_player_position", position, _velocity)
