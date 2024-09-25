extends Node2D

const MOB = 'Mob'
const NATURE = 'Nature'
const FLYING = 'Flying'

const SPEED = 150
signal player_hurt

@onready var mob_obstacles: Node2D = $Mobs
@onready var flying_obstacles: Node2D = $Flying
@onready var nature_obstacles: Node2D = $Nature

@export var variant = NATURE

func _ready():
	initialize_variant()

func _process(_delta: float) -> void:
	if not get_tree().paused:
		position.x -= SPEED * _delta

func initialize_variant():
	var options = []
	if variant == MOB:
		options = mob_obstacles.get_children()
	elif variant == FLYING:
		options = flying_obstacles.get_children()
	else:
		options = nature_obstacles.get_children()
	var obstacle = options.pick_random()
	obstacle.show()

func _on_obstacle_body_entered(body: Node2D) -> void:
	if body.has_method("play_hurt_sound"):
		body.call("play_hurt_sound")
	emit_signal("player_hurt")
