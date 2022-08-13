extends Node


func play(stream_name : String):
	for child in get_children():
		if child is AudioStreamPlayer and child.name == stream_name:
			child.play()
