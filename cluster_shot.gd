extends SpecialShot
class_name ClusterShot

# Cluster shot that bursts into smaller shots after a delay

@export var burst_delay: float = 1.0
@export var cluster_count: int = 8

# Preload projectile for cluster
const Projectile = preload("res://projectile.tscn")

var has_burst: bool = false

func _initialize() -> void:
	# Override base properties for cluster shot
	speed = 400.0
	lifetime = 3.0
	damage = 1.0
	
	# Visual customization - yellow color
	modulate = Color(1.0, 1.0, 0.3)
	
	# Schedule burst
	get_tree().create_timer(burst_delay).timeout.connect(burst)

func burst() -> void:
	if has_burst or not is_instance_valid(self):
		return
	
	has_burst = true
	
	# Create cluster of smaller projectiles
	var angle_step = TAU / cluster_count
	
	for i in range(cluster_count):
		var projectile = Projectile.instantiate()
		projectile.shooter = shooter
		projectile.global_position = global_position
		projectile.rotation = rotation + (angle_step * i)
		# Make cluster projectiles slightly smaller/weaker
		projectile.scale = Vector2(0.7, 0.7)
		get_parent().call_deferred("add_child", projectile)
	
	# Destroy the cluster shot
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	# If we hit something before bursting, burst immediately
	if not has_burst:
		burst()
	else:
		# Call parent implementation
		super._on_body_entered(body)
