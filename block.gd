extends StaticBody2D

# Block health
@export var health: float = 10.0

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		# Notify game manager before destroying
		var game_manager = get_node_or_null("/root/Main/GameManager")
		if game_manager:
			game_manager.add_score(1)
			game_manager.spawn_block()
		queue_free()
