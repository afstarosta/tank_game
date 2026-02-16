extends Area2D
class_name SpecialShot

# Base class for all special shots
# Extend this class to create different types of special shots

# Basic projectile settings (can be overridden)
@export var speed: float = 400.0
@export var lifetime: float = 3.0
@export var damage: float = 1.0

# Reference to the shooter (to ignore collision)
var shooter: Node2D = null

# Preload explosion scene
const Explosion = preload("res://explosion.tscn")

func _ready() -> void:
	# Call specialized initialization first
	_initialize()
	
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	
	# Auto-destroy after lifetime expires
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta: float) -> void:
	# Call custom movement logic
	_move(delta)

# Override this method in child classes for custom initialization
func _initialize() -> void:
	pass

# Override this method in child classes for custom movement
func _move(delta: float) -> void:
	# Default movement: straight line
	position += Vector2(1, 0).rotated(rotation) * speed * delta

# Override this method in child classes for custom hit behavior
func _on_hit(body: Node2D) -> void:
	# Default: just create explosion
	call_deferred("create_explosion")

func _on_body_entered(body: Node2D) -> void:
	# Ignore collision with shooter
	if body == shooter:
		return
	
	# Call custom hit behavior
	_on_hit(body)
	
	# Destroy projectile
	queue_free()

func create_explosion() -> void:
	# Create explosion at impact point
	var explosion = Explosion.instantiate()
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
