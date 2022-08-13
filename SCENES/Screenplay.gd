extends Node


func load_text(path : String) -> Node:
	var textbox = preload("res://SCENES/DialogueBox.tscn")
	textbox = textbox.instance()
	textbox.dialogPath = str("res://dialogue/", path)
	$CanvasLayer.add_child(textbox)
	return textbox


func load_text_custom_speed(path : String, speed : float) -> Node:
	var textbox = preload("res://SCENES/DialogueBox.tscn")
	textbox = textbox.instance()
	textbox.dialogPath = str("res://dialogue/", path)
	textbox.textSpeed = speed
	$CanvasLayer.add_child(textbox)
	return textbox
