extends Node2D

export (int) var number_of_tries = 3

func _on_Player_hit():
	$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	number_of_tries -= 1
	$LivesControl.change_lives(number_of_tries)
	if number_of_tries > 0:
		$Player.start()
	else:
		$GameOverControl.visible = true
		

var counter = 0 
var waves = [
	{ "id": 0, "path": "waves/Wave0.tscn", "timing": 2 } 
]
var triggered_waves = [] # ids of triggered waves
var current_wave

func _ready():
	for wave in waves:
		var path = "res://"+wave["path"]
		var scene = load(path)
		wave["scene"] = scene.instance()

func _process(delta):
	counter += delta
	for wave in waves:
		if counter >= wave["timing"] and (not triggered_waves.has(wave["id"])):
			triggered_waves.append(wave["id"])
			add_child(wave["scene"])
			
			 