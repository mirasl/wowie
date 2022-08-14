extends "res://SCENES/World.gd"

func _ready():
	yield(get_tree().create_timer(0.01), "timeout")
	if Audio.playing("Lab"):
		Audio.stop("Lab")
		Audio.play("BossFight")
