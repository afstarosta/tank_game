extends Area2D

# Projectile settings
@export var speed: float = 400.0
@export var lifetime: float = 3.0

# Reference to the shooter (to ignore collision)
var shooter: Node2D = null

# Preload explosion scene
const Explosion = preload("res://explosion.tscn")

func _ready() -> void:
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	
	# Auto-destroy after lifetime expires
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta: float) -> void:
	# Move in the direction the projectile is facing
	position += Vector2(1, 0).rotated(rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Ignore collision with shooter
	if body == shooter:
		return
	
	# Defer explosion creation to avoid physics query flush error
	call_deferred("create_explosion")
	
	# Destroy projectile
	queue_free()

func create_explosion() -> void:
	# Create explosion at impact point
	var explosion = Explosion.instantiate()
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
