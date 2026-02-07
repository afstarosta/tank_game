extends Node

# Game state
var score: int = 0

# Block spawning
const Block = preload("res://block.tscn")
@export var screen_margin: float = 16.0

# Reference to viewport
var viewport_size: Vector2

signal score_changed(new_score: int)

func _ready() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	print("Game Manager ready. Viewport size: ", viewport_size)

func add_score(points: int) -> void:
	score += points
	score_changed.emit(score)
	print("Score: ", score)

func spawn_block() -> void:
	var block = Block.instantiate()
	
	# Random position within screen bounds
	var random_x = randf_range(screen_margin, viewport_size.x - screen_margin)
	var random_y = randf_range(screen_margin, viewport_size.y - screen_margin)
	var spawn_position = Vector2(random_x, random_y)
	
	# Start above screen for animation
	var start_position = Vector2(random_x, -50)
	block.position = start_position
	
	# Add to scene
	get_parent().add_child(block)
	
	# Animate falling
	animate_block_spawn(block, start_position, spawn_position)

func animate_block_spawn(block: Node2D, start_pos: Vector2, end_pos: Vector2) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(block, "position", end_pos, 0.5)
