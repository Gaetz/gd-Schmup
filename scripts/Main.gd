extends Node2D

export (int) var number_of_tries = 3

func _on_Player_hit():
	$RespawnTimer.start()

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	number_of_tries -= 1
	$UI/LivesControl.change_lives(number_of_tries)
	if number_of_tries > 0:
		$Player.start()
	else:
		$GameOverControl.visible = true