class_name error_step_lights extends Control

@export var lights : Array[pager_light]
var error : active_error

func set_count(number : int):
	print(str("number of lights: ", number))
	number %= lights.size()
	var i := 0
	for light in lights:
		light.toggle(i < number)
		i += 1

func unset():
	if(error != null):
		error.step.disconnect(set_count)
		error = null

func set_error(new_error: active_error):
	unset()
	set_count(new_error.step_index)
	new_error.step.connect(set_count)
	error = new_error
