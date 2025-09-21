extends TouchScreenButton

func _on_pressed():
	var target_lever = get_node("../../Control/Control/Button")
	var mouse = get_node("../../Node2D/CharacterBody2D")
	
	if target_lever and mouse.can_click == true:
		$"../../mazee/Area2D/CollisionShape2D".disabled = true
		$"../../mazee/Area2D/CollisionShape2D2".disabled = true
		$"../../mazee/Area2D/CollisionShape2D3".disabled = true
		$"../../mazee/Area2D/CollisionShape2D4".disabled = true
		$"../../mazee/Area2D/CollisionShape2D5".disabled = true
		$"../../mazee/Area2D/CollisionShape2D6".disabled = true
		$"../../mazee/Panel34".visible = true
		$"../../mazee/Panel35".visible = true
		$"../../mazee/Panel36".visible = true
		$"../../mazee/AnimationPlayer".play("texture")
		mouse.can_click = false
		
