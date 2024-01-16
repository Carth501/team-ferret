class_name error_factory extends Node

@export var cubicle_instance: cubicle

func _ready():
	if(cubicle_instance == null):
		push_error("error factory doesn't have a reference to the cubicle.")

func create_error_node(error):
	var new_error = active_error.new()
	add_child(new_error)
	new_error.set_id(error.id)
	new_error.set_pattern(error.pattern)
	new_error.connect_to_modules(cubicle_instance.module_obj_dic)
