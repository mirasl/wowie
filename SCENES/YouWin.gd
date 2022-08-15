extends Node2D

const SONG := "Lab"

var check1 : = true

func _ready():
	$Label2.text = "You destroyed " + str(Global.kills) + " robots!"
	yield(get_tree().create_timer(6), "timeout")
	#Audio.play(SONG)


func _physics_process(delta):
	if check1 and not Audio.playing("YouWin"):
		check1 = false
		Audio.play(SONG)
	
	if Input.is_action_just_pressed("accept"):
		Audio.stop(SONG)
		Global.kills = 1
		Global.world_number = 4
		get_tree().change_scene("res://SCENES/World4.tscn")
