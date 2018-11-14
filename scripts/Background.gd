extends ParallaxBackground

export (int) var background_speed = -5

func _process(delta):
	scroll_offset += Vector2(background_speed, 0)