extends CharacterBody2D

@export var gravity = 400
@export var jump_force = 150
@export var max_fall_speed = 170
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var jump_sound_effect: AudioStreamPlayer2D = $JumpSoundEffect
@onready var hurt_sound_effect: AudioStreamPlayer2D = $HurtSoundEffect

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	jump_check()
	update_animations()
	move_and_slide()

func is_moving(input_axis):
	return input_axis != 0

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity * delta)
 
func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
			jump_sound_effect.play()
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2:
			velocity.y = -jump_force / 2

func update_animations():
	if get_tree().paused:
		animation_player.stop()
		return
	
	if not is_on_floor():
		animation_player.play("jump")
	else:
		animation_player.play("run")

func play_hurt_sound():
	hurt_sound_effect.play()
