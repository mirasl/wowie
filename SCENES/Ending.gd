extends "res://SCENES/Screenplay.gd"

const FADE_IN_TIME = 0.5

var textbox
var check1 := true
var check2 := true
var check3 := true
var check4 := true
var check5 := true
var check6 := true


func _ready():
	Audio.play("Intro")
	$ChargeBot.callable = false
	$Player.calling_enabled = false
	$Player/Hey.hide()
	$Player/Explosion.hide()
	
	var overlay = $CanvasLayer3/Overlay
	overlay.modulate = Color(0,0,0,1)
	overlay.show()
	yield(get_tree().create_timer(1), "timeout")
	var t1 := get_tree().create_tween()
	t1.tween_property(overlay, "modulate", Color(0, 0, 0, 0), FADE_IN_TIME)
	
	yield(get_tree().create_timer(FADE_IN_TIME + 0.5), "timeout")
	
	textbox = load_text_custom_speed("ending.json", 0.05)


func _physics_process(delta):
	if is_instance_valid(textbox):
		if textbox.dialogPath == "res://dialogue/ending.json":
			if textbox.phraseNum == 3 and check1:
				check1 = false
				$AnimationPlayer.play("walk_up")
				
			elif textbox.phraseNum == 5 and check2:
				check2 = false
				$AnimationPlayer.stop()
				$AnimationPlayer.play("look_right")
				
			elif textbox.phraseNum == 7 and check3:
				check3 = false
				$AnimationPlayer.stop()
				$AnimationPlayer.play("pace")
			
			elif textbox.phraseNum == 8 and check4:
				check4 = false
				$AnimationPlayer.stop()
				$AnimationPlayer.play("look_right")
			
			elif textbox.phraseNum == 11 and check5:
				check5 = false
				$AnimationPlayer.stop()
				$AnimationPlayer.play("look_left")
			
			elif textbox.phraseNum == 13:
				if Input.is_action_just_pressed("accept") and check6:
					check6 = false
					$ChargeBot.player_position = $Player.position
					$ChargeBot.launch()
					yield(get_tree().create_timer(1), "timeout")
					$Player/AnimatedSprite.hide()
					$Player/Explosion.show()
					$Player/Explosion.play("default")
					Audio.stop("Intro")
					Audio.play("MetalBang")
					yield(get_tree().create_timer(0.45), "timeout")
					$Player/Explosion.hide()
					Audio.play("YouWin")
					yield(get_tree().create_timer(1.55), "timeout")
					get_tree().change_scene("res://SCENES/YouWin.tscn")
			
			
			
	
