extends Button

@export var max_random_moves: int = 10 # Number of times the button will move randomly

var current_moves_count: int = 0

@onready var bubble_chat = $"../../Control2/buble chat"

func _ready():
	# Connect the button\'s \'pressed\' signal to a function in this script
	pressed.connect(_on_button_pressed)
	# Godot\'s global randf() is usually sufficient and seeded automatically.
	pass

func _on_button_pressed():
	if current_moves_count < max_random_moves:
		var viewport_size = get_viewport_rect().size
		
		# For Control nodes like Button, \'size\' already gives the correct dimensions.
		# \'get_rect().size\' is also an option, but \'size\' is directly available.
		var button_current_size = size
		
		# Calculate random position within the viewport, accounting for button size
		var random_x = randf() * (viewport_size.x - button_current_size.x)
		var random_y = randf() * (viewport_size.y - button_current_size.y)
		
		global_position = Vector2(random_x, random_y)
		current_moves_count += 1
		print("Button moved to: ", global_position, ", Moves left: ", max_random_moves - current_moves_count)

	else:
		$"../../mouse".can_move = false
		bubble_chat.visible = true
		disabled = true
		position.x = 544.0
		position.y = 165.0
		if bubble_chat.visible == true:
			$"../../Control2/buble chat/AnimationPlayer".play("poping up")
			print("ok")
		# Optionally, disable the button after max moves
		# disabled = true
		# You could also change its text or appearance
		# text = "Done!"

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://lvl_1.tscn")
