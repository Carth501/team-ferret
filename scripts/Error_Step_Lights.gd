class_name error_step_lights extends Control

@export var lights : Array[pager_light]

func set_count(number : int):
	number %= lights.size()
	var i := 0
	for light in lights:
		light.toggle(i < number)
		i += 1
