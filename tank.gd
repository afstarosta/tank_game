extends CharacterBody2D

# Movement settings
@export var move_speed: float = 200.0
@export var rotation_speed: float = 2.0

# Shooting settings
@export var fire_rate: float = 0.3
@export var special_fire_rate: float = 0.5

# Tank rotation angle
var tank_rotation: float = 0.0
var fire_cooldown: float = 0.0
var special_fire_cooldown: float = 0.0

# Special shot queue
var special_shot_queue: Array = []

# Preload projectile scene
const Projectile = preload("res://projectile.tscn")
const FastShot = preload("res://fast_shot.tscn")

@onready var objectsToAdjustRotation = get_children()
@onready var tank_cannon: Sprite2D = $TankCannon
@onready var pickup_area: Area2D = get_node_or_null("PickupArea")

func _ready() -> void:
	# Connect pickup area signal
	if pickup_area:
		pickup_area.monitoring = true
		pickup_area.monitorable = true
		pickup_area.area_entered.connect(_on_power_up_area_entered)

func _process(delta: float) -> void:
	# Handle rotation (LB/RB bumpers)
	var rotation_input: float = 0.0
	if Input.is_joy_button_pressed(0, JOY_BUTTON_LEFT_SHOULDER):  # LB
		rotation_input -= 1.0
	if Input.is_joy_button_pressed(0, JOY_BUTTON_RIGHT_SHOULDER):  # RB
		rotation_input += 1.0
	tank_rotation += rotation_input * rotation_speed * delta
	
	# Apply rotation to children except those with independent_rotation flag
	for obj in objectsToAdjustRotation:
		if not obj.has_meta("independent_rotation"):
			obj.rotation = tank_rotation
	
	# Rotate cannon with right analog stick
	if tank_cannon:
		var aim_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var aim_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		var aim_direction = Vector2(aim_x, aim_y)
		
		# Only update cannon rotation when stick is outside deadzone
		# This allows aim to persist when player releases the stick
		if aim_direction.length() > 0.9:
			tank_cannon.rotation = aim_direction.angle()
	
	# Handle shooting (RT trigger)
	fire_cooldown -= delta
	var trigger_value = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT)
	if trigger_value > 0.5 and fire_cooldown <= 0.0:  # RT pressed
		shoot()
		fire_cooldown = fire_rate
	
	# Handle special shot (LT trigger)
	special_fire_cooldown -= delta
	var special_trigger_value = Input.get_joy_axis(0, JOY_AXIS_TRIGGER_LEFT)
	if special_trigger_value > 0.5 and special_fire_cooldown <= 0.0:  # LT pressed
		if special_shot_queue.size() > 0:
			shoot_special()
			special_fire_cooldown = special_fire_rate
	
	# Handle forward/backward movement (Left analog stick)
	var direction: float = -Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)  # Negative because up is -1
	
	# Apply deadzone
	if abs(direction) < 0.2:
		direction = 0.0
	
	# Move in the direction the tank is facing (sprite faces right by default)
	if direction != 0.0:
		velocity = Vector2(direction, 0).rotated(tank_rotation) * move_speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func shoot() -> void:
	# Create and configure projectile
	var projectile = Projectile.instantiate()
	
	# Set shooter reference to ignore collision
	projectile.shooter = self
	
	# Position at cannon tip
	if tank_cannon:
		projectile.global_position = tank_cannon.global_position
		projectile.rotation = tank_cannon.rotation
	else:
		# Fallback: use right stick for aim direction
		var aim_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var aim_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		var aim_direction = Vector2(aim_x, aim_y)
		projectile.global_position = global_position
		projectile.rotation = aim_direction.angle()
	
	# Add to scene
	get_parent().add_child(projectile)

func shoot_special() -> void:
	# Get the next special shot from the queue
	var special_shot_scene = special_shot_queue.pop_front()
	
	# Create and configure special projectile
	var projectile = special_shot_scene.instantiate()
	
	# Set shooter reference to ignore collision
	projectile.shooter = self
	
	# Position at cannon tip
	if tank_cannon:
		projectile.global_position = tank_cannon.global_position
		projectile.rotation = tank_cannon.rotation
	else:
		# Fallback: use right stick for aim direction
		var aim_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		var aim_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
		var aim_direction = Vector2(aim_x, aim_y)
		projectile.global_position = global_position
		projectile.rotation = aim_direction.angle()
	
	# Add to scene
	get_parent().add_child(projectile)

func add_special_shot(special_shot_scene: PackedScene) -> void:
	special_shot_queue.append(special_shot_scene)

func _on_power_up_area_entered(area: Area2D) -> void:
	if area.is_in_group("power_up"):
		# Add the power-up's special shot to the queue
		add_special_shot(area.special_shot_scene)
		# Remove the power-up from the scene
		area.queue_free()
