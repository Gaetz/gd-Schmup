extends Area2D

var destruction_particle = preload("res://objects/DestructionParticule.tscn")
var damage_particle = preload("res://objects/DamageParticule.tscn")

enum Entry { NONE, RIGHT, UP, DOWN, LEFT }
enum Exit { NONE, RIGHT, UP, DOWN, LEFT }
enum Phase { WAITING, ENTRY, MAIN, EXIT }

export (int) var lives = 1
export (float) var time_on_screen = -1
export (Entry) var entry = Entry.RIGHT
export (Exit) var exit = Exit.LEFT
export (int) var entry_order = 0
export (float) var transition_speed = float(400)
export (Vector2) var main_speed = Vector2()

var phase
var target_position
var time_counter

var SECURITY_OFFSET = 200

func _ready():
	set_entry_position()
	time_counter = 0.0
	phase = Phase.ENTRY
	set_generators_active(false)

func set_entry_position():
	var screen_size = get_viewport().size
	target_position = Vector2(position.x, position.y)
	if entry == Entry.RIGHT:
		position.x += screen_size.x
	if entry == Entry.UP:
		position.y -= screen_size.y
	if entry == Entry.DOWN:
		position.y += screen_size.y
	if entry == Entry.LEFT:
		position.x -= screen_size.x

func set_exit_target_position():
	var screen_size = get_viewport().size
	var x = position.x
	var y = position.y
	if exit == Exit.RIGHT:
		x = screen_size.x + SECURITY_OFFSET
	if exit == Exit.UP:
		y = -SECURITY_OFFSET
	if exit == Exit.DOWN:
		y = screen_size.y + SECURITY_OFFSET
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
	if new_phase == Phase.MAIN:
		set_generators_active(true)
	if new_phase == Phase.EXIT:
		set_generators_active(false)

func set_generators_active(b):
	for child in get_children():
		if "generator" in child.get_groups():
			child.set_process(b)

func process_entry(delta):
	if entry == Entry.RIGHT:
		if position.x > target_position.x:
			position.x -= transition_speed * delta
		else:
			change_phase(Phase.MAIN)
	elif entry == Entry.UP:
		if position.y < target_position.y:
			position.y += transition_speed * delta
		else:
			change_phase(Phase.MAIN)
	elif entry == Entry.DOWN:
		if position.y > target_position.y:
			position.y -= transition_speed * delta
		else:
			change_phase(Phase.MAIN)
	elif entry == Entry.RIGHT:
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
	elif exit == Exit.UP:
		if position.y > target_position.y:
			position.y -= transition_speed * delta
		else:
			queue_free()
	elif exit == Exit.DOWN:
		if position.y < target_position.y:
			position.y += transition_speed * delta
		else:
			queue_free()
	elif exit == Exit.LEFT:
		if position.x > target_position.x:
			position.x -= transition_speed * delta
		else:
			queue_free()
	
func is_on_screen():
	return not(
		position.x > -SECURITY_OFFSET and position.x < 1280 + SECURITY_OFFSET and
		position.y > -SECURITY_OFFSET and position.y < 720 + SECURITY_OFFSET
	)

# Collisions
func _on_Enemy_area_entered(area):
	if area in get_tree().get_nodes_in_group("player bullet"):
		var particle = damage_particle.instance()
		var rx = randi()%11+1 - 6
		var ry = randi()%11+1 - 6
		particle.position = area.position + Vector2(rx+20, ry)
		particle.emitting = true
		get_node("/root/Main").add_child(particle)
		damage(area)

func damage(b):
	lives -= b.damage()
	if lives <= 0:
		var particle = destruction_particle.instance()
		particle.position = position
		particle.emitting = true
		get_node("/root/Main").add_child(particle)
		queue_free()