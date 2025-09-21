extends Control


func _ready() -> void:
	$AnimationPlayer.play("new_animation")
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass


func _on_video_stream_player_finished() -> void:
	get_tree().quit()
	pass


func _on_timer_timeout() -> void:
	$VideoStreamPlayer.play()
