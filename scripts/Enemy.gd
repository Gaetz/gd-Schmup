extends Area2D

export (int) var lives = 1

func _on_Enemy_body_entered(body):
	if body in get_tree().get_nodes_in_group("player bullet"):
		damage(body)
		
func damage(bullet):
	lives -= bullet.damage()
	if lives <= 0:
		queue_free()
