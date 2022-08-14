extends "res://SCENES/World.gd"

const FADE_DURATION : = 0.5


func _ready():
	$CanvasLayer3/Overlay.hide()
	for i in 3:
		yield(get_tree().create_timer(0.01), "timeout")
		if Audio.playing("Lab"):
			Audio.stop("Lab")
		if not Audio.playing("BossFight"):
			Audio.play("BossFight")


func _on_Level_boss_defeated():
	yield(get_tree().create_timer(0.5), "timeout")
	var overlay = $CanvasLayer3/Overlay
	overlay.show()
	overlay.modulate.a = 0
	var t1 := get_tree().create_tween()
	t1.tween_property(overlay, "modulate", Color(0, 0, 0, 1), FADE_DURATION)
	yield(get_tree().create_timer(FADE_DURATION), "timeout")
	get_tree().change_scene("res://SCENES/Ending.tscn")
