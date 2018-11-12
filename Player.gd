extends Area2D

signal hit

export (int) var max_speed = 500
export (int) var acceleration = 30
export (int) var deceleration_factor = 0.85
export (int) var lives = 1
export (int) var damage = 1
export (int) var cooldown = 0.2
export (PackedScene) var Bullet

var speed = 0
var cooldown_count = 0
var velocity = Vector2(0, 0)
var screen_size = Vector2(0, 0)
var sprite_size = Vector2(0, 0)

func _ready():
	screen_size = get_viewport_rect().size
	sprite_size = $Sprite.texture.get_size()
	position = Vector2(80, screen_size.y / 2 - sprite_size.y / 2)
	
func start():
	show()
	$CollisionShape2D.disabled = false	
	
func _process(delta):
	process_move(delta)
	process_shoot(delta)

func process_move(delta):
	var direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if direction.length() > 0:
		speed = speed + acceleration
		if speed > max_speed:
			speed = max_speed
		velocity = direction.normalized() * speed
	position = position + velocity * delta
	position.x = clamp(position.x, sprite_size.x / 2, screen_size.x - sprite_size.x / 2)
	position.y = clamp(position.y, sprite_size.y / 2, screen_size.y - sprite_size.y / 2)
	velocity = velocity * deceleration_factor
	
func process_shoot(delta):
	cooldown_count += delta
	if cooldown_count > cooldown:
		shoot()
		cooldown_count -= cooldown

func shoot():
	var bullet = Bullet.instance()
	bullet.position = position + Vector2(sprite_size.x, 0)
	bullet.direction = Vector2(1, 0)
	get_tree().root.add_child(bullet)

func _on_Player_body_entered(body):
	lives = lives - 1
	if lives <= 0:
		hide()
		emit_signal("hit")
		$CollisionShape2D.disabled = true	
