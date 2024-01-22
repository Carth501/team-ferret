class_name pager 
extends Control

@onready var prev_spr = $PrevSpr as AnimatedSprite2D
@onready var next_spr = $NextSpr as AnimatedSprite2D

@export var error_code_display: Label
var error_hexes: Array[String] = []
var current_display: int = 0
@onready var data: data_libraries_single = get_node("/root/data_libraries_single")

func _ready():
	error_code_display.text = ""

func add_error(new_error):
	error_hexes.append(new_error.hex)
	set_display(error_hexes.size() - 1)

func set_display(value: int):
	if(check_display_conditions(value)):
		var error = error_hexes[value]
		error_code_display.text = error
		
func check_display_conditions(value: int) -> bool:
	if(error_hexes.size() <= 0):
		return false
	if(!value < error_hexes.size()):
		push_error("pager index exceeds errors array limit")
		return false
	if(!value >= 0):
		push_error("pager index is below 0")
		return false
	return true

func next_error_code():
	if(error_hexes.size() > 0):
		current_display += 1
		current_display %= error_hexes.size()
	set_display(current_display)
	next_spr.play("click")

func prev_error_code():
	if(error_hexes.size() > 0):
		current_display -= 1
		if(current_display < 0):
			current_display += error_hexes.size()
	set_display(current_display)
	prev_spr.play("click")

func remove_error(old_error_id: String):
	var old_error_hex: String = data.dereference_error_id(old_error_id).hex
	var index = get_error_index(old_error_hex)
	if(index == -1):
		push_error(str("expected error with hex ", old_error_hex, " but none were found."))
	error_hexes.remove_at(index)
	if(error_hexes.size() == 0):
		error_code_display.text = ""
	else:
		set_display(current_display % error_hexes.size())

func get_error_index(error_id) -> int:
	var index := 0
	for error in error_hexes:
		if(error == error_id):
			return index
		index += 1
	return -1
