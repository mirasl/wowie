extends Node2D


func _ready():
	$MultiCamera.add_target($Player)
	$MultiCamera.add_target($ChargeBot)
	$Player.position = $Level/PlayerStartPos.position
	$ChargeBot.position = $Level/RobotStartPos.position
	if not Audio.playing("Lab"):
		Audio.play("Lab")
	$CanvasLayer2/Healthbar.set_health(3)


func _on_ChargeBot_get_player_position():
	$ChargeBot.player_position = $Player.position


func _on_ChargeBot_launching(launching):
	$MultiCamera.launching = launching



func _on_Player_player_hit(hp : int):
	$CanvasLayer2/Healthbar.set_health(hp)
