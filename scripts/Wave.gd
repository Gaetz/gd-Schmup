extends Node2D

var enemies = []

func _ready():
	load_enemies()

func load_enemies():
	for child in get_children():
		enemies.append(child)


func _process(delta):
	if len(enemies) == 0:
		queue_free()