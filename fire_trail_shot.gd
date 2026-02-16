extends SpecialShot
class_name FireTrailShot

# Fire trail shot leaves a trail of fire that damages enemies

var trail_timer: float = 0.0
var trail_interval: float = 0.1  # Spawn fire every 0.1 seconds

# Preload fire wall scene
const FireWall = preload("res://fire_wall.tscn")

func _initialize() -> void:
	# Override base properties for fire trail shot
	speed = 400.0
	lifetime = 3.0
	damage = 1.0
	
	# Visual customization - orange/red color
	modulate = Color(1.0, 0.5, 0.0)

func _move(delta: float) -> void:
	# Default movement
	position += Vector2(1, 0).rotated(rotation) * speed * delta
	
	# Spawn fire trail
	trail_timer += delta
	if trail_timer >= trail_interval:
		spawn_fire()
		trail_timer = 0.0

func spawn_fire() -> void:
	var fire = FireWall.instantiate()
	fire.global_position = global_position
	get_parent().call_deferred("add_child", fire)
