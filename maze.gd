extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and $mazee/Sprite2D and $Node2D/CharacterBody2D.can_click == true:
		$mazee/Area2D/CollisionShape2D.disabled = true
		$mazee/Area2D/CollisionShape2D2.disabled = true
		$mazee/Area2D/CollisionShape2D3.disabled = true
		$mazee/Area2D/CollisionShape2D4.disabled = true
		$mazee/Area2D/CollisionShape2D5.disabled = true
		$mazee/Area2D/CollisionShape2D6.disabled = true
		$mazee/Panel34.visible = true
		$mazee/Panel35.visible = true
		$mazee/Panel36.visible = true
		$mazee/AnimationPlayer.play("texture")
		$Node2D/CharacterBody2D.can_click = false
