extends Panel



func _on_area_2d_area_entered(area: Area2D) -> void:
	var player = get_node("../Node2D/CharacterBody2D")
	if player.having_the_key == true:
		$AnimationPlayer.play("new_animation")
		print("if")
	else:
		print("else")
