extends "res://SCENES/Screenplay.gd"

var textbox
var check1 := true
var check2 := true
var check3 := true

# script for intro
func _ready():
	$Label.hide()
	$Overlay.hide()
	
	Audio.play("Intro")
	
	$ChargeBot.callable = false
	$Player.calling_enabled = false
	$Player/Hey.hide()
	$Player/AnimatedSprite/AnimationPlayer.play("WalkUp")
	$Player/AnimatedSprite/AnimationPlayer.playback_speed = 3.5
	
	yield(get_tree().create_timer(1), "timeout")
	textbox = load_text_custom_speed("intro.json", 0.03)


func _physics_process(delta):
	if is_instance_valid(textbox):
		if textbox.dialogPath == "res://dialogue/intro.json":
			if textbox.phraseNum == 2:
				$Player/AnimatedSprite/AnimationPlayer.play("IdleUp")
			if textbox.phraseNum == 4:
				$Player/AnimatedSprite/AnimationPlayer.play("WalkUp")
			if textbox.phraseNum == 5:
				$Player/AnimatedSprite/AnimationPlayer.stop()
			if textbox.phraseNum == -1 and check1:
				$AnimationPlayer.play("checkout_robot")
				check1 = false
				textbox.queue_free()
		
		if textbox.dialogPath == "res://dialogue/intro2.json":
			if textbox.phraseNum == -1 and check2:
				$AnimationPlayer.play("walk_to_door")
				check2 = false
				textbox.queue_free()
		
		if textbox.dialogPath == "res://dialogue/intro3.json":
			if textbox.phraseNum == -1 and check3:
				$AnimationPlayer.play("leave_room")
				check3 = false
				textbox.queue_free()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "checkout_robot":
		textbox = load_text("intro2.json")
	
	elif anim_name == "walk_to_door":
		$Player.hey()
		yield(get_tree().create_timer(0.2), "timeout")
		$ChargeBot.launch()
		$AnimationPlayer.play("dodge_robot")
		yield(get_tree().create_timer(2), "timeout")
		textbox = load_text("intro3.json")
	
	elif anim_name == "leave_room":
		$Overlay.show()
		$Overlay.modulate.a = 0
		var t = get_tree().create_tween()
		t.tween_property($Overlay, "modulate", Color(0, 0, 0, 1), 1)
		yield(get_tree().create_timer(1), "timeout")
		Audio.stop("Intro")
		Audio.play("Lab")
		$AnimationPlayer.play("ready")
	
	elif anim_name == "ready":
		Global.world_number = 1
		get_tree().change_scene("res://SCENES/World1.tscn")


func _on_ChargeBot_get_player_position():
	$ChargeBot.player_position = $Player.position
