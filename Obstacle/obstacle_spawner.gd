extends Node2D

@onready var timer: Timer = $Timer
const Obstacle = preload("res://Obstacle/obstacle.tscn")

func _ready() -> void:
	randomize()

func start_random_timer():
	var random_delay = randf_range(0.5, 3.0)
	timer.wait_time = random_delay
	timer.start()
	
func spawn_nature_tile():
	var obstacle = Obstacle.instantiate()
	obstacle.global_position = global_position
	var world = get_tree().current_scene
	world.add_child(obstacle)
	obstacle.connect("player_hurt", Callable(world, "_on_player_hurt"))

func _on_timer_timeout() -> void:
	spawn_nature_tile()
	start_random_timer()
