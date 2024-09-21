extends Node2D

const SPEED = 150
signal player_hurt

func _ready() -> void:
	var options = get_children()
	var obstacle = options.pick_random()
	obstacle.show()

func _process(delta: float) -> void:
	if not get_tree().paused:
		position.x -= SPEED * delta

func _on_obstacle_body_entered(body: Node2D) -> void:
	if body.has_method("play_hurt_sound"):
		body.call("play_hurt_sound")
	emit_signal("player_hurt")
