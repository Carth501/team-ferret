class_name error_factory extends Node

signal update_active_error_count(int)

@export var cubicle_instance: cubicle
var active_error_count = 0

func _ready():
	if(cubicle_instance == null):
		push_error("error factory doesn't have a reference to the cubicle.")

func create_error_node(error):
	var new_error = active_error.new()
	add_child(new_error)
	new_error.set_id(error.id)
	new_error.set_pattern(error.pattern)
	new_error.connect_to_cubicle(cubicle_instance)
	active_error_count += 1
	new_error.resolved_error.connect(decrement_error_count)
	update_active_error_count.emit(active_error_count)

func decrement_error_count():
	active_error_count -= 1
	update_active_error_count.emit(active_error_count)

func get_active_error_count() -> int:
	return active_error_count
