extends Position2D
var bullet = preload("res://objects/Bullet.tscn")

enum ShotType { NONE, LINE, CIRCLE, FAN }

export (float) var bullet_cooldown = 0
export (ShotType) var type = ShotType.NONE
export (int) var line_angle = 0
export (int) var circle_bullet_number = 50
export (int) var fan_angle_max = 45
export (int) var fan_angle_speed = 2

var bullet_counter
var fan_positive
var angle

func _ready():
	add_to_group("generator")
	bullet_counter = 0.0
	fan_positive = true
	angle = 0
	if type == ShotType.NONE:
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
	if type == ShotType.CIRCLE and circle_bullet_number != 0:
		for i in range(0, circle_bullet_number):
			b.angle = 360.0 / float(circle_bullet_number) * i
			get_node("/root/Main").add_child(b)
	else:
		if type == ShotType.LINE:
			b.angle = 180 - line_angle
		elif type == ShotType.FAN:
			if fan_positive:
				b.angle = 180 - angle
				angle += fan_angle_speed
				if angle >= fan_angle_max:
					fan_positive = false
					angle = fan_angle_max
			else:
				b.angle = 180 - angle
				angle -= fan_angle_speed
				if angle <= -fan_angle_max:
					fan_positive = true
					angle = -fan_angle_max
		get_node("/root/Main").add_child(b)