extends Control

var live_textures = []

func _ready():
	var lives = get_parent().number_of_tries
	for i in range(lives):
		var text = TextureRect.new()
		text.texture = load("res://sprites/ship.png")
		text.rect_scale = Vector2(0.5, 0.5)
		text.rect_position = Vector2(20 + i * 50, 20)
		live_textures.append(text)
		add_child(text)

func change_lives(n):
	for i in range(len(live_textures) - 1, -1, -1):
		if i > n - 1 and live_textures[i]:
			live_textures[i].queue_free()
			live_textures.remove(i)