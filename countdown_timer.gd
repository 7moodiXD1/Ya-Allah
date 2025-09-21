extends Node

@export var countdown_time: float = 10.0 # الوقت الكلي للمؤقت بالثواني
@onready var timer_label: Label = $"../../Label"
@onready var countdown_timer: Timer = $"."

signal countdown_finished

func _ready():
	# التأكد من وجود عقدة Timer
	if countdown_timer == null:
		print("Error: CountdownTimer node not found. Please add a Timer node as a child.")
		set_process(false) # إيقاف السكريبت إذا لم يتم العثور على Timer
		return

	# ربط إشارة timeout() الخاصة بالـ Timer بدالة _on_countdown_timer_timeout()
	countdown_timer.timeout.connect(_on_timeout)
	countdown_timer.wait_time = countdown_time
	countdown_timer.one_shot = true # لكي يعمل المؤقت مرة واحدة فقط
	countdown_timer.autostart = false # لنبدأه يدويًا
	
	# تحديث الـ Label فورًا عند بدء اللعبة
	_update_timer_label()

func start_timer():
	countdown_timer.start()
	set_process(true) # تفعيل _process لتحديث الـ Label

func _process(delta: float) -> void:
	# تحديث الـ Label كل إطار
	_update_timer_label()

func _update_timer_label():
	var time_left = countdown_timer.time_left if countdown_timer.time_left > 0 else 0
	timer_label.text = str(snapped(time_left, 0.1))

func _on_timeout():
	print("Countdown Finished!")
	timer_label.text = "0.0"
	set_process(false) # إيقاف _process بعد انتهاء المؤقت
	countdown_finished.emit() # إطلاق الإشارة عند انتهاء المؤقت
