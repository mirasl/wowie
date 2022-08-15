extends "res://SCENES/World.gd"

const FADE_OUT_DURATION := 2.0

var check1 := true


func _ready():
	$CanvasLayer3/Overlay.hide()
	Audio.stop("TitleScreen")

func _physics_process(delta):
	if Input.is_action_just_pressed("call") and check1:
		check1 = false
		yield(get_tree().create_timer(2), "timeout")
		var t1 = get_tree().create_tween()
		$CanvasLayer3/Overlay.show()
		$CanvasLayer3/Overlay.modulate = Color(0, 0, 0, 0)
		t1.tween_property($CanvasLayer3/Overlay, "modulate", Color(0, 0, 0, 1), FADE_OUT_DURATION)
		yield(get_tree().create_timer(FADE_OUT_DURATION + 0.5), "timeout")
		Audio.stop("Lab")
		Global.world_number = 1
		get_tree().change_scene("res://SCENES/StartScreen.tscn")
