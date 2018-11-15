extends Node2D

var enemies = []

func _ready():
	set_process(false)
	load_enemies()
	set_process(true)

func load_enemies():
	for child in get_children():
		enemies.append(child)
		child.set_entry_target_position()

func _process(delta):
	if len(enemies) == 0:
		queue_free()