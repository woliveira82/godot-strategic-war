extends Camera2D


func _process(delta):
	simple_pan(delta)


func simple_pan(delta):
	var movement = Vector2.ZERO
	movement.x = Input.get_axis("camera_move_left", "camera_move_right")
	movement.y = Input.get_axis("camera_move_up", "camera_move_down")
	position += movement.normalized() * delta * 1000 * (1/zoom.x)
