extends Node2D

export(int) var SPEED = 50
onready var tileMap = $TileMap
var platformLengths = [1, 2, 3]

func _ready():
	var tileLen = get_random_length()
	print(tileLen)
	if tileLen == 1:
		tileMap.set_cell(0, 0, tileMap.tile_set.find_tile_by_name("tile-0"))
	else:
		var i = 0
		while i < tileLen:
			var tileName
			if i == 0:
				tileName = "tile-1"
			elif i == (tileLen - 1):
				tileName = "tile-3"
			else:
				tileName = "tile-2"
			tileMap.set_cell(i, 0, tileMap.tile_set.find_tile_by_name(tileName))
			i += 1

func _process(delta):
	position.x -= SPEED * delta

func get_random_length():
	platformLengths.shuffle()
	return platformLengths[0]
