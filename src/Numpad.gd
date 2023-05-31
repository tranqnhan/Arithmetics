extends HBoxContainer

signal numpad_pressed(number) # send arguments via signal

var voices = DisplayServer.tts_get_voices_for_language("en")
var voice_id = voices[1]

func _ready():
	var btn : Button
	for i in range(0, 10):
		btn = get_node(str(i))
		btn.pressed.connect(on_numpad_pressed.bind(i))

func on_numpad_pressed(number):
	#DisplayServer.tts_speak(str(number), voice_id)
	emit_signal("numpad_pressed", number)
