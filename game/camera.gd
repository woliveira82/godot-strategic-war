extends Camera2D


func _process(delta):
	process_zoom(delta)
	simple_pan(delta)


func process_zoom(delta):
	if Input.is_action_pressed("camera_zoom_in"):
		zoom = zoom.slerp(
			clamp(zoom * 1.1, Vector2(0.2, 0.2), Vector2(2.0, 2.0)),
			10.0 * delta,
		)
		
	if Input.is_action_pressed("camera_zoom_out"):
		zoom = zoom.slerp(
			clamp(zoom * 0.9, Vector2(0.2, 0.2), Vector2(2.0, 2.0)),
			10.0 * delta,
		)


func simple_pan(delta):
	var movement = Vector2.ZERO
	movement.x = Input.get_axis("camera_move_left", "camera_move_right")
	movement.y = Input.get_axis("camera_move_up", "camera_move_down")
	position += movement.normalized() * delta * 1000 * ( 1 / zoom.x )
