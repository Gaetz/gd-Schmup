extends Area2D
var enemy_sprite = preload("res://sprites/bullet_enemy.png")

export (int) var speed = 800
export (bool) var special_bullet = false
export (bool) var enemy_bullet = false

var angle = 0
var direction = Vector2()
var velocity = Vector2()
var screen_size
var damage = 1

func _ready():
	screen_size = get_viewport_rect().size
	if enemy_bullet:
		$Sprite.texture = enemy_sprite
		angle = 180
		set_collision_layer_bit(0, false)
		set_collision_layer_bit(2, true)
		$Particles2D.emitting = false
		$Sprite.scale = Vector2(1, 1)
	direction = get_dir(angle)
	velocity = direction.normalized() * speed

func get_dir(degree_angle):
	return Vector2(cos(deg2rad(degree_angle)), sin(deg2rad(degree_angle)))
	
func _process(delta):
	position = position + velocity * delta
	if out_of_screen():
		queue_free()

func out_of_screen():
	return not(position.x >= 0 and position.x <= screen_size.x
	and position.y >= 0 and position.y <= screen_size.y)
	
func damage():
	queue_free()
	return damage