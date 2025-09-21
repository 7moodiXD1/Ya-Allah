





extends Control

# إشارات مخصصة لإعلام المشاهد الأخرى بحالة اللعبة
signal level_complete
signal game_over

# تعداد (enum) لإدارة حالات اللعبة المختلفة
enum GameState { WATCHING, PLAYING, GAME_OVER }

# متغيرات يمكن تعديلها من محرر Godot
@export var start_pattern_length = 3
@export var pattern_speed = 0.8  # الثواني بين كل زر في النمط
@export var input_time_limit = 10.0 # الوقت المتاح للاعب للإدخال

# عقد واجهة المستخدم
@onready var message_label = $MessageLabel
@onready var button_grid = $MainLayout/ButtonGrid
@onready var info_label = $InfoLabel
@onready var pattern_timer = $PatternTimer
@onready var input_timer = $InputTimer

# متغيرات منطق اللعبة
var _buttons = []
var _current_pattern = []
var _player_pattern = []
var _current_level = 1
@export var max_levels = 4
var _current_state = GameState.WATCHING

# --- دوال Godot الأساسية ---

func _ready():
	# ربط إشارات المؤقتات بالدوال المناسبة
	pattern_timer.wait_time = pattern_speed
	pattern_timer.connect("timeout", _on_pattern_timer_timeout)
	input_timer.wait_time = input_time_limit
	input_timer.connect("timeout", _on_input_timer_timeout)

	# الحصول على جميع الأزرار من الشبكة وربط إشاراتها
	for button in button_grid.get_children():
		if button is Button:
			_buttons.append(button)
			button.pressed.connect(_on_button_pressed.bind(button))

	# مؤقت بدء اللعبة الأولي
	message_label.text = "Get Ready"
	
	await get_tree().create_timer(2.0).timeout 
	start_new_game()
	
	
# --- دوال بدء وإعادة تشغيل اللعبة ---

func start_new_game():
	#info_label.text = "Level " + str(int(_current_level))
	start_new_level()

func start_new_level():
	info_label.text = "Level " + str(int(_current_level))
	_player_pattern.clear()
	generate_pattern()
	play_pattern()

# --- دوال منطق اللعبة ---

func generate_pattern():
	_current_pattern.clear()
	var pattern_length = start_pattern_length + _current_level - 1
	for _i in range(pattern_length):
		var random_button = _buttons[randi() % _buttons.size()]
		_current_pattern.append(random_button)

func play_pattern():
	set_game_state(GameState.WATCHING)
	message_label.text = "Watch The Pattern"
	# تعطيل الأزرار أثناء عرض النمط
	for b in _buttons:
		b.disabled = true

	# استخدام tween لإضاءة الأزرار بشكل متسلسل
	var tween = create_tween()
	tween.set_loops(1)

	for button in _current_pattern:
		# تغيير لون الزر للإشارة إلى أنه جزء من النمط
		tween.tween_callback(func(): button.modulate = Color.BLUE)
		tween.tween_interval(pattern_speed / 2.0)
		# إعادة الزر إلى لونه الأصلي
		tween.tween_callback(func(): button.modulate = Color.WHITE)
		tween.tween_interval(pattern_speed / 2.0)

	# بعد انتهاء عرض النمط، ابدأ دور اللاعب
	tween.tween_callback(start_player_turn)

func start_player_turn():
	set_game_state(GameState.PLAYING)
	message_label.text = "Put The Pattern"
	# تفعيل الأزرار مرة أخرى
	for b in _buttons:
		b.disabled = false
	input_timer.start() # بدء مؤقت الإدخال

# --- دوال معالجة الإشارات (Signals) ---

func _on_button_pressed(button: Button):
	if _current_state != GameState.PLAYING:
		return

	# إضافة الزر الذي تم النقر عليه إلى نمط اللاعب
	_player_pattern.append(button)

	# التحقق مما إذا كان الزر صحيحًا
	var index = _player_pattern.size() - 1
	if _player_pattern[index] != _current_pattern[index]:
		end_game(false) # اللاعب خسر
		return

	# التحقق مما إذا كان اللاعب قد أكمل النمط
	if _player_pattern.size() == _current_pattern.size():
		input_timer.stop()
		_current_level += 1
		info_label.text = "Level " + str(int(_current_level))
		message_label.text = "Right!"
		# تأخير بين المراحل
		if _current_level < max_levels:
			await get_tree().create_timer(2.0).timeout # تأخير 2 ثانية بين المراحل
			start_new_level()
		else:
			end_game(true)

func _on_pattern_timer_timeout():
	# هذه الدالة لم تعد مستخدمة بشكل مباشر بفضل Tween
	pass

func _on_input_timer_timeout():
	if _current_state == GameState.PLAYING:
		message_label.text = "Timeout"
		end_game(false) # اللاعب خسر بسبب انتهاء الوقت

# --- دوال إدارة حالة اللعبة ---

func set_game_state(new_state: GameState):
	_current_state = new_state

func end_game(player_won: bool):
	set_game_state(GameState.GAME_OVER)
	input_timer.stop()
	for b in _buttons:
		b.disabled = true
	if player_won:
		$AnimationPlayer.play("next_scene")
		message_label.text = "You Win"
		emit_signal("level_complete")
	else:
		message_label.text = "GameOver"
		emit_signal("game_over")
		$Timer.start()
		
	
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://lvl_3.tscn")
	pass


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://memory_maze.tscn")
	
