extends Node2D

@onready var timer: Timer = $Timer
const AirObstacle = preload("res://Obstacle/flying_obstacle.tscn")
const LandObstacle = preload("res://Obstacle/obstacle.tscn")
@onready var air_spawn_points: Node2D = $AirSpawnPoints

func _ready() -> void:
	randomize()

func start_random_timer():
	var random_delay = randf_range(0.4, 2.0)
	timer.wait_time = random_delay
	timer.start()
	
func spawn_obstacle():
	var Obstacle = LandObstacle
	var isAirObstacle = randf() < .3
	if isAirObstacle:
		Obstacle = AirObstacle
	
	var obstacle = Obstacle.instantiate()
	if isAirObstacle:
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
