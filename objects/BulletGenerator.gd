extends Position2D
var bullet = preload("res://objects/Bullet.tscn")

export (float) var bullet_cooldown
var bullet_counter

func _ready():
	add_to_group("generator")
	bullet_counter = 0.0
	if bullet_cooldown == 0:
		set_process(false)
	
func _process(delta):
	bullet_counter += delta
	if bullet_counter > bullet_cooldown:
		shoot()
		bullet_counter -= bullet_cooldown

func shoot():
	var b = bullet.instance()
	b.enemy_bullet = true
	b.position = global_position
	b.damage = 1
	get_node("/root/Main").add_child(b)