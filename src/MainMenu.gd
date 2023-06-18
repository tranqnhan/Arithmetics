extends Control

func _on_addition_pressed():
	get_tree().change_scene_to_file("res://Addition.tscn")


func _on_increment_pressed():
	get_tree().change_scene_to_file("res://Increment.tscn")
