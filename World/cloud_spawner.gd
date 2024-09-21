extends Node2D

@onready var timer: Timer = $Timer
const Cloud = preload("res://World/cloud.tscn")

func _ready() -> void:
	randomize()

func start_random_timer():
	var random_delay = randf_range(0.5, 3.0)
	timer.wait_time = random_delay
	timer.start()
	
func spawn_nature_tile():
	var cloud = Cloud.instantiate()
	cloud.global_position = global_position
	var world = get_tree().current_scene
	world.add_child(cloud)

func _on_timer_timeout() -> void:
	spawn_nature_tile()
	start_random_timer()
