extends Button

func _pressed() -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$"../../Control2/buble chat/AnimationPlayer2".play("poping up")
	$"../../mouse".visible = true
	$"../../press".visible = true


func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	$"../../mouse".can_move = true


func _on_pressed() -> void:
	$"../../Panel2".visible = true
	$"../../AnimationPlayer3".play("new_animation")


func _on_animation_player_3_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://troll_video.tscn")
