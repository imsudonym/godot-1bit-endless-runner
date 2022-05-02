extends Node

onready var player = $Player
onready var highscoreLabel = $HighscoreLabel/Label
onready var gameOverLabel = $GameOverLabel/Label
onready var nameInput = $NameInput

func _ready():
	get_tree().paused = true
	set_score_label()
	
	var save_data = SaveAndLoad.load_data_from_file()
	if Global.score > save_data.highscore:
		nameInput.show()
		highscoreLabel.hide()
		Global.newHighscore = true
	else:
		nameInput.hide()
		highscoreLabel.show()
		set_highscore_label()
		
	
	if Global.newHighscore:
		player.spriteAnimator.play("Happy")
	else:
		player.spriteAnimator.play("Sleeping")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://World.tscn")

func set_highscore_label():
	var save_data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = "Highscore: \n" + str(save_data.highscore) + " (by "+ save_data.player +")"

func update_save_data():
	var save_data = SaveAndLoad.load_data_from_file()
	if Global.score > save_data.highscore:
		save_data.highscore = Global.score
		save_data.player = Global.player
		SaveAndLoad.save_data_to_file(save_data)

func set_score_label():
	gameOverLabel.text = "GAME OVER\n" + str(Global.score) 

func _on_NameInput_text_entered(new_text):
	print(new_text)
	Global.player = new_text
	nameInput.hide()
	update_save_data()
	set_highscore_label()
	highscoreLabel.show()
	
