extends Node

const SAVE_PATH = "res://save_data.json"

func save_game_data():
	var config = ConfigFile.new()
	config.set_value("Game", "highscore", Global.high_score)
	config.save(SAVE_PATH)

func load_game_data():
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	if error == OK:
		Global.high_score = config.get_value("Game", "highscore")
