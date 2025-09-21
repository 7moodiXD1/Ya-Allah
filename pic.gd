extends Node2D



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://pic_too.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://lvl_4.tscn")


func _on_not_virus__pressed() -> void:
	get_tree().change_scene_to_file("res://pic_to.tscn")
