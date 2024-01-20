class_name cubicle extends Node

signal diagetic_error_report(new_error)
signal diagetic_error_resolved(error_id)
signal module_triggered(module_id: String)

@export var current_level_id: String
@export var control_panel: Control
@export var timer_corral: Node
@export var game_timer: Timer
@export var error_factory_controller: error_factory
@export var manual_instance: manual
@export var level_clock_handler: level_clock
@export var pause_curtain: Panel
@export var pause_button: button_module
@export var resume_button: button_module
@export var level_music: AudioStreamPlayer
@export var danger_music: AudioStreamPlayer
var data: data_libraries_single
var loader: level_loader
var current_level
var error_schedule := []
var error_catalogue := []
var module_id_list
var module_obj_dic: Dictionary = {}
var error_timers_list := []
var starting_cpc: int
var goal_cpc: int
var shift_duration: int
var failure_threshold_percent: float
var paused := false

func _ready():
	data = get_node("/root/data_libraries_single")
	if(!data.ready):
		await data.ready
	loader = get_node("/root/level_loader_single")
	if(!loader.ready):
		await loader.ready
	loader.cubicle_ready(self)
	if(pause_button == null):
		push_error("pause_button not hooked up")
	else:
		pause_button.internal_button.pressed.connect(toggle_pause)
	if(resume_button == null):
		push_error("resume_button not hooked up")
	else:
		resume_button.internal_button.pressed.connect(toggle_pause)

func load_level(level_id: String = "test"):
	current_level_id = level_id
	get_level()
	get_error_schedule(current_level)
	get_error_catalogue(current_level)
	create_module_id_list()
	create_module_objects()
	create_error_timers()
	setup_manual()
	set_initial_module_settings()
	populate_error_factory()
	configure_level_settings()
	
func get_level():
	var level_list = data.level_data
	for level in level_list:
		var metadata = level.metadata
		if (metadata.id == current_level_id):
			current_level = level 
			return

func configure_level_settings():
	if(current_level.has("starting_cpc")):
		starting_cpc = current_level.starting_cpc
	if(current_level.has("goal_cpc")):
		goal_cpc = current_level.goal_cpc
	if(current_level.gameplay.has("shift_duration")):
		shift_duration = current_level.gameplay.shift_duration
		level_clock_handler.set_value(shift_duration)
		create_danger_timer(shift_duration)
	if(current_level.has("failure_threshold_percent")):
		failure_threshold_percent = current_level.failure_threshold_percent

func get_error_schedule(level):
	var error_id_schedule = level.gameplay.errors.scheduled
	for error in error_id_schedule:
		var error_item = data.dereference_error_id(error.id)
		error_item["time"] = error.time
		error_schedule.append(error_item)

func get_error_catalogue(level):
	if(!level.has("errors")):
		push_warning("level has no errors list, was this intentional?")
	var error_id_list = level.gameplay.errors.random
	for error in error_id_list:
		var dereferenced = data.dereference_error_id(error)
		error_catalogue.append(dereferenced)

func create_module_id_list():
	var list = []
	for error in error_schedule:
		for step in error.pattern:
			if !list.has(step.id):
				list.append(step.id)
	for error in error_catalogue:
		for step in error.pattern:
			if !list.has(step.id):
				list.append(step.id)
	module_id_list = list

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
	var spacing = 10
	var x_pos = params.offset[0] * 64 + params.offset[0] * spacing
	var y_pos = params.offset[1] * 64 + params.offset[1] * spacing
	if(new_module == null):
		push_error("switch instance does not have the script attached")
	new_module.name = params.id
	new_module.set_id(params.id)
	new_module.set_label(params.label)
	control_panel.add_child(new_module)
	new_module.set_anchors_preset(Control.PRESET_CENTER, false)
	new_module.position = Vector2(x_pos, y_pos)
	module_obj_dic[params.id] = new_module

func dereference_module_id(id: String):
	for module_def in data.control_data:
		if(module_def.id == id):
			return module_def
	push_error(str("did not find error def for id ", id))

func create_error_timers():
	for error in error_schedule:
		var timer := self_destruct_timer.new()
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

func toggle_pause():
	paused = !paused
	pause_curtain.visible = paused
	if(paused):
		game_timer.stop()
		for timer in error_timers_list:
			if(timer != null):
				timer.paused = true
	else:
		game_timer.start()
		for timer in error_timers_list:
			if(timer != null):
				timer.paused = false

func end_level():
	var save_handler = get_node("/root/save_handler_single")
	save_handler.go_to_game_menu()

func complete_level():
	var save_handler = get_node("/root/save_handler_single")
	save_handler.level_complete(current_level.metadata.id)

func create_danger_timer(duration: float):
	var danger_timer = Timer.new()
	danger_timer.name = "Danger Timer"
	add_child(danger_timer)
	danger_timer.wait_time = duration * 0.9 - 10
	danger_timer.one_shot = true
	danger_timer.start()
	danger_timer.timeout.connect(start_danger_music)
	error_timers_list.append(danger_timer)

func start_danger_music():
	level_music.stop()
	danger_music.play()
