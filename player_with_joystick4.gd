extends CharacterBody2D

@export var speed = 600.0

var can_click = false
var can_move = false

@onready var virtual_joystick:VirtualJoystick

func _physics_process(delta: float) -> void:
	var input_direction = Vector2.ZERO
	if can_move:
		if virtual_joystick and virtual_joystick.is_node_ready():
			input_direction = virtual_joystick.get_direction()
		else:
			input_direction = Input.get_vector("A", "D", "W", "S")
	
	if can_move:
		velocity = input_direction * speed
	
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("click"):
		can_click = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	can_click = false
