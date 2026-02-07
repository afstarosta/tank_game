extends Area2D

# Explosion settings
@export var damage: float = 10.0
@export var explosion_radius: float = 32.0
@export var duration: float = 0.3

func _ready() -> void:
	# Apply damage to overlapping bodies
	apply_damage()
	
	# Auto-destroy after animation duration
	await get_tree().create_timer(duration).timeout
	queue_free()

func apply_damage() -> void:
	# Use direct space query instead of waiting for Area2D
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	
	# Create a circle shape for the query
	var shape = CircleShape2D.new()
	shape.radius = explosion_radius
	query.shape = shape
	query.transform = global_transform
	query.collision_mask = 1
	
	# Query for intersecting bodies
	var results = space_state.intersect_shape(query)
	
	print("Explosion detected ", results.size(), " bodies")
	
	for result in results:
		var body = result.collider
		# Check if body has a take_damage method
		if body.has_method("take_damage"):
			print("Applying damage to: ", body.name)
			body.take_damage(damage)
		else:
			print("Body ", body.name, " has no take_damage method")
