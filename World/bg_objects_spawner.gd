extends Node2D

const Cloud = preload("res://World/cloud.tscn")
const Moon = preload("res://World/moon.tscn")
const SPAWN_CLOUD_CHANCE = 0.8
const SPAWN_MOON_CHANCE = 0.01

@onready var spawn_points = $SpawnPoints
@onready var timer: Timer = $Timer

func get_spawn_position():
	var points = spawn_points.get_children()
	var random_point = points.pick_random()
	return random_point.global_position

func random_spawn():
	if randf() < SPAWN_CLOUD_CHANCE:
		spawn_cloud([1, 2].pick_random())
	if randf() < SPAWN_MOON_CHANCE:
		spawn_moon()
	
func spawn_moon():
	var object = Moon.instantiate()
	var world = get_tree().current_scene
	world.add_child(object)
	var spawn_position = get_spawn_position()
	object.global_position = spawn_position

func spawn_cloud(num):
	for i in range(num):
		var object = Cloud.instantiate()
		var world = get_tree().current_scene
		world.add_child(object)
		var spawn_position = get_spawn_position()
		object.global_position = spawn_position
		object.position.x += i * randf_range(5.0, 10.0)
		object.z_index = 1

func start_random_timer():
	var random_delay = randf_range(3.0, 8.0)
	timer.wait_time = random_delay
	timer.start()

func _on_timer_timeout() -> void:
	random_spawn()
	start_random_timer()
