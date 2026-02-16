extends SpecialShot
class_name HomingShot

# Homing shot that follows nearby targets

@export var homing_range: float = 150.0
@export var turn_speed: float = 3.0

var target: Node2D = null
var velocity: Vector2 = Vector2.ZERO

func _initialize() -> void:
	# Override base properties for homing shot
	speed = 250.0  # Slower than normal
	lifetime = 5.0
	damage = 1.5
	
	# Set initial velocity
	velocity = Vector2(1, 0).rotated(rotation) * speed
	
	# Visual customization - purple color
	modulate = Color(0.8, 0.3, 1.0)

func _move(delta: float) -> void:
	# Find nearest target if we don't have one
	if not is_instance_valid(target):
		find_target()
	
	# Home towards target if we have one
	if is_instance_valid(target):
		var direction_to_target = (target.global_position - global_position).normalized()
		var desired_velocity = direction_to_target * speed
		
		# Smoothly turn towards target
		velocity = velocity.lerp(desired_velocity, turn_speed * delta)
		rotation = velocity.angle()
	
	# Move with velocity
	position += velocity * delta

func find_target() -> void:
	target = null
	var closest_distance: float = homing_range
	
	# Find all bodies in the scene
	var bodies = get_tree().get_nodes_in_group("blocks")
	
	for body in bodies:
		if body == shooter or not is_instance_valid(body):
			continue
		
		var distance = global_position.distance_to(body.global_position)
		if distance < closest_distance:
			closest_distance = distance
			target = body
