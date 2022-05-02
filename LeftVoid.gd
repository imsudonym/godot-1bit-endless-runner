extends Area2D

func _on_LeftVoid_area_entered(area):
	print("leftvoid area entered")
	area.queue_free()
