extends Area2D

export (int) var speed = 800
export (bool) var special_bullet = false

var direction = Vector2()
var velocity = Vector2()
var screen_size
var damage = 1

func _ready():
	screen_size = get_viewport_rect().size
	velocity = direction.normalized() * speed

func _process(delta):
	position = position + velocity * delta
	if out_of_screen():
		queue_free()

func out_of_screen():
	return not(position.x >= 0 and position.x <= screen_size.x
	and position.y >= 0 and position.y <= screen_size.y)
	
func damage():
	return damage