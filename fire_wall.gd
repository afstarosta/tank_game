extends Area2D
class_name FireWall

# A wall of fire that damages anything that touches it

@export var lifetime: float = 5.0
@export var damage: float = 0.5

var damaged_bodies: Array = []

func _ready() -> void:
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Auto-destroy after lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body not in damaged_bodies:
		damaged_bodies.append(body)
		# Start damaging this body
		_damage_body(body)

func _on_body_exited(body: Node2D) -> void:
	if body in damaged_bodies:
		damaged_bodies.erase(body)

func _damage_body(body: Node2D) -> void:
	# Damage body repeatedly while in fire
	while body in damaged_bodies and is_instance_valid(body):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		await get_tree().create_timer(0.5).timeout
