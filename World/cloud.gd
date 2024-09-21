extends Node2D

const SPEED = 20
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	var flip = [true, false].pick_random()
	sprite_2d.flip_h = flip

func _process(delta: float) -> void:
	if not get_tree().paused:
		position.x -= SPEED * delta
