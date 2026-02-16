extends StaticBody2D

# Block health
@export var health: float = 10.0
@export var power_up_drop_chance: float = 0.3  # 30% chance to drop a power-up

# Preload power-up scene
const PowerUp = preload("res://power_up.tscn")

func _ready() -> void:
	# Add to blocks group for homing shot targeting
	add_to_group("blocks")

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		# Drop power-up with a chance
		if randf() < power_up_drop_chance:
			drop_power_up()
		
		# Notify game manager before destroying
		var game_manager = get_node_or_null("/root/Main/GameManager")
		if game_manager:
			game_manager.add_score(1)
			game_manager.spawn_block()
		queue_free()

func drop_power_up() -> void:
	var power_up = PowerUp.instantiate()
	power_up.global_position = global_position
	
	# Randomize power-up type
	var random_type = randi() % 5  # 0-4 for all power-up types
	power_up.power_up_type = random_type
	
	get_parent().call_deferred("add_child", power_up)
