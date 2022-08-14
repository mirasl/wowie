extends Node2D

signal next_level


func _on_ExitSensor_body_entered(body):
	if body.get_filename() == "res://SCENES/Player.tscn":
		emit_signal("next_level")
