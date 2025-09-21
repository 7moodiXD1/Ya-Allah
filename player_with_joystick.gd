extends CharacterBody2D

@export var max_speed = 100.0 # أقصى سرعة حركة للاعب
@export var acceleration = 500.0 # معدل التسارع (وحدة/ثانية^2)
@export var friction = 800.0 # معدل التباطؤ (وحدة/ثانية^2)
@export var slowdown_speed = 20.0 # السرعة عند تفعيل زر التبطيء
@export var slowdown_duration_limit = 5.0 # أقصى مدة يمكن الضغط فيها على زر التبطيء
@export var slowdown_cooldown_time = 10.0 # وقت الكول داون لزر التبطيء

# مرجع إلى عقدة Virtual Joystick
@onready var virtual_joystick: VirtualJoystick # تأكد من المسار الصحيح لعقدة VirtualJoystick
@onready var slowdown_button = 
@onready var cooldown_label = $CanvasLayer/cooldown_label

var can_click = false
var can_move = true

var having_the_key = false

var current_speed = 0.0
var is_slowing_down = false
var slowdown_timer = 0.0
var slowdown_cooldown_timer = 0.0

func _ready():
	cooldown_label.text = ""
	if slowdown_button:
		slowdown_button.pressed.connect(_on_slowdown_button_pressed)
		slowdown_button.released.connect(_on_slowdown_button_released)

func _physics_process(delta: float) -> void:
	var input_direction = Vector2.ZERO

	# الحصول على مدخلات الحركة من Virtual Joystick أو لوحة المفاتيح
	if can_move:
		if virtual_joystick and virtual_joystick.is_node_ready():
			input_direction = virtual_joystick.get_direction()
		else:
			input_direction = Input.get_vector("A", "D", "W", "S")

	# تحديث مؤقت التبطيء والكول داون
	if is_slowing_down:
		cooldown_label.text = str("skill")
		slowdown_timer += delta
		if slowdown_timer >= slowdown_duration_limit:
			_end_slowdown()
			_start_cooldown()
	
	if slowdown_cooldown_timer > 0:
		slowdown_cooldown_timer -= delta
		if slowdown_cooldown_timer <= 0:
			slowdown_cooldown_timer = 0
			cooldown_label.text = ""
			#if slowdown_button: slowdown_button.disabled = false
		else:
			cooldown_label.text = "Cooldown: %s" % str(snapped(slowdown_cooldown_timer, 0.1))
			#if slowdown_button: slowdown_button.disabled = true

	var target_speed = max_speed
	if is_slowing_down:
		target_speed = slowdown_speed

	if input_direction.length() > 0:
		# تسارع
		current_speed = lerp(current_speed, target_speed, acceleration * delta / target_speed)
		velocity = input_direction * current_speed
	else:
		# تباطؤ
		current_speed = lerp(current_speed, 0.0, friction * delta / max_speed)
		velocity = input_direction * current_speed # استخدام input_direction هنا للحفاظ على الاتجاه الأخير أثناء التباطؤ
		if current_speed < 5.0: # لمنع الحركة البطيئة جدًا بعد التوقف
			current_speed = 0.0
			velocity = Vector2.ZERO

	move_and_slide()

func _on_slowdown_button_pressed():
	if slowdown_cooldown_timer <= 0:
		is_slowing_down = true
		slowdown_timer = 0.0
		#if slowdown_button: slowdown_button.disabled = true # تعطيل الزر مؤقتاً أثناء الضغط عليه

func _on_slowdown_button_released():
	if is_slowing_down:
		_end_slowdown()
		_start_cooldown()

func _end_slowdown():
	is_slowing_down = false
	slowdown_timer = 0.0
	#if slowdown_button: slowdown_button.disabled = false # إعادة تفعيل الزر بعد انتهاء التبطيء

func _start_cooldown():
	slowdown_cooldown_timer = slowdown_cooldown_time
	#if slowdown_button: slowdown_button.disabled = true
	cooldown_label.text = "Cooldown: %s" % str(snapped(slowdown_cooldown_timer, 0.1))



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
