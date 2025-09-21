extends RigidBody2D

@export var speed: float = 600.0
var can_click = false
var can_move = true

func _physics_process(delta):
	if can_click == false:
		print("false")
	else:
		print("true")
	var input_direction = Vector2.ZERO
	if can_move:
		if Input.is_action_pressed("ui_right"):
			input_direction.x += 1
		if Input.is_action_pressed("ui_left"):
			input_direction.x -= 1
		if Input.is_action_pressed("ui_down"):
			input_direction.y += 1
		if Input.is_action_pressed("ui_up"):
			input_direction.y -= 1
	# Normalize the direction vector to prevent faster diagonal movement
	input_direction = input_direction.normalized()

	# Apply force to move the RigidBody2D
	# Using apply_central_force for a more physics-based movement
	# Alternatively, you can set linear_velocity directly for snappier control:
	linear_velocity = input_direction * speed
	
	apply_central_force(input_direction * speed)
	# Optional: Dampen angular velocity to prevent unwanted rotation
	# angular_velocity = 0
	# Optional: Limit linear velocity to prevent it from getting too high
	# if linear_velocity.length() > speed:
	#    linear_velocity = linear_velocity.normalized() * speed



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("die_area"):
		
		print("no")
	elif area.is_in_group("click"):
		can_click = true
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	can_click = false
