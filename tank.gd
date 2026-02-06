extends Node2D

# Movement settings
@export var move_speed: float = 200.0
@export var rotation_speed: float = 2.0

# Tank rotation angle
var tank_rotation: float = 0.0

@onready var objectsToAdjustRotation = get_children()
@onready var tank_cannon: Sprite2D = $TankCannon

func _process(delta: float) -> void:
	# Handle rotation (A/D keys)
	if Input.is_action_pressed("ui_left"):  # A key
		tank_rotation -= rotation_speed * delta
	if Input.is_action_pressed("ui_right"):  # D key
		tank_rotation += rotation_speed * delta
	
	# Apply rotation to children except those with independent_rotation flag
	for obj in objectsToAdjustRotation:
		if not obj.has_meta("independent_rotation"):
			obj.rotation = tank_rotation
	
	# Rotate cannon to follow mouse position
	if tank_cannon:
		var mouse_pos = get_global_mouse_position()
		var cannon_global_pos = tank_cannon.global_position
		var angle_to_mouse = (mouse_pos - cannon_global_pos).angle()
		tank_cannon.rotation = angle_to_mouse
	
	# Handle forward/backward movement (W/S keys)
	var direction: float = 0.0
	if Input.is_action_pressed("ui_up"):  # W key
		direction = 1.0
	if Input.is_action_pressed("ui_down"):  # S key
		direction = -1.0
	
	# Move in the direction the tank is facing (sprite faces right by default)
	if direction != 0.0:
		var velocity = Vector2(direction, 0) * move_speed
		position += velocity.rotated(tank_rotation) * delta
