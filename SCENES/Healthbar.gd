extends AnimatedSprite


func set_health(health : int):
	health = clamp(health, 0, 3)
	play(str(health))
	$Label.text = "HP: " + str(health) + "/3"
