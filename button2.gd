extends Button

@export var game_scene_path: String = "res://GameScene.tscn"

@onready var bubble_chat = $"../../Control2/buble chat"

var start_1 = false
var click_count = 0
var current_corner_index = -1 # -1 means no corner set yet, or initial position

func _ready():
	print("Button _ready() called. Initializing...")
	pressed.connect(_on_button_pressed)
	# تم إزالة _move_to_random_corner(true) من هنا ليبدأ الزر في مكانه الافتراضي
	print("Button initialized. Initial position: ", position)

func _on_button_pressed():
	click_count += 1
	print("Button pressed. Current click count: ", click_count)
	if click_count == 4 and start_1 == false:
		print("Three clicks detected! Calling _handle_triple_click()...")
		_handle_forth_click()
		 #Reset click count after triple click
	
	else:
		start_1 = false
		$"../../mouse".can_move = true
		bubble_chat.visible = false
		_handle_single_click()
		

func _handle_single_click():
	_move_to_random_corner() # Move to a new, different random corner
	print("Single click handled. New position: ", position)

func _handle_forth_click():
	$"../../mouse".can_move = false
	bubble_chat.visible = true
	disabled = true
	position.x = 544.0
	position.y = 165.0
	if bubble_chat.visible == true:
		$"../../Control2/buble chat/AnimationPlayer".play("poping up")
		print("ok")
	
	
	print("Entering _handle_triple_click() function.")
	 # Disable the button to prevent further clicks
	print("Attempting to change scene directly to: ", game_scene_path)
	#var error = get_tree().change_scene_to_file("res://game_scene.tscn")
	#if error != OK:
		#print("ERROR: Failed to change scene! Error code: ", error)
		#print("Please check if the path \'", game_scene_path, "\' is correct and the scene file exists.")
	#else:
		#print("Scene change initiated successfully to: ", game_scene_path)

func _move_to_random_corner():
	var viewport_size = get_viewport_rect().size
	var button_size = size

	var corners = [
		Vector2(0, 0), # Top-left (Index 0)
		Vector2(viewport_size.x - button_size.x, 0), # Top-right (Index 1)
		Vector2(0, viewport_size.y - button_size.y), # Bottom-left (Index 2)
		Vector2(viewport_size.x - button_size.x, viewport_size.y - button_size.y) # Bottom-right (Index 3)
	]

	var new_corner_index = randi() % corners.size()

	# Ensure the new corner is different from the current one
	while new_corner_index == current_corner_index:
		new_corner_index = randi() % corners.size()
	
	current_corner_index = new_corner_index
	position = corners[current_corner_index]


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://lvl_2.tscn")
