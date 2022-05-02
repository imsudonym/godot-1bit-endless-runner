extends Node

var is_game_started = false

onready var startMenu = $StartMenu
onready var scoreLabel = $ScoreLabel/Label
onready var scoreTimer = $ScoreTimer
onready var instructionsLabel = $InstructionsLabel/Label
onready var highscoreLabel = $HighscoreLabel/Label
onready var player = $Player

func _ready():
	player.connect("second_jump", self, "_on_Second_Jump")
	VisualServer.set_default_clear_color(Color.black)
	pause_game()

func _process(delta):
	if not is_game_started:
		if Input.is_action_just_pressed("ui_accept"):
			start_game()
		elif Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit()

func pause_game():
	get_tree().paused = true
	is_game_started = false
	
	Global.newHighscore = false
	Global.score = 0
	
	set_highscore_label()
	
	scoreLabel.hide()
	instructionsLabel.hide()
	highscoreLabel.show()
	startMenu.show()

func set_highscore_label():
	var save_data = SaveAndLoad.load_data_from_file()
	if save_data.highscore > 0:
		highscoreLabel.text = "Highscore: \n" + str(save_data.highscore) + " (by "+ save_data.player +")"
	else:
		highscoreLabel.text = ""

func start_game():
	get_tree().paused = false
	is_game_started = true
	
	startMenu.hide()
	highscoreLabel.hide()
	instructionsLabel.show()
	scoreLabel.show()

func update_score():
	Global.score += 1
	scoreLabel.text = str(Global.score)	

func game_over():
	scoreTimer.stop()
	get_tree().paused = true
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://GameOver.tscn")

func _on_ScoreTimer_timeout():
	update_score()

func _on_Start_body_entered(body):
	scoreTimer.start()

func _on_Void_body_entered(body):
	game_over()

func _on_Second_Jump():
	instructionsLabel.hide()
