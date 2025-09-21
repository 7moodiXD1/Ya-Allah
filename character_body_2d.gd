extends CharacterBody2D


const speed= 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1
	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
	velocity = input_direction * speed
	move_and_slide()
