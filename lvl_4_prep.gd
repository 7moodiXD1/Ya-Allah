extends Node2D




func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://lvl_5.tscn")
