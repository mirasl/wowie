extends Control

export var dialogPath = "res://dialogue/intro.json"
export(float) var textSpeed = 0.05

var dialog

var phraseNum = 0
var finished = false


func _ready():
	$Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()


func _process(delta):
	#$Indicator.visible = finished
	if Input.is_action_just_pressed("accept"):
		if finished:
			nextPhrase()
		else:
			$Text.visible_characters = len($Text.text)


func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath), dialogPath + " path does not exist")
	
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []


func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		hide()
		phraseNum = -1
		return
	
	finished = false
	
	$Name.bbcode_text = dialog[phraseNum]["Name"]
	$Text.bbcode_text = dialog[phraseNum]["Text"]
	
	set_box_color()
	
	$Text.visible_characters = 0
	
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	phraseNum += 1
	return


func set_box_color():
	var speaker = dialog[phraseNum]["Name"]
	if speaker == "COMPUTER":
		$Textbox.modulate = Color.darkred
	elif speaker == "DR ELECTRON":
		$Textbox.modulate = Color("855e97")
	else:
		$Textbox.modulate = Color(1, 1, 1)
