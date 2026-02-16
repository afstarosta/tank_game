extends SpecialShot
class_name BouncyShot

# Bouncy shot bounces off walls 2 times before exploding

var bounces_remaining: int = 2
var velocity: Vector2 = Vector2.ZERO

func _initialize() -> void:
	# Override base properties for bouncy shot
	speed = 500.0
	lifetime = 5.0
	damage = 1.0
	
	# Set initial velocity
	velocity = Vector2(1, 0).rotated(rotation) * speed
	
	# Visual customization - cyan color
	modulate = Color(0.3, 1.0, 1.0)

func _move(delta: float) -> void:
	# Move with velocity
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	# Ignore collision with shooter
	if body == shooter:
		return
	
	# Check if we can bounce
	if bounces_remaining > 0:
		bounce(body)
		bounces_remaining -= 1
	else:
		# No more bounces, explode
		_on_hit(body)
		queue_free()

func bounce(body: Node2D) -> void:
	# Simple bounce - reverse direction
	# For better physics, you'd calculate the normal of the collision surface
	# For now, we'll just reverse the velocity based on position
	var collision_normal = (global_position - body.global_position).normalized()
	velocity = velocity.bounce(collision_normal)
	
	# Update rotation to match new direction
	rotation = velocity.angle()
