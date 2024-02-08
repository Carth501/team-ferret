class_name pager 
extends Control

@onready var prev_spr = $PrevSpr as AnimatedSprite2D
@onready var next_spr = $NextSpr as AnimatedSprite2D
@onready var prev_btn = $"Prev Button"

@export var error_code_display: Label
@export var step_lights_display: error_step_lights
var active_errors: Array[active_error] = []
var current_display := 0
@onready var data: data_libraries_single = get_node("/root/data_libraries_single")

func _ready():
	error_code_display.text = ""
	step_lights_display.unset()

func add_error(new_error: active_error):
	active_errors.append(new_error)
	if(active_errors.size() == 1):
		current_display = 0
		set_display()

func set_display():
	if(check_display_conditions(current_display)):
		if(active_errors[current_display] != null):
			var error = active_errors[current_display]
			error_code_display.text = error.hex
			step_lights_display.set_error(error)
			watch_error()
		else:
			next_error_code()

func check_display_conditions(value: int) -> bool:
	if(active_errors.size() <= 0):
		return false
	if(!value < active_errors.size()):
		push_error("pager index exceeds errors array limit")
		return false
	if(!value >= 0):
		push_error(str("pager index is below 0: ", value))
		return false
	return true

func next_error_code():
	unwatch_error()
	if(active_errors.size() > 0):
		current_display += 1
		current_display %= active_errors.size()
	set_display()
	next_spr.play("click")

func prev_error_code():
	unwatch_error()
	if(active_errors.size() > 0):
		current_display -= 1
		if(current_display < 0):
			current_display += active_errors.size()
	set_display()
	prev_spr.play("click")

func toggle_extra_button(on: bool):
	prev_btn.visible = on
	prev_spr.visible = on

func unwatch_error():
	var error = active_errors[current_display]
	if(error != null):
		error.tree_exiting.disconnect(next_error_code)

func watch_error():
	var error = active_errors[current_display]
	if(error != null):
		error.tree_exiting.connect(next_error_code)
