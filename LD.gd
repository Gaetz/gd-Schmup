extends Node2D

var counter = 0 
var waves = [
	{ "id": 0, "path": "waves/Wave0.tscn", "timing": 2 },
	{ "id": 1, "path": "waves/Wave1.tscn", "timing": 10 }
]
var triggered_waves = [] # ids of triggered waves


func _ready():
	""" Load, instanciate and store each wave """
	for wave in waves:
		var path = "res://"+wave["path"]
		var scene = load(path)
		wave["scene"] = scene.instance()

func _process(delta):
	""" Trigger each wave with the proper timing """
	counter += delta
	for wave in waves:
		if counter >= wave["timing"] and (not triggered_waves.has(wave["id"])):
			triggered_waves.append(wave["id"])
			get_node("/root/Main").add_child(wave["scene"])