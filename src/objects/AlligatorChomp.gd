extends Node2D

signal on_teeth(body) # send arguments via signal

var is_chomping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Head.rotation_degrees = -90
	
func chomp():
	if (is_chomping):
		return
	is_chomping = true
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Head, "rotation_degrees", 0, .5)
	tween.tween_callback(finish_chomp)
	tween.chain().tween_property($Head, "rotation_degrees", -90, 2)
	
func finish_chomp():
	is_chomping = false
	
func _on_head_body_entered(body):
	emit_signal("on_teeth", body)
