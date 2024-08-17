extends CharacterBody2D

enum {IDLE, WALK} 

@export var team: int = 0
@export var goal: Vector2

var max_health := 3.0
var health: float = max_health
var acceleration = 60.0
var max_speed = 100.0
var friction = 80
var direction: Vector2
var state := IDLE
var distance_tolerance = 60
var guarded_area: Area2D
var selected := false
var dead := false

@onready var wait_timer = $WaitTimer
@onready var sprite = $Sprite2D
@onready var hitbox = $Hitbox
@onready var animation_player = $AnimationPlayer
@onready var damage_sprite = $Sprite2D/DamageSprite
@onready var collision = $CollisionShape2D


func _ready():
	goal = position
	set_up()


func set_up(new_position = null):
	sprite.frame = team
	collision_layer = 2 ** team
	hitbox.team = team
	hitbox.collision_layer = 2 ** team
	hitbox.collision_mask = 15 - 2 ** team
	if new_position:
		position = new_position
	
	set_goal(position)


func set_goal(goal_position: Vector2):
	goal = goal_position


func _physics_process(delta):
	var direction = Vector2.ZERO
	if dead:
		_idle_state(delta)
	
	else:
		match state:
			IDLE:
				_idle_state(delta)
			WALK:
				_walk_state(delta)


func _idle_state(delta):
	if wait_timer.is_stopped():
		wait_timer.start()

	if velocity.length() < friction * delta:
		velocity = Vector2.ZERO
	else:
		velocity -= velocity.normalized() * friction * delta
	
	move_and_slide()


func _walk_state(delta):
	var direction = position.direction_to(goal)
	velocity += direction * acceleration * delta
	velocity = velocity.limit_length(max_speed)
	
	move_and_slide()
	
	if position.distance_to(goal) < distance_tolerance:
		state = IDLE


func _on_wait_timer_timeout():
	if position.distance_to(goal) > distance_tolerance:
		state = WALK


func _on_hit_taken(damage, body_position):
	_update_health(health -1)
	animation_player.play("red_flash")
	var direction = position - body_position
	state = IDLE
	velocity = direction * 60 * get_physics_process_delta_time()
	if dead:
		_death()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 1:
			set_selected(true)
			Signals.on_unit_selected.emit(self)


func _draw():
	if selected:
		draw_arc(Vector2.ZERO, 35.0, 0.0, 7.0, 32, Color(1.0, 1.0, 1.0), 3.0, true)


func set_selected(valor: bool):
	selected = valor
	queue_redraw()


func _update_health(new_health):
	health = new_health
	if health <= 0.0:
		dead = true
	
	else:
		var prop: float = health / max_health
		damage_sprite.modulate.a = 1.0 - prop


func _death():
	z_index = -1
	collision.set_deferred("disabled", true)
	hitbox.monitorable = false
	hitbox.monitoring = false
	damage_sprite.modulate.a = 1.0
	animation_player.play("death")
