extends Camera2D

var player

var deadzone = 100.0

const cameraOffsetX = 0.0
const cameraOffsetY = 0.0

func _process(_delta):
	if(player != null):
		if(position.x + deadzone  - cameraOffsetX < player.global_position.x):
			position.x = player.global_position.x - deadzone  + cameraOffsetX
		if(position.x - deadzone  - cameraOffsetX > player.global_position.x):
			position.x = player.global_position.x + deadzone + cameraOffsetX
			
		if(position.y + deadzone  - cameraOffsetY < player.global_position.y):
			position.y = player.global_position.y - deadzone + cameraOffsetY
		if(position.y - deadzone  - cameraOffsetY > player.global_position.y):
			position.y = player.global_position.y + deadzone + cameraOffsetY
