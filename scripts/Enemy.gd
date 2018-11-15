extends Area2D

enum Entry { RIGHT, UP, DOWN, LEFT }
enum Exit { NONE, RIGHT, UP, DOWN, LEFT }
enum Phase { WAITING, ENTRY, MAIN, EXIT }

export (int) var lives = 1
export (int) var time_on_screen = -1
export (Entry) var entry = Entry.RIGHT
export (Exit) var exit = Exit.LEFT
export (int) var entry_order = 0
export (float) var transition_speed = float(400)
export (Vector2) var main_speed = Vector2()

var time_counter
var phase
var target_position

var SECURITY_OFFSET = 200

func _ready():
	set_entry_target_position()
	
func set_entry_target_position():
	time_counter = 0.0
	phase = Phase.ENTRY
	target_position = position
	if entry == Entry.RIGHT:
		position.x = 1280 + SECURITY_OFFSET
	if entry == Entry.UP:
		position.y = -SECURITY_OFFSET
	if entry == Entry.DOWN:
		position.y = 720 + SECURITY_OFFSET
	if entry == Entry.LEFT:
		position.x = -SECURITY_OFFSET

func set_exit_target_position():
	var x = position.x
	var y = position.y
	if exit == Exit.RIGHT:
		x = 1280 + SECURITY_OFFSET
	if exit == Exit.UP:
		y = -SECURITY_OFFSET
	if exit == Exit.DOWN:
		y = 720 + SECURITY_OFFSET
	if exit == Exit.LEFT:
		x = -SECURITY_OFFSET
	target_position = Vector2(x, y)
	
func _process(delta):
	if phase == Phase.ENTRY:
		process_entry(delta)
	elif phase == Phase.MAIN:
		process_main(delta)
	elif phase == Phase.EXIT:
		process_exit(delta)

func change_phase(new_phase):
	phase = new_phase

func process_entry(delta):
	if entry == Entry.RIGHT:
		if position.x > target_position.x:
			position.x -= transition_speed * delta
		else:
			change_phase(Phase.MAIN)
	if entry == Entry.UP:
		if position.y < target_position.y:
			position.y += transition_speed * delta
		else:
			change_phase(Phase.MAIN)
	if entry == Entry.DOWN:
		if position.y > target_position.y:
			position.y -= transition_speed * delta
		else:
			change_phase(Phase.MAIN)
	if entry == Entry.RIGHT:
		if position.x < target_position.x:
			position.x += transition_speed * delta
		else:
			change_phase(Phase.MAIN)
	
func process_main(delta):
	position += main_speed * delta
	if time_on_screen != -1:
		time_counter += delta
		if time_counter > time_on_screen:
			change_phase(Phase.EXIT)
			set_exit_target_position()
	if exit == Exit.NONE and not is_on_screen():
		queue_free()
	
func process_exit(delta):
	if exit == Exit.RIGHT:
		if position.x < target_position.x:
			position.x += transition_speed * delta
		else:
			queue_free()
	if exit == Exit.UP:
		if position.y > target_position.y:
			position.y -= transition_speed * delta
		else:
			queue_free()
	if exit == Exit.DOWN:
		if position.y < target_position.y:
			position.y += transition_speed * delta
		else:
			queue_free()
	if exit == Exit.RIGHT:
		if position.x > target_position.x:
			position.x -= transition_speed * delta
		else:
			queue_free()
	
func is_on_screen():
	return not(
		position.x > -SECURITY_OFFSET and position.x < 1280 + SECURITY_OFFSET and
		position.y > -SECURITY_OFFSET and position.y < 720 + SECURITY_OFFSET
	)

# Damages
func _on_Enemy_body_entered(body):
	if body in get_tree().get_nodes_in_group("player bullet"):
		damage(body)
		
func damage(bullet):
	lives -= bullet.damage()
	if lives <= 0:
		queue_free()

