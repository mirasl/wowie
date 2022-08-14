extends Node2D


func _physics_process(delta):
	if Input.is_action_just_pressed("accept"):
		get_tree().change_scene("res://SCENES/World" + str(Global.world_number) + ".tscn")

