extends KinematicBody2D

export(int) var ACCELERATION = 512
export(int) var MAX_SPEED = 64
export(float) var FRICTION = 0.25
export(int) var GRAVITY = 200
export(int) var JUMP_FORCE = 128
export(int) var MAX_SLOPE_ANGLE = 46

var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false
var jumpsLeft = 2

onready var sprite = $Sprite
onready var spriteAnimator = $SpriteAnimator

signal second_jump

func _physics_process(delta):
	just_jumped = false
	if not is_on_game_over_screen():
		apply_gravity(delta)
	jump_check()
	update_animations()
	move()

func jump_check():
	if is_on_start_screen():
		return
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			motion.y = -JUMP_FORCE
			just_jumped = true
			snap_vector = Vector2.ZERO
			
			if jumpsLeft == 0:
				emit_signal("second_jump")
			else:
				jumpsLeft -= 1
				print("jumpsLeft: " + str(jumpsLeft))
	else:
		if Input.is_action_just_released("ui_accept") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
			
			if jumpsLeft <= 0:
				emit_signal("second_jump")
			else:
				jumpsLeft -= 1
				print("jumpsLeft: " + str(jumpsLeft))

func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func update_animations():
	if is_on_start_screen():
		spriteAnimator.play("Idle")
	elif not is_on_game_over_screen():
		if is_on_floor():
			spriteAnimator.play("Run")
		else:
			spriteAnimator.play("Jump")
	else:
		if Global.newHighscore:
			spriteAnimator.play("Happy")
		else:
			spriteAnimator.play("Sleeping")

func is_on_start_screen():
	if get_tree().current_scene.is_in_group("World"):
		return not get_tree().current_scene.is_game_started
	return false

func is_on_game_over_screen():
	return get_tree().current_scene.is_in_group("GameOver")
	
func move():
	var was_on_floor = is_on_floor()
	var last_position = position
	
	motion = move_and_slide_with_snap(motion, snap_vector * 4, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))
	
	if was_on_floor and not is_on_floor() and not just_jumped:
		motion.y = 0
		position.y = last_position.y
