extends Node2D

@onready var timer: Timer = $Timer
@onready var air_spawn_points: Node2D = $AirSpawnPoints
const Obstacle = preload("res://Obstacle/obstacle.tscn")

const MOB_OBSTACLE_THRESHOLD = 100
const FLYING_OBSTACLE_THRESHOLD = 400
const FLYING_OBSTACLE_SPAWN_CHANCE = 0.4
const MOB_OBSTACLE_SPAWN_CHANCE = 0.3

func _ready() -> void:
	randomize()

func start_random_timer():
	var random_delay = randf_range(0.5, 2.0)
	timer.wait_time = random_delay
	timer.start()
	
func spawn_obstacle():
	
	var spawnWhat = 'Nature'
	if Global.score >= MOB_OBSTACLE_THRESHOLD:
		# chance to spawn a mob obstacle
		if randf() < MOB_OBSTACLE_SPAWN_CHANCE:
			spawnWhat = 'Mob'
	if Global.score >= FLYING_OBSTACLE_THRESHOLD:
		# spawn an air obstacle
		if randf() < FLYING_OBSTACLE_SPAWN_CHANCE:
			spawnWhat = 'Flying'
	
	var obstacle = Obstacle.instantiate()
	obstacle.variant = spawnWhat
	
	if spawnWhat == 'Flying':
		obstacle.global_position = get_air_spawn_point().global_position
	else:
		obstacle.global_position = global_position

	var world = get_tree().current_scene
	world.add_child(obstacle)
	obstacle.connect("player_hurt", Callable(world, "_on_player_hurt"))

func get_air_spawn_point():
	var spawn_points = air_spawn_points.get_children()
	var spawn_point = spawn_points.pick_random()
	return spawn_point

func _on_timer_timeout() -> void:
	spawn_obstacle()
	start_random_timer()
