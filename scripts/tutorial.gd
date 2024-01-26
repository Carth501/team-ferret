class_name tutorial extends Control

var cubicle_instance: cubicle
@onready var textbox: Label = Label.new()
@export var circle: TextureRect
@onready var continue_button: Button = Button.new()

func set_cubicle(cubicle_ref: cubicle):
	set_up_textbox()
	set_up_continue_button()
	cubicle_instance = cubicle_ref
	hide_stuff()
	step1()

func set_up_continue_button():
	continue_button.text = "Continue"
	add_child(continue_button)
	continue_button.position = Vector2(-100, 260)

func set_up_textbox():
	textbox.mouse_filter = 1
	textbox.size = Vector2(240, 300)
	add_child(textbox)
	textbox.label_settings = LabelSettings.new()
	textbox.label_settings.font_color = Color.DARK_RED
	textbox.position = Vector2(20, 40)
	textbox.layout_direction = Control.LAYOUT_DIRECTION_RTL
	textbox.autowrap_mode = TextServer.AUTOWRAP_WORD
	textbox.mouse_filter = Control.MOUSE_FILTER_PASS

func hide_stuff():
	cubicle_instance.stop_timers()
	cubicle_instance.level_clock_handler.visible = false
	cubicle_instance.simulation_screen.visible = false
	cubicle_instance.pager_ref.visible = false

func step1():
	textbox.text = "Welcome! Onboarding should take one minute. Click the manual."
	circle.position = Vector2(-1330, 230)
	continue_button.visible = false
	cubicle_instance.manual_instance.manual_open.connect(step2)

func step2():
	cubicle_instance.manual_instance.manual_open.disconnect(step2)
	textbox.text = "This manual has everything you need to know. Tab through for a moment. Familiarize yourself. Move it around."
	circle.visible = false
	continue_button.visible = true
	continue_button.pressed.connect(step3)

func step3():
	textbox.text = "Moving on. Each error will need to be resolved ASAP. Don't slouch. If players see errors, they will stop playing."
	continue_button.pressed.disconnect(step3)
	continue_button.pressed.connect(step4)

func step4():
	textbox.text = "This is your pager. A PA-GER. Like a tweet, but, y'know, less reliable."
	cubicle_instance.pager_ref.visible = true
	circle.position = Vector2(-1240, 140)
	circle.visible = true
	continue_button.pressed.disconnect(step4)
	continue_button.pressed.connect(step5)

func step5():
	textbox.text = "Here's an error. Fix it."
	continue_button.pressed.disconnect(step5)
	continue_button.visible = false
	cubicle_instance.error_factory_controller.generate_new_error(0)
	cubicle_instance.error_factory_controller.update_active_error_count.connect(step6)

func step6(error_count: int):
	if(error_count == 0):
		circle.visible = false
		cubicle_instance.error_factory_controller.update_active_error_count.disconnect(step6)
		textbox.text = "You need to be faster."
		continue_button.visible = true
		continue_button.text = "Sorry"
		continue_button.pressed.connect(step7)
	
func step7():
	continue_button.pressed.disconnect(step7)
	textbox.text = "We will only be hiring you for a few minutes at a time."
	continue_button.text = "Continue"
	continue_button.pressed.connect(step8)

func step8():
	textbox.text = "Get our player count over a target we give you or you are fired."
	continue_button.pressed.disconnect(step8)
	continue_button.pressed.connect(step9)

func step9():
	textbox.text = "Here's your clock. Don't be late."
	cubicle_instance.start_timers()
	continue_button.visible = false
	cubicle_instance.level_clock_handler.visible = true

func tutorial_timer(duration: float) -> Timer:
	var timer := self_destruct_timer.new()
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.start()
	return timer
