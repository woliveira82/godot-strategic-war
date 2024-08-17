extends Area2D

signal on_hit_taken(damage, body_position)

var team := 0


func _on_body_entered(body):
	if body.team != team:
		if body is StaticBody2D:
			on_hit_taken.emit(false, body.position)
		else:
			on_hit_taken.emit(true, body.position)
