extends Node


func play(stream_name : String):
	for child in get_children():
		if child is AudioStreamPlayer and child.name == stream_name:
			child.play()


func playing(stream_name : String): # checks if stream is playing
	for child in get_children():
		if child is AudioStreamPlayer and child.name == stream_name:
			return child.playing


func stop(stream_name : String):
	for child in get_children():
		if child is AudioStreamPlayer and child.name == stream_name:
			child.stop()
