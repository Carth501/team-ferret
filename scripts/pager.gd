class_name pager extends Control

@export var error_code_display: Label
var error_ids: Array[String] = []
var current_display: int = 0

func _ready():
	error_code_display.text = ""

func add_error(new_error):
	error_ids.append(new_error.hex)
	set_display(error_ids.size() - 1)

func set_display(value: int):
	if(check_display_conditions(value)):
		var error = error_ids[value]
		error_code_display.text = error
		
func check_display_conditions(value: int) -> bool:
	if(error_ids.size() <= 0):
		return false
	if(!value < error_ids.size()):
		push_error("pager index exceeds errors array limit")
		return false
	if(!value >= 0):
		push_error("pager index is below 0")
		return false
	return true

func next_error_code():
	if(error_ids.size() > 0):
		current_display += 1
		current_display %= error_ids.size()
	set_display(current_display)

func remove_error(old_error_id):
	var index = get_error_index(old_error_id)
	if(index == -1):
		push_error(str("expected error with id ", old_error_id, " but none were found."))
	error_ids.remove_at(index)
	if(error_ids.size() == 0):
		error_code_display.text = ""
	else:
		set_display(current_display % error_ids.size())

func get_error_index(error_id) -> int:
	var index := 0
	for error in error_ids:
		if(error == error_id):
			return index
		index += 1
	return -1
