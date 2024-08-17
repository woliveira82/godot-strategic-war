extends Area2D

signal on_enemy_spotted(enemy_body)

var team := 0


func _on_body_entered(body):
	if body.team != team and body is CharacterBody2D:
		on_enemy_spotted.emit(body)
