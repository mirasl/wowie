
extends Node2D


func _ready():
	$Camera2D/AnimationPlayer.playback_speed = 0.3
	$Camera2D/AnimationPlayer.play("pan")
	Audio.play("TitleScreen")


func _physics_process(delta):
	if Input.is_action_just_pressed("accept"):
		Audio.stop("TitleScreen")
		get_tree().change_scene("res://SCENES/Office.tscn")
