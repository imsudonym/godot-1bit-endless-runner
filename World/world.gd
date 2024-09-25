extends Node

@onready var bg_object_spawner_timer: Timer = $BgObjectSpawner/Timer
@onready var obstacle_spawner_timer: Timer = $ObstacleSpawner/Timer

@onready var game_over_delay: Timer = $GameOverDelay
@onready var score_timer: Timer = $ScoreTimer
@onready var player: CharacterBody2D = $Player

@onready var control_instruction_label: CenterContainer = $ControlInstruction

@onready var score_label: Label = $ScoreLabel
@onready var hundreths_score_sound: AudioStreamPlayer = $HundrethsScoreSound
@onready var start_point: Sprite2D = $StartPoint

@onready var game_over_container: CenterContainer = $GameOverContainer
@onready var game_over_instructions: CenterContainer = $GameOverInstruction
@onready var try_again_message: Label = $GameOverInstruction/TryAgainMessage

var is_game_started = false
var is_game_over = false

func _ready():
	get_tree().paused = true
	RenderingServer.set_default_clear_color(Color.BLACK)
	SaveAndLoad.load_game_data()
	update_score(0)
	control_instruction_label.show()

func _process(_delta):
	var accept = Input.is_action_just_pressed('jump')
	var enter = Input.is_action_just_pressed('enter')
	if not is_game_started or is_game_over:
		if game_over_delay.time_left == 0 and accept:
			start_game()

func start_game():
	clear_world()
	start_point.show()
	get_tree().paused = false
	is_game_started = true
	is_game_over = false
	
	hide_game_over_ui()
	control_instruction_label.hide()
	
	update_score(0)
	score_timer.start()
	obstacle_spawner_timer.start()
	bg_object_spawner_timer.start()

func hide_game_over_ui():
	game_over_container.hide()
	try_again_message.hide()

func clear_world():
	clear_obstacles()

func clear_obstacles():
	var obstacles = get_tree().get_nodes_in_group("obstacles")
	for obstacle in obstacles:
		obstacle.queue_free()

func clear_bg_objects():
	var background_objects = get_tree().get_nodes_in_group("background-objects")
	for objects in background_objects:
		objects.queue_free()
		
func update_score(value):
	Global.score = value
	score_label.text = "HI " + str(Global.high_score).pad_zeros(5) + " " + str(Global.score).pad_zeros(5)

func game_over():
	get_tree().paused = true
	
	is_game_over = true
	is_game_started = false

	bg_object_spawner_timer.stop()
	obstacle_spawner_timer.stop()
	score_timer.stop()
	
	check_highscore()
	game_over_container.show()
	
	try_again_message.show()
	game_over_delay.start()
	resetStartPoint()
	clear_bg_objects()

func check_highscore():
	if Global.score > Global.high_score:
		Global.high_score = Global.score
		SaveAndLoad.save_game_data()

func _on_replay_button_pressed() -> void:
	hide_game_over_ui()

func _on_player_hurt():
	game_over()

func _on_score_timer_timeout() -> void:
	update_score(Global.score + 1)
	if Global.score % 100 == 0:
		hundreths_score_sound.play()

func resetStartPoint():
	start_point.position.x = 96
	start_point.position.y = 116
