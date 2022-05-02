extends Node2D

const Platform = preload("res://Platform.tscn")
onready var spawnPoint = $SpawnPoint
	
func spawn_platform():
	var spawn_position = spawnPoint.global_position
	var platform = Platform.instance()
	var main =  get_tree().current_scene
	main.add_child(platform)
	platform.global_position = spawn_position

func _on_Timer_timeout():
	spawn_platform()
