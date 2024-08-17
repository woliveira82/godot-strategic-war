extends Node2D

@export var camera: Camera2D

var unit_scene = preload("res://game/scenes/unit/unit.tscn")
var units_selected = []

# var dragging := false  # Are we currently dragging?
# var selected = []  # Array of selected units.
# var drag_start = Vector2.ZERO  # Location where drag began.
# var select_rect = RectangleShape2D.new()  # Collision shape for drag box.

@onready var units = $units


func _ready():
	Signals.on_unit_selected.connect(_add_unit_to_selected_list)


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

	elif event is InputEventMouseButton and event.pressed:
		var mouse_position = camera.get_global_mouse_position()
		if event.button_index == 2:
			if Input.is_key_pressed(KEY_SHIFT):
				_instantiate_unit(0, mouse_position)
			elif Input.is_key_pressed(KEY_CTRL):
				_instantiate_unit(1, mouse_position)
			else:
				for unit in units_selected:
					unit.set_goal(mouse_position)
					_unselect_units()
		#elif event.button_index == 1:
			#
			#pass
	
	#if event is InputEventMouseButton and event.button_index == 1:
		#if event.pressed:
			#if selected.size() == 0:
				#dragging = true
				#drag_start = event.position
			#else:
				#for item in selected:
					#item.collider.target = event.position
					#item.collider.selected = false
					#selected = []



func _add_unit_to_selected_list(unit):
	units_selected.append(unit)


func _unselect_units():
	units_selected = []
	get_tree().call_group("units", "set_selected", false)


func _instantiate_unit(team, unit_position):
	var instance = unit_scene.instantiate()
	units.add_child(instance)
	instance.team = team
	instance.set_up(unit_position)
