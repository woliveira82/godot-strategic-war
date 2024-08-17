extends Control


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == 1:
			print("select")
		elif event.button_index == 2:
			print("action")

