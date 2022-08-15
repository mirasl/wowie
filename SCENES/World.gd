extends Node2D


func _ready():
	$MultiCamera.add_target($Player)
	$MultiCamera.add_target($ChargeBot)
	$Player.position = $Level/PlayerStartPos.position
	$ChargeBot.position = $Level/RobotStartPos.position
	if not Audio.playing("Lab") and not get_filename() == "res://SCENES/World3.tscn" and not get_filename() == "res://SCENES/World4.tscn":
		Audio.play("Lab")
	elif get_filename() == "res://SCENES/World4.tscn":
		Audio.play("TitleScreen")
	$CanvasLayer2/Healthbar.set_health(6)


func _on_ChargeBot_get_player_position():
	$ChargeBot.player_position = $Player.position


func _on_ChargeBot_launching(launching):
	$MultiCamera.launching = launching


func _on_Player_player_hit(hp : int):
	$CanvasLayer2/Healthbar.set_health(hp)


func _on_Level_next_level():
	Global.world_number += 1
	get_tree().change_scene("res://SCENES/World" + str(Global.world_number) + ".tscn")
