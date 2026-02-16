extends Area2D
class_name PowerUp

# Type of special shot this power-up provides
enum PowerUpType {
	FAST_SHOT,
	BOUNCY_SHOT,
	FIRE_TRAIL_SHOT,
	HOMING_SHOT,
	CLUSTER_SHOT,
}

@export var power_up_type: PowerUpType = PowerUpType.FAST_SHOT

# Visual settings
@export var rotation_speed: float = 2.0
@export var bob_speed: float = 1.0
@export var bob_amount: float = 10.0

var initial_y: float
var time: float = 0.0
var special_shot_scene: PackedScene

# Preload special shot scenes
const FastShot = preload("res://fast_shot.tscn")
const BouncyShot = preload("res://bouncy_shot.tscn")
const FireTrailShot = preload("res://fire_trail_shot.tscn")
const HomingShot = preload("res://homing_shot.tscn")
const ClusterShot = preload("res://cluster_shot.tscn")

func _ready() -> void:
	initial_y = position.y
	
	# Enable monitoring
	monitoring = true
	monitorable = true
	
	# Set the special shot scene based on type
	match power_up_type:
		PowerUpType.FAST_SHOT:
			special_shot_scene = FastShot
		PowerUpType.BOUNCY_SHOT:
			special_shot_scene = BouncyShot
		PowerUpType.FIRE_TRAIL_SHOT:
			special_shot_scene = FireTrailShot
		PowerUpType.HOMING_SHOT:
			special_shot_scene = HomingShot
		PowerUpType.CLUSTER_SHOT:
			special_shot_scene = ClusterShot
	
	# Add to power_up group for detection
	add_to_group("power_up")

func _process(delta: float) -> void:
	time += delta
	
	# Bob up and down
	position.y = initial_y + sin(time * bob_speed) * bob_amount
