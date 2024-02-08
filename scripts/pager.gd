class_name pager 
extends Control

@onready var prev_spr = $PrevSpr as AnimatedSprite2D
@onready var next_spr = $NextSpr as AnimatedSprite2D
@onready var prev_btn = $"Prev Button"

@export var error_code_display: Label
var active_errors: Array[active_error] = []
var current_display: int = 0
@onready var data: data_libraries_single = get_node("/root/data_libraries_single")

func _ready():
	error_code_display.text = ""

func add_error(new_error: active_error):
	active_errors.append(new_error)
	if(active_errors.size() == 1):
		set_display(active_errors.size() - 1)

func set_display(value: int):
	if(check_display_conditions(value)):
		var error = active_errors[value]
		error_code_display.text = error.hex

func check_display_conditions(value: int) -> bool:
	if(active_errors.size() <= 0):
		return false
	if(!value < active_errors.size()):
		push_error("pager index exceeds errors array limit")
		return false
	if(!value >= 0):
		push_error("pager index is below 0")
		return false
	return true

func next_error_code():
	if(active_errors.size() > 0):
		current_display += 1
		current_display %= active_errors.size()
	set_display(current_display)
	next_spr.play("click")

func prev_error_code():
	if(active_errors.size() > 0):
		current_display -= 1
		if(current_display < 0):
			current_display += active_errors.size()
	set_display(current_display)
	prev_spr.play("click")

func remove_error(old_error_id: String):
	var old_error_hex: String = data.dereference_error_id(old_error_id).hex
	var index = get_error_index(old_error_hex)
	if(index == -1):
		push_error(str("expected error with hex ", old_error_hex, " but none were found.",
		"\nCurrent array: ", active_errors))
	active_errors.remove_at(index)
	if(active_errors.size() == 0):
		error_code_display.text = ""
	else:
		set_display(current_display % active_errors.size())

func get_error_index(error_id: String) -> int:
	var index := 0
	for error in active_errors:
		if(error.id == error_id):
			return index
		index += 1
	return -1

func toggle_extra_button(on: bool):
	prev_btn.visible = on
	prev_spr.visible = on
