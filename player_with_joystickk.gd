extends CharacterBody2D

@export var speed = 100.0 # سرعة حركة اللاعب

var can_click = false
var can_move = true
var having_the_key = false
var can_slow = true

# مرجع إلى عقدة Virtual Joystick
@onready var virtual_joystick: VirtualJoystick

func _physics_process(delta: float) -> void:
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("speed_low"):
		if can_slow:
			speed = 20.0
			$Timer2.start()
	else:
		speed = 100.0
		
	
	# الحصول على مدخلات الحركة من Virtual Joystick أو لوحة المفاتيح
	if can_move:
		if virtual_joystick and virtual_joystick.is_node_ready():
			input_direction = virtual_joystick.get_direction()
		else:
		# إذا لم يكن Virtual Joystick موجودًا أو مفعلًا، نستخدم مدخلات لوحة المفاتيح
			input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# تطبيع متجه الحركة لتجنب الحركة الأسرع قطريًا
	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		
	velocity = input_direction * speed
	
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("die"):
		visible = false
		position.x = 0
		position.y = 0
		can_move = false
		$Timer.start()
	else:
		if area.is_in_group("key"):
			$"../../key".visible = false
			having_the_key = true
	if area.is_in_group("click"):
		can_click = true

func _on_timer_timeout() -> void:
	visible = true
	can_move = true
