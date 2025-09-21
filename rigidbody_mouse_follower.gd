extends RigidBody2D

@export var follow_force: float = 1000.0 # Adjust this value to control how strongly it follows
@export var max_speed: float = 500.0 # Optional: Limit the maximum linear speed

func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	var direction_to_mouse = (mouse_position - global_position)

	# Calculate the distance to the mouse
	var distance = direction_to_mouse.length()

	# Only apply force if the mouse is not too close to avoid jittering
	if distance > 5: # Small deadzone to prevent constant jitter when very close
		var force_vector = direction_to_mouse.normalized() * follow_force
		apply_central_force(force_vector)

	# Optional: Dampen angular velocity to prevent unwanted rotation
	angular_velocity = 0

	# Optional: Limit linear velocity
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

	# Optional: Reduce linear velocity if very close to mouse to prevent overshooting
	if distance < 50 and linear_velocity.length() > 0:
		linear_velocity *= 0.9 # Gradually slow down
