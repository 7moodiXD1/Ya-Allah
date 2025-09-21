extends Node2D

@export var target_node_path: NodePath # Path to the node that will be moved

var target_node: Node2D

func _ready():
	# Ensure target_node_path is set in the editor
	if target_node_path:
		target_node = get_node(target_node_path)
	else:
		print("Error: target_node_path not set for random_position_button.gd")
		set_process(false) # Disable script if no target

	# Connect the button's 'pressed' signal to a function in this script
	# Assuming there's a Button node as a child named 'MoveButton'
	var button = get_node_or_null(".")
	if button and button is Button:
		button.pressed.connect(_on_pressed)
	else:
		print("Error: No 'MoveButton' (Button node) found as a child.")

func _on_pressed():
	if target_node:
		var viewport_size = get_viewport_rect().size
		var random_x = randf_range(0, viewport_size.x)
		var random_y = randf_range(0, viewport_size.y)
		target_node.global_position = Vector2(random_x, random_y)
		print("Moved target node to: ", target_node.global_position)
