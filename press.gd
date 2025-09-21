extends TouchScreenButton

func _on_pressed() -> void:
	var target_button = get_node("../Control/Button")
	var mouse = get_node("../mouse")
	
	if target_button and mouse.can_click == true:
		target_button.emit_signal("pressed")
	
