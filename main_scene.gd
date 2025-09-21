extends Node2D

@export var computer_part_scenes: Array[PackedScene]
@export var virus_scenes: Array[PackedScene]

@onready var falling_objects_container = $FallingObjectsContainer
@onready var spawn_timer = $SpawnTimer
@onready var score_label = $UI/ScoreLabel
@onready var game_over_label = $UI/GameOverLabel
@onready var restart_button = $UI/RestartButton

var score: int = 0
var game_over: bool = false
var virus_click_limit: int = 3 # Number of viruses allowed to be clicked before game over
var viruses_clicked: int = 0

func _ready():
	spawn_timer.timeout.connect(_on_spawn_timer_timeout())
	spawn_timer.start()

	# Initialize UI
	update_score_display()
	game_over_label.visible = false
	restart_button.visible = false
	restart_button.pressed.connect(_on_restart_button_pressed)

func _on_spawn_timer_timeout():
	if game_over: return

	var object_to_spawn: PackedScene
	var virus: bool

	# Randomly decide to spawn a computer part or a virus
	if randf() < 0.7: # 70% chance for computer part
		object_to_spawn = computer_part_scenes.pick_random()
		virus = false
	else: # 30% chance for virus
		object_to_spawn = virus_scenes.pick_random()
		virus = true

	var falling_object_instance = object_to_spawn.instantiate()
	falling_objects_container.add_child(falling_object_instance)

	# Set random horizontal position at the top of the screen
	var spawn_x = randf_range(50, get_viewport_rect().size.x - 50)
	falling_object_instance.position = Vector2(spawn_x, -50) # Start slightly above screen

	# Connect the clicked signal
	falling_object_instance.clicked.connect(_on_falling_object_clicked)

func _on_falling_object_clicked(is_virus_object: bool):
	if game_over: return

	if is_virus_object:
		viruses_clicked += 1
		if viruses_clicked >= virus_click_limit:
			_game_over()
		else:
			score -= 5 # Penalize for clicking a virus
	else:
		score += 10 # Reward for clicking a computer part

	update_score_display()

func update_score_display():
	score_label.text = "Score: " + str(score)

func _game_over():
	game_over = true
	spawn_timer.stop()
	get_tree().paused = true # Pause the game

	game_over_label.visible = true
	restart_button.visible = true

	# Remove all falling objects
	for child in falling_objects_container.get_children():
		child.queue_free()

func _on_restart_button_pressed():
	get_tree().paused = false # Unpause the game
	get_tree().reload_current_scene()
