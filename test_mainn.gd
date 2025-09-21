extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and $mouse.can_click == true:
		$Control/Button.emit_signal("pressed")

func _ready() -> void:
	$mouse.can_move = false
	$"Control3/buble chat/AnimationPlayer".play("poping up")
	



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$mouse.can_move = true
