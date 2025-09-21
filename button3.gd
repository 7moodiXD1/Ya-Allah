extends Sprite2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		$"../../../mazee".visible = false
		$"../../../Area2D".visible = false
		$"../../../Label".visible = false
		$"../../../CanvasLayer/Virtual Joystick".visible = false
		$"../../../door".visible = false
		$"../../../key".visible = false
		$"../../../trap1".visible = false
		$"../../../trap2".visible = false
		$"../../../trap3".visible = false
		$"../../../Timer".start()
		$"../../../Node2D/CharacterBody2D".visible = true
		$"../../../Node2D/CharacterBody2D".queue_free()
		get_tree().change_scene_to_file("res://lvl_4.tscn")
		pass
