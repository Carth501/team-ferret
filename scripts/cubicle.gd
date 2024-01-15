class_name cubicle extends Node

signal diagetic_error_report(new_error)

@export var current_level_id: String
@export var control_panel: Control
@export var timer_corral: Node
var data
var current_level
var error_schedule := []
var control_id_list
var control_obj_list := []
var error_timers_list := []

func _ready():
	data = get_node("/root/data_libraries_single")
	if(!data.ready):
		await data.ready
	load_level()

func load_level():
	get_level(data.level_data)
	get_error_schedule(current_level)
	create_control_id_list()
	create_control_objects()
	create_error_timers()
	
func get_level(level_list: Array):
	for level in level_list:
		if (level.id == current_level_id):
			current_level = level 
			return

func get_error_schedule(level):
	var error_id_schedule = level.errors
	for error in error_id_schedule:
		var error_item = dereference_error_id(error.id)
		error_item["time"] = error.time
		error_schedule.append(error_item)

func create_control_id_list():
	var list = []
	for error in error_schedule:
		for control_id in error.pattern:
			if !list.has(control_id):
				list.append(control_id)
	control_id_list = list

func dereference_error_id(id: String):
	for error_def in data.error_data:
		if(error_def.id == id):
			return error_def
	push_error(str("did not find error def for id ", id))

func create_control_objects():
	for control_id in control_id_list:
		var control_definition = dereference_control_id(control_id)
		match control_definition.type:
			"button":
				create_button(control_definition)
			_:
				push_error(str(control_definition.type, " not found. Check spelling."))

func create_button(params):
	var button_scene = load("res://scenes/controls/button.tscn")
	var button_instance = button_scene.instantiate() as button_control
	if(button_instance == null):
		push_error("button instance does not have the script attached")
	button_instance.name = params.id
	button_instance.set_label(params.label)
	control_panel.add_child(button_instance)
	button_instance.set_anchors_preset(Control.PRESET_CENTER, false)
	button_instance.position = Vector2(params.offset[0]*64, params.offset[1]*64)
	control_obj_list.append(button_instance)

func dereference_control_id(id: String):
	for control_def in data.control_data:
		if(control_def.id == id):
			return control_def
	push_error(str("did not find error def for id ", id))

func create_error_timers():
	for error in error_schedule:
		var timer := Timer.new()
		timer_corral.add_child(timer)
		timer.wait_time = error.time
		timer.one_shot = true
		timer.start()
		error_timers_list.append(timer)
		timer.timeout.connect(next_error_report)
		print(str("new timer created for ", error.time))

func next_error_report():
	var new_error = error_schedule.pop_front()
	print(str("next_error_report called for ", new_error))
	diagetic_error_report.emit(new_error)
