extends SpecialShot
class_name FastShot

# Fast shot travels at higher speed with shorter lifetime

func _initialize() -> void:
	# Override base properties for fast shot
	speed = 800.0  # Twice as fast as normal
	lifetime = 2.0  # Shorter lifetime
	damage = 1.0
	
	# You can customize visual appearance here if needed
	# For example, change modulate color to indicate it's a special shot
	modulate = Color(1.0, 0.8, 0.3)  # Slightly yellow tint

# Fast shot uses default movement (straight line)
# No need to override _move unless you want custom behavior
