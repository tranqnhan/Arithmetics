extends Control

var apple_res = preload("res://objects/BouncingApple.tscn")
var particle_res = preload("res://DefaultCircularParticle.tscn")

var apple_inst
var particle_inst : GPUParticles2D

var previous = 0
var current = 0
var enqueue = 0
var win = DisplayServer.window_get_size()

func _on_plus_one_pressed():
	apple_inst = apple_res.instantiate()
	apple_inst.position = $AppleSpawn.position + ($AppleSpawn.size / 2)
	apple_inst.linear_velocity.x = (randi() % 1000) - 500
	push_obj(apple_inst)
	
	particle_inst = particle_res.instantiate()
	particle_inst.position = apple_inst.position
	particle_inst.restart()
	get_tree().create_timer(particle_inst.emitting,false).timeout.connect(particle_inst.queue_free)
	$Group/Particles.add_child(particle_inst)

func _on_minus_one_pressed():
	if (current == 0):
		return

	apple_inst = $Group/Objects.get_children()[0]
	pop_object(apple_inst)
	
	particle_inst = particle_res.instantiate()
	particle_inst.position = apple_inst.position
	particle_inst.restart()
	get_tree().create_timer(particle_inst.emitting,false).timeout.connect(particle_inst.queue_free)
	$Group/Particles.add_child(particle_inst)

func pop_object(obj):
	if (current == 0):
		return
	enqueue -= 1
	current -= 1
	obj.queue_free()
	update_equation()
	$StaggeredUpdate.start()
	
func push_obj(obj):
	enqueue += 1
	current += 1
	$Group/Objects.add_child(apple_inst)
	update_equation()
	$StaggeredUpdate.start()
	
func update_equation():
	var op
	if (enqueue < 0):
		op = "-"
	else:
		op = "+"
	$MainVB/TotalHB/Label.text = str(previous) + op + str(abs(enqueue)) + "=" + str(current)
	$StaggeredUpdate.start()

func _on_chomp_pressed():
	$AlligatorChomp.chomp()

func _on_alligator_chomp_on_teeth(body):
	print(str(current) + str($AlligatorChomp.is_chomping))
	if ($AlligatorChomp.is_chomping):
		pop_object(body)

func _on_staggered_update_timeout():
	previous = current
	enqueue = 0
	var enqueue_equation: Label = $MainVB/TotalHB/Label.duplicate()
	$MainVB/TotalHB/Label.text = str(current)
	add_child(enqueue_equation)
	enqueue_equation.global_position = $MainVB/TotalHB/Label.global_position
	var tween_a = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
	tween_a.tween_property($SideVB, "global_position", $SideVB.position + Vector2(0, enqueue_equation.get_theme_font_size("font_size")), .5)
	var tween_b = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
	tween_b.tween_property(enqueue_equation, "global_position", Vector2(0, 0), .5)
	tween_a.finished.connect(update_equation_visuals.bind(enqueue_equation))
	
func update_equation_visuals(enqueue_equation: Label):
	remove_child(enqueue_equation)
	$SideVB.global_position = $SideVB.position - Vector2(0, enqueue_equation.get_theme_font_size("font_size"))
	if ($SideVB.get_child_count() > 10):
		$SideVB.get_child(10).queue_free()
	$SideVB.add_child(enqueue_equation)
	$SideVB.move_child(enqueue_equation, 0)
		
	


