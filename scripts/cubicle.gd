class_name cubicle extends Node

signal diagetic_error_report(new_error)
signal diagetic_error_resolved(error_id)
signal module_triggered(module_id: String)

@export var current_level_id: String
@export var control_panel: Control
@export var timer_corral: Node
@export var error_factory_controller: error_factory
@export var manual_instance: manual
var data
var current_level
var error_schedule := []
var error_catalogue := []
var module_id_list
var module_obj_dic: Dictionary = {}
var error_timers_list := []

func _ready():
	data = get_node("/root/data_libraries_single")
	if(!data.ready):
		await data.ready
	load_level()

func load_level():
	get_level(data.level_data)
	get_error_schedule(current_level)
	get_error_catalogue(current_level)
	create_module_id_list()
	create_module_objects()
	create_error_timers()
	setup_manual()
	set_initial_module_settings()
	populate_error_factory()
	
func get_level(level_list: Array):
	for level in level_list:
		if (level.id == current_level_id):
			current_level = level 
			return

func get_error_schedule(level):
	var error_id_schedule = level.error_schedule
	for error in error_id_schedule:
		var error_item = dereference_error_id(error.id)
		error_item["time"] = error.time
		error_schedule.append(error_item)

func get_error_catalogue(level):
	var error_id_list = level.errors
	for error in error_id_list:
		error_catalogue.append(dereference_error_id(error))

func create_module_id_list():
	var list = []
	for error in error_schedule:
		for step in error.pattern:
			if !list.has(step.id):
				list.append(step.id)
	module_id_list = list

func dereference_error_id(id: String):
	for error_def in data.error_data:
		if(error_def.id == id):
			return error_def
	push_error(str("did not find error def for id ", id))

func create_module_objects():
	for module_id in module_id_list:
		var module_definition = dereference_module_id(module_id)
		var new_module
		match module_definition.type:
			"button":
				new_module = create_button()
			"switch":
				new_module = create_switch()
			_:
				push_error(str(module_definition.type, " not found. Check spelling."))
		configure_module(new_module, module_definition)

func create_button() -> abstract_module:
	var button_scene = load("res://scenes/modules/button.tscn")
	return button_scene.instantiate() as button_module

func create_switch() -> abstract_module:
	var switch_scene = load("res://scenes/modules/switch.tscn")
	return switch_scene.instantiate() as switch_module

func configure_module(new_module: abstract_module, params):
	if(new_module == null):
		push_error("switch instance does not have the script attached")
	new_module.name = params.id
	new_module.set_id(params.id)
	new_module.set_label(params.label)
	control_panel.add_child(new_module)
	new_module.set_anchors_preset(Control.PRESET_CENTER, false)
	new_module.position = Vector2(params.offset[0]*64, params.offset[1]*64)
	module_obj_dic[params.id] = new_module

func dereference_module_id(id: String):
	for module_def in data.control_data:
		if(module_def.id == id):
			return module_def
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

func next_error_report():
	var new_error = error_schedule.pop_front()
	diagetic_error_report.emit(new_error)

func announce_error_resolved(error_id):
	diagetic_error_resolved.emit(error_id)

func setup_manual():
	manual_instance.build_error_list(data.error_data, data.control_data)

func set_initial_module_settings():
	if(current_level.has("init_values")):
		for key in current_level.init_values:
			if(!module_obj_dic.has(key)):
				push_error(str("current_level.init_values has key ", key, 
				" not found in module_obj_dic"))
			module_obj_dic[key].set_value(current_level.init_values[key])

func populate_error_factory():
	error_factory_controller.set_error_list(error_catalogue)
