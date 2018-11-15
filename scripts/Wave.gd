extends Node2D

var enemies = []

func _ready():
	set_process(false)
	load()
	set_process(true)

func load():
	for child in get_children():
		enemies.append(child)

func _process(delta):
	if len(enemies) == 0:
		queue_free()