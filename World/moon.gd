extends Node2D

const SPEED = 10
@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	if not get_tree().paused:
		position.x -= SPEED * delta
