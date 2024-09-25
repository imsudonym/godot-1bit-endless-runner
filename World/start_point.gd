extends Sprite2D

const SPEED = 150

func _process(delta: float) -> void:
	if not get_tree().paused:
		position.x -= SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	hide()
