extends Control

#var voices = DisplayServer.tts_get_voices_for_language("en")
#var voice_id = voices[1]

var num1 : int
var num2 : int
var answerkey : int

var problem_solved = false

var apple_tex = preload("res://images/apple.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_problem()

	#DisplayServer.tts_speak("What is " + $Question.text, voice_id)

func _input(_ev):
	for k in range(0, 10):
		if (Input.is_action_just_pressed(str(k))):
			answer_attempt(k)
			break;

func generate_problem():
	num1 = randi() % 10
	num2 = randi() % 10
	answerkey = num1 + num2
	
	while(answerkey >= 10):
		num1 = randi() % 10
		num2 = randi() % 10
		answerkey = num1 + num2
		
	problem_solved = false
	$MainVB/EquationHB/Answer.text = ""
	$MainVB/EquationHB/Question.text = str(num1) + "+" + str(num2) + "="
	
	var tex
	for i in range(num1):
		tex = TextureRect.new()
		tex.texture = apple_tex
		$MainVB/DisplayHB/LHB.add_child(tex)
		
	for i in range(num2):
		tex = TextureRect.new()
		tex.texture = apple_tex
		$MainVB/DisplayHB/RHB.add_child(tex)

func answer_attempt(number) -> void:
	if (problem_solved):
		return
		
	var sound
	
	if (number != answerkey):
		sound = load("res://sounds/wrong.mp3")
		$MainVB/EquationHB/SoundEffect.play()
		var question = $MainVB/EquationHB/Question
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE)
		tween.tween_property(question, "position", Vector2(-40,0), .1)
		tween.tween_property(question, "position", Vector2(40,0), .2)
		tween.tween_property(question, "position", Vector2(0,0), .1)
		generate_problem()
	else:
		sound = load("res://sounds/correct.mp3")
		
		problem_solved = true
		#DisplayServer.tts_speak("is correct", voice_id)
		
		$MainVB/EquationHB/Answer.text = str(answerkey)
		var eqpos = $MainVB/EquationHB.position
		var eqsize = $MainVB/EquationHB.size
		$MainVB/EquationHB/GPUParticles2D.position = eqpos + eqsize / 2
		$MainVB/EquationHB/GPUParticles2D.restart()
		
		$MainVB/NextBTN.visible = true
		$MainVB/Numpad.visible = false
		
		var tex
			
		for i in range(answerkey):
			tex = TextureRect.new()
			tex.texture = apple_tex
			$MainVB/DisplayHB/EHB.add_child(tex)
		
		#Wait 1 seconds
		#await get_tree().create_timer(1).timeout
		
	
	if ($MainVB/EquationHB/SoundEffect.playing):
		$MainVB/EquationHB/SoundEffect.stop()
	
	$MainVB/EquationHB/SoundEffect.stream = sound
	$MainVB/EquationHB/SoundEffect.play()
	
	#if (number == answerkey):
		#await get_tree().create_timer(2).timeout
		#generate_problem()
		
func _on_numpad_numpad_pressed(number):
	answer_attempt(number)

func _on_next_button_down():
	$MainVB/NextBTN.visible = false
	$MainVB/Numpad.visible = true
	
	for c in $MainVB/DisplayHB/LHB.get_children():
		c.free()
		
	for c in $MainVB/DisplayHB/RHB.get_children():
		c.free()
	
	for c in $MainVB/DisplayHB/EHB.get_children():
		c.free()
	
	generate_problem()
